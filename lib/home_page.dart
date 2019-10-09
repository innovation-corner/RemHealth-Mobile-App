import 'package:flutter/material.dart';

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
              fontSize: 25.0,
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
                      onTap: () {},
                      child: Container(
                        height: 180,
                        width: MediaQuery.of(context).size.width * 0.415,
                        decoration: BoxDecoration(
                            color: Colors.orange,
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
                              firstText: "Register",
                              secondText: "Child",
                              textColor: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 180,
                        width: MediaQuery.of(context).size.width * 0.415,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
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
                              firstText: "Update Child",
                              secondText: "Details",
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
                      onTap: () {},
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
                              firstText: "Confirm",
                              secondText: "Immunization",
                              textColor: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
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
                              firstText: "Report",
                              secondText: "Disease",
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
              Container(
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
}

class MenuText extends StatelessWidget {
  final String firstText;
  final String secondText;
  final Color textColor;

  const MenuText({Key key, this.firstText, this.secondText, this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 70,
        left: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              firstText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Lato",
                color: textColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              secondText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "Lato",
                  color: textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}
