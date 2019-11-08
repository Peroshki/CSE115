//Creates the sign up page, including its sign up form.
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:socialshopper/menu.dart';
import 'auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _db = Firestore.instance;

class SignupPage extends StatefulWidget {
  static String tag = 'signup-page';
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //These notify listeners of change in text input.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  //Two password controllers in order to assure that user is correctly entering desired password.
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordControllerRedux =
      TextEditingController();

  bool _success;
  String _userEmail;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordControllerRedux,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                alignment: Alignment.center,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _register();
                    }
                  },
                  color: Colors.blue,
                  child: const Text('Submit',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//Creates an alert depending on the error caught which is stored in String reason
  dynamic createAlert(BuildContext context, String reason) {
    return showDialog<dynamic>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(reason),
            actions: <Widget>[
              FlatButton(
                child: const Text('Continue'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    _passwordControllerRedux.dispose();
    _nameController.dispose();
    super.dispose();
  }

//Here, it is attempted to actually register an account. Email and password are taken from their respective controllers.
//Additionally, if registration is successful, then data is saved in database.
//Then, MenuPage is shown
//If registration is not successful, then an error is caught and passed to createAlert
  void _register() async {
    String reason;
    try {
      if (_passwordControllerRedux.text != _passwordController.text) {
        throw PlatformException(code: 'Passwords do not match.');
      }
      final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email;
        });
        signUpUpdateUserData(user); // Yucky workaround

        Navigator.of(context).pushNamed(MenuPage.tag);
      } else {
        _success = false;
      }
    } on PlatformException catch (e) {
      print(e.code);
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          reason = 'Invalid Email';
          createAlert(context, reason);
          break;
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          reason = 'Email is already connected to an account.';
          createAlert(context, reason);
          break;
        case 'ERROR_WEAK_PASSWORD':
          reason = 'Password must be at least 6 characters in length.';
          createAlert(context, reason);
          break;
        case 'Passwords do not match.':
          reason = 'Password must match!';
          createAlert(context, reason);
          break;
        default:
          reason = 'Error';
          createAlert(context, reason);
          break;
      }
    }
  }

  void signUpUpdateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);
    //Map data to database fields
    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': _nameController
          .text, //This is the yucky workaround. Name is forced to be updated using text from controller.
      'lastSeen': DateTime.now()
    }, merge: true); //Merges data so old data isn't overwritten
  }
}
