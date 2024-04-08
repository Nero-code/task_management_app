part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthenticatedState extends AuthState {}

final class AuthenticationRequiredState extends AuthState {}

final class AuthenticationErrorState extends AuthState {
  final String failMsg;
  const AuthenticationErrorState({required this.failMsg});
}

final class ChangedAuthTypeState extends AuthState {
  final bool isRegister;
  const ChangedAuthTypeState({required this.isRegister});
  @override
  List<Object> get props => [isRegister];
}
