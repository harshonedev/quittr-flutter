import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quittr/features/achievements/presentation/bloc/achievements_bloc.dart';
import '../bloc/reason_bloc.dart'; 

class ReasonListScreen extends StatefulWidget {
  const ReasonListScreen({super.key});

  @override
  State<ReasonListScreen> createState() => _ReasonListScreenState();
}

class _ReasonListScreenState extends State<ReasonListScreen> {
  final TextEditingController _reasonController = TextEditingController();

  void _showAddReasonBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      _reasonController.clear();
                      context.pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_reasonController.text.isNotEmpty) {
                        context.read<ReasonBloc>().add(
                              AddReasonEvent(
                                  reasonText: _reasonController.text),
                            );
                        _reasonController.clear();
                        context.pop();
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'New Reason',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _reasonController,
                        decoration: const InputDecoration(
                          labelText: 'Enter your reason',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<ReasonBloc>().add(FetchReasonsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddReasonBottomSheet,
        label: const Text("New Reason"),
        icon: const Icon(CupertinoIcons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text(
          'Reasons for Change',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddReasonBottomSheet,
          ),
        ],
      ),
      body: BlocListener<AchievementsBloc, AchievementsState>(
        listener: (context, state) {
          if (state is AchievementUnlocked) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    "New Achievement Unlocked: +${state.achievement.pointsAwarded} points"),
                action: SnackBarAction(
                  label: 'See',
                  onPressed: () {
                    context.push('/achievements');
                  },
                ),
              ),
            );
          }
          if (state is AchievementsError) {
            debugPrint("Error unlocking achievement: ${state.message}");
          }
        },
        child: BlocBuilder<ReasonBloc, ReasonState>(
          builder: (context, state) {
            if (state is ReasonLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ReasonLoadedState) {
              final reasons = state.reasons;
              if (reasons.isEmpty) {
                return const Center(child: Text('No reasons added yet'));
              }
              return ListView.builder(
                itemCount: reasons.length,
                itemBuilder: (context, index) {
                  final reason = reasons[index];
                  return GestureDetector(
                    onTap: () {
                      context.push(
                        '/reason-detail',
                        extra: reason,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 16, right: 0, top: 0, bottom: 0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withAlpha(50),
                            width: 1,
                          ),
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 0),
                        title: Text(
                          reason.reason,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            if (state is ReasonErrorState) {
              return Center(child: Text(state.message));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}
