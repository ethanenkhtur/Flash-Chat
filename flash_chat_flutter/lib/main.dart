import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FlashChat());
}

class FlashChat extends StatelessWidget {
  const FlashChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.welcomeScreen,
      routes: {
        WelcomeScreen.welcomeScreen: (context) => const WelcomeScreen(),
        ChatScreen.chatScreen: (context) => const ChatScreen(),
        LoginScreen.loginScreen: (context) => const LoginScreen(),
        RegistrationScreen.registrationScreen: (context) =>
            const RegistrationScreen(),
      },
    );
  }
}
