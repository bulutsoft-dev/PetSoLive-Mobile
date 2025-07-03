import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../blocs/account_cubit.dart';
import '../blocs/user_cubit.dart';
import '../../injection_container.dart';
import 'login_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final locale = context.locale;
    final supportedLocales = context.supportedLocales;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AccountCubit>(create: (_) => sl<AccountCubit>()),
            BlocProvider<UserCubit>(create: (_) => sl<UserCubit>()),
          ],
          child: BlocBuilder<AccountCubit, AccountState>(
            builder: (context, accountState) {
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                children: [
                  // User Info or Login Prompt
                  accountState is AccountSuccess
                      ? _UserInfoSection(user: accountState.response.user)
                      : _LoginPromptSection(),
                  const SizedBox(height: 28),
                  Divider(thickness: 1, color: colorScheme.surfaceVariant.withOpacity(0.18)),
                  const SizedBox(height: 28),
                  _AboutAppSection(),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _UserInfoSection extends StatelessWidget {
  final dynamic user;
  const _UserInfoSection({required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: colorScheme.primary.withOpacity(0.13),
          child: Icon(Icons.person, size: 36, color: colorScheme.primary),
        ),
        const SizedBox(height: 12),
        Text(user.name ?? '', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 4),
        Text(user.email ?? '', style: theme.textTheme.bodyMedium, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
        if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone, size: 18, color: colorScheme.primary),
              const SizedBox(width: 6),
              Text(user.phoneNumber!, style: theme.textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ],
        if (user.address != null && user.address!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: 18, color: colorScheme.primary),
              const SizedBox(width: 6),
              Expanded(child: Text(user.address!, style: theme.textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center)),
            ],
          ),
        ],
        const SizedBox(height: 12),
        OutlinedButton.icon(
          icon: const Icon(Icons.logout),
          label: Text('profile_logout').tr(),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(120, 40),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            context.read<AccountCubit>().emit(AccountInitial());
          },
        ),
      ],
    );
  }
}

class _LoginPromptSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.account_circle_rounded, size: 64, color: colorScheme.primary),
        const SizedBox(height: 12),
        Text('profile_login_prompt', style: theme.textTheme.titleLarge, textAlign: TextAlign.center).tr(),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          icon: const Icon(Icons.login),
          label: Text('login_title').tr(),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(160, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
          },
        ),
      ],
    );
  }
}

class _AboutAppSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // PetSoLive block
        Center(
          child: Image.asset(
            'assets/images/logo.png',
            height: 56,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 12),
        Text('app_name', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary), textAlign: TextAlign.center).tr(),
        const SizedBox(height: 8),
        Text('about_app_description', style: theme.textTheme.bodyMedium, textAlign: TextAlign.center).tr(),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.email_outlined, color: colorScheme.primary, size: 18),
            const SizedBox(width: 6),
            _LinkText(
              text: 'support_email',
              onTap: () async {
                final url = Uri.parse('mailto:petsolivesoft@gmail.com');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.language, color: colorScheme.primary, size: 18),
            const SizedBox(width: 6),
            _LinkText(
              text: 'official_website',
              onTap: () async {
                final url = Uri.parse('https://www.petsolive.com.tr/');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.star_rate_rounded),
          label: Text('rate_us').tr(),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () async {
            final url = Uri.parse('https://play.google.com/store/apps/details?id=com.petsolive.petsolive');
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            }
          },
        ),
        const SizedBox(height: 24),
        Divider(thickness: 1, color: colorScheme.surfaceVariant.withOpacity(0.18)),
        const SizedBox(height: 24),
        // BulutSoft block
        Center(
          child: Image.asset(
            'assets/images/bulutsoft_logo.png',
            height: 48,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 10),
        Text('developer_name', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary), textAlign: TextAlign.center).tr(),
        const SizedBox(height: 8),
        Text('bulutsoft_description', style: theme.textTheme.bodyMedium, textAlign: TextAlign.center).tr(),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.email_outlined, color: colorScheme.primary, size: 18),
            const SizedBox(width: 6),
            InkWell(
              onTap: () async {
                final url = Uri.parse('mailto:bulutsoftdev@gmail.com');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
              borderRadius: BorderRadius.circular(4),
              splashColor: colorScheme.primary.withOpacity(0.1),
              highlightColor: colorScheme.primary.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: Text(
                  'bulutsoftdev@gmail.com',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.language, color: colorScheme.primary, size: 18),
            const SizedBox(width: 6),
            InkWell(
              onTap: () async {
                final url = Uri.parse('https://www.bulutsoft.com.tr/');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              borderRadius: BorderRadius.circular(4),
              splashColor: colorScheme.primary.withOpacity(0.1),
              highlightColor: colorScheme.primary.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: Text(
                  'www.bulutsoft.com.tr',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.apps),
          label: Text('more_from_bulutsoft').tr(),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () async {
            final url = Uri.parse('https://play.google.com/store/apps/dev?id=4877931304410735668');
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            }
          },
        ),
        const SizedBox(height: 10),
        Text('all_rights_reserved', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.6)), textAlign: TextAlign.center).tr(),
      ],
    );
  }
}

class _LinkText extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _LinkText({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      splashColor: colorScheme.primary.withOpacity(0.1),
      highlightColor: colorScheme.primary.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Text(
          text.tr(),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.primary,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
} 