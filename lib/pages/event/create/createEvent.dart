import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../login/signup.dart';
import '../../../domain/repository/models/events.dart' as EventsMap;
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CreateEvent extends StatefulWidget {
  CreateEvent({super.key});


  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Event"),
      ),
      body: FormBuilder(
        key: _fbKey,
        child: Column(
          children: <Widget>[
            Text("EventName:"),
            Text("Date Von:"),
            Text("Date Bis:"),
            Text("Description:"),
            Text("Tags Selection:"),
            Text("Partisipation Age:"),
            Text("Partisipant amount:"),
            Text("Location Info:"),
            Text("Optional Questions:"),
            Text("Optional Questions:"),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                 ElevatedButton(onPressed: (){
                   if (_fbKey.currentState!.saveAndValidate()){
                     print(_fbKey.currentState!.value);
                   }
                 }

                     , child: Text('Submit'))
              ],
            )
          ],
        ),
      ),
    );
  }
}


