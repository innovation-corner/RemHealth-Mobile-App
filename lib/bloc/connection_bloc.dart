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
      if (connected = true) {
        // print('connected');
        yield LoadedConnectionState(connected: true);
      } else {
        yield LoadedConnectionState(connected: false);
      }
    }
  }

  bool connected;

  Future checkNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
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
