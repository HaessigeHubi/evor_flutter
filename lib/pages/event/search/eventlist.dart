import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../login/signup.dart';
import '../../../domain/repository/models/events.dart' as EventsMap;
import '../../../domain/repository/models/users.dart' as EventUser;
import 'detailevent.dart';

class EventList extends StatefulWidget {
  const EventList({super.key, required this.user});
  final EventUser.User user;
  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("All Events close to you"),
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
      body: EventListItems( user: widget.user,),
    );
  }
}

class EventListItems extends StatefulWidget {
  final EventUser.User user;
  const EventListItems({super.key, required this.user});

  @override
  State<EventListItems> createState() => _EventListItemsState();
}

class _EventListItemsState extends State<EventListItems> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventsMap.Event>>(
      //Gets Events from the DB
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
                      //Default Image
                      backgroundImage: NetworkImage(
                          'https://media.gettyimages.com/photos/spectators-cheering-at-sporting-event-picture-id487704373')),
                  trailing: const Icon(Icons.add),
                  subtitle: Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(snapshot.data![index].description),
                      Text(snapshot.data![index].startDate + ' - ' + snapshot.data![index].endDate),
                      Text(snapshot.data![index].address),
                    ],
                  )),
                  title: Text(snapshot.data![index].eventname),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailEvent(
                              event: snapshot.data![index],
                          user: widget.user,
                            )));
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
