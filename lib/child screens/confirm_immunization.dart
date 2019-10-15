import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:immunization_mobile/custom_widgets/button_widget.dart';
import 'package:immunization_mobile/custom_widgets/custom_colors.dart';
import 'package:immunization_mobile/custom_widgets/input_text.dart';
import '../lists.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class ConfirmImmunization extends StatefulWidget {
  @override
  _ConfirmImmunizationState createState() => _ConfirmImmunizationState();
}

class _ConfirmImmunizationState extends State<ConfirmImmunization> {
  @override
  void initState() {
    super.initState();
    selectedVaccine = Lists.vaccines[0];
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

  Widget vaccineDropDown(String text, String hint, List items) {
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
                    value: items[selectedIndex],
                    items: items.map((obj) {
                      return new DropdownMenuItem(
                        value: obj,
                        child: new Text(obj),
                      );
                    }).toList(),
                    onChanged: (obj) {
                      setState(() {
                        selectedVaccine = obj;
                        selectedIndex = items.indexOf(obj);
                      });
                    }),
              ),
            ),
          ),
        )
      ],
    );
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
              // onChange: (bool isChecked, String label, int index) =>
              //     print("isChecked: $isChecked   label: $label  index: $index"),
              onSelected: (List<String> checked) =>
                  print("checked: ${checked.toString()}"),
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
