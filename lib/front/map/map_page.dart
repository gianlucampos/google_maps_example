import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_example/front/map/map_controller.dart';
import 'package:google_maps_example/front/map/widgets/placeholder_form.dart';
import 'package:google_maps_example/front/store/app_store.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';

final appKey = GlobalKey();

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final appStore = GetIt.I.get<AppStore>();
  final controller = GetIt.I.get<MapController>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    autorun((_) {
      print("Autorun has been triggered ${controller.markers.length}");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: appKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Observer(builder: (_) {
          return AppBar(
            title: Text(appStore.appBarDescription),
            leading: appStore.markerMode == MarkerMode.create
                ? null
                : IconButton(
                    onPressed: () {
                      appStore.setAppBarDescription('Google Maps Example');
                      appStore.setMarkerMode(MarkerMode.create);
                    },
                    icon: const Icon(Icons.cancel),
                  ),
            actions: [
              IconButton(
                onPressed: () {
                  appStore.setAppBarDescription('Editing markers');
                  appStore.setMarkerMode(MarkerMode.edit);
                },
                icon: const Icon(Icons.edit_location),
              ),
              IconButton(
                onPressed: () {
                  appStore.setAppBarDescription('Removing markers');
                  appStore.setMarkerMode(MarkerMode.remove);
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          );
        }),
      ),
      body: Observer(builder: (_) {
        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: controller.coordenates,
            zoom: 18,
          ),
          zoomControlsEnabled: true,
          myLocationEnabled: true,
          mapType: MapType.terrain,
          markers: controller.markers,
          onMapCreated: controller.onMapCreated,
          onTap: onTap,
        );
      }),
    );
  }

  void onTap(LatLng coordenates) async {
    if (appStore.markerMode != MarkerMode.remove) {
      await showDialog(
        context: appKey.currentState!.context,
        builder: (context) => PlaceholderModal(coordenates: coordenates),
      );
    }
  }
}
