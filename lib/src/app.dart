import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:effective_flutter_course/src/theme/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/menu/bloc/menu_bloc.dart';

import 'features/menu/data/category_repository.dart';
import 'features/menu/data/data_sources/categories_data_source.dart';
import 'features/menu/data/data_sources/menu_data_source.dart';
import 'features/menu/data/menu_repository.dart';
import 'features/menu/view/menu_screen.dart';
import 'features/order/bloc/order_bloc.dart';
import 'features/order/data/data_sources/order_data_source.dart';
import 'features/order/data/order_repository.dart';
import 'localization/generated/app_localizations.dart';

class CoffeeShop extends StatelessWidget {
  const CoffeeShop({super.key});

  static final dioClient = Dio(
    BaseOptions(
      baseUrl: 'https://coffeeshop.academy.effective.band/api/v1',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ICategoryRepository>(
          create: (_) => CategoriesRepository(
            networkCategoriesDataSource: NetworkCategoriesDataSource(
              dio: dioClient,
            ),
          ),
        ),
        RepositoryProvider<IMenuRepository>(
          create: (_) => MenuRepository(
            networkMenuDataSource: NetworkMenuDataSource(
              dio: dioClient,
            ),
          ),
        ),
        RepositoryProvider<IOrderRepository>(
          create: (_) => OrderRepository(
            networkOrderDataSource: NetworkOrderDataSource(
              dio: dioClient,
            ),
          ),
        ),
      ],
      child: MaterialApp(
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
        home: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => MenuBloc(
                menuRepository: context.read<IMenuRepository>(),
                categoryRepository: context.read<ICategoryRepository>(),
              ),
            ),
            BlocProvider(
              create: (context) => OrderBloc(
                orderRepository: context.read<IOrderRepository>(),
              ),
            )
          ],
          child: const MenuScreen(),
        ),
      ),
    );
  }
}
