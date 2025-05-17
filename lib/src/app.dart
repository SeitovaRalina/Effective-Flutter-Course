import 'package:flutter/material.dart';
import 'package:effective_flutter_course/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:device_preview/device_preview.dart';

import 'features/menu/view/menu_screen.dart';

class CoffeeShop extends StatelessWidget {
  const CoffeeShop({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateTitle: (context) => AppLocalizations.of(context)!.title,
        theme: theme,
        home: const MenuScreen(),
    );
  }
}