import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:immunization_mobile/custom_widgets/button_widget.dart';
import 'package:immunization_mobile/custom_widgets/custom_colors.dart';
import 'package:immunization_mobile/custom_widgets/input_text.dart';
import 'package:immunization_mobile/scanner.dart';
import '../lists.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class RegisterChild extends StatefulWidget {
  @override
  _RegisterChildState createState() => _RegisterChildState();
}

class _RegisterChildState extends State<RegisterChild> {
  @override
  void initState() {
    super.initState();
    selectedState = Lists.stateList[0];
    selectedLocalGovt = Lists.localGovtList[0];
    phcSelectedState = Lists.stateList[0];
    phcSelectedLocalGovt = Lists.localGovtList[0];
  }

  //barcode details
  String barcode = "";

  //dropdown values
  Map selectedState;
  Map phcSelectedState;

  var selectedLocalGovt;
  var phcSelectedLocalGovt;

  var selectedPhc;

  List locals = [
    "Select Local Government",
  ];

  //dropdown indexes
  int selectedStateIndex = 0;
  int selectedLocalIndex = 0;

  int phcSelectedStateIndex = 0;
  int phcSelectedLocalIndex = 0;

  int selectedPhcIndex = 0;

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
      _phoneError = "";
    });
    if (fatherName.text.length < 1 ||
        phoneNumber.text.length < 1 ||
        motherName.text.length < 1 ||
        childName.text.length < 1 ||
        dateOfBirth.text.length < 1 ||
        selectedStateIndex == 0 ||
        selectedLocalIndex == 0 ||
        phcSelectedStateIndex == 0 ||
        phcSelectedLocalIndex == 0) {
      setState(() {
        _error = "Please Fill in all fields";
      });
      return false;
    }
    if (phoneNumber.text.length < 11) {
      setState(() {
        _error = "Fill up your phone number";
      });
      return false;
    }
    return true;
  }

  // stores the error state
  String _error = "";
  String _phoneError = "";

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
                        getLocalGovt(phcSelectedState['text']);
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

  //Date Picker
  DateTime selectedDate = DateTime.now();

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
                cursorColor: Colors.green,
                obscureText: false,
                label: "Name of Father",
                focusColor: RemColors.green,
                borderColor: Colors.grey,
                controller: fatherName,
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
                label: "Name Of Mother",
                focusColor: RemColors.green,
                borderColor: Colors.grey,
                controller: motherName,
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
                label: "Name of care giver",
                focusColor: RemColors.green,
                borderColor: Colors.grey,
                controller: careGiver,
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
                label: "Phone Number of caregiver/mother",
                focusColor: RemColors.green,
                borderColor: Colors.grey,
                controller: phoneNumber,
                onChanged: (text) {},
                type: TextInputType.phone,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 23),
              child: phcStateDropDown(
                  "PHC facility State", "Select State", Lists.stateList),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 23),
              child: phcLocalDropDown(
                  "PHC Local Government", "Select State First", locals),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 23),
              child: primaryHealthCareDropdown(
                  "Primary Health Care Facility", "Select PHC", Lists.phc),
            ),
            SizedBox(
              height: 40,
            ),
            errorWidget(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 55),
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
                  : CircularProgressIndicator(
                      backgroundColor: RemColors.green,
                    ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(left: 55, right: 55, bottom: 40),
              child: _loading == false && barcode == ""
                  ? ButtonWidget(
                      color: RemColors.green,
                      onTap: () {
                        setState(() {
                          _loading = true;
                        });
                        setState(() {
                          _loading = false;
                        });
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
}
