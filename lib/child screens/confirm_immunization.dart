import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:immunization_mobile/bloc/bloc.dart';
import 'package:immunization_mobile/config/api.dart';
import 'package:immunization_mobile/config/auth_details.dart';
import 'package:immunization_mobile/custom_widgets/button_widget.dart';
import 'package:immunization_mobile/custom_widgets/custom_colors.dart';
import 'package:immunization_mobile/custom_widgets/input_text.dart';
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
    location.onLocationChanged().listen((value) {
      setState(() {
        userLocation = value;
      });
    });
  }

  //location
  var location = new Location();

  Map<String, double> userLocation;

  runCheck() {
    var oneSec = Duration(seconds: 5);
    Timer.periodic(oneSec, (Timer t) async {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/vaccine.json');
      bool fileExists = file.existsSync();
      connectionBloc.dispatch(CheckInternet());
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
              Api.confirmImmunization(id),
              body: json.encode(data),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader: "Bearer $token"
              },
            );

            var decodedResponse = json.decode(response.body);

            print(decodedResponse);

            setState(() {
              offlineList = [];
            });
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
      setState(() {
        offlineList = jsonContent;
      });
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
      'lat': userLocation["latitude"].toString(),
      'lon': userLocation["longitude"].toString(),
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

      setState(() {
        _success = "Immunization Saved!";
      });

      readFile();
    }
  }

  List vaccines = [];

  List vaccineList = [];

  List offlineList = [];

  submit() async {
    if (connectionBloc.connected == true && reg.text.length > 1) {
      setState(() {
        _error = "";
        _loading = true;
      });

      Map obj = {
        'immunizationCode': reg.text,
        'type': '',
        'lat': userLocation["latitude"].toString(),
        'lon': userLocation["longitude"].toString(),
      };

      for (var vaccine in vaccines) {
        obj['immunizationCode'] = reg.text;
        obj['type'] = vaccine;

        try {
          String token = await Authentication.getToken();
          String id = await Authentication.getId();

          http.Response response = await http.post(
            Api.confirmImmunization(id),
            body: json.encode(obj),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader: "Bearer $token"
            },
          );

          var decodedResponse = json.decode(response.body);

          if (decodedResponse['message'] == 'saved') {
            setState(() {
              _success = "Immunization Confirmed!";
            });
          } else {
            setState(() {
              _error = "Could not confirm immunization!";
            });
          }

          print(decodedResponse);
        } catch (e) {
          print("error: $e");
        }
      }
    } else {
      setState(() {
        _error = "Fill in immunization code or scan qr code";
      });
    }
    setState(() {
      _loading = false;
    });
  }

  getCode() async {
    setState(() {
      _loading = true;
    });
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

      setState(() {
        _error = '';
        reg.text = code;
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      _loading = true;
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
    setState(() {
      _error = "";
    });
    if (reg.text.length < 1 || selectedIndex == 0) {
      setState(() {
        _error = "Please Fill in all fields";
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
            fontSize: 25.0,
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
            Container(
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
            ),
            SizedBox(
              height: 30,
            ),
            CheckboxGroup(
                labels: <String>[
                  "BCG",
                  "HBV 1",
                  "OPV",
                  "OPV 1",
                  "PCV 1",
                  "Rotarix 1",
                  "Pentavalent 1",
                  "OPV 2",
                  "Rotarix 2",
                  "PCV 2",
                  "Pentavalent 2",
                  "OPV 3",
                  "PCV 3",
                  "IPV",
                  "Rotarix 3",
                  "Pentavalent 3",
                  "Vitamin A1",
                  "Measles Vaccine",
                  "Yellow Fever vaccine",
                  "Meningitis vaccine",
                  "Vitamin A2",
                  "OPV booster",
                  "Measles 2",
                  "Typhoid Vaccine",
                ],
                onSelected: (List<String> checked) {
                  setState(() {
                    vaccines = checked;
                  });
                }),
            SizedBox(
              height: 20,
            ),
            _success.length > 0 ? successWidget() : errorWidget(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 55),
              child: Center(
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
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(left: 55, right: 55, bottom: 40),
              child: _loading == false
                  ? ButtonWidget(
                      color: RemColors.green,
                      onTap: () {
                        setState(() {
                          _success = '';
                          _error = '';
                        });
                        if (connectionBloc.connected == false) {
                          save();
                        } else {
                          submit();
                        }
                      },
                      shadow: Color.fromRGBO(70, 193, 13, 0.46),
                      text: "Confirm Immunization",
                    )
                  : Container(),
            ),
          ],
        ),
      ),
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
          this.barcode = 'The user did not grant the camera permission!';
          _error = 'Please Grant Camera Access';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  Future<Map<String, double>> _getLocation() async {
    var currentLocation = <String, double>{};
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      currentLocation = null;
      print(e);
    }
    return currentLocation;
  }
}
