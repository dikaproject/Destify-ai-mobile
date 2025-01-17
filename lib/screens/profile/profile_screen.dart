import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
                    'Settings',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ).animate().fadeIn().slideX(),
                  const SizedBox(height: 24),

                  // Language Settings
                  _buildSettingsGroup(
                    context,
                    'Language',
                    [
                      _buildSettingsTile(
                        context,
                        'App Language',
                        'English',
                        Icons.language,
                        onTap: () {},
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
                      ),
                      _buildSettingsTile(
                        context,
                        'Developer',
                        'Rasya Dika Pratama',
                        Icons.code,
                        onTap: () {},
                      ),
                      _buildSettingsTile(
                        context,
                        'School',
                        'SMK Telkom Purwokerto',
                        Icons.school,
                        onTap: () {},
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
                      'Guest User',
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
                      _buildStatItem(context, '12', 'Places\nVisited'),
                      _buildStatItem(context, '5', 'Saved\nDestinations'),
                      _buildStatItem(context, '3', 'Upcoming\nTrips'),
                    ],
                  ).animate().fadeIn().slideY(),
                ),

                // Menu Items
                _buildMenuItem(
                  context,
                  Icons.favorite,
                  'Saved Places',
                  'Your favorite destinations',
                  color: Colors.red[400]!,
                ),
                _buildMenuItem(
                  context,
                  Icons.history,
                  'Travel History',
                  'Places you have visited',
                  color: Colors.blue[400]!,
                ),
                _buildMenuItem(
                  context,
                  Icons.wallet_travel,
                  'Upcoming Trips',
                  'Your planned adventures',
                  color: Colors.green[400]!,
                ),
                _buildMenuItem(
                  context,
                  Icons.help_outline,
                  'Help & Support',
                  'Get assistance and FAQs',
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
            label,
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: children,
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
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }
}