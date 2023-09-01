import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_example/back/models/custom_placeholder.dart';
import 'package:google_maps_example/back/repositories/placeholder_repository.dart';
import 'package:google_maps_example/front/map/map_page.dart';
import 'package:google_maps_example/front/map/widgets/placeholder_details.dart';
import 'package:google_maps_example/front/map/widgets/placeholder_form.dart';
import 'package:google_maps_example/front/store/app_store.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';

part 'map_controller.g.dart';

// ignore: library_private_types_in_public_api
class MapController = _MapController with _$MapController;

abstract class _MapController with Store {
  final appStore = GetIt.I.get<AppStore>();
  final repository = GetIt.I.get<PostosRepository>();

  late GoogleMapController mapsController;

  @observable
  ObservableSet<Marker> markers = ObservableSet<Marker>();

  @action
  void addMarker(CustomPlaceholder point) {
    var marker = Marker(
      consumeTapEvents: true,
      markerId: MarkerId(point.name!),
      position: LatLng(point.latitude!, point.longitude!),
      onTap: () => chooseActionOnTap(point),
    );
    repository.addPoint(point);
    markers.add(marker);
  }

  @action
  void removeMarker(LatLng coordenates) {
    markers.removeWhere((elem) => elem.position == coordenates);
    repository.removePointByCoordenates(
      latitude: coordenates.latitude,
      longitude: coordenates.longitude,
    );
  }

  void chooseActionOnTap(CustomPlaceholder point) async {
    if (appStore.markerMode == MarkerMode.remove) {
      removeMarker(LatLng(point.latitude!, point.longitude!));
      return;
    }

    var existentMarker = repository.getPointByPosition(
      latitude: point.latitude!,
      longitude: point.longitude!,
    );

    if (appStore.markerMode == MarkerMode.view) {
      await _showModal.call(existentMarker!);
      return;
    }

    if (appStore.markerMode == MarkerMode.edit) {
      await showDialog(
        context: appKey.currentState!.context,
        builder: (context) => PlaceholderModal(coordenates: existentMarker!),
      );
      return;
    }
  }

  void onMapCreated(GoogleMapController gmc) {
    mapsController = gmc;
    _loadMarkers();
    // _moveToCurrentLocation();
  }

  void _loadMarkers() async {
    for (CustomPlaceholder point in repository.getPoints) {
      addMarker(point);
    }
  }

  void _moveToCurrentLocation() async {
    try {
      _checkLocationPermition();
      Position currentPosition = await Geolocator.getCurrentPosition();
      final coordenates =
          LatLng(currentPosition.latitude, currentPosition.longitude);
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
