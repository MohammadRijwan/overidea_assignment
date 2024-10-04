import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:overidea_assignment/src/core/utils/app_locale.dart';

class GoogleMapScreen extends StatefulWidget {
  static String route = 'google_map_screen';

  const GoogleMapScreen({super.key});

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapController _mapController;
  late Location _location;
  LatLng? _currentLocation;
  late Marker _currentLocationMarker;
  late Circle _twoKmRadiusCircle;

  @override
  void initState() {
    super.initState();
    _location = Location();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    await _location.requestPermission();
    final locationData = await _location.getLocation();
    setState(() {
      _currentLocation =
          LatLng(locationData.latitude!, locationData.longitude!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocale.mapScreen.getString(context),
        ),
      ),
      body: _currentLocation != null
          ? GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _currentLocation!,
                zoom: 14,
              ),
              markers: {
                _currentLocationMarker = Marker(
                  markerId: const MarkerId('Current Location'),
                  position: _currentLocation!,
                  infoWindow: const InfoWindow(title: 'Current Location'),
                ),
              },
              circles: {
                _twoKmRadiusCircle = Circle(
                  circleId: const CircleId('2km Radius'),
                  center: _currentLocation!,
                  radius: 2000,
                  strokeColor: Colors.blue,
                  fillColor: Colors.blue.withOpacity(0.5),
                ),
              },
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
