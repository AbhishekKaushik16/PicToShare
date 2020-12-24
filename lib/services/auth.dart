import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pic_to_share/screens/login_screen.dart';
import 'package:pic_to_share/screens/phone_verification.dart';
import 'package:pic_to_share/screens/welcome_screen.dart';


// Handles all the authentication


final databaseReference = FirebaseDatabase.instance.reference().child("Users");
class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Authentication Status
  String getCurrentUID() {
    if(_auth.currentUser != null)
      return _auth.currentUser.uid;
    else
      return null;
  }

  // Add User to Firebase Realtime Database(Need some improvements).
  void addUserToDatabase(User user, String number, String isNumberVerified) async{
    await databaseReference.push().set({
      'userMail': user.email,
      'number': number,
      'isNumberVerified': isNumberVerified,
      'isEmailVerified': user.emailVerified ? "yes" : "no",
    });
  }
  // sign in with email and password
  Future signIn(String email, String password, BuildContext context) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      Navigator.pushNamed(context, WelcomeScreen.id);
      return null;
    }catch(e) {
      print(e.code);
      return e.code;
    }
  }
  // sign Up
  Future signUp(String email, String password, BuildContext context) async{
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      // Send email verification link to user email
      print(user.uid);
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
      Navigator.pushNamed(context, PhoneVerification.id);
      return null;
    } catch (e) {
      print(e);
      return e.code;
    }
  }
  // Logout
  Future<void> signOut(BuildContext context) async{
    await FirebaseAuth.instance.signOut().then((value) => Navigator.pushNamed(context, LoginScreen.id));
  }

  // Send number confirmation code
  void verifyNumber(String phone, BuildContext context) {
    String smsCode;
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        // If your device supports automatic OTP reading.
        verificationCompleted: (AuthCredential credential) async{
          Navigator.of(context).pop();
          addUserToDatabase(user, phone, "yes");
          Navigator.pushNamed(context, WelcomeScreen.id);
        },
        verificationFailed: (FirebaseAuthException e){
          print(e);
        },
        // Manual Entering OTP(You can test this by entering different Mobile Number)
        codeSent: (String verificationId, [int forceResendingToken]){
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Enter OTP"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          smsCode = value;
                        },
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Confirm"),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async{
                        AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
                        if(user != null){
                          addUserToDatabase(user, phone, "yes");
                          Navigator.pushNamed(context, WelcomeScreen.id);
                        }else{
                          print("Error");
                        }
                      },
                    )
                  ],
                );
              }
          );
        },
        // Timeout after 60sec.
        codeAutoRetrievalTimeout: (String verificationId){
          verificationId = verificationId;
          print(verificationId);
          print("Timeout");
        }
    );
  }

}