import 'dart:convert';
import 'dart:ui' as ui;

import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../event/search/detailevent.dart';
import '../login/signup.dart';
import 'package:flutter/material.dart';
import '../../domain/repository/models/events.dart' as EventsMap;
import '../../domain/location/userLocation.dart' as UserLocation;

import 'dart:typed_data';

bool updateMap = true;
Filter mapfilter = new Filter.e();

class GoogleMapsWidget extends StatefulWidget {
  const GoogleMapsWidget({super.key});

  @override
  State<GoogleMapsWidget> createState() => _GoogleMapsWidgetState();
}

class _GoogleMapsWidgetState extends State<GoogleMapsWidget> {
  double latitude = 42.376888;
  double longitude = 8.541694;
  late GoogleMapController mapController;
  LatLng _center = LatLng(47.376888, 8.541694);

  final Map<String, Marker> _markers = {};

  Future<void> onMapCreated(GoogleMapController controller) async {
    if (updateMap) {
      mapController = controller;
      String stylingMap = await DefaultAssetBundle.of(context)
          .loadString('assets/map_style.json');
      mapController.setMapStyle(stylingMap);
      final events = await EventsMap.fetchEvents();
      _markers.clear();

      final Uint8List markerIcon = await getBytesFromAsset('assets/position.png', 80);

      setState(() {
        final Map<String, Marker> _tmpmarkers = {};
        for (final event in events) {
          if (event.eventname.contains(mapfilter.eventname)) {
            final marker = Marker(
              markerId: MarkerId(event.eventname),
              position: LatLng(event.lat, event.lng),
              infoWindow: InfoWindow(
                  title: event.eventname,
                  snippet: event.address,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailEvent(event: event)));
                  }),
              icon: BitmapDescriptor.fromBytes(markerIcon),
            );
            _markers[event.eventname] = marker;
          }
        }
      });
      Position newPosition = await UserLocation.determinePosition();
      setState(() {
        mapController.animateCamera(CameraUpdate.newLatLng(
            LatLng(newPosition.latitude, newPosition.longitude)));
      });
      updateMap = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: onMapCreated,
      onCameraIdle: () {
        onMapCreated(mapController);
      },
      mapType: MapType.normal,
      myLocationEnabled: true,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 14.0,
        tilt: 59.44,
      ),
      markers: _markers.values.toSet(),
    );
  }
}

class Filter {
  String eventname = '';
  String datefrom = '';
  String dateto = '';
  String tag = '';
  String Location = '';
  Filter(String eventname, String datefrom, String dateto, String tag,
      String Location) {
    this.eventname = eventname;
    this.datefrom = datefrom;
    this.dateto = dateto;
    this.Location = Location;
  }
  Filter.e() {}
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

Future<Uint8List> getRoundedImage(String imagePath) async {
  final ByteData imageData = await rootBundle.load(imagePath);
  final Uint8List bytes = Uint8List.view(imageData.buffer);

  final img.Image? image = img.decodeImage(bytes);
  final img.Image circleImage = img.Image(width: image!.width, height: image.height);
  img.fill(circleImage, color: img.ColorRgba8(255, 255, 255, 0));
  img.drawCircle(circleImage, x: image.width ~/ 2, y: image.height ~/ 2,
      radius: image.width ~/ 2, color: img.ColorRgba8(255, 255, 255, 255));

  final img.Image maskedImage = img.copyMask(image, circleImage);
  final Uint8List roundedImage = img.encodePng(maskedImage);

  return roundedImage;
}
