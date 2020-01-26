import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:remhealth_mobile/bloc/bloc.dart';
import 'package:remhealth_mobile/config/api.dart';
import 'package:remhealth_mobile/config/auth_details.dart';
import 'package:remhealth_mobile/custom_widgets/button_widget.dart';
import 'package:remhealth_mobile/custom_widgets/custom_colors.dart';
import 'package:remhealth_mobile/custom_widgets/input_text.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import '../lists.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class ConfirmImmunization extends StatefulWidget {
  @override
  _ConfirmImmunizationState createState() => _ConfirmImmunizationState();
}

class _ConfirmImmunizationState extends State<ConfirmImmunization> {
  final connectionBloc = ConnectionBloc();

  @override
  void initState() {
    super.initState();
    connectionBloc.dispatch(CheckInternet());
    runCheck();
    _getLocation();
  }

  //location
  var location = new Location();

  LocationData userLocation;

  runCheck() {
    var oneSec = Duration(seconds: 3);
    Timer.periodic(oneSec, (Timer t) async {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/vaccine.json');
      bool fileExists = file.existsSync();
      connectionBloc.dispatch(CheckInternet());
      _getLocation();
      if (fileExists == true) {
        submitOffline();
      }
    });
  }

  submitOffline() async {
    if (connectionBloc.connected == true) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/vaccine.json');
      List jsonContent = json.decode(file.readAsStringSync());

      Map data = {
        'immunizationCode': reg.text,
        'type': '',
        'lat': '',
        'lon': '',
      };

      for (var i = 0; i < jsonContent.length; i++) {
        List list = jsonContent[i]['vaccine'];
        for (var vaccine in list) {
          data['immunizationCode'] = jsonContent[i]['immunizationCode'];
          data['type'] = vaccine;
          data['lat'] = jsonContent[i]['lat'];
          data['lon'] = jsonContent[i]['lon'];

          try {
            String token = await Authentication.getToken();
            String id = await Authentication.getId();

            http.Response response = await http.post(
              Api.confirmImmunization(jsonContent[i]['immunizationCode']),
              body: json.encode(data),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader: "Bearer $token"
              },
            );

            var decodedResponse = json.decode(response.body);

            print(decodedResponse);

            if (this.mounted) {
              setState(() {
                offlineList = [];
              });
            }
          } catch (e) {
            print("error: $e");
          }
        }
      }
      deleteFile();
    }
  }

  readFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      print(directory.toString());
      final file = File('${directory.path}/vaccine.json');
      List jsonContent = json.decode(file.readAsStringSync());
      if (this.mounted) {
        setState(() {
          offlineList = jsonContent;
        });
      }
      print(offlineList);
    } catch (e) {
      print("Couldn't read file vaccine.json : $e");
    }
  }

  deleteFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/vaccine.json');
    file.deleteSync(recursive: true);
    print('deleted');
  }

  save() async {
    Map data = {
      'immunizationCode': reg.text,
      'vaccine': vaccines,
      'lat': userLocation.latitude.toString(),
      'lon': userLocation.longitude.toString(),
    };

    vaccineList.add(data);

    if (connectionBloc.connected == false && reg.text.length > 1) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/vaccine.json');
      bool fileExists = file.existsSync();

      if (fileExists == true) {
        print("File exists");
        List jsonContent = json.decode(file.readAsStringSync());
        jsonContent.add(data);
        file.writeAsStringSync(json.encode(jsonContent));
      } else {
        file.writeAsStringSync(json.encode(vaccineList));
        print('saved vaccine.json');
      }

      if (this.mounted) {
        setState(() {
          _success = "Immunization Saved!";
        });
      }
      readFile();
    }
  }

  List vaccines = [];

  List vaccineList = [];

  List offlineList = [];

  submit() async {
    if (connectionBloc.connected == true && reg.text.length > 1) {
      if (this.mounted) {
        setState(() {
          _error = "";
          _loading = true;
        });
      }

      Map obj = {
        'immunizationCode': reg.text,
        'type': '',
        'lat': userLocation.latitude.toString(),
        'lon': userLocation.longitude.toString(),
      };

      for (var vaccine in vaccines) {
        obj['immunizationCode'] = reg.text;
        obj['type'] = vaccine;

        try {
          String token = await Authentication.getToken();
          String id = await Authentication.getId();

          http.Response response = await http.post(
            Api.confirmImmunization(reg.text.trim()),
            body: json.encode(obj),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader: "Bearer $token"
            },
          );

          var decodedResponse = json.decode(response.body);

          if (decodedResponse['message'] == 'saved') {
            if (this.mounted) {
              setState(() {
                _success = "Confirmed for $childName!";
                _loading = false;
                hasId = false;
                reg.text = '';
                labels = [];
              });
            }
          } else {
            if (this.mounted) {
              setState(() {
                _error = decodedResponse['message'];
                _loading = false;
              });
            }
          }
          print(decodedResponse);
        } catch (e) {
          print("error: $e");
        }
      }
    } else {
      if (this.mounted) {
        setState(() {
          _error = "Fill in immunization code or scan qr code";
        });
      }
    }
  }

  getCode() async {
    if (this.mounted) {
      setState(() {
        _loading = true;
      });
    }
    try {
      String token = await Authentication.getToken();

      http.Response response = await http.get(
        Api.getCode(barcode),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
      );

      var decodedResponse = json.decode(response.body);

      print(decodedResponse);

      String code = decodedResponse['data']['rows'][0]['immunizationCode'];
      if (this.mounted) {
        setState(() {
          _error = '';
          reg.text = code;
        });
      }
    } catch (e) {
      print(e);
    }
    if (this.mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  bool hasId = false;

  String childId;

  String childName;

  List childVaccines = <String>[];

  List labels = <String>[];

  Future getChildId(code) async {
    setState(() {
      _loading = true;
    });

    try {
      String token = await Authentication.getToken();

      http.Response response = await http.get(
        Api.getDetailsByIm(code),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
      );

      var details = json.decode(response.body);

      String id = details['data']['id'].toString();

      String name = details['data']['name'];

      http.Response im = await http.get(
        Api.listImmunization(id),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
      );

      var imList = json.decode(im.body);

      List imlist2 = imList['data'];

      for (var item in imList['data']) {
        childVaccines.add(item['type']);
      }

      http.Response vaccineList = await http.get(
        Api.getVaccines,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
      );

      var decodedResponse = json.decode(vaccineList.body);
      List items = decodedResponse['vaccines'];

      for (var item in items) {
        labels.add(item['name']);
      }

      setState(() {
        childId = id;

        hasId = true;
        childName = name;
      });
    } catch (e) {
      print(e);
      setState(() {
        _error = "An error occured";
      });
    }

    setState(() {
      _loading = false;
    });
  }

  //barcode details
  String barcode = "";

  //dropdown values
  var selectedVaccine;

  //indexes
  int selectedIndex = 0;

  // controllers for our inputs
  static TextEditingController reg = TextEditingController();

  //loading state
  bool _loading = false;

  validateInput() {
    if (this.mounted) {
      setState(() {
        _error = "";
      });
    }
    if (reg.text.length < 1 || selectedIndex == 0) {
      setState(() {
        _error = "Please Fill in all fields";
      });
      return false;
    }

    if (userLocation == null) {
      setState(() {
        _error = "Please Turn On GPS!";
      });
      return false;
    }

    return true;
  }

  //success message
  String _success = '';

  // shows the success message on screen
  Widget successWidget() {
    if (_success.length > 0) {
      return Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 2,
            ),
            Text(
              _success,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                  fontFamily: "Lato"),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      );
    }
    return Container();
  }

  // stores the error state
  String _error = "";

// shows the error on the screen if present
  Widget errorWidget() {
    if (_error.length > 0) {
      return Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 2,
            ),
            Text(
              _error,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                  fontFamily: "Lato"),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Confirm Immunization",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17.0,
            fontFamily: "Poppins",
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            hasId == false
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 23),
                    child: InputText(
                      cursorColor: RemColors.green,
                      obscureText: false,
                      label: "Immunization Number",
                      focusColor: RemColors.green,
                      borderColor: Colors.grey,
                      controller: reg,
                      onChanged: (text) {},
                    ),
                  )
                : Container(),
            hasId == false ? Container() : buildCheckbox(),
            SizedBox(
              height: 20,
            ),
            _success.length > 0 ? successWidget() : errorWidget(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 65),
              child: hasId == false
                  ? Center(
                      child: _loading == false
                          ? ButtonWidget(
                              color: Colors.orange,
                              onTap: () {
                                scan();
                                validateInput();
                              },
                              shadow: Color.fromRGBO(234, 154, 16, 0.72),
                              text: "Capture QR Code",
                            )
                          : CircularProgressIndicator(),
                    )
                  : Container(),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(left: 55, right: 55, bottom: 40),
              child: _loading == false ? buildButtonWidget() : Container(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonWidget() {
    if (hasId == true) {
      return Center(
        child: _loading == false
            ? ButtonWidget(
                color: RemColors.green,
                onTap: () {
                  setState(() {
                    _success = '';
                    _error = '';
                  });
                  _getLocation();
                  if (connectionBloc.connected == false) {
                    save();
                  } else {
                    submit();
                  }
                },
                shadow: Color.fromRGBO(70, 193, 13, 0.46),
                text: "Confirm Immunization",
              )
            : CircularProgressIndicator(),
      );
    }
    return ButtonWidget(
      color: RemColors.green,
      onTap: () {
        setState(() {
          _success = '';
          _error = '';
        });
        if (connectionBloc.connected == false) {
          save();
          setState(() {
            _error = 'Must Be connected To Internet to get Vaccines';
          });
        } else {
          getChildId(reg.text);
        }
      },
      shadow: Color.fromRGBO(70, 193, 13, 0.46),
      text: "Get Vaccines",
    );
  }

  Widget buildCheckbox() {
    List im = <String>[];

    // print(childVaccines);

    for (var obj in childVaccines) {
      im.add(obj);

      labels.removeWhere((item) => im.contains(item));
      // print(labels);
    }

    return Column(
      children: <Widget>[
        // SizedBox(
        //   height: 30,
        // ),
        labels.length == 0
            ? Text(
                'Select vaccines for $childName',
                style: TextStyle(fontSize: 17),
              )
            : Text(
                'No more vaccines for $childName',
                style: TextStyle(fontSize: 17),
              ),
        SizedBox(
          height: 10,
        ),
        CheckboxGroup(
            labels: labels,
            disabled: im,
            // checked: im,
            onSelected: (List<String> checked) {
              if (this.mounted) {
                setState(() {
                  vaccines = checked;
                });
              }
            }),
        SizedBox(
          height: 20,
        ),
        Text(
          'Vaccines Taken:',
          style: TextStyle(fontSize: 17),
        ),
        ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.only(
            left: 40.0,
          ),
          itemCount: im.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(im[index]),
                SizedBox(
                  height: 10,
                )
              ],
            );
          },
        ),
      ],
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      getCode();
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          _error = 'Please Grant Camera Access';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this._error = 'Could not scan code');
    } catch (e) {
      setState(() => this._error = 'could not scan code');
    }
  }

  Future<LocationData> _getLocation() async {
    LocationData currentLocation;
    try {
      currentLocation = await location.getLocation();
      if (this.mounted) {
        setState(() {
          userLocation = currentLocation;
        });
      }
    } on PlatformException catch (e) {
      print(e);
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Error'),
            content: SingleChildScrollView(
                child: Text(
                    "Please check that your GPS is on and that you have granted the app location access")),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      currentLocation = null;
      print(e);
    }
    return currentLocation;
  }
}
