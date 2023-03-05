import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'events.dart';

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

Future<http.Response> joinEvent(String eventId, String userId){
  print(eventId + userId);
  return http.post(
    Uri.parse('http://10.0.2.2:8080/events/' + eventId + '/users'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'id': userId
    })
  );
}