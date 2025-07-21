import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../themes/app_theme.dart';
import '../localization/localization_manager.dart';
import '../blocs/theme_cubit.dart';
import '../../routes/app_router.dart';
import 'main_scaffold.dart';

class PetSoLiveApp extends StatelessWidget {
  const PetSoLiveApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'PetSoLive',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.themeMode,
          home: const MainScaffold(),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          onGenerateRoute: AppRouter.generateRoute,
          navigatorObservers: [routeObserver],
        );
      },
    );
  }
} 