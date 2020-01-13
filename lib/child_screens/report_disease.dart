import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:immunization_mobile/bloc/bloc.dart';
import 'package:immunization_mobile/bloc/bloc.dart' as prefix0;
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

class ReportDisease extends StatefulWidget {
  @override
  _ReportDiseaseState createState() => _ReportDiseaseState();
}

class _ReportDiseaseState extends State<ReportDisease> {
  final connectionBloc = ConnectionBloc();

  @override
  void initState() {
    super.initState();
    selectedDisease = Lists.diseases[0];
    connectionBloc.dispatch(CheckInternet());
    selectedState = Lists.stateList[0];
    selectedLocalGovt = Lists.localGovtList[0];
    runCheck();
    _getLocation();
  }

  //location
  var location = new Location();

  Map<String, double> userLocation;

  //dropdown values
  Map selectedState;
  var selectedLocalGovt;
  List locals = [
    "Select Local Government",
  ];

  switches() {
    switch (selectedStateIndex) {
      case 1:
        {
          locals.clear();
          locals.addAll(Lists.abia);
        }
        break;

      case 2:
        {
          locals.clear();
          locals.addAll(Lists.adamawa);
        }
        break;

      case 3:
        {
          locals.clear();
          locals.addAll(Lists.akwaIbom);
        }
        break;

      case 4:
        {
          locals.clear();
          locals.addAll(Lists.anambra);
        }
        break;

      case 5:
        {
          locals.clear();
          locals.addAll(Lists.bauchi);
        }
        break;

      case 6:
        {
          locals.clear();
          locals.addAll(Lists.bayelsa);
        }
        break;

      case 7:
        {
          locals.clear();
          locals.addAll(Lists.benue);
        }
        break;

      case 8:
        {
          locals.clear();
          locals.addAll(Lists.borno);
        }
        break;

      case 9:
        {
          locals.clear();
          locals.addAll(Lists.crossRiver);
        }
        break;

      case 10:
        {
          locals.clear();
          locals.addAll(Lists.delta);
        }
        break;

      case 11:
        {
          locals.clear();
          locals.addAll(Lists.ebonyi);
        }
        break;

      case 12:
        {
          locals.clear();
          locals.addAll(Lists.enugu);
        }
        break;

      case 13:
        {
          locals.clear();
          locals.addAll(Lists.edo);
        }
        break;

      case 14:
        {
          locals.clear();
          locals.addAll(Lists.ekiti);
        }
        break;

      case 15:
        {
          locals.clear();
          locals.addAll(Lists.fct);
        }
        break;

      case 16:
        {
          locals.clear();
          locals.addAll(Lists.gombe);
        }
        break;

      case 17:
        {
          locals.clear();
          locals.addAll(Lists.imo);
        }
        break;

      case 18:
        {
          locals.clear();
          locals.addAll(Lists.jigawa);
        }
        break;

      case 19:
        {
          locals.clear();
          locals.addAll(Lists.kaduna);
        }
        break;

      case 20:
        {
          locals.clear();
          locals.addAll(Lists.kano);
        }
        break;

      case 21:
        {
          locals.clear();
          locals.addAll(Lists.katsina);
        }
        break;

      case 22:
        {
          locals.clear();
          locals.addAll(Lists.kebbi);
        }
        break;

      case 23:
        {
          locals.clear();
          locals.addAll(Lists.kogi);
        }
        break;

      case 24:
        {
          locals.clear();
          locals.addAll(Lists.kwara);
        }
        break;

      case 25:
        {
          locals.clear();
          locals.addAll(Lists.lagos);
        }
        break;

      case 26:
        {
          locals.clear();
          locals.addAll(Lists.nasarawa);
        }
        break;

      case 27:
        {
          locals.clear();
          locals.addAll(Lists.niger);
        }
        break;

      case 28:
        {
          locals.clear();
          locals.addAll(Lists.ogun);
        }
        break;

      case 29:
        {
          locals.clear();
          locals.addAll(Lists.ondo);
        }
        break;

      case 30:
        {
          locals.clear();
          locals.addAll(Lists.osun);
        }
        break;

      case 31:
        {
          locals.clear();
          locals.addAll(Lists.oyo);
        }
        break;

      case 32:
        {
          locals.clear();
          locals.addAll(Lists.plateau);
        }
        break;

      case 33:
        {
          locals.clear();
          locals.addAll(Lists.rivers);
        }
        break;

      case 34:
        {
          locals.clear();
          locals.addAll(Lists.sokoto);
        }
        break;

      case 35:
        {
          locals.clear();
          locals.addAll(Lists.taraba);
        }
        break;

      case 36:
        {
          locals.clear();
          locals.addAll(Lists.yobe);
        }
        break;

      case 37:
        {
          locals.clear();
          locals.addAll(Lists.zamfara);
        }
        break;

      default:
    }
  }

  //dropdown indexes
  int selectedStateIndex = 0;
  int selectedLocalIndex = 0;

  Widget stateDropDown(String text, String hint, List items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontFamily: "Lato",
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        SizedBox(
          height: 6.0,
        ),
        Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.white),
          child: DropdownButtonHideUnderline(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton(
                    style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black),
                    hint: Text(
                      hint,
                      style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.grey),
                    ),
                    value: items[selectedStateIndex],
                    items: items.map((obj) {
                      return new DropdownMenuItem(
                        value: obj,
                        child: new Text(obj['text']),
                      );
                    }).toList(),
                    onChanged: (obj) {
                      setState(() {
                        selectedState = obj;
                        selectedStateIndex = obj['value'];
                        // getLocalGovt();
                        switches();
                      });
                    }),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget localDropDown(String text, String hint, List items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontFamily: "Lato",
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        SizedBox(
          height: 6.0,
        ),
        Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.white),
          child: DropdownButtonHideUnderline(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton(
                    style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black),
                    hint: Text(
                      hint,
                      style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.grey),
                    ),
                    value: selectedStateIndex == 0
                        ? items[0]
                        : items[selectedLocalIndex],
                    items: selectedStateIndex != 0
                        ? items.map((obj) {
                            return new DropdownMenuItem(
                              value: obj,
                              child: new Text(obj),
                            );
                          }).toList()
                        : null,
                    onChanged: (obj) {
                      setState(() {
                        selectedLocalGovt = obj;
                        selectedLocalIndex = items.indexOf(obj);
                      });
                    }),
              ),
            ),
          ),
        )
      ],
    );
  }

  runCheck() {
    var oneSec = Duration(seconds: 3);
    Timer.periodic(oneSec, (Timer t) async {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/disease.json');
      bool fileExists = file.existsSync();
      connectionBloc.dispatch(CheckInternet());
      if (fileExists == true) {
        submitOffline();
      }
      connectionBloc.dispatch(CheckInternet());
    });
  }

  submitOffline() async {
    if (connectionBloc.connected == true) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/disease.json');
      List jsonContent = json.decode(file.readAsStringSync());

      Map data = {
        'immunizationCode': '',
        'type': '',
        'state': '',
        'lga': '',
        'lat': '',
        'lon': ''
      };

      for (var i = 0; i < jsonContent.length; i++) {
        List list = jsonContent[i]['disease'];
        for (var disease in list) {
          data['type'] = disease;
          data['state'] = jsonContent[i]['state'];
          data['lga'] = jsonContent[i]['lga'];
          data['lat'] = jsonContent[i]['lat'];
          data['lon'] = jsonContent[i]['lon'];

          try {
            String token = await Authentication.getToken();
            String id = await Authentication.getId();

            http.Response response = await http.post(
              Api.reportDisease(jsonContent[i]['immunizationCode']),
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
      final file = File('${directory.path}/disease.json');
      List jsonContent = json.decode(file.readAsStringSync());
      setState(() {
        offlineList = jsonContent;
      });
      print(offlineList);
    } catch (e) {
      print("Couldn't read file disease.json : $e");
    }
  }

  deleteFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/disease.json');
    file.deleteSync(recursive: true);
  }

  save() async {
    Map data = {
      'immunizationCode': reg.text.trim(),
      'disease': diseases,
      'state': selectedState['text'],
      'lga': selectedLocalGovt,
      'lat': userLocation["latitude"].toString(),
      'lon': userLocation["longitude"].toString(),
    };

    diseaseList.add(data);

    if (connectionBloc.connected == false && reg.text.length > 1) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/disease.json');
      bool fileExists = file.existsSync();

      if (fileExists == true) {
        print("File exists");
        List jsonContent = json.decode(file.readAsStringSync());
        jsonContent.add(data);
        file.writeAsStringSync(json.encode(jsonContent));
      } else {
        file.writeAsStringSync(json.encode(diseaseList));
        print('saved disease.json');
      }

      setState(() {
        _success = "Disease Saved!";
      });

      readFile();
    }
  }

  List diseases = [];

  List diseaseList = [];

  List offlineList = [];

  report() async {
    if (connectionBloc.connected == true && reg.text.length > 1) {
      setState(() {
        _error = "";
        _loading = true;
      });

      Map obj = {
        'immunizationCode': reg.text,
        'type': '',
        'state': selectedState['text'],
        'lga': selectedLocalGovt,
        'lat': userLocation["latitude"].toString(),
        'lon': userLocation["longitude"].toString(),
      };

      for (var disease in diseases) {
        obj['type'] = disease;

        try {
          String token = await Authentication.getToken();
          String id = await Authentication.getId();

          http.Response response = await http.post(
            Api.reportDisease(reg.text.trim()),
            body: json.encode(obj),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader: "Bearer $token"
            },
          );

          var decodedResponse = json.decode(response.body);

          print(decodedResponse);

          if (response.statusCode == 200) {
            setState(() {
              _success = "Disease Reported";
              _loading = false;
            });
          } else {
            setState(() {
              _error = decodedResponse['message'];
              _loading = false;
            });
          }
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

  //barcode details
  String barcode = "";

  //dropdown values
  var selectedDisease;

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

    if (userLocation == null) {
      setState(() {
        _error = "Please Turn On GPS!";
      });
      return false;
    }

    return true;
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
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Report Disease",
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
            Container(
              margin: EdgeInsets.symmetric(horizontal: 23),
              child: stateDropDown("State", "Select State", Lists.stateList),
            ),
            SizedBox(
              height: 30,
            ),
            //local govt dropdown
            Container(
              margin: EdgeInsets.symmetric(horizontal: 23),
              child: localDropDown(
                  "Local Government", "Select State First", locals),
            ),
            SizedBox(
              height: 30,
            ),
            CheckboxGroup(
                labels: <String>[
                  "Tuberculosis",
                  "Hepatitis",
                  "Poliomyelitis",
                  "Pneumonia",
                  "Diarrhoea",
                  "Diphtheria",
                  "Tetanus",
                  "Pertussis",
                  "Hepatitis B",
                  "Hemophilus Influenza type B",
                  "Poor vision",
                  "Measles",
                  "Yellow fever",
                  "Meningococcal Meningitis",
                  "Typhoid",
                ],
                onSelected: (List<String> checked) {
                  setState(() {
                    diseases = checked;
                  });
                }),
            SizedBox(
              height: 40,
            ),
            _success.length > 0 ? successWidget() : errorWidget(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 65),
              child: Center(
                child: _loading == false
                    ? ButtonWidget(
                        color: Colors.orange,
                        onTap: () {
                          setState(() {
                            _loading = true;
                          });
                          scan();
                          validateInput();
                          setState(() {
                            _loading = false;
                          });
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
                        _getLocation();
                        if (connectionBloc.connected == false) {
                          save();
                        } else {
                          report();
                        }
                      },
                      shadow: Color.fromRGBO(70, 193, 13, 0.46),
                      text: "Report Disease",
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

  Future<Map<String, double>> _getLocation() async {
    var currentLocation = <String, double>{};
    try {
      currentLocation = await location.getLocation();
      if (this.mounted) {
        setState(() {
          userLocation = currentLocation;
        });
      }
    } catch (e) {
      currentLocation = null;
      print(e);
    }
    return currentLocation;
  }
}
