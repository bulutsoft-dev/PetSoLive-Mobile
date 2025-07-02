import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class HelpRequestsScreen extends StatelessWidget {
  const HelpRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('help_requests.title', style: Theme.of(context).textTheme.titleLarge).tr(),
    );
  }
} 