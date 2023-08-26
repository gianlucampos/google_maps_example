import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_example/back/models/custom_placeholder.dart';
import 'package:google_maps_example/back/repositories/placeholder_repository.dart';
import 'package:google_maps_example/front/map/map_page.dart';
import 'package:google_maps_example/front/map/widgets/placeholder_details.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';

part 'map_controller.g.dart';

// ignore: library_private_types_in_public_api
class MapController = _MapController with _$MapController;

abstract class _MapController with Store {
  late GoogleMapController mapsController;

  LatLng coordenates = const LatLng(-31.751510, -52.378206);

  @observable
  ObservableSet<Marker> markers = ObservableSet<Marker>();

  @action
  void addMarker(CustomPlaceholder point) {
    final marker = Marker(
      markerId: MarkerId(point.name),
      position: LatLng(point.latitude, point.longitude),
      onTap: () async => await _showModal.call(point),
    );
    markers.add(marker);
  }

  @action
  void removeMarker(LatLng coordenates) {
    // markers.removeWhere((elem) => elem.position == coordenates);
    markers.clear();
  }

  void onMapCreated(GoogleMapController gmc) {
    mapsController = gmc;
    // _loadMarkers();
    // _moveToCurrentLocation();
  }

  void _loadMarkers() async {
    final mapPoints = GetIt.I.get<PostosRepository>().getPoints;
    for (CustomPlaceholder point in mapPoints) {
      addMarker(point);
    }
  }

  void _moveToCurrentLocation() async {
    try {
      _checkLocationPermition();
      Position currentPosition = await Geolocator.getCurrentPosition();
      coordenates = LatLng(currentPosition.latitude, currentPosition.longitude);
      await mapsController.animateCamera(CameraUpdate.newLatLng(coordenates));
    } catch (e) {
      developer.log('Error at getPosicao: $e');
    }
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

  Future _showModal(CustomPlaceholder point) {
    return showModalBottomSheet(
      context: appKey.currentState!.context,
      builder: (context) => PlaceHolderDetails(placeholder: point),
    );
  }
}
