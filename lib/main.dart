import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_example/front/map/map_controller.dart';
import 'package:google_maps_example/front/map/map_page.dart';

import 'back/repositories/placeholder_repository.dart';
import 'front/store/app_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  setupDI();
  runApp(const MainApp());
}

void setupDI() {
  GetIt getIt = GetIt.instance;
  getIt.registerSingleton<PostosRepository>(PostosRepository());
  getIt.registerSingleton<AppStore>(AppStore());
  getIt.registerSingleton<MapController>(MapController());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Postos Locais',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MapPage(),
    );
  }
}
