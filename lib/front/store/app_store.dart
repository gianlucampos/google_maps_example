import 'dart:io';

import 'package:mobx/mobx.dart';

part 'app_store.g.dart';

enum MarkerMode { create, edit, remove }

// ignore: library_private_types_in_public_api
class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  MarkerMode markerMode = MarkerMode.create;

  @observable
  String appBarDescription = 'Google Maps Example';

  @observable
  File? selectedImage;

  @action
  void setMarkerMode(MarkerMode value) => markerMode = value;

  @action
  void setAppBarDescription(String value) => appBarDescription = value;

  @action
  void setSelectedImage(File value) => selectedImage = value;
}
