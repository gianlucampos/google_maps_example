import 'package:flutter/material.dart';
import 'package:google_maps_example/front/controllers/map_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

final appKey = GlobalKey();

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: appKey,
      appBar: AppBar(
        title: const Text('Google Maps Example'),
      ),
      body: ChangeNotifierProvider<MapController>(
        create: (context) => MapController(),
        child: Builder(builder: (context) {
          final local = context.watch<MapController>();

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: local.coordenates,
              zoom: 18,
            ),
            zoomControlsEnabled: true,
            myLocationEnabled: true,
            mapType: MapType.terrain,
            onMapCreated: local.onMapCreated,
            compassEnabled: true,
            markers: local.markers,
            onLongPress: local.addMarker,
          );
        }),
      ),
    );
  }
}
