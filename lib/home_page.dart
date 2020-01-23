import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immunization_mobile/auth/hospital_login.dart';
import 'package:immunization_mobile/child_screens/confirm_immunization.dart';
import 'package:immunization_mobile/child_screens/register_child.dart';
import 'package:immunization_mobile/child_screens/report_disease.dart';
import 'package:immunization_mobile/child_screens/update_child.dart';

import 'package:immunization_mobile/config/auth_details.dart';

import 'bloc/authentication_bloc.dart';
import 'bloc/authentication_event.dart';
import 'custom_widgets/custom_colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Rem Health",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17.0,
              fontFamily: "Poppins",
              color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.1),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RegisterChild()));
                      },
                      child: Container(
                        height: 180,
                        width: MediaQuery.of(context).size.width * 0.415,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                blurRadius: 19.5,
                                offset: Offset(0, 6),
                              )
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Stack(
                          children: <Widget>[
                            MenuText(
                              icon: Icon(
                                Icons.person_add,
                                color: RemColors.white,
                                size: 32,
                              ),
                              firstText: "Register Child",
                              secondText: "",
                              textColor: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UpdateChild()));
                      },
                      child: Container(
                        height: 180,
                        width: MediaQuery.of(context).size.width * 0.415,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                blurRadius: 19.5,
                                offset: Offset(0, 6),
                              )
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        child: Stack(
                          children: <Widget>[
                            MenuText(
                              icon: Icon(
                                Icons.update,
                                color: RemColors.white,
                                size: 32,
                              ),
                              firstText: "Update Child",
                              secondText: "",
                              textColor: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ConfirmImmunization()));
                      },
                      child: Container(
                        height: 180,
                        width: MediaQuery.of(context).size.width * 0.415,
                        decoration: BoxDecoration(
                            color: RemColors.green,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                blurRadius: 19.5,
                                offset: Offset(0, 6),
                              )
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Stack(
                          children: <Widget>[
                            MenuText(
                              icon: Icon(
                                Icons.check_box,
                                color: RemColors.white,
                                size: 30,
                              ),
                              firstText: "Confirm Immunization",
                              secondText: "",
                              textColor: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ReportDisease()));
                      },
                      child: Container(
                        height: 180,
                        width: MediaQuery.of(context).size.width * 0.415,
                        decoration: BoxDecoration(
                            color: RemColors.red,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                blurRadius: 19.5,
                                offset: Offset(0, 6),
                              )
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        child: Stack(
                          children: <Widget>[
                            MenuText(
                              icon: Icon(
                                Icons.error,
                                color: RemColors.white,
                                size: 32,
                              ),
                              firstText: "Report Disease",
                              secondText: "",
                              textColor: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              InkWell(
                onTap: () {
                  logOut();
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Log Out",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: RemColors.red,
                          fontSize: 22,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: RemColors.red,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Image.asset(
                "assets/logo_coloured.png",
                color: Colors.grey,
                width: 160,
              )
            ],
          ),
        ),
      ),
    );
  }

  logOut() async {
    await Authentication.logout();

    final _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _authenticationBloc.dispatch(FetchAuthState());

    // redirect to dashboard
    Navigator.of(context)
        .pushReplacement(new MaterialPageRoute(builder: (context) => Login()));
  }
}

class MenuText extends StatelessWidget {
  final String firstText;
  final String secondText;
  final Color textColor;
  final Icon icon;

  const MenuText(
      {Key key, this.firstText, this.secondText, this.textColor, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(margin: EdgeInsets.only(top: 50), child: icon),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25),
            padding: EdgeInsets.only(top: 10),
            child: Text(
              firstText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Lato",
                color: textColor,
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              secondText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "Lato",
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
