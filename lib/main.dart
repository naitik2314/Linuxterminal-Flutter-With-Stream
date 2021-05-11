import 'RegistrationPage.dart';
import 'LogIn.dart';
import 'first-screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'SignUp': (context) => SignUpUsingEmail(),
        'SignIn': (context) => LogIn(),
        'Home': (context) => HomePage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Linux Terminal App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IntroScreen(),
    );
  }
}
