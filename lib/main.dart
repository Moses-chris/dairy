import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myapp/app_settings.dart';
import 'package:myapp/config.dart';
import 'package:myapp/data/utils/local_database.dart';
import 'package:myapp/domain/repository/mood_repo.dart';
import 'package:myapp/firebase.dart';
import 'package:myapp/presentation/injector/injector.dart';
import 'package:myapp/presentation/routes/routes.dart';
import 'package:myapp/presentation/theme/ultramarine_light.dart';

String createDirectory({required String path}) {
  if (!Directory(path).existsSync()) {
    Directory(path).createSync(recursive: true);
  }
  return path;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = Config();
  final directory = await getApplicationDocumentsDirectory();
  await LocalDatabase.initialise(
    directory: createDirectory(
      path: directory.path + config.cacheDirectory,
    ),
  );
  await Injector.initialise();

  /// Firebase Services initialisation
  await Injector.resolve<FirebaseService>().initialise();
  await Injector.resolve<ReportingService>().initialise();
  await Injector.resolve<AnalyticsService>().initialise();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final isFreshInstall = Injector.resolve<AppSettings>().isFreshInstall;
  if (isFreshInstall) {
    Injector.resolve<MoodRepo>().addDefaultMoods();
  }

  /// Run this statement when you reinstall your app
  /// for adding moods in backend (run only once)
  // Injector.resolve<MoodRepo>().addDefaultMoods();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: UltramarineLightTheme().theme,
      routerConfig: AppRouter.appRoutes,
    );
  }
}
