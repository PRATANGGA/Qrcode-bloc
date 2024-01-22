part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

//Event -> Aksi
// 1. AuthEventLogin -> melakukan tindakan login
// 2. AuthEventLogut -> melakukan tindakan logut

class AuthEventLogin extends AuthEvent {
  AuthEventLogin(this.email, this.pass);
  final String email;
  final String pass;
}

class AuthEventLogout extends AuthEvent {}
