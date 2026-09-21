import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/reason_model.dart';

class ReasonDetailScreen extends StatelessWidget {
  final ReasonModel reason;

  const ReasonDetailScreen({super.key, required this.reason});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          'Reason',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          reason.reason,
          style: const TextStyle(
            fontSize: 24,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
