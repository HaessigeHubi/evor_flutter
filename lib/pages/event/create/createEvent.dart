import 'dart:core';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:geocoding/geocoding.dart';
import '../../login/signup.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../../../domain/repository/models/events.dart' as EventsMap;
import 'selectLocation.dart';


import 'package:image_picker/image_picker.dart';

class CreateEvent extends StatefulWidget {
  CreateEvent({super.key});
  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool _visibleAgeSet = false;
  List<String> _textFieldValues = [];
  late List<dynamic> imageList;
  XFile? imageFile;
  ResponseLocation responseLocation = new ResponseLocation(1, 1, new Placemark(street: 'No Location selected'));
  String address = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create new Event"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
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
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: _fbKey,
                child: Column(
                  children: <Widget>[
                    if (imageFile != null) Image.file(File(imageFile!.path)),
                    SizedBox(height: 10),
                    FormBuilderImagePicker(
                      name: 'image',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Choose your Evente Image',
                      ),
                      maxImages: 1,
                      onChanged: (List) {
                        _fbKey.currentState?.save();
                        imageList = _fbKey.currentState!.value['image'];
                        if (imageList.first != null) {
                          print(imageList.first);

                          setState(() {
                            imageFile = imageList.first;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    Text('The Image will be croped'),
                    FormBuilderTextField(
                      name: "event_name",
                      decoration: InputDecoration(labelText: "Event name"),
                      validator: (valueCandidate) {
                        if (valueCandidate?.isEmpty ?? true) {
                          return 'This field is required';
                        }
                        if (valueCandidate!.length > 50) {
                          return 'Too long';
                        }
                        return null;
                      },
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
                    SizedBox(height: 10),
                    FormBuilderTextField(
                      name: "description",
                      decoration: InputDecoration(labelText: "Description"),
                      maxLines: 3,
                      validator: (valueCandidate) {
                        if (valueCandidate?.isEmpty ?? true) {
                          return 'Please add a description';
                        }
                        return null;
                      },
                    ),
                    Text("What kind of Event"),
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
                    TextField(
                      decoration: InputDecoration(
                          labelText: "Partition Age (optional)"),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          labelText: "Maxiumum Partitions (optional)"),
                      keyboardType: TextInputType.number,
                    ),
                    Text("Optional Questions:"),
                    Text("Optional Questions:"),
                    SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                              context,
                          MaterialPageRoute(builder: (context) => SelectLocation()),
                          );
                          print(result);
                          setState(() {
                            responseLocation = result as ResponseLocation;
                            String street = responseLocation.selectedLocation.street!;
                            String postalCode = responseLocation.selectedLocation.postalCode!;
                            String administrativeArea = responseLocation.selectedLocation.administrativeArea!;
                            String country = responseLocation.selectedLocation.country!;
                            address = '$street \n$postalCode $administrativeArea\n$country';
                          });
                        }, child:
                         Text('Select Location')),
                    if(responseLocation.selectedLocation.street != 'No Location selected') Text(address,style: TextStyle(fontSize:19,fontWeight: FontWeight.bold),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () {
                              _fbKey.currentState?.save();
                              print(_fbKey.currentState!.value['image']);
                              if (_fbKey.currentState!.validate()) {
                                EventsMap.createEvent(EventsMap.Event(
                                    id: 2,
                                    eventname: _fbKey
                                        .currentState!.value['event_name'],
                                    description: _fbKey
                                        .currentState!.value['description'],
                                    createDate: 'createDate',
                                    lat: responseLocation.latitude,
                                    lng: responseLocation.longitude,
                                    address: address));
                                Navigator.pop(context, 'Test');
                              }
                            },
                            child: Text('Submit')),
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
