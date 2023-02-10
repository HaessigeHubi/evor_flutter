
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../login/signup.dart';
import 'package:flutter/material.dart';
import '../../domain/repository/models/events.dart' as EventsMap;

class GoogleMapsWidget extends StatefulWidget {
  const GoogleMapsWidget({super.key});

  @override
  State<GoogleMapsWidget> createState() => _GoogleMapsWidgetState();
}

class _GoogleMapsWidgetState extends State<GoogleMapsWidget> {
  late GoogleMapController mapController;

  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    String stylingMap = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    mapController.setMapStyle(stylingMap);

    final events = await EventsMap.fetchEvents();
    setState(() {
      _markers.clear();
      for (final event in events) {
        final marker = Marker(
          markerId: MarkerId(event.eventname),
          position: LatLng(event.lat, event.lng),
          infoWindow: InfoWindow(
            title: event.eventname,
            snippet: event.address,
          ),
        );
        _markers[event.eventname] = marker;
      }
    });
  }

  final LatLng _center = const LatLng(47.376888, 8.541694);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 18.0,
        tilt: 59.44,
      ),
      markers: _markers.values.toSet(),
    );
  }
}