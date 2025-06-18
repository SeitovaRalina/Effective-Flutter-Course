import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'common/database/database.dart';
import 'features/location/bloc/location/location_bloc.dart';
import 'features/location/bloc/map/map_bloc.dart';
import 'features/location/data/data_sources/locations_data_source.dart';
import 'features/location/data/data_sources/savable_locations_data_source.dart';
import 'features/location/data/locations_repository.dart';
import 'features/menu/bloc/menu_bloc.dart';
import 'features/menu/data/category_repository.dart';
import 'features/menu/data/data_sources/categories_data_source.dart';
import 'features/menu/data/data_sources/menu_data_source.dart';
import 'features/menu/data/data_sources/savable_categories_data_source.dart';
import 'features/menu/data/data_sources/savable_menu_data_source.dart';
import 'features/menu/data/menu_repository.dart';
import 'features/menu/view/menu_screen.dart';
import 'features/order/bloc/order_bloc.dart';
import 'features/order/data/data_sources/order_data_source.dart';
import 'features/order/data/order_repository.dart';
import 'localization/generated/app_localizations.dart';
import 'common/extensions/context_extensions.dart';
import 'theme/theme.dart';

class CoffeeShop extends StatelessWidget {
  const CoffeeShop({super.key});

  static final dioClient = Dio(
    BaseOptions(
      baseUrl: 'https://coffeeshop.academy.effective.band/api/v1',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static final menuDb = MenuDb();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ICategoryRepository>(
          create: (_) => CategoriesRepository(
            networkCategoriesDataSource: NetworkCategoriesDataSource(
              dio: dioClient,
            ),
            dbCategoriesDataSource: DbCategoriesDataSource(
              menuDb: menuDb,
            ),
          ),
        ),
        RepositoryProvider<IMenuRepository>(
          create: (_) => MenuRepository(
            networkMenuDataSource: NetworkMenuDataSource(
              dio: dioClient,
            ),
            dbMenuDataSource: DbMenuDataSource(
              menuDb: menuDb,
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
        RepositoryProvider<ILocationsRepository>(
          create: (context) => LocationsRepository(
            networkLocationsDataSource:
                NetworkLocationsDataSource(dio: dioClient),
            dbLocationsDataSource: DbLocationsDataSource(menuDb: menuDb),
          ),
        )
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
        onGenerateTitle: (context) => context.l10n.title,
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
            ),
            BlocProvider(
              create: (context) => MapBloc(
                locationsRepository: context.read<ILocationsRepository>(),
              )..add(const LoadLocationsEvent()),
            ),
            BlocProvider(
              create: (context) => LocationBloc(),
            )
          ],
          child: const MenuScreen(),
        ),
      ),
    );
  }
}
