import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../login/signup.dart';
import '../../../domain/repository/models/events.dart' as EventsMap;


class UserEventList extends StatefulWidget {
  const UserEventList({super.key});

  @override
  State<UserEventList> createState() => _UserEventListState();
}

class _UserEventListState extends State<UserEventList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Events"),
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
      body: const UserEventListItems(),
    );
  }
}


class UserEventListItems extends StatefulWidget {
  const UserEventListItems({super.key});

  @override
  State<UserEventListItems> createState() => _UserEventListItemsState();
}

class _UserEventListItemsState extends State<UserEventListItems> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventsMap.Event>>(
      future: EventsMap.fetchEvents(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(
                              'https://media.gettyimages.com/photos/spectators-cheering-at-sporting-event-picture-id487704373')),
                      trailing: const Icon(Icons.add),
                      subtitle: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(snapshot.data![index].description),
                              Text(snapshot.data![index].createDate),
                              Text(snapshot.data![index].address),
                            ],
                          )
                      ),
                      title: Text(snapshot.data![index].eventname),
                      onTap:(){

                      },
                    ));
              });
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        // By default show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}