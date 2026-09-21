import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class TestimonialsScreen extends StatefulWidget {
  final Map userInfo;

  const TestimonialsScreen({
    super.key,
    required this.userInfo,
  });

  @override
  State<TestimonialsScreen> createState() => _TestimonialsScreenState();
}

class _TestimonialsScreenState extends State<TestimonialsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _testimonials = [
    {
      'name': 'David, 28',
      'duration': '1 year clean',
      'quote':
          'This app changed my life. The daily tracking and community support kept me accountable. Now I\'m helping others on their journey.',
      'image': 'assets/illustrations/testimonial_1.svg',
    },
    {
      'name': 'Sarah, 32',
      'duration': '8 months clean',
      'quote':
          'I tried quitting many times before, but the personalized approach and resources here made all the difference. I feel like myself again.',
      'image': 'assets/illustrations/testimonial_2.svg',
    },
    {
      'name': 'Michael, 25',
      'duration': '6 months clean',
      'quote':
          'The emergency tools and meditation exercises helped me overcome the strongest urges. I\'m proud of my progress every day.',
      'image': 'assets/illustrations/testimonial_3.svg',
    },
  ];

  void _onGetStarted() {
    context.go(
      '/onboarding/goals',
      extra: widget.userInfo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Success Stories',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontFamily:
                          GoogleFonts.poppins(fontWeight: FontWeight.w600)
                              .fontFamily,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                itemCount: _testimonials.length,
                itemBuilder: (context, index) {
                  final testimonial = _testimonials[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // TODO: Add SVG illustration here
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '"${testimonial['quote']!}"',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      height: 1.6,
                                      fontStyle: FontStyle.italic,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                testimonial['name']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                testimonial['duration']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _testimonials.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withAlpha(51),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => _onGetStarted(),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                    ),
                    child: const Text('Start Your Journey'),
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
