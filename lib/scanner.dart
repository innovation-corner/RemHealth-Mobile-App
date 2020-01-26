import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:remhealth_mobile/custom_widgets/button_widget.dart';
import 'package:remhealth_mobile/custom_widgets/custom_colors.dart';

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  String barcode = "";

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Scan QR code',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25.0,
                fontFamily: "Poppins",
                color: Colors.white,
              )),
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            CheckboxGroup(
              labels: <String>[
                "Sunday",
                "Monday",
                "Tuesday",
                "Wednesday",
                "Thursday",
                "Friday",
                "Saturday",
              ],
              disabled: ["Wednesday", "Friday"],
              onChange: (bool isChecked, String label, int index) =>
                  print("isChecked: $isChecked   label: $label  index: $index"),
              onSelected: (List<String> checked) =>
                  print("checked: ${checked.toString()}"),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: ButtonWidget(
                      color: Colors.orange,
                      onTap: () {
                        scan();
                      },
                      shadow: Color.fromRGBO(234, 154, 16, 0.72),
                      text: "Scan Code",
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      barcode,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
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
