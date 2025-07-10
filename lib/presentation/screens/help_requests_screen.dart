import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../blocs/help_request_cubit.dart';
import '../blocs/account_cubit.dart';
import '../widgets/help_request_card.dart';
import '../../injection_container.dart';
import '../../core/network/auth_service.dart';
import 'add_help_request_screen.dart';

class HelpRequestsScreen extends StatefulWidget {
  const HelpRequestsScreen({Key? key}) : super(key: key);

  @override
  State<HelpRequestsScreen> createState() => _HelpRequestsScreenState();
}

class _HelpRequestsScreenState extends State<HelpRequestsScreen> {
  final List<String> baseTabs = [
    'help_requests.tab_all',
    'help_requests.tab_low',
    'help_requests.tab_medium',
    'help_requests.tab_high',
  ];

  bool _showFab = false;
  Map<String, dynamic>? _user;
  List<dynamic> _helpRequests = [];

  List<String> getTabs(bool showMyAds) {
    if (showMyAds) {
      return [...baseTabs, 'help_requests.tab_my_ads']; // En sağda
    }
    return baseTabs;
  }

  @override
  void initState() {
    super.initState();
    _checkUserLoggedIn();
    Future.microtask(() => context.read<HelpRequestCubit>().getAll());
  }

  Future<void> _checkUserLoggedIn() async {
    final authService = AuthService();
    final user = await authService.getUser();
    setState(() {
      _user = user;
      _showFab = user != null && user['id'] != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: BlocBuilder<HelpRequestCubit, HelpRequestState>(
        builder: (context, state) {
          List<dynamic> helpRequests = [];
          if (state is HelpRequestLoaded) {
            helpRequests = state.helpRequests;
            _helpRequests = helpRequests;
          }
          final userId = _user != null ? _user!['id'] : null;
          final hasMyAds = userId != null && helpRequests.any((e) => e.userId == userId);
          final tabs = getTabs(hasMyAds);

          return DefaultTabController(
            key: ValueKey(tabs.length),
            length: tabs.length,
            child: Column(
              children: [
                TabBar(
                  tabs: tabs.map((e) => Tab(text: e.tr())).toList(),
                  labelColor: colorScheme.primary,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: colorScheme.primary,
                ),
                Expanded(
                  child: TabBarView(
                    children: tabs.map((selectedTab) {
                      List<dynamic> filtered;
                      if (selectedTab == 'help_requests.tab_my_ads') {
                        filtered = helpRequests.where((e) => e.userId == userId).toList();
                      } else if (selectedTab == 'help_requests.tab_all') {
                        filtered = helpRequests;
                      } else {
                        final level = selectedTab.replaceAll('help_requests.tab_', '').toLowerCase();
                        filtered = helpRequests.where((e) => e.emergencyLevel.toString().split('.').last == level).toList();
                      }
                      if (state is HelpRequestLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is HelpRequestError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, color: Colors.red, size: 48),
                              const SizedBox(height: 12),
                              Text('help_requests.error'.tr(), style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.red)),
                              const SizedBox(height: 8),
                              Text(state.error.toString(), style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                            ],
                          ),
                        );
                      }
                      if (filtered.isEmpty) {
                        return Center(child: Text('help_requests.empty').tr());
                      }
                      return ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final req = filtered[i];
                          return HelpRequestCard(
                            request: req,
                            onTap: () {
                              Navigator.of(context).pushNamed('/help_request', arguments: req.id);
                            },
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: _showFab
          ? FloatingActionButton(
              heroTag: 'help_requests_fab',
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: context.read<HelpRequestCubit>()),
                        BlocProvider.value(value: context.read<AccountCubit>()),
                      ],
                      child: AddHelpRequestScreen(),
                    ),
                  ),
                );
                if (context.mounted) {
                  await context.read<HelpRequestCubit>().getAll();
                  setState(() {});
                }
              },
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              child: const Icon(Icons.add, size: 28),
              tooltip: 'help_requests.add'.tr(),
            )
          : null,
    );
  }
} 