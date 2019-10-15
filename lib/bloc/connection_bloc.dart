import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'dart:io';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  @override
  ConnectionState get initialState => InitialConnectionState();

  @override
  Stream<ConnectionState> mapEventToState(
    ConnectionEvent event,
  ) async* {
    if (event is CheckInternet) {
      yield LoadingConnectionState();
      checkNetwork();
      yield LoadedConnectionState(connected: connected);
    }
  }

  bool connected = false;

  Future checkNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // print('connected');
        connected = true;
        return true;
      }
    } on SocketException catch (_) {
      // print('not connected');
      connected = false;
      return false;
    }
  }
}
