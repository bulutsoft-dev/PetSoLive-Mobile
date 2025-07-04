import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/help_request_cubit.dart';
import '../widgets/help_request_card.dart';
import 'package:easy_localization/easy_localization.dart';
import '../localization/locale_keys.g.dart';
import '../../injection_container.dart';

class HelpRequestsScreen extends StatefulWidget {
  const HelpRequestsScreen({Key? key}) : super(key: key);

  @override
  State<HelpRequestsScreen> createState() => _HelpRequestsScreenState();
}

class _HelpRequestsScreenState extends State<HelpRequestsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      'help_requests.tab_all',
      'help_requests.tab_low',
      'help_requests.tab_medium',
      'help_requests.tab_high',
    ];
    return BlocProvider(
      create: (_) => HelpRequestCubit(sl())..getAll(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: SafeArea(
            child: TabBar(
              controller: _tabController,
              tabs: tabs.map((e) => Tab(text: e.tr())).toList(),
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        body: BlocBuilder<HelpRequestCubit, HelpRequestState>(
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
                    Text(
                      'help_requests.error'.tr(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.error.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else if (state is HelpRequestLoaded) {
              if (state.helpRequests.isEmpty) {
                return Center(child: Text('help_requests.empty').tr());
              }
              final selectedTab = tabs[_tabController.index];
              final filtered = selectedTab == 'help_requests.tab_all'
                  ? state.helpRequests
                  : state.helpRequests.where((e) => e.emergencyLevel.toLowerCase() == selectedTab.replaceAll('help_requests.tab_', '').toLowerCase()).toList();
              return TabBarView(
                controller: _tabController,
                children: tabs.map((tab) {
                  final tabFiltered = tab == 'help_requests.tab_all'
                      ? state.helpRequests
                      : state.helpRequests.where((e) => e.emergencyLevel.toLowerCase() == tab.replaceAll('help_requests.tab_', '').toLowerCase()).toList();
                  if (tabFiltered.isEmpty) {
                    return Center(child: Text('help_requests.empty').tr());
                  }
                  return ListView.builder(
                    itemCount: tabFiltered.length,
                    itemBuilder: (context, i) {
                      final req = tabFiltered[i];
                      return HelpRequestCard(
                        request: req,
                        onTap: () {
                          Navigator.of(context).pushNamed('/help_request', arguments: req.id);
                        },
                      );
                    },
                  );
                }).toList(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
} 