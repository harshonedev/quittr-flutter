import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ChooseGoalsScreen extends StatefulWidget {
  final Map userInfo;

  const ChooseGoalsScreen({
    super.key,
    required this.userInfo,
  });

  @override
  State<ChooseGoalsScreen> createState() => _ChooseGoalsScreenState();
}

class _ChooseGoalsScreenState extends State<ChooseGoalsScreen> {
  final Set<String> _selectedGoals = {};

  final List<Map<String, String>> _goals = [
    {
      'title': 'Mental Clarity',
      'description': 'Improve focus and cognitive function',
      'icon': '🧠',
    },
    {
      'title': 'Better Relationships',
      'description': 'Build deeper connections with loved ones',
      'icon': '❤️',
    },
    {
      'title': 'Self-Control',
      'description': 'Gain mastery over urges and impulses',
      'icon': '💪',
    },
    {
      'title': 'Emotional Balance',
      'description': 'Achieve better emotional regulation',
      'icon': '🎭',
    },
    {
      'title': 'Productivity',
      'description': 'Increase work and study efficiency',
      'icon': '📈',
    },
    {
      'title': 'Self-Esteem',
      'description': 'Build confidence and self-worth',
      'icon': '⭐',
    },
    {
      'title': 'Energy Levels',
      'description': 'Boost daily energy and vitality',
      'icon': '⚡',
    },
    {
      'title': 'Sleep Quality',
      'description': 'Improve sleep patterns and rest',
      'icon': '😴',
    },
  ];

  void _toggleGoal(String goal) {
    setState(() {
      if (_selectedGoals.contains(goal)) {
        _selectedGoals.remove(goal);
      } else {
        _selectedGoals.add(goal);
      }
    });
  }

  void _onContinue() {
    final completeUserInfo = {
      ...widget.userInfo,
      'goals': _selectedGoals.toList(),
    };
    debugPrint('completeUserInfo: $completeUserInfo');
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose Your Goals',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontFamily: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ).fontFamily,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select the goals that matter most to you. This will help us personalize your journey.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                itemCount: _goals.length,
                itemBuilder: (context, index) {
                  final goal = _goals[index];
                  final isSelected = _selectedGoals.contains(goal['title']);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () => _toggleGoal(goal['title']!),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  goal['icon']!,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    goal['title']!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Text(
                                    goal['description']!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Checkbox(
                              value: isSelected,
                              onChanged: (_) => _toggleGoal(goal['title']!),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: FilledButton(
                onPressed: _selectedGoals.isNotEmpty ? _onContinue : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
