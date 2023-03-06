import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../domain/repository/models/events.dart' as EventsMap;
import '../../../domain/repository/models/users.dart' as EventUser;

//Details are beeing send by Parameters. The User and Event is then displayed
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
      backgroundColor: Colors.orange,
      title: Text(event.eventname),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //Default Image
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
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                  "Description: ",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )
              ),
              Expanded(
                flex: 1,
                child: Text(
                  event.description,
                  style: const TextStyle(
                    fontSize: 16,
                  )
              ),)

            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                  "Date: ",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )
              ),
              Text(
                  event.startDate + ' - ' + event.endDate,
                  style: const TextStyle(
                    fontSize: 16,
                  )
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                  "Adress: ",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )
              ),
              Text(
                event.address,
                  style: const TextStyle(
                    fontSize: 16,
                  )
              ),
            ],
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                  "Tag: ",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )
              ),
              Text(
                  event.tag,
                  style: const TextStyle(
                    fontSize: 16,
                  )
              ),
            ],
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                  "Max Participations: ",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )
              ),
              Text(
                  event.maxParticipation.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                  )
              ),
            ],
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                  "Age Restriction: ",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )
              ),
              Text(
                  event.ageRestriction.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                  )
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.all(16.0),
              child:
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text('Go Back'),),),

              ElevatedButton(onPressed: (){
                print(event.id);
                EventsMap.joinEvent(event.id.toString(), user.id);
                Navigator.pop(context);
              }, child: Text('Join Event'),)
            ],
          ),

        ],
      ),

    ),
  );
}

