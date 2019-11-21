import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immunization_mobile/auth/hospital_register.dart';
import 'package:immunization_mobile/bloc/bloc.dart';
import 'package:immunization_mobile/config/api.dart';
import 'package:immunization_mobile/config/auth_details.dart';
import 'package:immunization_mobile/custom_widgets/button_widget.dart';
import 'package:immunization_mobile/custom_widgets/custom_colors.dart';
import 'package:immunization_mobile/custom_widgets/input_text.dart';
import 'package:immunization_mobile/home_page.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

// controllers for our inputs
  static TextEditingController email = TextEditingController();
  static TextEditingController password = TextEditingController();

  //loading state
  bool _loading = false;

  validateInput() {
    setState(() {
      _error = "";
    });
    if (email.text.length < 1) {
      setState(() {
        _error = "Please Fill in email or password";
      });
      return false;
    }

    if (password.text.length < 1) {
      setState(() {
        _error = "Fill up your password";
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

  loginUser() async {
    Map<String, dynamic> inputData = {
      "email": email.text.trim(),
      "password": password.text.trim()
    };

    if (validateInput()) {
      setState(() {
        _loading = true;
      });
      try {
        http.Response response = await http.post(
          Api.login,
          body: json.encode(inputData),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        );

        var decodedResponse = json.decode(response.body);
        int statusCode = response.statusCode;

        if (statusCode != 200) {
          setState(() {
            _error = decodedResponse['message'];
          });
          print(decodedResponse);
        } else {
// save user details and token in shared preferences
          await Authentication.storeToken(decodedResponse);

          final _authenticationBloc =
              BlocProvider.of<AuthenticationBloc>(context);
          _authenticationBloc.dispatch(FetchAuthState());

          // redirect to dashboard
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (context) => HomePage()));
        }
      } catch (e) {
        print(e);
        setState(() {
          _error = "An error Occured";
        });
      }
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.orange,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Image.asset(
                    "assets/logo_icon.png",
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17.0,
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
                    label: "Email/Phone number",
                    focusColor: RemColors.green,
                    borderColor: Colors.grey,
                    controller: email,
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
                  height: 40,
                ),
                errorWidget(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 65),
                  child: Center(
                    child: _loading == false
                        ? ButtonWidget(
                            color: RemColors.green,
                            onTap: () {
                              validateInput();
                              loginUser();
                            },
                            shadow: Color.fromRGBO(70, 193, 13, 0.46),
                            text: "Login",
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
                  margin: EdgeInsets.symmetric(horizontal: 65),
                  child: _loading == false
                      ? ButtonWidget(
                          color: Colors.orange,
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                          shadow: Color.fromRGBO(234, 154, 16, 0.72),
                          text: "Register",
                        )
                      : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
