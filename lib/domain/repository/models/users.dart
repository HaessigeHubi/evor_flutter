import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class User {
  final int id;
  final String firstname;
  final String lastname;
  final String birthday;
  final String email;

  const User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.birthday,
    required this.email
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        birthday: json['birthday'],
        email: json['email'])
    ;
  }
}
List<User> parseUsers(String responseBody){
  final parsed = jsonDecode(responseBody).cast<Map<String,dynamic>>();
  return parsed.map<User>((json) => User.fromJson(json)).toList();
}

User parseUser(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return User.fromJson(parsed);
}

Future<List<User>> fetchUsers() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8080/users'));
  if (response.statusCode == 200) {
    print(response.body);
    return compute(parseUsers, response.body);
  } else {
    throw Exception('failed');
  }
}
Future<User> fetchUserbyMail(String? email) async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8080/users/email/$email'));
  if (response.statusCode == 200) {
    print(response.body);
    if (response.body != ''){
      return parseUser(response.body);
    }
     return User(id: 1, firstname: '', lastname: '', birthday: '', email: '');
  } else {
    print(response.body);
    throw Exception('failed');
  }
}

Future<User> fetchUserbyMails(String email) async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8080/users/email/$email'));
  if (response.statusCode == 200) {
    print(response.body);
    if (response.body != ''){
      return parseUser(response.body);
    }
    return User(id: 1, firstname: '', lastname: '', birthday: '', email: '');
  } else {
    print(response.body);
    throw Exception('failed');
  }
}
Future<User> createUser(User user) async {
  final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstname': user.firstname,
        'lastname': user.lastname,
        'birthday': user.birthday,
        'email': user.email,
      }));

      return parseUser(response.body);
}

