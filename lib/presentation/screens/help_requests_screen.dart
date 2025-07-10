import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../blocs/help_request_cubit.dart';
import '../blocs/account_cubit.dart';
import '../widgets/help_request_card.dart';
import '../../injection_container.dart';
import '../../core/network/auth_service.dart';

class HelpRequestsScreen extends StatefulWidget {
  const HelpRequestsScreen({Key? key}) : super(key: key);

  @override
  State<HelpRequestsScreen> createState() => _HelpRequestsScreenState();
}

class _HelpRequestsScreenState extends State<HelpRequestsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> tabs = [
    'help_requests.tab_all',
    'help_requests.tab_low',
    'help_requests.tab_medium',
    'help_requests.tab_high',
  ];

  bool _showFab = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _checkUserLoggedIn();
  }

  Future<void> _checkUserLoggedIn() async {
    final authService = AuthService();
    final user = await authService.getUser();
    setState(() {
      _showFab = user != null && user['id'] != null;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<HelpRequestCubit>()..getAll()),
        BlocProvider(create: (_) => sl<AccountCubit>()),
      ],
      child: Scaffold(
        // AppBar kaldırıldı
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: tabs.map((e) => Tab(text: e.tr())).toList(),
              labelColor: colorScheme.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: colorScheme.primary,
              onTap: (_) => setState(() {}), // Tab değişince rebuild
            ),
            Expanded(
              child: BlocBuilder<HelpRequestCubit, HelpRequestState>(
                builder: (context, state) {
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
                  } else if (state is HelpRequestLoaded) {
                    final selectedTab = tabs[_tabController.index];
                    final filtered = selectedTab == 'help_requests.tab_all'
                        ? state.helpRequests
                        : state.helpRequests.where((e) => e.emergencyLevel.toLowerCase() == selectedTab.replaceAll('help_requests.tab_', '').toLowerCase()).toList();
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
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
        floatingActionButton: _showFab
            ? FloatingActionButton(
                heroTag: 'help_requests_fab',
                onPressed: () {
                  Navigator.of(context).pushNamed('/add_help_request');
                },
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                child: const Icon(Icons.add, size: 28),
                tooltip: 'help_requests.add'.tr(),
              )
            : null,
      ),
    );
  }
} 