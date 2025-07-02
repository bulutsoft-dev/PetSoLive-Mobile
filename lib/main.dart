import 'package:flutter/material.dart';
import 'presentation/themes/app_theme.dart';
import 'presentation/partials/base_app_bar.dart';
import 'presentation/partials/base_nav_bar.dart';
import 'presentation/partials/base_drawer.dart';

void main() {
  runApp(const PetSoLiveApp());
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
    Center(child: Text('Ana Sayfa')), // Buraya gerçek sayfalar eklenecek
    Center(child: Text('Keşfet')),
    Center(child: Text('Profil')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: 'PetSoLive'),
      drawer: BaseDrawer(
        header: DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
          child: const Text('Menü', style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Ana Sayfa'),
            onTap: () => setState(() => _currentIndex = 0),
          ),
          ListTile(
            leading: const Icon(Icons.explore),
            title: const Text('Keşfet'),
            onTap: () => setState(() => _currentIndex = 1),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () => setState(() => _currentIndex = 2),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BaseNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Keşfet'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
