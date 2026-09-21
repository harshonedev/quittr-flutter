import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:quittr/features/motivaton/presentation/bloc/motivational_quotes_bloc.dart';

class MotivationScreen extends StatefulWidget {
  const MotivationScreen({super.key});

  @override
  State<MotivationScreen> createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  final sl = GetIt.instance;
  // late MotivationalQuotesBloc _quotesBloc;

  @override
  void initState() {
    // Create the bloc in initState and keep a reference to it
    // _quotesBloc = MotivationalQuotesBloc(sl());
    // // Add the event after bloc is created
    // _quotesBloc.add(MotivationalQuotesGetEvent());
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
      create: (context) =>
          MotivationalQuotesBloc(sl())..add(MotivationalQuotesGetEvent()),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text("Motivation"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            BlocBuilder<MotivationalQuotesBloc, MotivationalQuotesState>(
              builder: (context, state) {
                if (state is MotivationalQuotesLoading) {
                  return const CircularProgressIndicator();
                }
                if (state is MotivationalQuotesSuccess) {
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
                              state.motivationalQuotes[state.currentQuoteIndex]
                                  .text,
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }
                return Text("no qoutes");
              },
            ),
            Positioned(
              bottom: 30,
              right: 15,
              left: 15,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<MotivationalQuotesBloc,
                    MotivationalQuotesState>(
                  builder: (context, state) {
                    return FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        context
                            .read<MotivationalQuotesBloc>()
                            .add(MotivationalQuotesFadeOut());
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
