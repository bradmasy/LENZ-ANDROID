import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

import '../util/LocationUtil.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _mapController = MapController();
  late FollowOnLocationUpdate _followOnLocationUpdate;
  late StreamController<double?> _followCurrentLocationStreamController;

  @override
  void initState() {
    super.initState();
    _followOnLocationUpdate = FollowOnLocationUpdate.always;
    _followCurrentLocationStreamController = StreamController<double?>();
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
        onPositionChanged: (MapPosition position, bool hasGesture) {
          if (hasGesture &&
              _followOnLocationUpdate != FollowOnLocationUpdate.never) {
            setState(
              () => _followOnLocationUpdate = FollowOnLocationUpdate.never,
            );
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
            stream: GetIt.I.get<LocationUtil>().getLocationStream(),
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
              onPressed: () {
                // Follow the location marker on the map when location updated until user interact with the map.
                setState(() {
                  _mapController.rotate(0);
                  _followOnLocationUpdate = FollowOnLocationUpdate.always;
                });
                // Follow the location marker on the map and zoom the map to level 18.
                _followCurrentLocationStreamController.add(17);
              },
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
}
