import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/features/Auth/presentation/bloc/auth_bloc.dart';
import 'package:task_management_app/features/Auth/presentation/screens/login_signup_screen.dart';
import 'package:task_management_app/features/Task_management/presentation/bloc/tasks_bloc.dart';
import 'package:task_management_app/features/Task_management/presentation/screens/add_update_tasks_screen.dart';
import 'package:task_management_app/features/Task_management/presentation/screens/home_screen.dart';
import 'package:task_management_app/injection_container.dart' as di;
import 'package:task_management_app/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
            create: (_) => di.sl<AuthBloc>()..add(IsAuthenticatedCheckEvent())),
        BlocProvider<TasksBloc>(
            create: (_) => di.sl<TasksBloc>()..add(GetTasksEvent())),
      ],
      child: MaterialApp(
        title: 'Task Manager',
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/Auth': (context) => LoginOrSignupScreen(),
          '/Home': (context) => HomeScreen(),
          '/Home/add_update_tasks_page': (context) => AddUpdateTasksScreen(),
        },
      ),
    );
  }
}
