import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../blocs/account_cubit.dart';
import '../blocs/user_cubit.dart';
import '../blocs/theme_cubit.dart';
import '../../injection_container.dart';
import 'login_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'veterinarian_application_screen.dart';
import '../../data/providers/veterinarian_api_service.dart';
import '../../core/constants/admob_banner_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AccountCubit, AccountState>(
          builder: (context, accountState) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionTitle(context, 'profile.account_section'.tr()),
                _buildAccountCard(context, accountState),
                const SizedBox(height: 24),

                _buildSectionTitle(context, 'profile.app_settings'.tr()),
                _buildAppSettingsCard(context),
                const SizedBox(height: 24),

                _buildSectionTitle(context, 'profile.support_section'.tr()),
                _buildSupportCard(context),
                const SizedBox(height: 24),

                _buildSectionTitle(context, 'profile.veterinarian_section'.tr()),
                _buildVeterinarianCard(context),
                const SizedBox(height: 24),

                _buildSectionTitle(context, 'profile.developer_info'.tr()),
                _buildDeveloperInfoCard(context),
                const SizedBox(height: 24),

                _buildSectionTitle(context, 'profile.app_info'.tr()),
                _buildAppInfoCard(context),
                AdmobBannerWidget(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 2, top: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, AccountState state) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12),
        child: state is AccountSuccess
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: colorScheme.primary.withOpacity(0.10),
                        child: Icon(Icons.person, size: 28, color: colorScheme.primary),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(state.response.user.username, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary, fontSize: 17)),
                            const SizedBox(height: 2),
                            Text(state.response.user.email ?? '-', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface, fontSize: 13)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.logout, color: colorScheme.primary, size: 20),
                        tooltip: 'profile.logout'.tr(),
                        onPressed: () => context.read<AccountCubit>().logout(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                    ],
                  ),
                  if ((state.response.user.address ?? '').isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.home, size: 15, color: colorScheme.primary.withOpacity(0.7)),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            state.response.user.address!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7), fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 10),
                  _buildUserInfoGrid(state, colorScheme),
                ],
              )
            : Row(
                children: [
                  _iconWithBg(context, Icons.account_circle_rounded, colorScheme.primary, size: 28, radius: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('profile.login_prompt'.tr(), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text('profile.account_desc'.tr(), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7), fontSize: 12)),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    icon: Icon(Icons.login, color: colorScheme.primary, size: 16),
                    label: Text('login_title').tr(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      side: BorderSide(color: colorScheme.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      textStyle: const TextStyle(fontSize: 13),
                    ),
                    onPressed: () {
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
                ],
              ),
      ),
    );
  }

  Widget _buildUserInfoGrid(AccountSuccess state, ColorScheme colorScheme) {
    final user = state.response.user;
    final infoList = [
      _userInfoGridTile(Icons.phone, user.phoneNumber ?? '-', colorScheme),
      _userInfoGridTile(Icons.location_city, user.city ?? '-', colorScheme),
      _userInfoGridTile(Icons.map, user.district ?? '-', colorScheme),
      _userInfoGridTile(Icons.cake, user.dateOfBirth != null ? user.dateOfBirth!.toString().split(' ').first : '-', colorScheme),
      _userInfoGridTile(Icons.verified_user, (user.roles != null && user.roles!.isNotEmpty) ? user.roles!.first : '-', colorScheme),
      _userInfoGridTile(Icons.calendar_today, user.createdDate != null ? user.createdDate!.toString().split(' ').first : '-', colorScheme),
    ];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.2,
      padding: EdgeInsets.zero,
      children: infoList,
    );
  }

  Widget _userInfoGridTile(IconData icon, String value, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(7),
      ),
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: colorScheme.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettingsCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: _iconWithBg(context, Icons.dark_mode_rounded, colorScheme.primary),
              title: Text('profile.dark_mode'.tr(), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
              subtitle: Text('profile.dark_mode_desc'.tr(), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7))),
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
              contentPadding: EdgeInsets.zero,
              leading: _iconWithBg(context, Icons.language_rounded, colorScheme.primary),
              title: Text('profile.language'.tr(), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
              subtitle: Text('profile.language_desc'.tr(), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7))),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(context.locale.languageCode.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary)),
              ),
              onTap: () => _showLanguageSelector(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: _iconWithBg(context, Icons.email_outlined, colorScheme.primary),
              title: Text('profile.contact_support'.tr(), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
              subtitle: Text('profile.support_desc'.tr(), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7))),
              onTap: () async {
                final url = Uri.parse('mailto:petsolivesoft@gmail.com');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
              hoverColor: colorScheme.primary.withOpacity(0.06),
            ),
            Divider(height: 1),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: _iconWithBg(context, Icons.star_rounded, colorScheme.primary),
              title: Text('profile.rate_app'.tr(), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
              onTap: () async {
                final url = Uri.parse('https://play.google.com/store/apps/details?id=com.petsolive.petsolive');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              hoverColor: colorScheme.primary.withOpacity(0.06),
            ),
            Divider(height: 1),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: _iconWithBg(context, Icons.share_rounded, colorScheme.primary),
              title: Text('profile.share_app'.tr(), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
              onTap: () async {
                final url = Uri.parse('https://play.google.com/store/apps/details?id=com.petsolive.petsolive');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              hoverColor: colorScheme.primary.withOpacity(0.06),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVeterinarianCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // TODO: Kullanıcı veteriner mi kontrolü yapılacak, şimdilik hep başvuru gösteriliyor.
    return Card(
      elevation: 2,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _iconWithBg(context, Icons.medical_services, colorScheme.primary),
                const SizedBox(width: 10),
                Text('profile.veterinarian_title'.tr(), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary)),
              ],
            ),
            const SizedBox(height: 8),
            Text('profile.veterinarian_desc'.tr(), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7))),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_moderator),
              label: Text('profile.veterinarian_apply'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                final accountState = context.read<AccountCubit>().state;
                if (accountState is! AccountSuccess) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LoginScreen(),
                    ),
                  );
                  return;
                }
                final user = accountState.response.user;
                final vets = await VeterinarianApiService().getAll();
                final alreadyApplied = vets.any((v) => v.userId == user.id);
                if (alreadyApplied) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('profile.veterinarian_already_applied'.tr()), backgroundColor: Colors.orange),
                  );
                  return;
                }
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => VeterinarianApplicationScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeveloperInfoCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _iconWithBg(context, Icons.business_rounded, colorScheme.primary),
                const SizedBox(width: 10),
                Text('BulutSoft', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Text('profile.bulutsoft_desc'.tr(), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7))),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _iconWithBg(context, Icons.email_outlined, colorScheme.primary, size: 18, radius: 28),
                const SizedBox(width: 6),
                InkWell(
                  borderRadius: BorderRadius.circular(4),
                  splashColor: colorScheme.primary.withOpacity(0.1),
                  onTap: () async {
                    final url = Uri.parse('mailto:bulutsoftdev@gmail.com');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    child: Text('bulutsoftdev@gmail.com', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.primary, decoration: TextDecoration.underline)),
                  ),
                ),
              ],
            ),
            Divider(height: 18),
            Row(
              children: [
                _iconWithBg(context, Icons.person_rounded, colorScheme.primary),
                const SizedBox(width: 10),
                Text('Furkan Bulut', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Text('profile.furkan_desc'.tr(), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7))),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _iconWithBg(context, Icons.email_outlined, colorScheme.primary, size: 18, radius: 28),
                const SizedBox(width: 6),
                InkWell(
                  borderRadius: BorderRadius.circular(4),
                  splashColor: colorScheme.primary.withOpacity(0.1),
                  onTap: () async {
                    final url = Uri.parse('mailto:furkanblt@gmail.com');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    child: Text('furkanblt@gmail.com', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.primary, decoration: TextDecoration.underline)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfoCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.info_rounded, color: colorScheme.primary),
              title: Text('profile.version'.tr(), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
              subtitle: Text('v1.0.0'),
            ),
            Divider(height: 1),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.privacy_tip_rounded, color: colorScheme.primary),
              title: Text('profile.privacy_policy'.tr(), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
              subtitle: Text('profile.privacy_policy_desc'.tr(), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.7))),
              onTap: () {
                // Gizlilik politikası göster
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('profile.select_language'.tr(), style: Theme.of(context).textTheme.titleMedium?.copyWith(color: colorScheme.onSurface)),
            const SizedBox(height: 16),
            ...context.supportedLocales.map((locale) => ListTile(
              title: Text(locale.languageCode.toUpperCase(), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
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

  Widget _iconWithBg(BuildContext context, IconData icon, Color color, {double size = 24, double radius = 22}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade100,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: color, size: size),
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

class _VeterinarianRegisterDialog extends StatefulWidget {
  @override
  State<_VeterinarianRegisterDialog> createState() => _VeterinarianRegisterDialogState();
}

class _VeterinarianRegisterDialogState extends State<_VeterinarianRegisterDialog> {
  final _formKey = GlobalKey<FormState>();
  final _qualificationsController = TextEditingController();
  final _clinicAddressController = TextEditingController();
  final _clinicPhoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _qualificationsController.dispose();
    _clinicAddressController.dispose();
    _clinicPhoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // TODO: Kullanıcı bilgileri ve API çağrısı
    // Başarılıysa dialog kapat, snackbar göster
    await Future.delayed(const Duration(milliseconds: 800));
    if (context.mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('profile.veterinarian_apply_success'.tr()), backgroundColor: Colors.green),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.medical_services, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text('profile.veterinarian_apply_title'.tr(), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _qualificationsController,
                decoration: InputDecoration(labelText: 'profile.qualifications'.tr(), prefixIcon: Icon(Icons.school)),
                validator: (v) => v == null || v.isEmpty ? 'profile.qualifications_required'.tr() : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _clinicAddressController,
                decoration: InputDecoration(labelText: 'profile.clinic_address'.tr(), prefixIcon: Icon(Icons.location_on)),
                validator: (v) => v == null || v.isEmpty ? 'profile.clinic_address_required'.tr() : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _clinicPhoneController,
                decoration: InputDecoration(labelText: 'profile.clinic_phone'.tr(), prefixIcon: Icon(Icons.phone)),
                validator: (v) => v == null || v.isEmpty ? 'profile.clinic_phone_required'.tr() : null,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    child: Text('form.cancel'.tr()),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    ),
                    child: _isLoading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text('form.save'.tr()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 