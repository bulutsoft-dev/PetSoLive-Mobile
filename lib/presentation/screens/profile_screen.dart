import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../blocs/account_cubit.dart';
import '../blocs/user_cubit.dart';
import '../blocs/theme_cubit.dart';
import '../../injection_container.dart';
import 'login_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AccountCubit>(create: (_) => sl<AccountCubit>()),
            BlocProvider<UserCubit>(create: (_) => sl<UserCubit>()),
          ],
          child: BlocBuilder<AccountCubit, AccountState>(
            builder: (context, accountState) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSectionTitle(context, 'profile.account_section'.tr()),
                  _buildAccountCard(context),
                  const SizedBox(height: 24),

                  _buildSectionTitle(context, 'profile.app_settings'.tr()),
                  _buildAppSettingsCard(context),
                  const SizedBox(height: 24),

                  _buildSectionTitle(context, 'profile.support_section'.tr()),
                  _buildSupportCard(context),
                  const SizedBox(height: 24),

                  _buildSectionTitle(context, 'profile.app_info'.tr()),
                  _buildAppInfoCard(context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        if (state is AccountSuccess) {
          final user = state.response.user;
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text(user.username),
              subtitle: Text(user.email ?? ''),
              trailing: OutlinedButton.icon(
                icon: Icon(Icons.logout),
                label: Text('profile.logout'.tr()),
                onPressed: () => context.read<AccountCubit>().emit(AccountInitial()),
              ),
            ),
          );
        } else {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(Icons.account_circle_rounded, size: 40),
              title: Text('profile.login_prompt'.tr()),
              trailing: OutlinedButton.icon(
                icon: Icon(Icons.login),
                label: Text('login_title').tr(),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildAppSettingsCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.dark_mode_rounded),
            title: Text('profile.dark_mode'.tr()),
            trailing: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                final isDark = state.themeMode == ThemeMode.dark;
                return Switch(
                  value: isDark,
                  onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                );
              },
            ),
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.language_rounded),
            title: Text('profile.language'.tr()),
            trailing: Text(context.locale.languageCode.toUpperCase()),
            onTap: () => _showLanguageSelector(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.email_outlined),
            title: Text('profile.contact_support'.tr()),
            onTap: () {
              // Mail gönder
            },
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.star_rounded),
            title: Text('profile.rate_app'.tr()),
            onTap: () {
              // Play Store'a yönlendir
            },
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.share_rounded),
            title: Text('profile.share_app'.tr()),
            onTap: () {
              // Uygulamayı paylaş
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.info_rounded),
            title: Text('profile.version'.tr()),
            subtitle: Text('v1.0.0'), // Dinamik olarak çekebilirsin
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.privacy_tip_rounded),
            title: Text('profile.privacy_policy'.tr()),
            onTap: () {
              // Gizlilik politikası göster
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('profile.select_language'.tr(), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            ...context.supportedLocales.map((locale) => ListTile(
              title: Text(locale.languageCode.toUpperCase()),
              onTap: () {
                context.setLocale(locale);
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
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