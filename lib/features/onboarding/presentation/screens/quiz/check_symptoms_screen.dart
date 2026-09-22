import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quittr/core/widgets/responsive_scroll_body.dart';

class CheckSymptomsScreen extends StatefulWidget {
  final Map userInfo;

  const CheckSymptomsScreen({
    super.key,
    required this.userInfo,
  });

  @override
  State<CheckSymptomsScreen> createState() => _CheckSymptomsScreenState();
}

class _CheckSymptomsScreenState extends State<CheckSymptomsScreen> {
  final Set<String> _selectedSymptoms = {};

  final List<Map<String, dynamic>> _symptoms = [
    {
      'title': 'Anxiety',
      'description': 'Feeling nervous, restless or tense',
    },
    {
      'title': 'Depression',
      'description': 'Feeling sad or having a depressed mood',
    },
    {
      'title': 'Sleep Issues',
      'description': 'Trouble falling or staying asleep',
    },
    {
      'title': 'Low Energy',
      'description': 'Feeling tired and having little energy',
    },
    {
      'title': 'Brain Fog',
      'description': 'Difficulty thinking or concentrating',
    },
    {
      'title': 'Mood Swings',
      'description': 'Rapid changes in mood',
    },
    {
      'title': 'Social Withdrawal',
      'description': 'Avoiding social situations',
    },
    {
      'title': 'Urges',
      'description': 'Strong desires or cravings',
    },
  ];

  void _toggleSymptom(String symptom) {
    setState(() {
      if (_selectedSymptoms.contains(symptom)) {
        _selectedSymptoms.remove(symptom);
      } else {
        _selectedSymptoms.add(symptom);
      }
    });
  }

  void _onContinue() {
    final completeUserInfo = {
      ...widget.userInfo,
      'symptoms': _selectedSymptoms.toList(),
    };

    context.go('/onboarding', extra: completeUserInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Check Symptoms',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily:
                    GoogleFonts.poppins(fontWeight: FontWeight.w600).fontFamily,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Select any symptoms you\'ve experienced:',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  itemCount: _symptoms.length,
                  itemBuilder: (context, index) {
                    final symptom = _symptoms[index];
                    final isSelected =
                        _selectedSymptoms.contains(symptom['title']);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => _toggleSymptom(symptom['title']),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      symptom['title'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      symptom['description'],
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
                                onChanged: (_) =>
                                    _toggleSymptom(symptom['title']),
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
                  onPressed: _selectedSymptoms.isNotEmpty ? _onContinue : null,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
