import 'package:flutter/material.dart';
import 'package:immunization_mobile/scanner.dart';

import 'auth/hospital_login.dart';
import 'custom_widgets/custom_colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rem Health',
      theme: ThemeData(primarySwatch: RemColors.green),
      home: Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: RaisedButton(
          color: Colors.orange,
          textColor: Colors.white,
          splashColor: Colors.blueGrey,
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Scan()));
          },
          child: Text("Scan QR code!"),
        ),
      ),
    );
  }
}
