part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class CheckedAuth extends AuthEvent {
  final bool splash;
  final BuildContext context;
  CheckedAuth({this.splash = false, this.context});
}

class AuthByGoogle extends AuthEvent {
  final BuildContext context;
  AuthByGoogle(this.context);
}

class LoginCredential extends AuthEvent {
  final BuildContext context;
  final AuthCredential credential;
  LoginCredential(this.context, {@required this.credential});
}

class AuthSuccess extends AuthEvent {
  final BuildContext context;
  final User auth;
  AuthSuccess(this.context, this.auth);
}
