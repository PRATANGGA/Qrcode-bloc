part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

//State -> Kondisi saat ini
// 1. AuthStateLogin -> terautentifikasi
// 2. AuthStateLogut -> tidak terautentifikasi
// 3. AuthStateLoading -> loading....
// 4. AuthStateError -> gagal login -> dapat error

final class AuthStateLogin extends AuthState {}

final class AuthStateLoading extends AuthState {}

final class AuthStateLogout extends AuthState {}

final class AuthStateError extends AuthState {
  AuthStateError(this.message);

  final String message;
}
