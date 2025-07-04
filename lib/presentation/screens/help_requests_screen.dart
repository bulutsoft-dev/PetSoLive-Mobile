import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/help_request_cubit.dart';
import '../widgets/help_request_card.dart';
import 'package:easy_localization/easy_localization.dart';
import '../localization/locale_keys.g.dart';
import '../../injection_container.dart';

class HelpRequestsScreen extends StatelessWidget {
  const HelpRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HelpRequestCubit(sl())..getAll(),
      child: Scaffold(
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
              return ListView.builder(
                itemCount: state.helpRequests.length,
                itemBuilder: (context, i) {
                  final req = state.helpRequests[i];
                  return HelpRequestCard(
                    title: req.title,
                    description: req.description,
                    location: req.location,
                    status: req.status,
                    onTap: () {
                      // Detay ekranına yönlendirme eklenebilir
                    },
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
} 