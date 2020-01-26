import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
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
import 'package:intl/intl.dart';

class UpdateChild extends StatefulWidget {
  @override
  _UpdateChildState createState() => _UpdateChildState();
}

class _UpdateChildState extends State<UpdateChild> {
  final connectionBloc = ConnectionBloc();
  DateTime selectedDate;

  @override
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
    _getLocation();
  }

  //location
  var location = new Location();

  Future<LocationData> _getLocation() async {
    LocationData currentLocation;
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

  LocationData userLocation;

  //barcode details
  String barcode = "";

  //dropdown values
  Map selectedState;
  Map phcSelectedState;

  var selectedLocalGovt;
  var phcSelectedLocalGovt;

  var selectedPhc;

  String selectedLanguage;

  String selectedGender;

  List locals = [
    "Select Local Government",
  ];

  switches() {
    switch (selectedStateIndex) {
      case 1:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.abia);
        }
        break;

      case 2:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.adamawa);
        }
        break;

      case 3:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.akwaIbom);
        }
        break;

      case 4:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.anambra);
        }
        break;

      case 5:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.bauchi);
        }
        break;

      case 6:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.bayelsa);
        }
        break;

      case 7:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.benue);
        }
        break;

      case 8:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.borno);
        }
        break;

      case 9:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.crossRiver);
        }
        break;

      case 10:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.delta);
        }
        break;

      case 11:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.ebonyi);
        }
        break;

      case 12:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.enugu);
        }
        break;

      case 13:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.edo);
        }
        break;

      case 14:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.ekiti);
        }
        break;

      case 15:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.fct);
        }
        break;

      case 16:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.gombe);
        }
        break;

      case 17:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.imo);
        }
        break;

      case 18:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.jigawa);
        }
        break;

      case 19:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.kaduna);
        }
        break;

      case 20:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.kano);
        }
        break;

      case 21:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.katsina);
        }
        break;

      case 22:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.kebbi);
        }
        break;

      case 23:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.kogi);
        }
        break;

      case 24:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.kwara);
        }
        break;

      case 25:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.lagos);
        }
        break;

      case 26:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.nasarawa);
        }
        break;

      case 27:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.niger);
        }
        break;

      case 28:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.ogun);
        }
        break;

      case 29:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.ondo);
        }
        break;

      case 30:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.osun);
        }
        break;

      case 31:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.oyo);
        }
        break;

      case 32:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.plateau);
        }
        break;

      case 33:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.rivers);
        }
        break;

      case 34:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.sokoto);
        }
        break;

      case 35:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.taraba);
        }
        break;

      case 36:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.yobe);
        }
        break;

      case 37:
        {
          locals.clear();
          locals.add("Select Local Government");
          locals.addAll(Lists.zamfara);
        }
        break;

      default:
    }
  }

  //dropdown indexes
  int selectedStateIndex = 0;
  int selectedLocalIndex = 0;

  int phcSelectedStateIndex = 0;
  int phcSelectedLocalIndex = 0;

  int selectedPhcIndex = 0;

  int languageIndex = 0;

  int genderIndex = 0;

  // controllers for our inputs
  static TextEditingController reg = TextEditingController();
  static TextEditingController childName = TextEditingController();
  static TextEditingController fatherName = TextEditingController();
  static TextEditingController motherName = TextEditingController();
  static TextEditingController careGiver = TextEditingController();
  static TextEditingController phoneNumber = TextEditingController();
  static TextEditingController dateOfBirth = TextEditingController();

  //loading state
  bool _loading = false;

  validateInput() {
    setState(() {
      _error = "";
    });
    if (reg.text.length < 1 ||
        phoneNumber.text.length < 1 ||
        childName.text.length < 1 ||
        dateOfBirth.text.length < 1 ||
        selectedStateIndex == 0 ||
        selectedLocalIndex == 0) {
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

  String _success = "";

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
                        switches();
                        // getLocalGovt(selectedState['text']);
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
                        ? locals[0]
                        : locals[selectedLocalIndex],
                    items: selectedStateIndex != 0
                        ? locals.map((obj) {
                            return new DropdownMenuItem(
                              value: obj,
                              child: new Text(obj),
                            );
                          }).toList()
                        : null,
                    onChanged: (obj) {
                      setState(() {
                        selectedLocalGovt = obj;
                        selectedLocalIndex = locals.indexOf(obj);
                      });
                    }),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget phcStateDropDown(String text, String hint, List items) {
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
                    value: items[phcSelectedStateIndex],
                    items: items.map((obj) {
                      return new DropdownMenuItem(
                        value: obj,
                        child: new Text(obj['text']),
                      );
                    }).toList(),
                    onChanged: (obj) {
                      setState(() {
                        phcSelectedState = obj;
                        phcSelectedStateIndex = obj['value'];
                        // getLocalGovt(phcSelectedState['text']);
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

  Widget phcLocalDropDown(String text, String hint, List items) {
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
                    value: phcSelectedStateIndex == 0
                        ? items[0]
                        : items[phcSelectedLocalIndex],
                    items: phcSelectedStateIndex != 0
                        ? items.map((obj) {
                            return new DropdownMenuItem(
                              value: obj,
                              child: new Text(obj),
                            );
                          }).toList()
                        : null,
                    onChanged: (obj) {
                      setState(() {
                        phcSelectedLocalGovt = obj;
                        phcSelectedLocalIndex = items.indexOf(obj);
                      });
                    }),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget primaryHealthCareDropdown(String text, String hint, List items) {
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
                    value: items[selectedPhcIndex],
                    items: items.map((obj) {
                      return new DropdownMenuItem(
                        value: obj,
                        child: new Text(obj),
                      );
                    }).toList(),
                    onChanged: (obj) {
                      setState(() {
                        selectedPhc = obj;
                        selectedPhcIndex = items.indexOf(obj);
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
      final file = File('${directory.path}/update.json');
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
      final file = File('${directory.path}/update.json');
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

          http.Response response = await http.put(
            Api.editChild(obj['code']),
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
      final file = File('${directory.path}/update.json');
      List jsonContent = json.decode(file.readAsStringSync());
      setState(() {
        offlineList = jsonContent;
      });
      print(offlineList);
    } catch (e) {
      print("Couldn't read file update.json : $e");
    }
  }

  deleteFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/update.json');
    file.deleteSync(recursive: true);
    print('deleted update.json');
  }

  save() async {
    Map data = {
      'code': reg.text,
      'name': childName.text,
      'dob': selectedDate.toIso8601String(),
      'phonenumber': phoneNumber.text,
      'state': selectedState['text'],
      'lga': selectedLocalGovt,
      'language': selectedLanguage,
      'gender': selectedGender,
      'qrCode': barcode,
      'lat': userLocation.latitude.toString(),
      'lon': userLocation.longitude.toString(),
    };

    childList.add(data);

    if (connectionBloc.connected == false && validateInput() == true) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/update.json');
      bool fileExists = file.existsSync();

      if (fileExists == true) {
        print("File exists");
        List jsonContent = json.decode(file.readAsStringSync());
        jsonContent.add(data);
        file.writeAsStringSync(json.encode(jsonContent));
      } else {
        file.writeAsStringSync(json.encode(childList));
        print('saved update.json');
      }

      setState(() {
        _success = "Child Details Updated!";
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
        'qrCode': barcode,
        'lat': userLocation.latitude.toString(),
        'lon': userLocation.longitude.toString(),
      };

      try {
        String token = await Authentication.getToken();

        http.Response response = await http.put(
          Api.editChild(reg.text.trim()),
          body: json.encode(obj),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: "Bearer $token"
          },
        );

        var decodedResponse = json.decode(response.body);

        if (decodedResponse['message'] == 'Data updated') {
          setState(() {
            childName.text = '';
            dateOfBirth.text = '';
            phoneNumber.text = '';
            genderIndex = 0;
            languageIndex = 0;
            barcode = '';
            _success = "Data Updated!";
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
          "Update Child Details",
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
                      text: "Update Details",
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
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
}
