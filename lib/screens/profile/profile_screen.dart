import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:destify_mobile/providers/theme_provider.dart';
import 'package:destify_mobile/providers/language_provider.dart';
import 'package:destify_mobile/utils/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Settings Header
                  Text(
                    AppLocalizations.of(context).translate('settings'),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ).animate().fadeIn().slideX(),
                  const SizedBox(height: 24),

                  // Appearance Settings
                  _buildSettingsGroup(
                    context,
                    AppLocalizations.of(context).translate('appearance'),
                    [
                      _buildThemeToggle(context),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Language Settings
                  _buildSettingsGroup(
                    context,
                    AppLocalizations.of(context).translate('language'),
                    [
                      Consumer<LanguageProvider>(
                        builder: (context, languageProvider, child) {
                          return ListTile(
                            leading: const Icon(Icons.language),
                            title: Text(AppLocalizations.of(context).translate('appLanguage')),
                            subtitle: Text(languageProvider.getLanguageName()),
                            onTap: () => _showLanguageSelector(context),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // About App
                  _buildSettingsGroup(
                    context,
                    'About',
                    [
                      _buildSettingsTile(
                        context,
                        'Version',
                        '1.0.0',
                        Icons.info_outline,
                        onTap: () => _showVersionInfo(context),
                      ),
                      _buildSettingsTile(
                        context,
                        'Developer',
                        'Rasya Dika Pratama',
                        Icons.code,
                        onTap: () => _showDeveloperSocials(context),
                      ),
                      _buildSettingsTile(
                        context,
                        'School',
                        'SMK Telkom Purwokerto',
                        Icons.school,
                        onTap: () => _redirectToSchoolWebsite(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Profile Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 50, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context).translate('guestUser'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () => _showSettingsModal(context),
              ),
            ],
          ),

          // Profile Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Stats Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(context, '12', 'placesVisited'),
                      _buildStatItem(context, '5', 'savedDestinations'),
                      _buildStatItem(context, '3', 'upcomingTrips'),
                    ],
                  ).animate().fadeIn().slideY(),
                ),

                // Menu Items
                _buildMenuItem(
                  context,
                  Icons.favorite,
                  AppLocalizations.of(context).translate('savedPlaces'),
                  AppLocalizations.of(context).translate('favorites'),
                  color: Colors.red[400]!,
                ),
                _buildMenuItem(
                  context,
                  Icons.history,
                  AppLocalizations.of(context).translate('travelHistory'),
                  AppLocalizations.of(context).translate('placesYouVisited'),
                  color: Colors.blue[400]!,
                ),
                _buildMenuItem(
                  context,
                  Icons.wallet_travel,
                  AppLocalizations.of(context).translate('upcomingTripsTitle'),
                  AppLocalizations.of(context).translate('plannedAdventures'),
                  color: Colors.green[400]!,
                ),
                _buildMenuItem(
                  context,
                  Icons.help_outline,
                  AppLocalizations.of(context).translate('helpSupport'),
                  AppLocalizations.of(context).translate('getFaq'),
                  color: Colors.purple[400]!,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context).translate(label),
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    required Color color,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    ).animate().fadeIn().slideX();
  }

  Widget _buildSettingsGroup(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: children.map((child) => Material(
              color: Colors.transparent,
              child: child,
            )).toList(),
          ),
        ),
      ],
    ).animate().fadeIn().slideX();
  }

  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(AppLocalizations.of(context).translate(title.toLowerCase())),
      subtitle: Text(subtitle),
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return SwitchListTile(
          value: themeProvider.isDarkMode,
          onChanged: (value) => themeProvider.toggleTheme(),
          title: Text(AppLocalizations.of(context).translate('darkMode')),
          subtitle: Text(
            themeProvider.isDarkMode 
              ? AppLocalizations.of(context).translate('switchToLight')
              : AppLocalizations.of(context).translate('switchToDark'),
          ),
          secondary: Icon(
            themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }

  void _showLanguageSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () {
                  context.read<LanguageProvider>().setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Bahasa Indonesia'),
                onTap: () {
                  context.read<LanguageProvider>().setLocale(const Locale('id'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeveloperSocials(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('developerSocials')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366)),
              title: const Text('WhatsApp'),
              onTap: () => _launchUrl('https://wa.me/6282137068694'),
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.instagram, color: Color(0xFFE4405F)),
              title: const Text('Instagram'),
              onTap: () => _launchUrl('https://instagram.com/rasyadikapratama'),
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.linkedin, color: Color(0xFF0A66C2)),
              title: const Text('LinkedIn'),
              onTap: () => _launchUrl('https://linkedin.com/in/rasyadika'),
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.github, color: Colors.black),
              title: const Text('GitHub'),
              onTap: () => _launchUrl('https://github.com/rasyadpras'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).translate('close')),
          ),
        ],
      ),
    );
  }

  void _showVersionInfo(BuildContext context) {
    // Get SafeArea padding
    final safePadding = MediaQuery.of(context).padding.top;
    
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).translate('versionInfo'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.95),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 200, // Position from top
            top: safePadding + kToolbarHeight + 10, // Account for status bar and app bar
            left: 16,
            right: 16,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
          dismissDirection: DismissDirection.horizontal,
          action: SnackBarAction(
            label: AppLocalizations.of(context).translate('close'),
            textColor: Theme.of(context).colorScheme.onPrimary,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
  }

  Future<void> _redirectToSchoolWebsite(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context).translate('redirecting')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).translate('cancel')),
          ),
        ],
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) {
      Navigator.pop(context); // Close loading dialog
      _launchUrl('https://smktelkom-pwt.sch.id');
    }
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}