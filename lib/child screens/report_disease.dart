import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:immunization_mobile/bloc/bloc.dart';
import 'package:immunization_mobile/bloc/bloc.dart' as prefix0;
import 'package:immunization_mobile/custom_widgets/button_widget.dart';
import 'package:immunization_mobile/custom_widgets/custom_colors.dart';
import 'package:immunization_mobile/custom_widgets/input_text.dart';
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
    // connectionBloc.dispatch(CheckInternet());
    saveFile();
    submit();
  }

  readFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      print(directory.toString());
      final file = File('${directory.path}/my_file.txt');
      String text = await file.readAsString();
      print(text);
    } catch (e) {
      print("Couldn't read file");
    }
  }

  saveFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/my_file.txt');
    final text = data.toString();
    await file.writeAsString(text);
    print('saved');
  }

  deleteFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/my_file.txt');
    file.deleteSync(recursive: true);
  }

  submit() async {
    data.add("second");
    if (connectionBloc.connected == false) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/my_file.txt');
      final text = data.toString();
      await file.writeAsString(text);
      print('saved');

      readFile();
    }
  }

  List data = ["text"];

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
                        selectedDisease = obj;
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
          "Report Disease",
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
              // onChange: (bool isChecked, String label, int index) =>
              //     print("isChecked: $isChecked   label: $label  index: $index"),
              onSelected: (List<String> checked) =>
                  print("checked: ${checked.toString()}"),
            ),
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 23),
            //   child:
            //       vaccineDropDown("Disease", "Select Disease", Lists.diseases),
            // ),
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
