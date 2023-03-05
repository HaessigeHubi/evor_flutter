import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'email_login.dart';
import 'email_signup.dart';

class SignUp extends StatelessWidget {
  final String title = "Sign Up";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Image(image: AssetImage('assets/Evor_Logo_White.png')),
          toolbarHeight: 300,
          elevation: 14,
          centerTitle: true,
          shape: const RoundedRectangleBorder(
              borderRadius:  BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30))
          ),
        ),
        body: Center(

            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Welcome to Evor",
                    style: TextStyle(
                      color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontFamily: 'Roboto')),
              ),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Container(
                        height: 50,
                        width: 220,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20)),
                        child: ElevatedButton(
                          style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Colors.orange)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EmailLogIn()),
                            );
                          },
                          child: const Text(
                            'Go to Login',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      )),

              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: SignInButton(
                    Buttons.Email,
                    text: "Create Account",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EmailSignUp()),
                      );
                    },
                  )),

            ])));
  }
}
