import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../partials/base_app_bar.dart';
import '../partials/base_nav_bar.dart';
import '../partials/base_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    _HomeTab(),
    _ExploreTab(),
    _ProfileTab(),
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
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),
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

class _HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets, size: 64, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text('home.welcome',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ).tr(),
          const SizedBox(height: 8),
          Text('home.description',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ).tr(),
        ],
      ),
    );
  }
}

class _ExploreTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('explore.coming_soon', style: Theme.of(context).textTheme.titleLarge).tr(),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('profile.coming_soon', style: Theme.of(context).textTheme.titleLarge).tr(),
    );
  }
}
