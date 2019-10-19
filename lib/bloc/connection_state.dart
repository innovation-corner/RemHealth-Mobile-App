import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ConnectionState extends Equatable {
  ConnectionState([List props = const []]) : super(props);
}

class InitialConnectionState extends ConnectionState {}

class LoadingConnectionState extends ConnectionState {}

class LoadedConnectionState extends ConnectionState {
  final bool connected;

  LoadedConnectionState({@required this.connected}) : super([connected]);
}
