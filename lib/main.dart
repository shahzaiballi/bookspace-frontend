import 'package:flutter/material.dart';
import 'core/constant/app_colors.dart';
import 'features/forgot/forgot_Screen.dart';
import 'features/home/home_Screen.dart';
import 'features/login/login_screen.dart';
import 'features/siignup/signup_screen.dart'; // Make sure this file exists


void main() {
  runApp(const NovelBookApp());
}

class NovelBookApp extends StatelessWidget {
  const NovelBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NovelBook',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: AppColors.accent,
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'Rubik',
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forgot': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const HomeScreen(),


      },
    );
  }
}
