import 'package:destify_mobile/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:destify_mobile/utils/app_localizations.dart'; // Add this import

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  bool isLastPage = false;

  List<OnboardingPage> _getPages(BuildContext context) {
    return [
      OnboardingPage(
        title: AppLocalizations.of(context).translate('onboarding-page1-title'),
        description: AppLocalizations.of(context).translate('onboarding-page1-description'),
        imagePath: 'assets/images/onboarding/explore.jpg',
        backgroundColor: const Color(0xFFE3F2FD),
        iconColor: const Color(0xFF2196F3),
      ),
      OnboardingPage(
        title: AppLocalizations.of(context).translate('onboarding-page2-title'),
        description: AppLocalizations.of(context).translate('onboarding-page2-description'),
        imagePath: 'assets/images/onboarding/ai.png',
        backgroundColor: const Color(0xFFE8EAF6),
        iconColor: const Color(0xFF3F51B5),
      ),
      OnboardingPage(
        title: AppLocalizations.of(context).translate('onboarding-page3-title'),
        description: AppLocalizations.of(context).translate('onboarding-page3-description'),
        imagePath: 'assets/images/onboarding/plan.jpeg',
        backgroundColor: const Color(0xFFE1F5FE),
        iconColor: const Color(0xFF03A9F4),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final pages = _getPages(context);
    
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: controller,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() => isLastPage = index == pages.length - 1);
            },
            itemBuilder: (context, index) {
              final page = pages[index];
              return Container(
                color: isDarkMode 
                    ? Theme.of(context).colorScheme.surface 
                    : page.backgroundColor,
                child: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDarkMode 
                                ? Theme.of(context).colorScheme.surface
                                : null,
                          ),
                          child: Image.asset(
                            page.imagePath,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ).animate(delay: 300.ms)
                            .fadeIn()
                            .scale(),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDarkMode 
                              ? Theme.of(context).colorScheme.surface
                              : Colors.white,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                          boxShadow: isDarkMode ? [] : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              page.title,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode 
                                    ? Theme.of(context).colorScheme.onSurface
                                    : Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ).animate(delay: 500.ms)
                              .fadeIn()
                              .slideY(begin: 0.2),
                            const SizedBox(height: 16),
                            Text(
                              page.description,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: isDarkMode 
                                    ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                                    : Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ).animate(delay: 700.ms)
                              .fadeIn()
                              .slideY(begin: 0.2),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () => controller.jumpToPage(pages.length - 1),
                                  child: Text(
                                    AppLocalizations.of(context).translate('onboarding-skip'),
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SmoothPageIndicator(
                                  controller: controller,
                                  count: pages.length,
                                  effect: ExpandingDotsEffect(
                                    dotColor: isDarkMode 
                                        ? Colors.grey[700]!
                                        : Colors.grey[300]!,
                                    activeDotColor: Theme.of(context).colorScheme.primary,
                                    dotHeight: 8,
                                    dotWidth: 8,
                                    expansionFactor: 4,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (isLastPage) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                                      );
                                    } else {
                                      controller.nextPage(
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                  child: Text(
                                    isLastPage 
                                        ? AppLocalizations.of(context).translate('onboarding-start')
                                        : AppLocalizations.of(context).translate('onboarding-next'),
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
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
            },
          ),
        ],
      ),
    );
  }

}

class OnboardingPage {
  final String title;
  final String description;
  final String imagePath;
  final Color backgroundColor;
  final Color iconColor;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.backgroundColor,
    required this.iconColor,
  });
}