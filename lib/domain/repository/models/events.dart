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
  final String owner;
  final String startDate;
  final String endDate;

  const Event({
    required this.id,
    required this.eventname,
    required this.description,
    required this.createDate,
    required this.lat,
    required this.lng,
    required this.address,
    required this.owner,
    required this.startDate,
    required this.endDate
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        id: json['id'],
        eventname: json['eventname'],
        description: json['description'],
        createDate: json['createDate'],
        lat: json['lat'],
        lng: json['lng'],
        address: json['address'],
        owner: json['owner'],
        startDate: json['startDate'],
        endDate: json['endDate']
    );
  }
}
List<Event> parseEvents(String responseBody){
  final parsed = jsonDecode(responseBody).cast<Map<String,dynamic>>();
  return parsed.map<Event>((json) => Event.fromJson(json)).toList();
}

Event parseEvent(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return Event.fromJson(parsed);
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

Future<Event> fetchEventbyMail(String email) async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8080/users/$email'));
  if (response.statusCode == 200) {
    print(response.body);
    if (response.body != ''){
      return parseEvent(response.body);
    }
    return Event(id: 1, eventname: '', description: '', createDate: '', lat: 0, lng: 0, address: '', owner: '',startDate: '',endDate: '');
  } else {
    print(response.body);
    throw Exception('failed');
  }
}

Future<Event> createEvent(Event event) async {
  final response = await http.post(
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
        'owner' : event.owner,
        'startDate': event.startDate,
        'endDate':event.endDate
      })
  );
  return parseEvent(response.body);
}

Future<List<Event>> fetchUsersEvents(String userid) async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8080/users/' + userid  + '/events'));
  if (response.statusCode == 200) {
    print(response.body);
    return compute(parseEvents, response.body);
  } else {
    throw Exception('failed');
  }
}

Future<http.Response> joinEvent(String eventId, int userId){
  print(eventId);
  return http.post(
      Uri.parse('http://10.0.2.2:8080/events/$eventId/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'id': userId
      })
  );
}