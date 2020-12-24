import 'package:flutter/material.dart';
import 'package:pic_to_share/screens/login_screen.dart';
import 'package:pic_to_share/screens/welcome_screen.dart';
import 'package:pic_to_share/services/auth.dart';


class Wrapper extends StatelessWidget {
  final authService = AuthService();
  static const String id = 'wrapper';

  @override
  Widget build(BuildContext context) {
    // Check if user is already logged in or not.
    return authService.getCurrentUID() == null? LoginScreen(): WelcomeScreen();
  }
}