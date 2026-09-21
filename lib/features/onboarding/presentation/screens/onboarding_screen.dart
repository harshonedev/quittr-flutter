import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  final Map userInfo;

  const OnboardingScreen({
    super.key,
    required this.userInfo,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map> _onboardingData = [
    {
      "title": "Porn is a drug",
      "description":
          "Using porn releases a chemical in the brain called dopamine. This chemical makes you feel good- it's why you feel pleasure when you watch porn.",
      "backgroundColor": Color(0xffd9042a),
    },
    {
      "title": "Porn destroys relationships",
      "description":
          "Porn reduces your hunger for a real relationship and replaces it with the hunger for more porn.",
      "backgroundColor": Color(0xffd9042a),
    },
    {
      "title": "Porn shatters sex drive",
      "description":
          "More than 50% of porn addicts have reported a decrease in libido, loss of interest in real sex, and an overall decrease in their sex drive.",
      "backgroundColor": Color(0xffd9042a),
    },
    {
      "title": "Feeling unhappy?",
      "description":
          "An elevated dopamine level means you need more dopamine to feel good. This is why so many heavy porn users report feeling depresed, unmotivated, and anti-social.",
      "backgroundColor": Color(0xffd9042a),
    },
    {
      "title": "Path to Recovery",
      "description":
          "Recovery is possible. By abstaining from porn, your brain can reset its dopamine sensitivity, leading to healthier relationships and improved well-being.",
      "backgroundColor": Color(0xffd9042a),
    },
  ];

  void _onNextPressed() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(
        '/onboarding/testimonials',
        extra: widget.userInfo,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _onboardingData[_currentPage]['backgroundColor'],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Image.asset(
                          'assets/images/onboarding/onboarding_${index + 1}.png',
                          width: MediaQuery.sizeOf(context).width * 0.65,
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.025,
                        ),
                        Text(
                          data['title']!,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontFamily: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ).fontFamily,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          data['description']!,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                          textAlign: TextAlign.center,
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
                      _onboardingData.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Colors.white
                              : Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _onNextPressed,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentPage == _onboardingData.length - 1
                              ? 'Get Started'
                              : 'Next',
                        ),
                        if (_currentPage != _onboardingData.length - 1)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                            ),
                          )
                      ],
                    ),
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
