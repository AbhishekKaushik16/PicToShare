import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pic_to_share/checkStatus.dart';
import 'package:pic_to_share/screens/login_screen.dart';
import 'package:pic_to_share/screens/phone_verification.dart';
import 'package:pic_to_share/screens/registration_screen.dart';
import 'package:pic_to_share/screens/welcome_screen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Navigation using Named Routes
      initialRoute: Wrapper.id,
      routes: {
        Wrapper.id: (context) => Wrapper(),
        LoginScreen.id: (context) => LoginScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        PhoneVerification.id: (context) => PhoneVerification(),
      },
    );
  }
}