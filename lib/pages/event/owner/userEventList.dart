import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../login/signup.dart';
import '../../../domain/repository/models/events.dart' as EventsMap;
import '../../../domain/repository/models/users.dart' as EventUser;


class UserEventList extends StatefulWidget {
  const UserEventList({super.key, required this.user});
  final EventUser.User user;

  @override
  State<UserEventList> createState() => _UserEventListState();
}

class _UserEventListState extends State<UserEventList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your upcoming Events"),
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
      body: UserEventListItems(user: widget.user),
    );
  }
}


class UserEventListItems extends StatefulWidget {
  const UserEventListItems({super.key, required this.user});
  final EventUser.User user;

  @override
  State<UserEventListItems> createState() => _UserEventListItemsState();
}

class _UserEventListItemsState extends State<UserEventListItems> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventsMap.Event>>(
      future: EventsMap.fetchUsersEvents(widget.user.id.toString()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {

                if(snapshot.data![index].owner.toString() == widget.user.id.toString()){
                  return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(
                                'https://media.gettyimages.com/photos/spectators-cheering-at-sporting-event-picture-id487704373')),
                        trailing: Icon(Icons.assignment_ind),
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
                } else{
                  return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(
                                'https://media.gettyimages.com/photos/spectators-cheering-at-sporting-event-picture-id487704373')),
                        trailing: Icon(Icons.handshake_outlined),
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
                }

                })
              ;
        } else if (snapshot.hasError) {
          return SizedBox(height: 0);
        }
        // By default show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}