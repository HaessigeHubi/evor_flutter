import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

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
  late GoogleMapController controller;
  int _selectedIndex = 1;
  Widget GoogleMaps = new GoogleMapsWidget();


  void _onItemTapped(int index) {
    setState(() async {

      switch (index){
        case 0: {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EventList()),
          );

        } break;
        case 1: {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateEvent()),
          );
          updateMap = true;
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
                Icons.filter_alt_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).push(_createRoute());
              },
            ),
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
            ),

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
        body: GoogleMaps);
  }
}


Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Page2(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.5, -1.0);
      const end = Offset(0.0, 0.0);
      const curve = Curves.fastOutSlowIn;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class Page2 extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbFilterKey = GlobalKey<FormBuilderState>();


  Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter the Map',style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.deepPurple,),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: _fbFilterKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    FormBuilderTextField(
                      name: "event_name",
                      decoration: InputDecoration(labelText: "Event name"),
                    ),
                    FormBuilderDateTimePicker(
                      name: "date_from",
                      inputType: InputType.date,
                      decoration: InputDecoration(labelText: "Date from"),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                    FormBuilderDateTimePicker(
                      name: "date_to",
                      inputType: InputType.date,
                      decoration: InputDecoration(labelText: "Date to"),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                    Text("Tags"),
                    FormBuilderChoiceChip(
                      name: 'Tags',
                      options: [
                        FormBuilderChipOption(value: "Cooperate🧑‍💼"),
                        FormBuilderChipOption(value: "Networking 🤝🏻"),
                        FormBuilderChipOption(value: "Chairy 💝"),
                        FormBuilderChipOption(value: "Birthday 🎂"),
                        FormBuilderChipOption(value: "Wedding💍"),
                        FormBuilderChipOption(value: "Chairy/Fundraising💝"),
                        FormBuilderChipOption(value: "Educational🎓"),
                        FormBuilderChipOption(value: "Religious 🙏🏼"),
                        FormBuilderChipOption(value: "Concert 🎶"),
                        FormBuilderChipOption(value: "Club/Party 💃"),
                        FormBuilderChipOption(value: "Movie 🎬"),
                        FormBuilderChipOption(value: "Political 🎩"),
                        FormBuilderChipOption(value: "Sports ⚽"),
                        FormBuilderChipOption(value: "Community 👨‍👨‍👦‍👦"),
                        FormBuilderChipOption(value: "Food 🍔"),
                        FormBuilderChipOption(value: "Gaming 🎮"),
                      ],
                      onChanged: (value) {},
                      validator: (valueCandidate) {
                        if (valueCandidate?.isEmpty ?? true) {
                          return 'Please select a tag for your event';
                        }
                        return null;
                      },
                    ),
                    FormBuilderTextField(
                      name: 'Location',
                      decoration: InputDecoration(
                          labelText: "Location"),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () {
                              _fbFilterKey.currentState?.save();
                              if (_fbFilterKey.currentState!.validate()) {
                                print(_fbFilterKey.currentState!.value['Tags'] );
                                mapfilter.eventname = _fbFilterKey.currentState!.value['event_name'] ?? "";
                                mapfilter.datefrom = _fbFilterKey.currentState!.value['date_from'] ?? "";
                                mapfilter.dateto = _fbFilterKey.currentState!.value['date_to'] ?? "";
                                mapfilter.tag = _fbFilterKey.currentState!.value['Tags'] ?? "999";
                                mapfilter.Location = _fbFilterKey.currentState!.value['Location'] ?? "";
                                updateMap = true;
                                Navigator.pop(context, mapfilter);
                              }
                            },
                            child: Text('Filter Map')),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}







