import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/responsive_utils.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_button.dart';
import '../widgets/dot_indicator.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: ref.read(onboardingCurrentPageIndexProvider));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(onboardingItemsProvider);
    final currentIndex = ref.watch(onboardingCurrentPageIndexProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF101B34),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF22163C), Color(0xFF101B34)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: SizedBox(
                    height: constraints.maxHeight < 650 ? 650 : constraints.maxHeight,
                    child: Column(
                      children: [
                        // Skip button
                        if (currentIndex != items.length - 1)
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: TextButton(
                                onPressed: () {
                                  context.go('/login');
                                },
                                child: Text('Skip', style: TextStyle(color: Colors.white70, fontSize: context.responsive.sp(14))),
                              ),
                            ),
                          )
                        else
                           SizedBox(height: context.responsive.sp(48)),
                        
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) {
                               ref.read(onboardingCurrentPageIndexProvider.notifier).state = index;
                            },
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(24)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: context.responsive.sp(140),
                                      width: context.responsive.sp(140),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFF8B3CFF), Color(0xFF2196F3)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(context.responsive.sp(32)),
                                      ),
                                      child: Icon(
                                         _getIcon(item.icon),
                                         size: context.responsive.sp(72),
                                         color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: context.responsive.sp(48)),
                                    Text(
                                      item.title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: context.responsive.sp(26),
                                        fontWeight: FontWeight.bold,
                                        height: 1.3,
                                      ),
                                    ),
                                    SizedBox(height: context.responsive.sp(16)),
                                    Text(
                                      item.subtitle,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: context.responsive.sp(15),
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        // Bottom Section
                        Padding(
                          padding: EdgeInsets.all(context.responsive.wp(24)),
                          child: Column(
                            children: [
                              DotIndicator(currentIndex: currentIndex, count: items.length),
                              SizedBox(height: context.responsive.sp(32)),
                              
                              if (currentIndex == 0)
                                SizedBox(
                                  width: double.infinity,
                                  child: OnboardingButton(
                                    text: 'Next',
                                    icon: Icons.chevron_right,
                                    onPressed: () {
                                      _pageController.nextPage(
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                  ),
                                )
                              else 
                                Row(
                                  children: [
                                     Expanded(
                                        flex: 1,
                                        child: OnboardingButton(
                                          text: 'Back',
                                          isPrimary: false,
                                          icon: Icons.chevron_left,
                                          onPressed: () {
                                            _pageController.previousPage(
                                              duration: const Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );
                                          },
                                        ),
                                     ),
                                     SizedBox(width: context.responsive.wp(16)),
                                     Expanded(
                                        flex: 1,
                                        child: OnboardingButton(
                                          text: currentIndex == items.length - 1 ? 'Get Started' : 'Next',
                                          isPrimary: true,
                                          icon: currentIndex == items.length - 1 ? null : Icons.chevron_right,
                                          onPressed: () {
                                             if (currentIndex == items.length - 1) {
                                                context.go('/login');
                                             } else {
                                                _pageController.nextPage(
                                                  duration: const Duration(milliseconds: 300),
                                                  curve: Curves.easeInOut,
                                                );
                                             }
                                          },
                                        ),
                                     ),
                                  ],
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String iconStr) {
    if (iconStr == 'Icons.menu_book_rounded') return Icons.menu_book_rounded;
    if (iconStr == 'Icons.track_changes_rounded') return Icons.track_changes_rounded;
    if (iconStr == 'Icons.groups_rounded') return Icons.groups_rounded;
    return Icons.image;
  }
}
