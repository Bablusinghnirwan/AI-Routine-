import 'package:flutter/material.dart';
import 'package:my_routine/core/theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_routine/features/tasks/views/home_screen.dart';
import 'package:my_routine/features/auth/auth_controller.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Hi, I\'m Challbot!',
      'desc':
          'Your cute AI coach for productivity. Let\'s crush your goals together!',
      'icon': Icons.smart_toy_rounded,
      'color': AppColors.pastelBlue,
    },
    {
      'title': 'Plan with AI',
      'desc': 'I can generate daily plans and advice just for you.',
      'icon': Icons.auto_awesome_rounded,
      'color': AppColors.pastelPink,
    },
    {
      'title': 'Track Progress',
      'desc': 'See your growth with beautiful charts and insights.',
      'icon': Icons.insights_rounded,
      'color': AppColors.pastelMint,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            // Background Doodles (Static for now, can be animated)
            Positioned(
              top: 100,
              left: -20,
              child: Icon(
                Icons.circle_outlined,
                size: 100,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
            Positioned(
              bottom: 150,
              right: -30,
              child: Icon(
                Icons.star_outline_rounded,
                size: 150,
                color: Colors.white.withOpacity(0.05),
              ),
            ),

            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      final page = _pages[index];
                      return Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Mascot / Icon
                            Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (page['color'] as Color).withOpacity(
                                  0.2,
                                ),
                                boxShadow: [AppTheme.glowShadow],
                              ),
                              child: Icon(
                                page['icon'],
                                size: 80,
                                color: page['color'],
                              ),
                            ),
                            const SizedBox(height: 40),

                            // Title
                            Text(
                              page['title'],
                              style: Theme.of(context).textTheme.displaySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),

                            // Description
                            Text(
                              page['desc'],
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 18,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppColors.glowAccent
                            : Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 32,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [AppTheme.glowShadow],
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_currentPage < _pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOutQuint,
                          );
                        } else {
                          // Save seen_onboarding and enable guest mode
                          final box = await Hive.openBox('settings');
                          await box.put('seen_onboarding', true);

                          // Set guest mode in AuthController
                          if (mounted) {
                            Provider.of<AuthController>(
                              context,
                              listen: false,
                            ).setGuestMode(true);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HomeScreen(),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1
                            ? "Get Started"
                            : "Next",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
