import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

import 'src/app.dart';
import 'src/common/bloc/base_observer.dart';
import 'src/theme/app_colors.dart';

void main() {
  Bloc.observer = const BaseObserver();
  runZonedGuarded(
      () => runApp(
            DevicePreview(
              enabled: !kReleaseMode,
              builder: (context) => const CoffeeShop(),
              backgroundColor: AppColors.background,
            ),
          ), (error, stack) {
    log(error.toString(), name: 'App Error', stackTrace: stack);
  });
}
