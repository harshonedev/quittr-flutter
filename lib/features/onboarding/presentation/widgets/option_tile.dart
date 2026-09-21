import 'package:flutter/material.dart';

class OptionTile extends StatefulWidget {
  const OptionTile({super.key, required this.option, required this.onSelected});
  final String option;
  final VoidCallback onSelected;
  @override
  State<OptionTile> createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          _isPressed = true;
        });
      },
      onTap: () async {
        setState(() {
          _isPressed = true;
        });
        await Future.delayed(const Duration(milliseconds: 100));
        setState(() {
          _isPressed = false;
        });
      },
      onTapUp: (details) {
        setState(() {
          _isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ElevatedButton(
          onPressed: widget.onSelected,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(20),
            elevation: 2.5,
            alignment: Alignment.centerLeft,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
                ),
                child: AnimatedOpacity(
                  opacity: _isPressed ? 1 : 0,
                  duration: const Duration(milliseconds: 100),
                  child: Padding(
                    padding: EdgeInsets.all(2.5),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(widget.option),
            ],
          ),
        ),
      ),
    );
  }
}
