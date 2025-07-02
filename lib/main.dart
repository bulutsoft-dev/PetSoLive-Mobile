import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'presentation/themes/app_theme.dart';
import 'presentation/partials/base_app_bar.dart';
import 'presentation/partials/base_nav_bar.dart';
import 'presentation/partials/base_drawer.dart';
import 'presentation/localization/localization_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: LocalizationManager.supportedLocales,
      path: LocalizationManager.path,
      fallbackLocale: LocalizationManager.fallbackLocale,
      child: const PetSoLiveApp(),
    ),
  );
}

class PetSoLiveApp extends StatelessWidget {
  const PetSoLiveApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetSoLive',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text('home.title').tr()),
    Center(child: Text('explore.title').tr()),
    Center(child: Text('profile.title').tr()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: 'appbar.title'.tr()),
      drawer: BaseDrawer(
        header: DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Text('drawer.header'.tr(), style: const TextStyle(color: Colors.white, fontSize: 20)),
        ),
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: Text('home.title').tr(),
            onTap: () => setState(() => _currentIndex = 0),
          ),
          ListTile(
            leading: const Icon(Icons.explore),
            title: Text('explore.title').tr(),
            onTap: () => setState(() => _currentIndex = 1),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text('profile.title').tr(),
            onTap: () => setState(() => _currentIndex = 2),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BaseNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: tr('home.title')),
          BottomNavigationBarItem(icon: const Icon(Icons.explore), label: tr('explore.title')),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: tr('profile.title')),
        ],
      ),
    );
  }
}
