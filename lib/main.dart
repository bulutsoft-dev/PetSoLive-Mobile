import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/themes/app_theme.dart';
import 'presentation/partials/base_app_bar.dart';
import 'presentation/partials/base_nav_bar.dart';
import 'presentation/partials/base_drawer.dart';
import 'presentation/localization/localization_manager.dart';
import 'presentation/blocs/theme_cubit.dart';
import 'presentation/screens/lost_pets_screen.dart';
import 'presentation/screens/help_requests_screen.dart';
import 'presentation/screens/profile_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/pets_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'injection_container.dart';
import 'routes/app_router.dart';
import 'presentation/blocs/account_cubit.dart';
import 'presentation/screens/pet_detail_screen.dart';
import 'presentation/blocs/lost_pet_ad_cubit.dart';
import 'presentation/blocs/help_request_cubit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/models/pet_dto.dart';
import 'data/models/lost_pet_ad_dto.dart';
import 'data/models/help_request_dto.dart';
import 'core/enums/emergency_level.dart';
import 'core/enums/help_request_status.dart';
import 'presentation/themes/colors.dart';
import 'presentation/app/pet_so_live_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PetDtoAdapter());
  Hive.registerAdapter(LostPetAdDtoAdapter());
  Hive.registerAdapter(HelpRequestDtoAdapter());
  Hive.registerAdapter(EmergencyLevelAdapter());
  Hive.registerAdapter(HelpRequestStatusAdapter());
  await MobileAds.instance.initialize();
  init();
  runApp(
    EasyLocalization(
      supportedLocales: LocalizationManager.supportedLocales,
      path: LocalizationManager.path,
      fallbackLocale: LocalizationManager.fallbackLocale,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (_) => sl<AccountCubit>()),
          BlocProvider(create: (_) => LostPetAdCubit(sl())..getAll()),
          BlocProvider(create: (_) => sl<HelpRequestCubit>()),
        ],
        child: const PetSoLiveApp(),
      ),
    ),
  );
}
