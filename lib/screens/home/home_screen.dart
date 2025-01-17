import 'package:flutter/material.dart';
import 'package:destify_mobile/widgets/custom_bottom_nav.dart';
import 'package:destify_mobile/screens/explore/explore_screen.dart';
import 'package:destify_mobile/screens/ai_chat/ai_chat_screen.dart';
import 'package:destify_mobile/screens/profile/profile_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:destify_mobile/screens/scan/scan_result_screen.dart';
import 'dart:io';  // Add this import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const ExploreScreen(),
    const AIChatScreen(),
    const ProfileScreen(),
  ];

  final ImagePicker _picker = ImagePicker();

  Future<void> _handleImagePick(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        // Close modal
        Navigator.pop(context);
        
        // Show scanning result screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScanResultScreen(
              imageFile: File(image.path),
            ),
          ),
        );
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Added to prevent resize
      extendBody: true, // Added to extend body behind bottom nav
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButton: MediaQuery.of(context).viewInsets.bottom > 0
          ? null // Hide FAB when keyboard is visible
          : FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Container(
                    height: 170, // Reduced from 200
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16), // Adjusted padding
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 12), // Reduced from 16
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Text(
                          'AI Image Scanner',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16), // Reduced from 20
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildScanOption(
                                context,
                                Icons.camera_alt,
                                'Camera',
                                () => _handleImagePick(ImageSource.camera),
                              ),
                              _buildScanOption(
                                context,
                                Icons.photo_library,
                                'Gallery',
                                () => _handleImagePick(ImageSource.gallery),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.document_scanner,
                  color: Colors.white,
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: MediaQuery.of(context).viewInsets.bottom > 0
          ? null // Hide bottom nav when keyboard is visible
          : CustomBottomNav(
              activeIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
            ),
    );
  }

  Widget _buildScanOption(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 72, // Reduced from 80
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12), // Reduced from 16
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 28, // Reduced from 32
              ),
            ),
            const SizedBox(height: 4), // Reduced from 6
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 12, // Reduced from 13
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // Enhanced Modern App Bar
          SliverAppBar(
            floating: true,
            expandedHeight: 60,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: Stack(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        size: 28,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: const Text(
                            '2',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),

          // Enhanced Hero Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.15),
                    Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Jakarta, Indonesia',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ).animate()
                    .fadeIn(duration: const Duration(milliseconds: 600))
                    .slideX(),
                  const SizedBox(height: 16),
                  Text(
                    'Discover Your\nDream Destination',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          letterSpacing: -0.5,
                        ),
                  ).animate()
                    .fadeIn(duration: const Duration(milliseconds: 800))
                    .slideX(),
                  const SizedBox(height: 24),
                  
                  // Enhanced Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search destinations...',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w500,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        suffixIcon: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.tune,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ).animate()
                    .fadeIn(duration: const Duration(milliseconds: 1000))
                    .slideY(),
                ],
              ),
            ),
          ),

          // Featured Destinations
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Featured Destinations',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return DestinationCard(index: index)
                        .animate()
                        .fadeIn()
                        .slideX()
                        .scale();
                    },
                  ),
                ),
              ],
            ),
          ),

          // Modified AI Features Grid
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What would you like to do?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 100, // Fixed height container
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildFeatureButton(
                          context,
                          Icons.auto_awesome,
                          'AI\nTravel',
                          Theme.of(context).colorScheme.primary,
                        ),
                        _buildFeatureButton(
                          context,
                          Icons.camera_alt,
                          'Scan\nPlace',
                          Colors.blue,
                        ),
                        _buildFeatureButton(
                          context,
                          Icons.map,
                          'Smart\nRoute',
                          Colors.green,
                        ),
                        _buildFeatureButton(
                          context,
                          Icons.calendar_today,
                          'Plan\nTrip',
                          Colors.orange,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // New Promotions Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Special Offers',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 155,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 280,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                              ],
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: -20,
                                bottom: -20,
                                child: Icon(
                                  Icons.local_offer,
                                  size: 120,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'SAVE 25%',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Holiday Package',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Book now and save!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      height: 32,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Theme.of(context).colorScheme.primary,
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          minimumSize: const Size(0, 32),
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: const Text(
                                          'Book Now',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureButton(BuildContext context, IconData icon, String label, Color color) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    height: 1.1,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                ),
            ),
          ],
        ),
      ),
    );
  }
}

class DestinationCard extends StatelessWidget {
  final int index;

  const DestinationCard({super.key, required this.index});

  String _getDestinationName(int index) {
    final names = [
      'Pantai Bali',
      'Pantai Cilacap',
      'Candi Borobudur',
      'Pulau Bali',
      'Raja Ampat'
    ];
    return names[index];
  }

  String _getDestinationLocation(int index) {
    final locations = [
      'Bali, Indonesia',
      'Nusawungu, Indonesia',
      'Magelang, Indonesia',
      'Bali, Indonesia',
      'Papua Barat, Indonesia'
    ];
    return locations[index];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.asset(
              'assets/images/destinations/destination$index.jpg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getDestinationName(index),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getDestinationLocation(index),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
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
}

class FeatureCard extends StatelessWidget {
  final int index;
  final List<IconData> icons = [
    Icons.auto_awesome,
    Icons.camera_alt,
    Icons.map,
    Icons.calendar_today,
  ];
  final List<String> titles = [
    'AI Powered',
    'Image Scan',
    'Smart Routes',
    'Trip Planner',
  ];

  FeatureCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icons[index],
            size: 32,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            titles[index],
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
