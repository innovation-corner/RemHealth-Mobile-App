import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:remhealth_mobile/config/auth_details.dart';
import './bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  @override
  AuthenticationState get initialState => InitialAuthenticationState();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is FetchAuthState) {
      String token = await Authentication.getToken();
      if (token.length > 10) {
        yield LoadedAuthState(auth: true);
        return;
      }
      yield LoadedAuthState(auth: false);
    }
  }
}
