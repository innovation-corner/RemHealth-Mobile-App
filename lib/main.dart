import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:immunization_mobile/bloc/bloc.dart';
import 'package:immunization_mobile/home_page.dart';
import 'package:immunization_mobile/scanner.dart';

import 'auth/hospital_login.dart';
import 'custom_widgets/custom_colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      builder: (context) => AuthenticationBloc(),
      child: MaterialApp(
        title: 'Rem Health',
        theme: ThemeData(
          primarySwatch: RemColors.green,
          cursorColor: RemColors.green,
          accentColor: Colors.orange,
        ),
        home: RemHealthHome(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class RemHealthHome extends StatefulWidget {
  @override
  _RemHealthHomeState createState() => _RemHealthHomeState();
}

class _RemHealthHomeState extends State<RemHealthHome> {
  final connectionBloc = ConnectionBloc();
  final _authenticationBloc = AuthenticationBloc();

  @override
  initState() {
    super.initState();
    connectionBloc.dispatch(CheckInternet());
    DotEnv().load('.env');
    // runCheck();
    _authenticationBloc.dispatch(FetchAuthState());
  }

  runCheck() {
    var oneSec = Duration(seconds: 3);
    Timer.periodic(oneSec, (Timer t) {
      connectionBloc.dispatch(CheckInternet());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _authenticationBloc,
      builder: (BuildContext context, AuthenticationState state) {
        if (state is InitialAuthenticationState) {
          return Scaffold();
        }
        if (state is LoadedAuthState) {
          if (state.auth == true) {
            return HomePage();
          } else
            return Login();
        }
      },
    );
  }
}
