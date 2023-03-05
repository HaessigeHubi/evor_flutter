import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'home.dart';
import 'pages/login/signup.dart';

import 'domain/repository/models/users.dart' as UserEvent;

/*
This has the IntroScreen for the Application. It checks if the User is logged in and then gives the Information to the Home Widget
 */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EVOR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IntroScreen(),
    );
  }
}

class IntroScreen extends StatefulWidget {
  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  FutureBuilder<UserEvent.User> build(BuildContext context) {
    //Loads User over Firebase Plugin and creates an Instance
    User? result = FirebaseAuth.instance.currentUser;
    return FutureBuilder<UserEvent.User>(
      //Gets User Data from the FB E-Mail
      future: UserEvent.fetchUserbyMail(result?.email),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.data != null){
          //Intro Screen
          return SplashScreen(
              useLoader: true,
              loadingTextPadding: const EdgeInsets.all(0),
              loadingText: const Text(""),
              navigateAfterSeconds: result != null ? Home(user: snapshot.data) : SignUp(),
              seconds: 3,
              title: const Text(
                'Welcome To EVOR!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              backgroundColor: Colors.white,
              styleTextUnderTheLoader: const TextStyle(),
              photoSize: 100.0,
              onClick: () => print("flutter"),
              loaderColor: Colors.red);
        }
        return SignUp();
      },
    );
  }
}

