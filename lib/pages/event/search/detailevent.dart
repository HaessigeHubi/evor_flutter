import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../domain/repository/models/events.dart' as EventsMap;
import '../../../domain/repository/models/users.dart' as EventUser;

class DetailEvent extends StatelessWidget{
  final EventsMap.Event event;
  final EventUser.User user;
  const DetailEvent ({
    Key? key,
    required this.event,
    required this.user
  }) : super (key: key);
  @override
  Widget build (BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(event.eventname),
    ),
    body: Center(
      child: Column(
        children: <Widget>[
          Image.network(
              'https://media.gettyimages.com/photos/spectators-cheering-at-sporting-event-picture-id487704373'
          ),
          const SizedBox(height: 16),
          Text(
              event.eventname,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              )
          ),
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Go Back'),),
          ElevatedButton(onPressed: (){
            print(event.id);
            EventsMap.joinEvent(event.id.toString(), user.id);
            Navigator.pop(context);
          }, child: Text('Join Event'),)
        ],
      ),

    ),
  );
}

