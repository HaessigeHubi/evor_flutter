import 'package:flutter/material.dart';

import '../../../domain/repository/models/events.dart' as EventsMap;

class DetailEvent extends StatelessWidget{
  final EventsMap.Event event;
  const DetailEvent ({
    Key? key,
    required this.event,
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
            Navigator.pop(context);
          }, child: Text('Join Event'),)
        ],
      ),

    ),
  );
}