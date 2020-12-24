import 'package:flutter/material.dart';
import 'package:pic_to_share/components/rounded_button.dart';
import 'package:pic_to_share/services/auth.dart';

import '../constants.dart';

class PhoneVerification extends StatefulWidget {
  static const String id = 'phone_verification';
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  String _numberError;
  final authService = AuthService();
  String number;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 100.0,),
            TextField(
              keyboardType: TextInputType.phone,
              textAlign: TextAlign.left,
              onChanged: (value) {
                //Do something with the user input.
                setState(() {
                  _numberError = null;
                });
                number = value;
              },
              decoration:
              kTextFieldDecoration.copyWith(
                // For india its +91
                hintText: 'Enter phone number with country code',
                errorText: _numberError,
              ),
            ),
            RoundedButton(
              title: 'Register Number',
              color: Colors.lightBlueAccent,
              onPressed: () async {
                if(number.length != 13) {
                  setState(() {
                    _numberError = "Wrong Number";
                  });
                }
                else {
                  authService.verifyNumber(number, context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
