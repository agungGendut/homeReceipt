part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {
  final String name;
  final User userLogin;
  AuthInitial(this.name, this.userLogin);
}

class UnAuthInitial extends AuthState {}

class LoadingInitial extends AuthState {}

class ErrorInitial extends AuthState {}
