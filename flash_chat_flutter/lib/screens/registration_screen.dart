import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_flutter/components/rounded_button.dart';
import 'package:flash_chat_flutter/constants.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  static const registrationScreen = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email')),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                colour: Colors.blueAccent,
                onPressed: () async {
                  setState(() {
                    _showSpinner = true;
                  });
                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email, password: password);
                    setState(() {
                      _showSpinner = false;
                    });
                    Navigator.pushNamed(context, ChatScreen.chatScreen);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      if (kDebugMode) {
                        print('The password provided is too weak.');
                      }
                    } else if (e.code == 'email-already-in-use') {
                      if (kDebugMode) {
                        print('The account already exists for that email.');
                      }
                    }
                  } catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                },
                title: 'Register',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
