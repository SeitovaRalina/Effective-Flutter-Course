import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

import 'src/app.dart';

void main() {
  runZonedGuarded(
      () => runApp(
            DevicePreview(
              enabled: !kReleaseMode,
              builder: (context) => const CoffeeShop(),
            ),
          ), (error, stack) {
    log(error.toString(), name: 'App Error', stackTrace: stack);
  });
}
