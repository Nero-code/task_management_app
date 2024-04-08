import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/features/Auth/presentation/bloc/auth_bloc.dart';
import 'package:task_management_app/features/Auth/presentation/widgets/auth_card.dart';

class LoginOrSignupScreen extends StatelessWidget {
  const LoginOrSignupScreen({super.key});

  Future<void> showSnack(BuildContext context) async {
    await Future.delayed(Duration(seconds: 0));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error Authenticating, try email \neve.holt@reqres.in"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthenticationErrorState) {
            showSnack(context);
          } else if (state is AuthenticatedState) {
            Future.delayed(Duration(seconds: 0)).then(
                (value) => Navigator.pushReplacementNamed(context, "/Home"));
          }
          return Stack(
            children: [
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Expanded(child: FlutterLogo(size: 100)),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 1000),
                              child: (state is ChangedAuthTypeState) &&
                                      !state.isRegister
                                  ? AuthCard(
                                      buttonLabel: "Login",
                                      changeAuthTitle: "Don't have an account?",
                                      onPressed: (email, pass) {
                                        BlocProvider.of<AuthBloc>(context).add(
                                            AuthRequestEvent(
                                                isRegister: false,
                                                email: email,
                                                pass: pass));
                                      },
                                      onChangeType: () {
                                        BlocProvider.of<AuthBloc>(context)
                                            .add(ChangeToRegisterEvent());
                                      },
                                    )
                                  : AuthCard(
                                      buttonLabel: "Register",
                                      onPressed: (email, pass) {
                                        BlocProvider.of<AuthBloc>(context).add(
                                            AuthRequestEvent(
                                                isRegister: true,
                                                email: email,
                                                pass: pass));
                                      },
                                      changeAuthTitle:
                                          "Already Have an account?",
                                      onChangeType: () {
                                        BlocProvider.of<AuthBloc>(context)
                                            .add(ChangeToLoginEvent());
                                      },
                                    ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (state is AuthLoadingState)
                Container(
                  color: const Color.fromARGB(117, 0, 0, 0),
                  child: Center(
                    child: Container(
                      height: 75,
                      width: 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
