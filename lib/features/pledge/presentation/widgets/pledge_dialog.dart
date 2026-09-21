import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PledgeDialog extends StatelessWidget {
  const PledgeDialog({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onPledge,
  });
  final String title;
  final String subTitle;
  final VoidCallback onPledge;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
          child: Text(
        title,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      )),
      content: Text(
        textAlign: TextAlign.center,
        subTitle,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            context.pop(); // Close the dialog
          },
        ),
        TextButton(
          child: Text('Pledge'),
          onPressed: () {
            onPledge();
          },
        ),
      ],
    );
  }
}
