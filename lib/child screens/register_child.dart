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
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../lists.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class RegisterChild extends StatefulWidget {
  @override
  _RegisterChildState createState() => _RegisterChildState();
}

class _RegisterChildState extends State<RegisterChild> {
  @override
  final connectionBloc = ConnectionBloc();
  DateTime selectedDate;

  void initState() {
    super.initState();
    selectedState = Lists.stateList[0];
    selectedLocalGovt = Lists.localGovtList[0];
    phcSelectedState = Lists.stateList[0];
    phcSelectedLocalGovt = Lists.localGovtList[0];
    selectedLanguage = Lists.languages[0];
    selectedGender = Lists.gender[0];
    selectedDate = DateTime.now();
    runCheck();
  }

  //barcode details
  String barcode = "";

  //dropdown values
  Map selectedState;
  Map phcSelectedState;

  String selectedLocalGovt;
  var phcSelectedLocalGovt;

  var selectedPhc;

  String selectedLanguage;

  String selectedGender;

  List locals = [
    "Select Local Government",
  ];

  //dropdown indexes
  int selectedStateIndex = 0;
  int selectedLocalIndex = 0;

  int phcSelectedStateIndex = 0;
  int phcSelectedLocalIndex = 0;

  int selectedPhcIndex = 0;

  int languageIndex = 0;

  int genderIndex = 0;

  // controllers for our inputs
  static TextEditingController childName = TextEditingController();
  static TextEditingController fatherName = TextEditingController();
  static TextEditingController motherName = TextEditingController();
  static TextEditingController careGiver = TextEditingController();
  static TextEditingController phoneNumber = TextEditingController();
  static TextEditingController password = TextEditingController();
  static TextEditingController retypePassword = TextEditingController();
  static TextEditingController dateOfBirth = TextEditingController();

  //loading state
  bool _loading = false;

  validateInput() {
    setState(() {
      _error = "";
    });
    if (phoneNumber.text.length < 1 ||
        childName.text.length < 1 ||
        dateOfBirth.text.length < 1 ||
        selectedStateIndex == 0 ||
        selectedLocalIndex == 0 ||
        genderIndex == 0 ||
        languageIndex == 0) {
      setState(() {
        _error = "Please Fill in all fields";
      });
      return false;
    }
    if (phoneNumber.text.length < 10) {
      setState(() {
        _error = "Phone Number must be at least 10 numbers";
      });
      return false;
    }
    if (barcode.length < 2) {
      setState(() {
        _error = "Scan QR code";
      });
      return false;
    }
    return true;
  }

  // stores the error state
  String _error = "";

  String _success = "";

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
                  fontSize: 16,
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

  Future getLocalGovt(String state) async {
    // var state = selectedState['text'] || phcSelectedState['text'];
    try {
      http.Response response = await http.get(
        "http://locationsng-api.herokuapp.com/api/v1/states/$state/lgas",
        // headers: {
        //   HttpHeaders.contentTypeHeader: 'application/json',
        //   HttpHeaders.authorizationHeader: "Bearer $token"
        // },
      );
      List body = json.decode(response.body);
      List newLocals = ["Select Local Government"]..addAll(body);

      setState(() {
        locals = newLocals;
      });
    } catch (e) {
      print(e);
    }
  }

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
                        getLocalGovt(selectedState['text']);
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

  Widget languageDropdown(String text, String hint, List items) {
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
                    value: languageIndex == 0 ? items[0] : items[languageIndex],
                    items: items.map((obj) {
                      return new DropdownMenuItem(
                        value: obj,
                        child: new Text(obj),
                      );
                    }).toList(),
                    onChanged: (obj) {
                      setState(() {
                        selectedLanguage = obj;
                        languageIndex = items.indexOf(obj);
                      });
                    }),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget genderDropdown(String text, String hint, List items) {
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
                    value: genderIndex == 0 ? items[0] : items[genderIndex],
                    items: items.map((obj) {
                      return new DropdownMenuItem(
                        value: obj,
                        child: new Text(obj),
                      );
                    }).toList(),
                    onChanged: (obj) {
                      setState(() {
                        selectedGender = obj;
                        genderIndex = items.indexOf(obj);
                      });
                    }),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2005),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      //format date
      var formatter = new DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(picked);

      setState(() {
        selectedDate = picked;
        dateOfBirth.text = formattedDate;
      });
    }
  }

  runCheck() {
    var oneSec = Duration(seconds: 3);
    Timer.periodic(oneSec, (Timer t) async {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/child.json');
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
      final file = File('${directory.path}/child.json');
      List jsonContent = json.decode(file.readAsStringSync());

      for (var obj in jsonContent) {
        // Map data = {
        //   'name': jsonContent,
        //   'dob': selectedDate.toIso8601String(),
        //   'phonenumber': phoneNumber.text,
        //   'state': selectedState['text'],
        //   'lga': selectedLocalGovt,
        //   'language': selectedLanguage,
        //   'gender': selectedGender,
        // };
        try {
          String token = await Authentication.getToken();

          http.Response response = await http.post(
            Api.registerChild,
            body: json.encode(obj),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader: "Bearer $token"
            },
          );

          var decodedResponse = json.decode(response.body);

          print(decodedResponse);
        } catch (e) {
          print("error: $e");
        }
      }
      deleteFile();
    }
  }

  readFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      print(directory.toString());
      final file = File('${directory.path}/child.json');
      List jsonContent = json.decode(file.readAsStringSync());
      setState(() {
        offlineList = jsonContent;
      });
      print(offlineList);
    } catch (e) {
      print("Couldn't read file child.json : $e");
    }
  }

  deleteFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/child.json');
    file.deleteSync(recursive: true);
    print('deleted');
  }

  save() async {
    Map data = {
      'name': childName.text,
      'dob': selectedDate.toIso8601String(),
      'phonenumber': phoneNumber.text,
      'state': selectedState['text'],
      'lga': selectedLocalGovt,
      'language': selectedLanguage,
      'gender': selectedGender,
      'qrCode': barcode
    };

    childList.add(data);

    if (connectionBloc.connected == false && validateInput() == true) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/child.json');
      bool fileExists = file.existsSync();

      if (fileExists == true) {
        print("File exists");
        List jsonContent = json.decode(file.readAsStringSync());
        jsonContent.add(data);
        file.writeAsStringSync(json.encode(jsonContent));
      } else {
        file.writeAsStringSync(json.encode(childList));
        print('saved child.json');
      }

      setState(() {
        _success = "Child Saved!";
      });

      readFile();
    }
  }

  List childList = [];

  List offlineList = [];

  submit() async {
    if (connectionBloc.connected == true && validateInput() == true) {
      setState(() {
        _error = "";
        _loading = true;
      });

      Map obj = {
        'name': childName.text,
        'dob': selectedDate.toIso8601String(),
        'phonenumber': phoneNumber.text,
        'state': selectedState['text'],
        'lga': selectedLocalGovt,
        'language': selectedLanguage,
        'gender': selectedGender,
        'qrCode': barcode
      };

      try {
        String token = await Authentication.getToken();

        http.Response response = await http.post(
          Api.registerChild,
          body: json.encode(obj),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: "Bearer $token"
          },
        );

        var decodedResponse = json.decode(response.body);

        if (decodedResponse['message'] == 'Data saved') {
          setState(() {
            childName.text = '';
            dateOfBirth.text = '';
            phoneNumber.text = '';
            genderIndex = 0;
            languageIndex = 0;
            barcode = '';
            _success = "Registered!";
            _loading = false;
          });
        } else {
          setState(() {
            _error = decodedResponse['message'];
            _loading = false;
          });
        }

        print(decodedResponse);
      } catch (e) {
        print("error: $e");
        setState(() {
          _error = 'An error occured.';
        });
      }
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
          "Register Child",
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
                label: "Name of child",
                focusColor: RemColors.green,
                borderColor: Colors.grey,
                controller: childName,
                onChanged: (text) {},
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 23),
              child: InputText(
                cursorColor: RemColors.green,
                obscureText: false,
                label: "Date of Birth",
                focusColor: RemColors.green,
                borderColor: Colors.grey,
                controller: dateOfBirth,
                onTap: () {
                  _selectDate(context);
                },
                type: TextInputType.datetime,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 23),
              child: languageDropdown(
                  "Language", "Select Language", Lists.languages),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 23),
              child: genderDropdown("Gender", "Select gender", Lists.gender),
            ),
            SizedBox(
              height: 30,
            ),
            //state Dropdown
            Container(
              margin: EdgeInsets.symmetric(horizontal: 23),
              child: stateDropDown(
                  "State of Origin", "Select State", Lists.stateList),
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
            Container(
              margin: EdgeInsets.symmetric(horizontal: 23),
              child: InputText(
                cursorColor: RemColors.green,
                obscureText: false,
                label: "Phone Number of caregiver/mother",
                focusColor: RemColors.green,
                borderColor: Colors.grey,
                controller: phoneNumber,
                onChanged: (text) {},
                type: TextInputType.phone,
              ),
            ),
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
                          scan();
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
                        validateInput();
                        if (connectionBloc.connected) {
                          submit();
                        } else {
                          save();
                        }
                      },
                      shadow: Color.fromRGBO(70, 193, 13, 0.46),
                      text: "Register Child",
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
}
