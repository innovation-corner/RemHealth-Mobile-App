import 'package:equatable/equatable.dart';

abstract class ConnectionEvent extends Equatable {
  ConnectionEvent([List props = const []]) : super(props);
}

class CheckInternet extends ConnectionEvent {}
