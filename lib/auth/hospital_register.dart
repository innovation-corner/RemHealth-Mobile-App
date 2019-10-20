import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immunization_mobile/auth/hospital_login.dart';
import 'package:immunization_mobile/bloc/bloc.dart';
import 'package:immunization_mobile/config/api.dart';
import 'package:immunization_mobile/config/auth_details.dart';
import 'package:immunization_mobile/custom_widgets/button_widget.dart';
import 'package:immunization_mobile/custom_widgets/custom_colors.dart';
import 'package:immunization_mobile/custom_widgets/input_text.dart';
import 'package:immunization_mobile/home_page.dart';
import 'package:immunization_mobile/lists.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  void initState() {
    super.initState();
    selectedState = Lists.stateList[0];
    selectedLocalGovt = Lists.localGovtList[0];
  }

  // controllers for our inputs
  static TextEditingController hospitalName = TextEditingController();
  static TextEditingController address = TextEditingController();
  static TextEditingController contactName = TextEditingController();
  static TextEditingController phoneNumber = TextEditingController();
  static TextEditingController email = TextEditingController();
  static TextEditingController password = TextEditingController();
  static TextEditingController retypePassword = TextEditingController();

  //dropdown values
  Map selectedState;
  var selectedLocalGovt;
  List locals = [
    "Select Local Government",
  ];

  //dropdown indexes
  int selectedStateIndex = 0;
  int selectedLocalIndex = 0;

  //loading state
  bool _loading = false;

  validateInput() {
    setState(() {
      _error = "";
      _phoneError = "";
    });
    if (address.text.length < 1 ||
        email.text.length < 1 ||
        contactName.text.length < 1 ||
        hospitalName.text.length < 1 ||
        selectedStateIndex == 0 ||
        selectedLocalIndex == 0) {
      setState(() {
        _error = "Please Fill in all fields";
      });
      return false;
    }
    if (phoneNumber.text.length < 10) {
      setState(() {
        _error = "Phone number must be at least 10 characters";
      });
      return false;
    }
    if (password.text.length < 1) {
      setState(() {
        _error = "Fill up your password";
      });
      return false;
    }
    if (retypePassword.text.length < 1) {
      setState(() {
        _error = "Confirm your password";
      });
      return false;
    }
    if (retypePassword.text != password.text) {
      setState(() {
        _error = "Passwords do not match!";
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

  Future getLocalGovt() async {
    var state = selectedState['text'];
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

      print(newLocals);
    } catch (e) {}
  }

  register() async {
    Map<String, dynamic> inputData = {
      "name": hospitalName.text.trim(),
      "phonenumber": phoneNumber.text.trim(),
      "email": email.text.trim(),
      "password": password.text.trim(),
      "address": address.text.trim(),
      "state": selectedState['text'],
      "lga": selectedLocalGovt,
      "contactName": contactName.text.trim(),
    };

    if (validateInput()) {
      setState(() {
        _loading = true;
      });
      try {
        http.Response response = await http.post(
          Api.register,
          body: json.encode(inputData),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        );

        var decodedResponse = json.decode(response.body);
        int statusCode = response.statusCode;

        if (statusCode != 200) {
          setState(() {
            _error = "An Error occured";
          });
          print(decodedResponse);
        }

        // save user details and token in shared preferences
        await Authentication.storeToken(decodedResponse);

        final _authenticationBloc =
            BlocProvider.of<AuthenticationBloc>(context);
        _authenticationBloc.dispatch(FetchAuthState());

        // redirect to dashboard
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        print(e);
        setState(() {
          _error = "An error Occured";
        });
        print(json.encode(inputData));
      }
      setState(() {
        _loading = false;
      });
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
                        getLocalGovt();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Center(
                child: Image.asset(
                  "assets/logo_icon.png",
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: Text(
                  "REGISTER",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 25.0,
                      fontFamily: "Poppins",
                      color: Colors.grey),
                ),
              ),
              SizedBox(
                height: 23.0,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 23),
                child: InputText(
                  cursorColor: RemColors.green,
                  obscureText: false,
                  label: "Hospital Name",
                  focusColor: RemColors.green,
                  borderColor: Colors.grey,
                  controller: hospitalName,
                  onChanged: (text) {},
                ),
              ),
              SizedBox(
                height: 30,
              ),
              //state Dropdown
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 23),
                child: InputText(
                  cursorColor: Colors.grey,
                  obscureText: false,
                  label: "Address",
                  focusColor: RemColors.green,
                  borderColor: Colors.grey,
                  controller: address,
                  onChanged: (text) {},
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 23),
                child: InputText(
                  cursorColor: Colors.grey,
                  obscureText: false,
                  label: "Name Of contact Person",
                  focusColor: RemColors.green,
                  borderColor: Colors.grey,
                  controller: contactName,
                  onChanged: (text) {},
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 23),
                child: InputText(
                  cursorColor: Colors.grey,
                  obscureText: false,
                  label: "Phone Number",
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
                child: InputText(
                  cursorColor: Colors.grey,
                  obscureText: false,
                  label: "Email",
                  focusColor: RemColors.green,
                  borderColor: Colors.grey,
                  controller: email,
                  onChanged: (text) {},
                  type: TextInputType.emailAddress,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 23),
                child: InputText(
                  cursorColor: Colors.grey,
                  obscureText: true,
                  label: "Password",
                  focusColor: RemColors.green,
                  borderColor: Colors.grey,
                  controller: password,
                  onChanged: (text) {},
                  type: TextInputType.visiblePassword,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 23),
                child: InputText(
                  cursorColor: Colors.grey,
                  obscureText: true,
                  label: "Confirm Password",
                  focusColor: RemColors.green,
                  borderColor: Colors.grey,
                  controller: retypePassword,
                  onChanged: (text) {},
                  type: TextInputType.visiblePassword,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              errorWidget(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 55),
                child: Center(
                  child: _loading == false
                      ? ButtonWidget(
                          color: RemColors.green,
                          onTap: () {
                            validateInput();
                            register();
                          },
                          shadow: Color.fromRGBO(70, 193, 13, 0.46),
                          text: "Register",
                        )
                      : CircularProgressIndicator(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  color: Colors.grey,
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 1,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 55),
                child: _loading == false
                    ? ButtonWidget(
                        color: Colors.orange,
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        shadow: Color.fromRGBO(234, 154, 16, 0.72),
                        text: "Back To Login",
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
