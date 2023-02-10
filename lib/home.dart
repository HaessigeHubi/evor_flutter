import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'pages/login/signup.dart';
import 'pages/event/search/eventlist.dart';
import 'pages/event/create/createEvent.dart';
import 'pages/event/owner/userEventList.dart';
import 'pages/Maps/googlemaps.dart';

class Home extends StatefulWidget {
  Home({this.uid});
  final String? uid;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String title = "EVOR";

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {

      switch (index){
        case 0: {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EventList()),
          );
        } break;
        case 1: {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateEvent()),
          );
        } break;
        case 2: {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserEventList()),
          );
        } break;
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title,style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.deepPurple,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ),
              onPressed: () {
                FirebaseAuth auth = FirebaseAuth.instance;
                auth.signOut().then((res) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                      (Route<dynamic> route) => false);
                });
              },
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 30,
          backgroundColor: Colors.deepPurple,
          selectedIconTheme: IconThemeData(size: 80, color: Colors.deepPurpleAccent),
          showUnselectedLabels: false,
          showSelectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_outlined),
              label: 'Create',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_available),
              label: 'My',
            ),
          ],
          currentIndex: _selectedIndex, //New
          onTap: _onItemTapped,
        ),
        body: GoogleMapsWidget());
  }
}








