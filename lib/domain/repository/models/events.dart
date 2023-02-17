import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Event {
  final int id;
  final String eventname;
  final String description;
  final String createDate;
  final double lat;
  final double lng;
  final String address;

  const Event({
    required this.id,
    required this.eventname,
    required this.description,
    required this.createDate,
    required this.lat,
    required this.lng,
    required this.address,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        id: json['id'],
        eventname: json['eventname'],
        description: json['description'],
        createDate: json['createDate'],
        lat: json['lat'],
        lng: json['lng'],
        address: json['address']);
  }
}
List<Event> parseEvents(String responseBody){
  final parsed = jsonDecode(responseBody).cast<Map<String,dynamic>>();
  return parsed.map<Event>((json) => Event.fromJson(json)).toList();
}


Future<List<Event>> fetchEvents() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8080/events'));
  if (response.statusCode == 200) {
    print(response.body);
    return compute(parseEvents, response.body);
  } else {
    throw Exception('failed');
  }
}

Future<http.Response> createEvent(Event event){
  return http.post(
    Uri.parse('http://10.0.2.2:8080/events'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'eventname': event.eventname,
      'description': event.description,
      'lat': event.lat.toString(),
      'lng': event.lng.toString(),
      'address': event.address,
    })
  );
}