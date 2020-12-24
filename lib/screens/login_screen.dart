import 'package:flutter/material.dart';
import 'package:pic_to_share/components/rounded_button.dart';
import 'package:pic_to_share/screens/registration_screen.dart';
import 'package:pic_to_share/services/auth.dart';
import '../constants.dart';


class LoginScreen extends StatefulWidget {
  static const String id = 'login_string';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 80.0,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 30,),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration:kTextFieldDecoration.copyWith(
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
                title: 'Sign In',
                color: Colors.lightBlueAccent,
                onPressed: () async {
                  dynamic error = await authService.signIn(email, password, context);
                  if(error != null) {
                    print(error);
                    if(error == "wrong-password"){
                      setState(() {
                        _passwordError = "Wrong Password";
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
                  Text("Don't have an account?"),
                  InkWell(
                      child: new Text(' Sign Up', style: TextStyle(color: Colors.blue),),
                      onTap: () => Navigator.pushNamed(context, RegistrationScreen.id)
                  ),
                ],
              )
            ],
          ),
        ),
    );
  }
}