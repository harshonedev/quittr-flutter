import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:quittr/features/side%20effects/presentaion/bloc/side_effects_bloc.dart';

class SideEffectsScreen extends StatefulWidget {
  const SideEffectsScreen({super.key});

  @override
  State<SideEffectsScreen> createState() => _SideEffectsScreenState();
}

class _SideEffectsScreenState extends State<SideEffectsScreen> {
  final sl = GetIt.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SideEffectsBloc(sl())..add(SideEffectsGetEvent()),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text("Side Effects"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            BlocBuilder<SideEffectsBloc, SideEffectsState>(
              builder: (context, state) {
                if (state is SideEffectsLoading) {
                  return const CircularProgressIndicator();
                }
                if (state is SideEffectsSuccess) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          "assets/images/motivation_background.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.18,
                        right: 0,
                        left: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: AnimatedOpacity(
                            duration: Duration(seconds: 1),
                            key: Key(state.currentQuoteIndex.toString()),
                            opacity: state.opacity,
                            child: Text(
                              textAlign: TextAlign.center,
                              state.sideEffects[state.currentQuoteIndex].text,
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }
                return Text("no side effects");
              },
            ),
            Positioned(
              bottom: 30,
              right: 15,
              left: 15,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<SideEffectsBloc, SideEffectsState>(
                  builder: (context, state) {
                    return FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        context
                            .read<SideEffectsBloc>()
                            .add(SideEffectsFadeOut());
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.recycling, size: 20, color: Colors.black),
                          SizedBox(width: 5),
                          Text("Regenerate"),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
