import 'dart:convert';
import 'package:demo1/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import '../models/place.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.OnselectLocation});
  final void Function(PlaceLocation location) OnselectLocation;
  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isgettingLocation = false;
  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyDaQA-OPpOI9cIhlzFhl1EU4XFFslsVedc';
  }

  Future<void> _savePlace(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyDaQA-OPpOI9cIhlzFhl1EU4XFFslsVedc');
    final response = await http.get(url);
    final resdata = json.decode(response.body);
    final address = resdata['results'][0]['formatted_address'];
    setState(() {
      _pickedLocation = PlaceLocation(
          address: address, latitude: latitude, longitude: longitude);
      _isgettingLocation = false;
    });
    widget.OnselectLocation(_pickedLocation!);
  }

  void _getCurrentLocatin() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isgettingLocation = true;
    });
    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) {
      return;
    }
    _savePlace(lat, lng);
  }

  void _selecetOnmap() async {
    final pickedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(),
      ),
    );

    if (pickedLocation == null) {
      return;
    }
    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewcontent = Text(
      'No location chosen',
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );
    if (_isgettingLocation) {
      previewcontent = const CircularProgressIndicator();
    }
    if (_pickedLocation != null) {
      previewcontent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );
    }
    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1, color: Theme.of(context).colorScheme.primary),
            ),
            height: 250,
            width: double.infinity,
            child: previewcontent),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
                onPressed: _getCurrentLocatin,
                icon: const Icon(Icons.location_on),
                label: const Text('Get current Location')),
            TextButton.icon(
                onPressed: _selecetOnmap,
                icon: const Icon(Icons.map),
                label: const Text('Select from Map')),
          ],
        )
      ],
    );
  }
}
