import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pic_to_share/components/imageGrid.dart';
import 'package:pic_to_share/components/rounded_button.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path/path.dart';
import 'package:pic_to_share/services/auth.dart';


User user;
final databaseReference = FirebaseDatabase.instance.reference();
class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_string';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _auth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instance;
  final _imagePicker = ImagePicker();
  final authService = AuthService();
  String _imageName;
  DataSnapshot _snapshot;
  String _imageHashtag;
  String _imageUrl;
  File _imageFile;
  @override
  // Gets user information.
  void initState() {
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser() async {
    try {
      final res = await _auth.currentUser;
      if (res != null) {
        user = res;
      }
    } catch (e) {
      print(e);
    }
  }
  // Uploads image to Firebase Storage
  uploadImage(BuildContext context) async {
    if (_imageFile != null){
      //Upload to Firebase
      String filename = basename(_imageFile.path);
      var snapshot = await _firebaseStorage.ref()
          .child('uploads/$filename')
          .putFile(_imageFile);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        _imageUrl = downloadUrl;
        print(_imageUrl);
      });
    } else {
      print('No Image Path Received');
    }
    if(_imageUrl != null && _imageHashtag != null && _imageName != null) {
      var date = new DateTime.now().toString();
      databaseReference.child("Images").push().set({
        'imageName': _imageName,
        'imageHashtag': _imageHashtag,
        'imageUrl': _imageUrl,
        'userId': user.uid,
        'uploadDate': date,
      }).then((value) => Navigator.pop(context));
    }
  }
  // Ask user for its permission and select one image from device.
  selectImage() async {
    PickedFile image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted){
      //Select Image
      image = await _imagePicker.getImage(source: ImageSource.gallery);
      _imageFile = File(image.path);
    } else {
      print('Permission not granted. Try Again with permission access');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("PicToShare"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => authService.signOut(context),
      ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ImageGrid(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          // Email is Verified but not updated in the database
          print(user.email);
          if(user.emailVerified == false) {
            // Email not verified
            showDialog(
              context: context,
              barrierDismissible: false,
              child: SafeArea(
                  child: AlertDialog(
                    elevation: 24.0,
                    title: Text("Unauthorised"),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('This is a demo alert dialog.'),
                          Text('Please verify your email and login again'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Approve'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                )
              )
            );
          }
          else {
            // Upload Form
            await showDialog(
                context: context,
                barrierDismissible: false,
                child: SafeArea(
                  child: AlertDialog(
                    elevation: 24.0,
                    title: Text("Upload an Image"),
                    content: SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 70.0,
                            child: TextField(
                              maxLength: 32,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                //Do something with the user input.
                                setState(() {
                                  _imageName = value;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Image Name',
                              ),
                            ),
                          ),
                          SizedBox(height: 9.0,),
                          Container(
                            height: 70.0,
                            child: TextField(
                              maxLength: 32,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                //Do something with the user input.
                                setState(() {
                                  _imageHashtag = value;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Image Hashtag',
                              ),
                            ),
                          ),
                          Container(
                            height: 28,
                            child: IconButton(
                              icon: Icon(Icons.add_a_photo),
                              color: Colors.blue,
                              onPressed: () => selectImage(),
                            ),
                          ),
                          Container(
                            height: 80,
                            child: RoundedButton(
                              title: 'Upload',
                              color: Colors.lightBlueAccent,
                              onPressed: () async {
                                uploadImage(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            );
          }
        },
        child: Center(
            child: Icon(Icons.add_a_photo),
        ),
      ),
    );
  }
}

