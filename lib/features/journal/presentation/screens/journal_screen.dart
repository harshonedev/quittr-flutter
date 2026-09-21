import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quittr/features/achievements/presentation/bloc/achievements_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/journal_bloc.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch journal entries when the screen initializes
    context.read<JournalBloc>().add(FetchJournalEntriesEvent());
  }

  void _showAddEntryBottomSheet() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

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
                    onPressed: () => context.pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (titleController.text.isNotEmpty) {
                        // Add journal entry using the bloc
                        context.read<JournalBloc>().add(
                              AddJournalEntryEvent(
                                title: titleController.text,
                                description: descriptionController.text,
                              ),
                            );

                        // Check if this is the first journal entry by examining the state
                        final journalState = context.read<JournalBloc>().state;
                        if (journalState is JournalLoadedState &&
                            journalState.entries.isEmpty) {
                          // This is the first entry, trigger achievement
                          context.read<AchievementsBloc>().add(
                              UnlockAchievementEvent(
                                  UnlockAchievementEvent.firstJournal));
                        }
                        context.pop();
                      }
                    },
                    child: const Text('Save'),
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
                        'Notes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 4,
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
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddEntryBottomSheet,
        label: Text("New Entry"),
        icon: Icon(CupertinoIcons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text(
          'Journal',
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showAddEntryBottomSheet();
            },
            icon: const Icon(CupertinoIcons.add),
          ),
        ],
      ),
      body: BlocListener<AchievementsBloc, AchievementsState>(
        listener: (context, state) {
          if (state is AchievementUnlocked) {
            // Show a snackbar or any other UI element to indicate the achievement
            debugPrint("Achievement unlocked: ${state.achievement.title}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    "New Achievement Unlocked: +${state.achievement.pointsAwarded} points"),
                action: SnackBarAction(
                  label: 'See',
                  onPressed: () {
                    // Handle the action when the user taps the button
                    context.push('/achievements');
                  },
                ),
              ),
            );
          }

          if (state is AchievementsError) {
            // Handle failure state if needed
            debugPrint("Error unlocking achievement: ${state.message}");
          }
        },
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<JournalBloc, JournalState>(
                builder: (context, state) {
                  if (state is JournalLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is JournalErrorState) {
                    return Center(child: Text('Error: ${state.message}'));
                  }

                  if (state is JournalLoadedState) {
                    final entries = state.entries;

                    if (entries.isEmpty) {
                      return const Center(
                        child:
                            Text('No journal entries yet. Add your first one!'),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        return GestureDetector(
                          onTap: () {
                            context.push(
                              '/journal-detail',
                              extra: entry,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 0, right: 0, top: 0, bottom: 0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withAlpha(40),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 6),
                              title: Text(
                                entry.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(entry.description),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('MMM d, y \'at\' h:mm a')
                                        .format(entry.createdAt),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
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

                  // Initial state
                  return const Center(
                      child: Text('Start your journal journey!'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
