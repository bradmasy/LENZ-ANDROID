import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../injection.dart';
import '../util/LocationUtil.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final LatLng initialLocation = const LatLng(49.283106, -123.115431);
  final double initialZoom = 8;

  late MapController _mapController;
  late FollowOnLocationUpdate _followOnLocationUpdate;
  late StreamController<double?> _followCurrentLocationStreamController;
  Stream<Position>? _locationStream;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _followOnLocationUpdate = FollowOnLocationUpdate.always;
    _followCurrentLocationStreamController = StreamController<double?>();
    _getLocationStream();
  }

  @override
  void dispose() async {
    super.dispose();
    await _followCurrentLocationStreamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        minZoom: 3,
        maxZoom: 20,
        initialCenter: initialLocation,
        initialZoom: initialZoom,
        onPositionChanged: (MapPosition position, bool hasGesture) {
          if (hasGesture &&
              _followOnLocationUpdate != FollowOnLocationUpdate.never) {
            setState(() {
              _followOnLocationUpdate = FollowOnLocationUpdate.never;
            });
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        CurrentLocationLayer(
          positionStream: const LocationMarkerDataStreamFactory()
              .fromGeolocatorPositionStream(
            stream: _locationStream,
          ),
          followCurrentLocationStream:
              _followCurrentLocationStreamController.stream,
          followOnLocationUpdate: _followOnLocationUpdate,
        ),
        const MarkerLayer(
          markers: [],
        ),
        const CircleLayer(
          circles: [],
        ),
        RichAttributionWidget(
          alignment: AttributionAlignment.bottomLeft,
          animationConfig: const ScaleRAWA(),
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () =>
                  launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FloatingActionButton(
              backgroundColor: const Color(0xA642A5F5),
              hoverColor: const Color(0xCD42A5F5),
              onPressed: _getCurrentLocation,
              child: const Icon(
                Icons.my_location,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _getLocationStream() async {
    _locationStream = await getIt.get<LocationUtil>().getLocationStream();
  }

  void _getCurrentLocation() async {
    if (locationServicePermission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      locationServicePermission = await Geolocator.requestPermission();
    }
    if (locationServicePermission == LocationPermission.denied) {
      locationServicePermission = await Geolocator.requestPermission();
    }
    if (locationServicePermission == LocationPermission.denied ||
        locationServicePermission == LocationPermission.deniedForever) {
      showToast('Current position requires location to be enabled');
    }

    // Follow the location marker on the map when location updated until user interact with the map.
    setState(() {
      _mapController.rotate(0);
      _followOnLocationUpdate = FollowOnLocationUpdate.always;
    });
    // Follow the location marker on the map and zoom the map to level 18.
    _followCurrentLocationStreamController.add(17);
  }
}
