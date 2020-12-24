import 'package:flutter/material.dart';
import 'package:pic_to_share/components/rounded_button.dart';
import 'package:pic_to_share/services/auth.dart';
import '../constants.dart';
import 'login_screen.dart';


class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_string';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final authService = AuthService();
  String _emailError;
  String _passwordError;
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 48.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                //Do something with the user input.
                email = value;
              },
              decoration:
              kTextFieldDecoration.copyWith(
                errorText: _emailError == null ? null: _emailError.toString(),
                hintText: 'Enter Your Email',

              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                //Do something with the user input.
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                errorText: _passwordError == null ? null: _passwordError.toString(),
                hintText: 'Enter Your password',
              ),
            ),
            RoundedButton(
              title: 'Sign Up',
              color: Colors.lightBlueAccent,
              onPressed: () async {
                dynamic error = await authService.signUp(email, password, context);
                if(error != null) {
                  print(error);
                  if(error == "weak-password"){
                    setState(() {
                      _passwordError = "Weak Password";
                      _emailError = null;
                    });
                  }else{
                    setState(() {
                      _emailError = error;
                      _passwordError = null;
                    });
                  }
                }
              },
            ),
            SizedBox(height: 20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                InkWell(
                    child: new Text(' Log In',style: TextStyle(color: Colors.blue),),
                    onTap: () => Navigator.pushNamed(context, LoginScreen.id)
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}