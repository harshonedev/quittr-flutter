import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:quittr/core/constants/string_constants.dart';
import 'package:quittr/features/achievements/presentation/bloc/achievements_bloc.dart';
import 'package:quittr/features/pledge/presentation/bloc/notification_bloc.dart';
import 'package:quittr/features/pledge/presentation/widgets/pledge_dialog.dart';
import 'package:quittr/features/pledge/presentation/widgets/pledge_success_widget.dart';
import 'package:quittr/features/pledge/presentation/widgets/pledge_bottom_sheet_container_widget.dart';
import 'package:go_router/go_router.dart';

class PledgeScreen extends StatefulWidget {
  const PledgeScreen({super.key});

  @override
  State<PledgeScreen> createState() => _PledgeScreenState();
}

class _PledgeScreenState extends State<PledgeScreen> {
  final sl = GetIt.instance;
  @override
  void dispose() {
    NotificationBloc(sl(), sl()).close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Fixed Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: const Icon(
                    Icons.close,
                    size: 25,
                  ),
                ),
                const Text(
                  'Pledge',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Container(
                  height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(),
                  ),
                  child: const Icon(
                    Icons.question_mark_rounded,
                    size: 15,
                  ),
                )
              ],
            ),
          ),

          // Scrollable Content
          BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              if (state is RelapseTrackerLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is RelapseTrackerPledgeConfirmed) {
                return Expanded(
                  child: Center(
                    child: Stack(alignment: Alignment.center, children: [
                      Lottie.asset(
                          "assets/animations/pledge_complete_animation.json",
                          repeat: false),
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PledgeSuccessWidget(),
                      )),
                    ]),
                  ),
                );
              }

              return Expanded(
                child: SingleChildScrollView(
                  // controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        SvgPicture.asset(
                          'assets/images/icons/pledge_hand_outlined.svg',
                          height: 200,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              Constants.pledgeBottomSheetHeading,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              Constants.pledgeBottomSheetSubHeading,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: PledgeBottomSheetContainerWidget(
                            height: 300,
                            width: double.infinity,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Fixed Footer
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                if (state is RelapseTrackerPledgeConfirmed) {
                  return GestureDetector(
                    onTap: () {
                      log("Triggering scheduled notification...");
                      context
                          .read<NotificationBloc>()
                          .dataSource
                          .scheduleNotification(
                              title: "Congratulations",
                              body:
                                  "You've successfully pledged to stay sober.",
                              delay: Duration(seconds: 10),
                              payload: "pledge_success");

                      // Trigger the first pledge achievement
                      try {
                        context.read<AchievementsBloc>().add(
                            UnlockAchievementEvent(
                                UnlockAchievementEvent.firstPledge));
                      } catch (e) {
                        log("Error unlocking pledge achievement: $e");
                      }

                      context.pop();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          "Finish",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return PledgeDialog(
                          title: Constants.pledgeDialougeBoxHeading,
                          subTitle: Constants.pledgeDialougeBoxSubHeading,
                          onPledge: () {
                            context.pop();
                            context
                                .read<NotificationBloc>()
                                .add(RelapseTrackerPledgeConfirmEvent());
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        "Pledge Now",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
