import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../blocs/account_cubit.dart';
import '../blocs/user_cubit.dart';
import '../../injection_container.dart';
import 'login_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final locale = context.locale;
    final supportedLocales = context.supportedLocales;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.18),
            colorScheme.secondary.withOpacity(0.13),
            colorScheme.surface.withOpacity(0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AccountCubit>(create: (_) => sl<AccountCubit>()),
          BlocProvider<UserCubit>(create: (_) => sl<UserCubit>()),
        ],
        child: BlocBuilder<AccountCubit, AccountState>(
          builder: (context, accountState) {
            final infoCard = _InfoCard(theme: theme, colorScheme: colorScheme);
            final localizationCard = _LocalizationCard(
              theme: theme,
              colorScheme: colorScheme,
              locale: locale,
              supportedLocales: supportedLocales,
              isDark: isDark,
            );
            if (accountState is AccountLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (accountState is! AccountSuccess) {
              // Not logged in
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                children: [
                  AnimatedScale(
                    scale: 1,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutBack,
                    child: _GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.account_circle_rounded, size: 72, color: colorScheme.primary),
                            const SizedBox(height: 18),
                            Text('profile.login_prompt', style: theme.textTheme.titleLarge, textAlign: TextAlign.center).tr(),
                            const SizedBox(height: 18),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.login),
                              label: Text('login.title').tr(),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(160, 48),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                elevation: 2,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  infoCard,
                  const SizedBox(height: 18),
                  localizationCard,
                ],
              );
            }
            final user = accountState.response.user;
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              children: [
                AnimatedScale(
                  scale: 1,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutBack,
                  child: _GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 38,
                                backgroundColor: colorScheme.primary.withOpacity(0.13),
                                child: Icon(Icons.person, size: 48, color: colorScheme.primary),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user.name, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(user.email, style: theme.textTheme.bodyMedium),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty)
                            Row(
                              children: [
                                Icon(Icons.phone, size: 20, color: colorScheme.primary),
                                const SizedBox(width: 8),
                                Text(user.phoneNumber!, style: theme.textTheme.bodyMedium),
                              ],
                            ),
                          if (user.address != null && user.address!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on, size: 20, color: colorScheme.primary),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(user.address!, style: theme.textTheme.bodyMedium)),
                                ],
                              ),
                            ),
                          if (user.createdAt != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today, size: 18, color: colorScheme.primary),
                                  const SizedBox(width: 8),
                                  Text(DateFormat.yMMMMd(context.locale.languageCode).format(user.createdAt!), style: theme.textTheme.bodySmall),
                                ],
                              ),
                            ),
                          const SizedBox(height: 22),
                          Divider(height: 32, thickness: 1.2, color: colorScheme.surfaceVariant.withOpacity(0.5)),
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.logout),
                              label: Text('profile.logout').tr(),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(120, 40),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                foregroundColor: colorScheme.primary,
                                side: BorderSide(color: colorScheme.primary.withOpacity(0.5)),
                              ),
                              onPressed: () {
                                context.read<AccountCubit>().emit(AccountInitial());
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                infoCard,
                const SizedBox(height: 18),
                localizationCard,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.10) : Colors.white.withOpacity(0.45),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.07),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme colorScheme;
  const _InfoCard({required this.theme, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1,
      duration: const Duration(milliseconds: 500),
      child: _GlassCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 48,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text('PetSoLive', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Icon(Icons.info_outline, color: colorScheme.primary, size: 22),
                  const SizedBox(width: 8),
                  Text('profile.app_info', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)).tr(),
                ],
              ),
              const SizedBox(height: 8),
              Text('PetSoLive v1.0.0', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 18),
              Row(
                children: [
                  Icon(Icons.developer_mode, color: colorScheme.primary, size: 22),
                  const SizedBox(width: 8),
                  Text('profile.developer_info', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)).tr(),
                ],
              ),
              const SizedBox(height: 8),
              Text('BulutSoft', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              _InfoButton(
                icon: Icons.email_outlined,
                label: 'petsolivesoft@gmail.com',
                onTap: () async {
                  final url = Uri.parse('mailto:petsolivesoft@gmail.com');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                color: colorScheme.primary,
              ),
              const SizedBox(height: 8),
              _InfoButton(
                icon: Icons.language,
                label: 'www.petsolive.com.tr',
                onTap: () async {
                  final url = Uri.parse('https://www.petsolive.com.tr/');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                color: colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Text('Muradiye, Manisa, Turkey', style: theme.textTheme.bodyMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocalizationCard extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme colorScheme;
  final Locale locale;
  final List<Locale> supportedLocales;
  final bool isDark;
  const _LocalizationCard({required this.theme, required this.colorScheme, required this.locale, required this.supportedLocales, required this.isDark});

  @override
  Widget build(BuildContext context) {
    String langName(Locale l) {
      switch (l.languageCode) {
        case 'tr':
          return 'Türkçe';
        case 'en':
          return 'English';
        default:
          return l.languageCode;
      }
    }
    return _GlassCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.language_rounded, color: colorScheme.primary, size: 22),
                const SizedBox(width: 8),
                Text('profile.language', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)).tr(),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.flag_circle, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text('${langName(locale)} (${locale.languageCode.toUpperCase()})', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      final newLocale = locale.languageCode == 'tr' ? const Locale('en') : const Locale('tr');
                      context.setLocale(newLocale);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Row(
                        children: [
                          Icon(Icons.swap_horiz_rounded, color: colorScheme.primary, size: 20),
                          const SizedBox(width: 4),
                          Text('profile.change_language', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.primary)).tr(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Divider(height: 24, thickness: 1, color: colorScheme.surfaceVariant.withOpacity(0.3)),
            Text('profile.supported_languages', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)).tr(),
            const SizedBox(height: 6),
            Wrap(
              spacing: 10,
              children: supportedLocales.map((l) => Chip(
                label: Text(langName(l)),
                backgroundColor: colorScheme.primary.withOpacity(locale == l ? 0.18 : 0.08),
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: locale == l ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                side: BorderSide(color: colorScheme.primary.withOpacity(0.18)),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  const _InfoButton({required this.icon, required this.label, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color, decoration: TextDecoration.underline)),
            ],
          ),
        ),
      ),
    );
  }
} 