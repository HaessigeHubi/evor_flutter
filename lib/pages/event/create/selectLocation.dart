import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocation extends StatefulWidget{
  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  LatLng startLocation = LatLng(47.376888, 8.541694);
  String location = "Move around";
  late ResponseLocation selectedLocation;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text("Select your Event Location"),
          backgroundColor: Colors.orange,
        ),
        body: Stack(
            children:[
              GoogleMap( //Map widget from google_maps_flutter package
                zoomGesturesEnabled: true, //enable Zoom in, out on map
                initialCameraPosition: CameraPosition( //innital position in map
                  target: startLocation, //initial position
                  zoom: 14.0, //initial zoom level
                ),
                mapType: MapType.normal, //map type
                onMapCreated: (controller) { //method called when map is created
                  setState(() {
                    mapController = controller;
                  });
                },
                onCameraMove: (CameraPosition cameraPositiona) {
                  cameraPosition = cameraPositiona; //when map is dragging 
                },
                onCameraIdle: () async { //when map drag stops
                  List<Placemark> placemarks = await placemarkFromCoordinates(cameraPosition!.target.latitude, cameraPosition!.target.longitude);
                  setState(() { //get place name from lat and lang
                    location = placemarks.first.administrativeArea.toString() + ", " +  placemarks.first.street.toString();
                    selectedLocation = new ResponseLocation(cameraPosition!.target.latitude, cameraPosition!.target.longitude, placemarks.first);
                  });
                },
              ),

              Center( //picker image on google map
                child: Image.asset("assets/position.png", width: 50,),
              ),


              Positioned(  //widget to display location name
                  bottom:100,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Card(
                      child: Container(
                          padding: EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width - 40,
                          child: Column(
                            children: [
                              ListTile(
                                leading: Image.asset("assets/position.png", width: 25,),
                                title:Text(location, style: TextStyle(fontSize: 18),),
                                dense: true,
                              ),
                              ElevatedButton(onPressed: (){
                                  Navigator.pop(context, selectedLocation);
                              }, child: Text('Use this location'))
                            ],
                          )
                      ),
                    ),
                  )
              )
            ]
        )
    );
  }
}

class ResponseLocation{
  late double latitude;
  late double longitude;
  late Placemark selectedLocation;
  ResponseLocation(double latitude, double longitude, Placemark selectedLocation){
    this.latitude = latitude;
    this.longitude = longitude;
    this.selectedLocation = selectedLocation;
  }
}