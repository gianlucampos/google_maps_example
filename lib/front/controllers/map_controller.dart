import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_example/back/models/custom_placeholder.dart';
import 'package:google_maps_example/back/repositories/placeholder_repository.dart';
import 'package:google_maps_example/front/pages/home_page.dart';
import 'package:google_maps_example/front/widgets/placeholder_details.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends ChangeNotifier {
  LatLng coordenates = const LatLng(-31.751510, -52.378206);
  Set<Marker> markers = <Marker>{};
  late GoogleMapController mapsController;

  onMapCreated(GoogleMapController gmc) {
    mapsController = gmc;
    _moveToCurrentLocation();
    _loadMarkers();
  }

  addMarker(LatLng coordenate) {
    final marker = Marker(
      markerId: MarkerId(Random().nextInt(5).toString()),
      position: coordenate,
    );
    markers.add(marker);
    notifyListeners();
  }

  void _loadMarkers() async {
    final mapPoints = PostosRepository().points;

    for (CustomPlaceholder point in mapPoints) {
      markers.add(
        Marker(
          markerId: MarkerId(point.name),
          position: LatLng(point.latitude, point.longitude),
          icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            'images/posto.png',
          ),
          onTap: () => {
            showModalBottomSheet(
              context: appKey.currentState!.context,
              builder: (context) => PlaceHolderDetails(placeholder: point),
            )
          },
        ),
      );
    }

    notifyListeners();
  }

  void _moveToCurrentLocation() async {
    try {
      _checkLocationPermition();
      Position currentPosition = await Geolocator.getCurrentPosition();
      coordenates = LatLng(currentPosition.latitude, currentPosition.longitude);
      mapsController.animateCamera(CameraUpdate.newLatLng(coordenates));
    } catch (e) {
      developer.log('Error at getPosicao: $e');
    }
    notifyListeners();
  }

  void _checkLocationPermition() async {
    bool activated = await Geolocator.isLocationServiceEnabled();
    if (!activated) {
      throw Future.error('Por favor, habilite a localização no smartphone');
    }

    LocationPermission permition = await Geolocator.checkPermission();
    if (permition == LocationPermission.denied) {
      permition = await Geolocator.requestPermission();
      if (permition == LocationPermission.denied) {
        throw Future.error('Você precisa autorizar o acesso à localização');
      }
    }

    if (permition == LocationPermission.deniedForever) {
      throw Future.error('Você precisa autorizar o acesso à localização');
    }
  }
}
