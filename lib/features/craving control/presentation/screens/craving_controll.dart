import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quittr/features/craving%20control/presentation/bloc/craving_controll_bloc.dart';

class CravingControll extends StatefulWidget {
  const CravingControll({super.key});

  @override
  State<CravingControll> createState() => _CravingControllState();
}

class _CravingControllState extends State<CravingControll> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CravingControllBloc()..add(StartBreathing()),
      child: BlocBuilder<CravingControllBloc, CravingControllState>(
        builder: (context, state) {
          if (state is CravingControllSuccess) {
            return Scaffold(
              backgroundColor: Colors.teal[200],
              body: SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      top: 120,
                      left: 0,
                      right: 0,
                      child: Text(
                        state.breathingText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: state.currentCircleSize,
                        height: state.currentCircleSize,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black26,
                          //     blurRadius: 15,
                          //     spreadRadius: 5,
                          //   ),
                          // ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: TextButton(
                          onPressed: () => context.pop(),
                          child: const Text('Close'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
