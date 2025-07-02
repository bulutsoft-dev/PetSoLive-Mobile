import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('profile.title', style: Theme.of(context).textTheme.titleLarge).tr(),
    );
  }
} 