import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_flutter/screens/chat_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_flutter/components/rounded_button.dart';
import 'package:flash_chat_flutter/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:alert/alert.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const loginScreen = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';
  bool _showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  colour: Colors.lightBlueAccent,
                  title: 'Log In',
                  onPressed: () async {
                    try {
                      setState(() {
                        _showSpinner = true; // starts the loading circle
                      });
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email, password: password);
                      Navigator.pushNamed(context, ChatScreen.chatScreen);
                      setState(() {
                        _showSpinner = false;
                      });
                      Alert(message: 'Logged in!', shortDuration: true).show();
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        setState(() {
                          _showSpinner = false;
                          Alert(
                                  message: 'Ooops! No such user found.',
                                  shortDuration: false)
                              .show();
                        });
                      } else if (e.code == 'wrong-password') {
                        setState(() {
                          _showSpinner = false;
                          Alert(
                                  message: 'Ooops! Password incorrect.',
                                  shortDuration: false)
                              .show();
                        });
                        Alert(
                            message: 'Wrong password provided for that user.',
                            shortDuration: false);
                      }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
