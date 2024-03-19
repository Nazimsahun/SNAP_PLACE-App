import 'package:demo1/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location =
        const PlaceLocation(address: '', latitude: 37.422, longitude: -122.084),
    this.isSelecting = true,
  });
  final PlaceLocation location;
  final bool isSelecting;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _PickedLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Pick your location ' : 'Your location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Navigator.of(context).pop(_PickedLocation);
              },
            ),
        ],
      ),
      body: GoogleMap(
        onTap: !widget.isSelecting
            ? null
            : (position) {
                setState(() {
                  _PickedLocation = position;
                });
              },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.location.latitude, widget.location.longitude),
          zoom: 16,
        ),
        markers: (_PickedLocation == Null && widget.isSelecting)
            ? {}
            : {
                Marker(
                  markerId: MarkerId('m1'),
                  position: _PickedLocation ??
                      LatLng(
                          widget.location.latitude, widget.location.longitude),
                ),
              },
      ),
    );
  }
}
