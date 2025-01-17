import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:io';

class ScanResultScreen extends StatelessWidget {
  final File? imageFile;
  final String? imagePath;

  const ScanResultScreen({
    super.key,
    this.imageFile,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full screen image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageFile != null 
                    ? FileImage(imageFile!) as ImageProvider
                    : AssetImage('assets/images/destinations/destination0.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Scanning Animation Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),

          // Scanning Line Animation
          Positioned.fill(
            child: Center(
              child: Container(
                height: 2,
                color: Theme.of(context).colorScheme.primary,
              ).animate(
                onPlay: (controller) => controller.repeat(),
              ).moveY(
                begin: -100,
                end: 100,
                duration: 1.5.seconds,
                curve: Curves.easeInOut,
              ).fadeIn(duration: 500.ms),
            ),
          ),

          // Back Button
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Analysis Results
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Loading Indicator
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 16),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Location Details
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pantai Bali',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ).animate().fadeIn().slideX(),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Bali, Indonesia',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ).animate(delay: 200.ms).fadeIn().slideX(),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '4.8',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ).animate(delay: 400.ms).fadeIn().scale(),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Tags
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildTag(context, 'Beach'),
                            _buildTag(context, 'Sunset Views'),
                            _buildTag(context, 'Water Sports'),
                            _buildTag(context, 'Popular'),
                          ],
                        ).animate(delay: 600.ms).fadeIn(),

                        const SizedBox(height: 16),
                        
                        // Description
                        Text(
                          'A beautiful beach destination known for its crystal clear waters, '
                          'golden sands, and stunning sunset views. Popular for surfing, '
                          'swimming, and various water sports activities.',
                          style: TextStyle(
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ).animate(delay: 800.ms).fadeIn(),

                        const SizedBox(height: 24),
                        
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                icon: const Icon(Icons.explore),
                                label: const Text('Explore More'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ).animate(delay: 1000.ms).fadeIn().slideY(),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }
}
