import 'package:flutter/material.dart';

class AppRatingDialog extends StatefulWidget {
  final Function(int) onRatingSelected;
  final VoidCallback onPlayStoreRatingRequested;

  const AppRatingDialog({
    super.key,
    required this.onRatingSelected,
    required this.onPlayStoreRatingRequested,
  });

  @override
  State<AppRatingDialog> createState() => _AppRatingDialogState();
}

class _AppRatingDialogState extends State<AppRatingDialog> {
  int _selectedRating = 0;

  final List<String> _ratingTexts = [
    "Not great",
    "Meh",
    "Good",
    "Great",
    "Amazing!"
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "How would you rate your experience so far?",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRating = index + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      _selectedRating >= index + 1
                          ? Icons.star
                          : Icons.star_border,
                      color: _selectedRating >= index + 1
                          ? Colors.amber
                          : Colors.grey,
                      size: 36,
                    ),
                  ),
                );
              }),
            ),
            if (_selectedRating > 0)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  _ratingTexts[_selectedRating - 1],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Maybe Later"),
                ),
                FilledButton(
                  onPressed: _selectedRating > 0
                      ? () {
                          Navigator.of(context).pop();
                          widget.onRatingSelected(_selectedRating);

                          if (_selectedRating == 5) {
                            widget.onPlayStoreRatingRequested();
                          }
                        }
                      : null,
                  child: const Text("Submit"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
