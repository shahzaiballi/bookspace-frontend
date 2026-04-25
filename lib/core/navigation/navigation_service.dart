import 'package:flutter/material.dart';

/// Centralized Navigation Service
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  static void goBack() {
    return navigatorKey.currentState!.pop();
  }

  static Future<dynamic> navigateToAndReplace(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }
  
  // Method to use when onboarding finishes
  static void finishOnboarding() {
    // Example: navigateToAndReplace('/home');
    debugPrint('Onboarding finished. Navigate to the next screen.');
  }
}

