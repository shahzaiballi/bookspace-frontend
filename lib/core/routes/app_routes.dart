
import 'package:flutter/material.dart';

import '../../features/forgot/forgot_Screen.dart';
import '../../features/home/home_Screen.dart';
import '../../features/login/login_screen.dart';
import '../../features/myLibrary/library_screen.dart';
import '../../features/siignup/signup_screen.dart';


class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgotpassword';
  static const String Home='/Home';
  static const String myLibrary='/library';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    Home:(context)=>const HomeScreen(),
    myLibrary:(context)=>const LibraryScreen(),
  };
}
