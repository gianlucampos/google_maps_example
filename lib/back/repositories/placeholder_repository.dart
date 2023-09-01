import 'package:google_maps_example/back/models/custom_placeholder.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class PostosRepository {
  final Set<CustomPlaceholder> _points = {
    CustomPlaceholder(
      name: 'Posto GT - Rede Rodoil',
      adress: 'R. João Negrão, 1072 - Rebouças - Centro, Curitiba - PR',
      imageLink:
          'https://lh5.googleusercontent.com/p/AF1QipP_xnSi5-sp9slSuMpSx-JlmvwvHGL1VJ_JcOGX=w408-h306-k-no',
      latitude: -25.4361979,
      longitude: -49.2624613,
    ),
    CustomPlaceholder(
      name: 'Auto Posto Rodoviária',
      adress: 'Av. Presidente Affonso Camargo 10 - Rebouças, Curitiba - PR',
      imageLink:
          'https://lh5.googleusercontent.com/p/AF1QipPnfQSsnvt6-VAxF-fUQ0onQCeRktJptOvSL_9F=w408-h306-k-no',
      latitude: -25.435538,
      longitude: -49.2623809,
    ),
    CustomPlaceholder(
      name: 'Auto Posto Nilo Cairo',
      adress: 'R. Tibagi, 652 - Centro, Curitiba - PR',
      imageLink:
          'https://lh5.googleusercontent.com/p/AF1QipOB2w7C9Q_NTblNRhcxJtN3-s4_gSjHI1rs5cSM=w408-h544-k-no',
      latitude: -25.435260,
      longitude: -49.2620769,
    ),
  };

  Set<CustomPlaceholder> get getPoints => _points;

  void savePoint(CustomPlaceholder point) {
    if (_points.contains(point)) {
      _points.remove(point);
    }
    _points.add(point);
  }

  CustomPlaceholder? getPointByPosition(
      {required double latitude, required double longitude}) {
    return _points.firstWhereOrNull(
        (point) => point.latitude == latitude && point.longitude == longitude);
  }

  void removePointByCoordenates(
      {required double latitude, required double longitude}) {
    _points.removeWhere(
        (point) => point.latitude == latitude && point.longitude == longitude);
  }
}
