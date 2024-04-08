part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthRequestEvent extends AuthEvent {
  final bool isRegister;
  final String email, pass;
  const AuthRequestEvent(
      {required this.isRegister, required this.email, required this.pass});
}

final class IsAuthenticatedCheckEvent extends AuthEvent {}

final class ChangeToLoginEvent extends AuthEvent {}

final class ChangeToRegisterEvent extends AuthEvent {}

final class LogoutEvent extends AuthEvent {}
