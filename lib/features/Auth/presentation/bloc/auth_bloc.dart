import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_management_app/features/Auth/domain/usecases/auth_usecases.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUsecases authUsecase;

  AuthBloc(this.authUsecase) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is IsAuthenticatedCheckEvent) {
        emit(AuthLoadingState());
        final either = await authUsecase.isLoggedIn();
        either.fold((fail) {
          emit(AuthenticationRequiredState());
        }, (isLogged) {
          if (isLogged) {
            emit(AuthenticatedState());
          } else {
            emit(AuthenticationRequiredState());
          }
        });
      } else if (event is AuthRequestEvent) {
        emit(AuthLoadingState());
        if (event.isRegister) {
          final either = await authUsecase.signup(
              email: event.email, password: event.pass);
          either.fold((fail) {
            emit(AuthenticationErrorState(failMsg: fail.errMsg));
          }, (r) {
            emit(AuthenticatedState());
          });
        } else {
          final either =
              await authUsecase.login(email: event.email, password: event.pass);
          either.fold((fail) {
            emit(AuthenticationErrorState(failMsg: fail.errMsg));
          }, (r) {
            emit(AuthenticatedState());
          });
        }
      } else if (event is ChangeToLoginEvent) {
        emit(ChangedAuthTypeState(isRegister: false));
      } else if (event is ChangeToRegisterEvent) {
        emit(ChangedAuthTypeState(isRegister: true));
      } else if (event is LogoutEvent) {
        emit(AuthenticationRequiredState());
      }
    });
  }
}
