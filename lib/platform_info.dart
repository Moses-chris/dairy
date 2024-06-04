import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

abstract class PlatformInfo {
  FirebaseOptions get options;

  factory PlatformInfo() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _AndroidPlatformInfo();
      case TargetPlatform.iOS:
        return _IosPlatformInfo();
      default:
        throw UnsupportedError(
          'PlatformInfo is not supported for this platform.',
        );
    }
  }
}

class _AndroidPlatformInfo implements PlatformInfo {
  @override
  final FirebaseOptions options = const FirebaseOptions(
    apiKey: String.fromEnvironment('apiKey'),
    appId: String.fromEnvironment('appIdAndroid'),
    messagingSenderId: String.fromEnvironment('messagingSenderId'),
    projectId: String.fromEnvironment('projectId'),
    storageBucket: String.fromEnvironment('storageBucket'),
  );
}

class _IosPlatformInfo implements PlatformInfo {
  @override
  final FirebaseOptions options = const FirebaseOptions(
    apiKey: String.fromEnvironment('apiKey'),
    appId: String.fromEnvironment('appIdIos'),
    messagingSenderId: String.fromEnvironment('messagingSenderId'),
    projectId: String.fromEnvironment('projectId'),
    storageBucket: String.fromEnvironment('storageBucket'),
    iosBundleId: String.fromEnvironment('iosBundleId'),
  );
}
