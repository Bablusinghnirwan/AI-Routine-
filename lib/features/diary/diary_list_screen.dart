import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_routine/core/theme.dart';
import 'package:my_routine/core/clay_widgets.dart';
import 'package:my_routine/features/diary/diary_controller.dart';
import 'package:my_routine/features/diary/diary_detail_screen.dart';

class DiaryListScreen extends StatelessWidget {
  const DiaryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.gray700),
        title: Text(
          'My Diary',
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.gray700,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Entries 📔',
                  style: Theme.of(
                    context,
                  ).textTheme.displaySmall?.copyWith(color: AppColors.gray700),
                ),
                ClayButton(
                  icon: Icons.edit_rounded,
                  label: "Write",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DiaryDetailScreen(),
                      ),
                    );
                  },
                  isActive: true,
                  activeColor: AppColors.green100,
                  iconColor: AppColors.green700,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // List
            Expanded(
              child: Consumer<DiaryController>(
                builder: (context, controller, child) {
                  final entries = controller.getEntries();

                  if (entries.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.book_rounded,
                            size: 48,
                            color: AppColors.gray300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No entries yet.\nStart writing today!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              color: AppColors.gray400,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      final isToday = DateUtils.isSameDay(
                        entry.date,
                        DateTime.now(),
                      );

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ClayCard(
                          color: isToday ? Colors.white : AppColors.yellow50,
                          padding: const EdgeInsets.all(20),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DiaryDetailScreen(entry: entry),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isToday
                                          ? AppColors.gray100
                                          : AppColors.yellow200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      isToday
                                          ? 'Today, ${DateFormat('h:mm a').format(entry.date)}'
                                          : DateFormat(
                                              'MMM d, yyyy',
                                            ).format(entry.date),
                                      style: GoogleFonts.nunito(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: isToday
                                            ? AppColors.gray400
                                            : AppColors.yellow700,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.favorite,
                                    size: 16,
                                    color: AppColors.pink400,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                entry.rawText
                                    .split('\n')
                                    .first, // Title/First line
                                style: GoogleFonts.nunito(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.gray800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                entry.rawText,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.nunito(
                                  fontSize: 14,
                                  color: AppColors.gray500,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
