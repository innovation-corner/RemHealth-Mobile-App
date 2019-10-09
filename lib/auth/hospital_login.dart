import 'package:flutter/material.dart';
import 'package:immunization_mobile/auth/hospital_register.dart';
import 'package:immunization_mobile/custom_widgets/button_widget.dart';
import 'package:immunization_mobile/custom_widgets/custom_colors.dart';
import 'package:immunization_mobile/custom_widgets/input_text.dart';
import 'package:immunization_mobile/home_page.dart';

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
      _phoneError = "";
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
                    height: MediaQuery.of(context).size.height * 0.2,
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
                  margin: EdgeInsets.symmetric(horizontal: 55),
                  child: _loading == false
                      ? ButtonWidget(
                          color: RemColors.green,
                          onTap: () {
                            setState(() {
                              _loading = true;
                            });
                            validateInput();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomePage()));
                            setState(() {
                              _loading = false;
                            });
                          },
                          shadow: Color.fromRGBO(70, 193, 13, 0.46),
                          text: "Login",
                        )
                      : CircularProgressIndicator(
                          backgroundColor: RemColors.green,
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
                            setState(() {
                              _loading = true;
                            });
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                            setState(() {
                              _loading = false;
                            });
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
