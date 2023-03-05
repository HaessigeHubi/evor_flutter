import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'pages/login/signup.dart';
import 'pages/event/search/eventlist.dart';
import 'pages/event/create/createEvent.dart';
import 'pages/event/owner/userEventList.dart';
import 'pages/Maps/googlemaps.dart';
import 'domain/repository/models/users.dart' as User;

String? userEmail;

class Home extends StatefulWidget {
  Home({required this.user});
  final User.User user;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late GoogleMapController controller;

  /*
  Navigation Logic, when the user presses something in the nav bar. Always sends Widget.User to the next Widget
  */
  void _onItemTapped(int index) {
    setState(() async {
      switch (index) {
        case 1:
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EventList(user: widget.user)),
            );
          }
          break;
        case 0:
          {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateEvent(user: widget.user)),
            );
            updateMap = true;
          }
          break;
        case 3:
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserEventList(user: widget.user)),
            );
          }
          break;
        case 4:
          {
            Navigator.of(context).push(_createRoute());
          }
          break;
      }
    });
  }

  String title() {
    return 'EVOR ' + widget.user.firstname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
        //Top Bar with Logo and Logout Button
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Image(image: AssetImage('assets/Evor_Logo.png'), height: 300,),
          toolbarHeight: 100,
            elevation: 14,
            //Rounded Corners
            shape: const RoundedRectangleBorder(
                borderRadius:  BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))
            ),
          backgroundColor: Colors.orange,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ),
              onPressed: () {
                //Logs current User out of the app
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
        //Navigation Bar with the FancyBottom Plugin. MAX 5 Tabs allowed
        bottomNavigationBar: FancyBottomNavigation(
          inactiveIconColor: Colors.orange,
          circleColor: Colors.orange,
          initialSelection: 2,
          tabs: [
            TabData(iconData: Icons.add, title: "Add"),
            TabData(iconData: Icons.list, title: "List"),
            TabData(iconData: Icons.map, title: "Map"),
            TabData(iconData: Icons.calendar_month, title: "Owner"),
            TabData(iconData: Icons.filter_alt, title: "Filter")
          ],
          onTabChangedListener: (position) {
            setState(() {
              _onItemTapped(position);
            });
          },
        ),
        body: GoogleMapsWidget(user: widget.user));
  }
}
//Just here to create an animation between button press and widget load
Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Filter_Event(),
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
//Filter App
class Filter_Event extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbFilterKey =
      GlobalKey<FormBuilderState>();

  Filter_Event({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter the Map', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.orange,
      ),
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
                      decoration: InputDecoration(labelText: "Location"),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () {
                              //Adds Filter Object and sends that to the Google Maps Widget. On load the Events get filtert
                              _fbFilterKey.currentState?.save();
                              if (_fbFilterKey.currentState!.validate()) {
                                print(_fbFilterKey.currentState!.value['Tags']);
                                mapfilter.eventname = _fbFilterKey
                                        .currentState!.value['event_name'] ??
                                    "";
                                mapfilter.datefrom = _fbFilterKey
                                        .currentState!.value['date_from'] ??
                                    "";
                                mapfilter.dateto = _fbFilterKey
                                        .currentState!.value['date_to'] ??
                                    "";
                                mapfilter.tag =
                                    _fbFilterKey.currentState!.value['Tags'] ??
                                        "999";
                                mapfilter.Location = _fbFilterKey
                                        .currentState!.value['Location'] ??
                                    "";
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
