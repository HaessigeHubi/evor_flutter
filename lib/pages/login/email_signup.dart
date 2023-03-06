import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/src/response.dart';
import 'package:intl/intl.dart';
import '../../../domain/repository/models/users.dart' as User;

import '../../../home.dart';

class EmailSignUp extends StatefulWidget {
  @override
  _EmailSignUpState createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  bool isLoading = false;
  bool userFound = false;
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Sign Up"),backgroundColor: Colors.orange,),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Enter Firstname",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter User Name';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: firstnameController,
                  decoration: InputDecoration(
                    labelText: "Enter Lastname",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter User Name';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: FormBuilderDateTimePicker(
                  controller: ageController,
                  firstDate: DateTime(1920, 1, 1),
                  lastDate: DateTime.now(),
                  format: DateFormat('dd.MM.yyyy'),
                  initialDate: DateTime(1999, 1, 1),
                  decoration: InputDecoration(
                    labelText: "Enter Birthday",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  name: 'ageField',
                  inputType: InputType.date,

                  // The validator receives the text that the user has entered.
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Enter Email",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    print(ageController.text);
                    if (value!.isEmpty) {
                      return 'Enter an Email Address';
                    } else if (!value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Enter Password",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Password';
                    } else if (value.length < 6) {
                      return 'Password must be atleast 6 characters!';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.orange)),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            await registerToFb();
                            setState(() {
                              isLoading = false;
                              userFound = true;
                            });
                          }
                        },
                        child: Text('Join'),
                      ),
              ),
                  if(userFound) const Text("E-Mail already exists",style: TextStyle(color: Colors.red),)
            ]))));
  }

  Future<void> registerToFb() async {
    User.User checkUser = await User.fetchUserbyMail(emailController.text);

    if (!checkUser.email.isEmpty) {
      isLoading = false;
      userFound = true;
    } else {
      //Sending User to Create in Firebase
      firebaseAuth
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((result) async {

        //Adding User to DB
        User.User loginUser =User.User(
            id: 1,
            firstname: firstnameController.text,
            lastname: nameController.text,
            birthday: ageController.text,
            email: emailController.text);
        User.User newUser = await User.createUser(loginUser);
        isLoading = false;
        userFound = false;
        print(newUser);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home(user: newUser)),
        );
      }).catchError((err) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Please Check your Connection"),
                content: Text(err.message),
                actions: [
                  TextButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    ageController.dispose();
    firstnameController.dispose();
  }
}
