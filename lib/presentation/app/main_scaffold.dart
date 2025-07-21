import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../partials/base_app_bar.dart';
import '../partials/base_drawer.dart';
import '../themes/colors.dart';
import '../blocs/theme_cubit.dart';
import '../blocs/account_cubit.dart';
import '../screens/lost_pets_screen.dart';
import '../screens/help_requests_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/pets_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../injection_container.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({Key? key}) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountCubit>().checkSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, accountState) {
        String profileLabel = 'profile.title'.tr();
        if (accountState is AccountSuccess) {
          profileLabel = accountState.response.user.username;
        }
        final List<Widget> pages = [
          const PetsScreen(),
          const LostPetsScreen(),
          HomeScreen(onTabChange: (int index) {
            setState(() {
              _currentIndex = index;
            });
          }),
          const HelpRequestsScreen(),
          const ProfileScreen(),
        ];
        return Scaffold(
          appBar: BaseAppBar(
            title: _getAppBarTitle(_currentIndex),
            actions: [
              IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                tooltip: 'theme.switch'.tr(),
                onPressed: () => themeCubit.toggleTheme(),
              ),
              IconButton(
                icon: const Icon(Icons.translate),
                tooltip: 'drawer.change_language'.tr(),
                onPressed: () {
                  final currentLocale = context.locale;
                  final newLocale = currentLocale.languageCode == 'tr' ? const Locale('en') : const Locale('tr');
                  context.setLocale(newLocale);
                },
              ),
            ],
          ),
          drawer: BaseDrawer(
            header: DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text('drawer.header'.tr(), style: const TextStyle(color: Colors.white, fontSize: 20)),
            ),
            children: [
              ListTile(
                leading: const Icon(Icons.pets),
                title: Text('animals.title').tr(),
                selected: _currentIndex == 0,
                onTap: () => _onDrawerTap(0),
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: Text('lost_pets.title').tr(),
                selected: _currentIndex == 1,
                onTap: () => _onDrawerTap(1),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: Text('home.title').tr(),
                selected: _currentIndex == 2,
                onTap: () => _onDrawerTap(2),
              ),
              ListTile(
                leading: const Icon(Icons.volunteer_activism),
                title: Text('help_requests.title').tr(),
                selected: _currentIndex == 3,
                onTap: () => _onDrawerTap(3),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(profileLabel),
                selected: _currentIndex == 4,
                onTap: () => _onDrawerTap(4),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text('drawer.website').tr(),
                onTap: () async {
                  final url = Uri.parse('https://www.petsolive.com.tr/');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.translate),
                title: Text('drawer.change_language').tr(),
                onTap: () {
                  final currentLocale = context.locale;
                  final newLocale = currentLocale.languageCode == 'tr' ? const Locale('en') : const Locale('tr');
                  context.setLocale(newLocale);
                },
              ),
              ListTile(
                leading: const Icon(Icons.login),
                title: Text('login.title').tr(),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => sl<AccountCubit>(),
                        child: const LoginScreen(),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                title: Text('theme.switch').tr(),
                onTap: () => themeCubit.toggleTheme(),
              ),
            ],
          ),
          body: pages[_currentIndex],
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            height: _currentIndex == 2 ? 54 : 48,
            width: _currentIndex == 2 ? 54 : 48,
            child: FloatingActionButton(
              onPressed: () => setState(() => _currentIndex = 2),
              backgroundColor: _currentIndex == 2 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: AnimatedScale(
                scale: _currentIndex == 2 ? 1.08 : 1.0,
                duration: const Duration(milliseconds: 180),
                child: Icon(Icons.home, size: 26, color: Colors.white),
              ),
              tooltip: 'home.title'.tr(),
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 58,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavBarItem(Icons.pets, 'pets.title', 0),
                    _buildNavBarItem(Icons.search, 'lost_pets.title', 1),
                    const SizedBox(width: 44),
                    _buildNavBarItem(Icons.volunteer_activism, 'help_requests.title', 3),
                    _buildNavBarItem(Icons.person, profileLabel, 4),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavBarItem(IconData icon, String labelKey, int index) {
    final isSelected = _currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark
        ? (isSelected ? AppColors.darkOnPrimary : AppColors.darkOnSurface.withOpacity(0.7))
        : (isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withOpacity(0.6));
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.09) : Colors.transparent,
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.08 : 1.0,
                duration: const Duration(milliseconds: 180),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 1),
              Text(
                labelKey.tr(),
                style: TextStyle(
                  color: color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'animals.title'.tr();
      case 1:
        return 'lost_pets.title'.tr();
      case 2:
        return 'home.title'.tr();
      case 3:
        return 'help_requests.title'.tr();
      case 4:
        return 'profile.title'.tr();
      default:
        return 'appbar.title'.tr();
    }
  }

  void _onDrawerTap(int index) {
    setState(() => _currentIndex = index);
    Navigator.of(context).pop();
  }
} 