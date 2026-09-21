import 'package:flutter/material.dart';
import 'package:quittr/core/constants/string_constants.dart';

class PledgeSuccessWidget extends StatelessWidget {
  const PledgeSuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 20),
            ),
            child: const Icon(
              Icons.check,
              size: 100,
            ),
          ),
          const Text(
            "Pledge Successful",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            textAlign: TextAlign.center,
            "${Constants.pledgeDialougeBoxSubHeading} Remember why you started , good luck!",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
