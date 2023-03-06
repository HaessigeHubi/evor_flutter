import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'googlemaps.dart';


//Filter App and returns Filter Object at the end. Similar to Create Event
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
