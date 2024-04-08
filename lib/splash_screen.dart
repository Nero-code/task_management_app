import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/features/Auth/presentation/bloc/auth_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          await Future.delayed(const Duration(seconds: 3));
          if (state is AuthenticatedState) {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, '/Home');
          } else if (state is AuthenticationRequiredState) {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, '/Auth');
          }
        },
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FlutterLogo(size: 100),
              // SizedBox(height: 40),
              // CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
