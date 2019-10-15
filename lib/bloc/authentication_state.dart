import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]) : super(props);
}

class InitialAuthenticationState extends AuthenticationState {}

class LoadingAuthState extends AuthenticationState {}

class LoadedAuthState extends AuthenticationState {
  final bool auth;

  LoadedAuthState({@required this.auth}) : super([auth]);
}
