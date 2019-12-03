import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth.dart';
import 'globals.dart' as globals;
import 'menu.dart';
import 'signup_page.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _db = Firestore.instance;

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _succ = false;

  @override
  Widget build(BuildContext context) {
    final googleButton = GoogleSignInButton(
      borderRadius: 24,
      //This has been changed in order to allow for the argument uid to be passed into the menu page.
      onPressed: () async {
        FirebaseUser user = await authService.googleSignIn();
        globals.userUID = user.uid;
        Navigator.of(context).pushNamed(MenuPage.tag, arguments: user.uid);
        ;
      },
    );

    final signUpButton = RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(SignupPage.tag);
      },
      padding: EdgeInsets.all(12),
      color: globals.mainColor,
      child: Text('Sign Up', style: TextStyle(color: Colors.white)),
    );
    final image = Container(
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: const AssetImage('assets/images/Logo(1).png'),
            )));

    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: ListView(
              children: <Widget>[
                image,
                SizedBox(height: 40.0),
                _EmailPasswordForm(),
                signUpButton,
                SizedBox(height: 40.0,),
                googleButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//Make the form which has email and password fields. This part of the login_page handles loging in with an email and password
//, as opposed to signing in with a Google Account
class _EmailPasswordForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<_EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //These notify listeners of change in text input.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Create a focus node so that the password field is focused
  // after pressing the next button on the keyboard for email input
  final FocusNode focusPassword = FocusNode();

  bool _success;
  String _userEmail;

  @override
  Widget build(BuildContext context) {
    final loginButton = ButtonTheme(
        minWidth: 250,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              _signInWithEmailAndPassword();
            }
          },
          padding: EdgeInsets.all(12),
          color: globals.mainColor,
          child: Text('Login', style: TextStyle(color: Colors.white)),
        ));
    final email = TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: globals.mainColor, width: 2.0),
        ),
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.grey)
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        // Once the user presses the 'next' button, focus on the password input
        FocusScope.of(context).requestFocus(focusPassword);
      },
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter email';
        }
        return null;
      },
    );
    final password = TextFormField(
      controller: _passwordController,
      focusNode: focusPassword,
      decoration: const InputDecoration(
        labelStyle: TextStyle(color: Colors.grey),
        labelText: 'Password',
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: globals.mainColor, width: 2.0),
        ),
      ),
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter password';
        }
        return null;
      },
    );
    //Returns the actual form built from the above elements.
    return Form(
      key: _formKey,
      child: _success == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                email,
                SizedBox(height: 10.0),
                password,
                SizedBox(height: 20.0),
                loginButton,
              ],
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
                //Remove alert
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

//Here, it is attempted to login into account. Email and password are taken from their respective controllers.
//Additionally, if login is successful, then data is merged with existing data in database.
//Then, MenuPage is shown
//If registration is not successful, then an error is caught and passed to createAlert
  void _signInWithEmailAndPassword() async {
    String reason;
    //Try the following. Throws PlatformException error if invalid email, wrong password, or nonexisting account.
    try {
      final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email;
        });
        logInUpdateUserData(user);
        globals.userUID = user.uid;
        Navigator.of(context).pushNamed(MenuPage.tag,
            // Pass the users uid as an argument to the main menu page
            arguments: user.uid);
      } else {
        _success = false;
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          reason = 'Invalid Email';
          createAlert(context, reason);
          break;
        case 'ERROR_USER_NOT_FOUND':
          reason = 'User Not Found';
          createAlert(context, reason);
          break;
        case 'ERROR_WRONG_PASSWORD':
          reason = 'Wrong Password';
          createAlert(context, reason);
          break;
        default:
          reason = 'Error';
          createAlert(context, reason);
          break;
      }
    }
  }

  //This is necessary as before auth's update function was used. This was fine for Google accounts,
  //but if signing in with email and password, the name was overwritten with null
  //as FirebaseAuth has no field for name when creating an account with email and password. So here, we update everything except for name.
  void logInUpdateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);
    //Map data to database fields
    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'lastSeen': DateTime.now(),
    }, merge: true); //Merges data so old data isn't overwritten
  }
}
