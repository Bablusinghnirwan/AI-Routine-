import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:my_routine/core/theme.dart';
import 'package:my_routine/services/gemini_service.dart';
import 'package:my_routine/features/tasks/controllers/task_controller.dart';
import 'package:my_routine/features/diary/diary_controller.dart';
import 'package:my_routine/features/notes/note_controller.dart';

class AIScreen extends StatefulWidget {
  const AIScreen({super.key});

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> {
  final TextEditingController _controller = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  final List<Map<String, String>> _messages = [
    {
      'role': 'ai',
      'text':
          'Hello! I noticed you have a busy schedule today. Want some tips on time management? 🤖',
    },
  ];
  bool _isLoading = false;

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final userMessage = _controller.text;
    setState(() {
      _messages.add({'role': 'user', 'text': userMessage});
      _isLoading = true;
      _controller.clear();
    });

    try {
      // Gather Context
      final taskController = Provider.of<TaskController>(
        context,
        listen: false,
      );
      final diaryController = Provider.of<DiaryController>(
        context,
        listen: false,
      );
      final noteController = Provider.of<NoteController>(
        context,
        listen: false,
      );

      final today = DateTime.now();
      final tasks = taskController.tasks
          .where(
            (t) =>
                t.dateTime.year == today.year &&
                t.dateTime.month == today.month &&
                t.dateTime.day == today.day,
          )
          .map(
            (t) =>
                "- ${t.title} at ${DateFormat('h:mm a').format(t.dateTime)} (${t.isCompleted ? 'Done' : 'Pending'})",
          )
          .join('\n');

      final notes = noteController
          .getNotesForDate(today)
          .map((n) => "- ${n.content}")
          .join('\n');

      final recentDiary = diaryController
          .getEntries()
          .take(3)
          .map(
            (e) =>
                "Entry on ${DateFormat('MMM d').format(e.date)}: ${e.rawText} (Mood: ${e.mood})",
          )
          .join('\n');

      final contextString =
          """
Current Date: ${DateFormat('EEEE, MMM d, yyyy').format(today)}
Time: ${DateFormat('h:mm a').format(today)}

Today's Tasks:
$tasks

Today's Sticky Notes:
$notes

Recent Diary Entries:
$recentDiary

SYSTEM INSTRUCTIONS:
You are a helpful AI Coach. You can manage tasks and notes.
- To add a task, return JSON: {"action": "add_task", "parameters": {"title": "Task Name", "time": "HH:mm"}}
- To create a note, return JSON: {"action": "create_note", "parameters": {"content": "Note content"}}
- To generate a theme (e.g. "dark space", "sunset"), return JSON: 
  {
    "action": "generate_theme", 
    "parameters": {
      "bgColor": "#HexCode", 
      "cardColor": "#HexCode", 
      "primaryColor": "#HexCode", 
      "textColor": "#HexCode"
    }
  }
""";

      final response = await _geminiService.chat(
        userMessage,
        context: contextString,
      );

      // Parse Response for Actions
      String displayText = response;
      try {
        // Simple regex to find JSON blocks.
        // Note: This assumes the AI puts the JSON in a block like ```json ... ``` or just {...}
        // For robustness, we might need a better parser, but let's try to extract JSON objects.
        final jsonRegex = RegExp(r'\{.*\}', dotAll: true);
        final match = jsonRegex.firstMatch(response);

        if (match != null) {
          final jsonStr = match.group(0)!;
          final action = jsonDecode(jsonStr);

          if (action is Map<String, dynamic> && action.containsKey('action')) {
            // Execute Action
            await _executeAction(action, taskController, noteController);

            // Remove JSON from display text
            displayText = response.replaceAll(jsonStr, '').trim();
            // Clean up markdown code blocks if any
            displayText = displayText
                .replaceAll('```json', '')
                .replaceAll('```', '')
                .trim();
          }
        }
      } catch (e) {
        debugPrint("Error parsing AI action: $e");
      }

      if (mounted) {
        setState(() {
          _messages.add({'role': 'ai', 'text': displayText});
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add({'role': 'ai', 'text': 'Oops! Something went wrong.'});
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _executeAction(
    Map<String, dynamic> action,
    TaskController taskController,
    NoteController noteController,
  ) async {
    final actionName = action['action'];
    final params = action['parameters'] ?? {};

    if (actionName == 'add_task') {
      final title = params['title'];
      final timeStr = params['time']; // Expecting "HH:mm" or similar
      if (title != null) {
        DateTime taskTime = DateTime.now();
        if (timeStr != null) {
          try {
            // Parse time, assuming today
            final now = DateTime.now();
            final timeParts = (timeStr as String).split(':');
            final hour = int.parse(timeParts[0]);
            final minute = int.parse(timeParts[1]);
            taskTime = DateTime(now.year, now.month, now.day, hour, minute);
          } catch (e) {
            debugPrint("Error parsing time: $e");
          }
        }
        await taskController.addTask(title, taskTime);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Task "$title" added!')));
      }
    } else if (actionName == 'create_note') {
      final content = params['content'];
      if (content != null) {
        await noteController.addNote(
          content,
          DateTime.now(),
          '#FFF9C4', // Default yellow
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Sticky note created!')));
      }
    } else if (actionName == 'generate_theme') {
      final bgColor = params['bgColor'];
      final cardColor = params['cardColor'];
      final primaryColor = params['primaryColor'];
      final textColor = params['textColor'];

      if (bgColor != null &&
          cardColor != null &&
          primaryColor != null &&
          textColor != null) {
        final themeManager = Provider.of<ThemeManager>(context, listen: false);

        // Helper to parse hex color
        Color parseColor(String hex) {
          hex = hex.replaceAll('#', '');
          if (hex.length == 6) {
            hex = 'FF$hex';
          }
          return Color(int.parse(hex, radix: 16));
        }

        try {
          final customColors = CustomThemeColors(
            bgColor: parseColor(bgColor),
            cardColor: parseColor(cardColor),
            primaryColor: parseColor(primaryColor),
            textColor: parseColor(textColor),
          );

          themeManager.setGeneratedTheme(customColors);

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Theme generated! ✨')));
        } catch (e) {
          debugPrint("Error parsing theme colors: $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.gray700),
        title: Text(
          'AI Coach',
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.gray700,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header (Removed redundant header)
          const SizedBox(height: 16),

          // Chat Area
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: isUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isUser) ...[
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.blue100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.smart_toy_rounded,
                            size: 16,
                            color: AppColors.blue800,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isUser ? AppColors.green500 : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: Radius.circular(isUser ? 20 : 4),
                              bottomRight: Radius.circular(isUser ? 4 : 20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            border: isUser
                                ? null
                                : Border.all(color: AppColors.gray100),
                          ),
                          child: Text(
                            msg['text']!.replaceAll('**', ''), // Remove stars
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              color: isUser ? Colors.white : AppColors.gray600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      if (isUser) ...[
                        const SizedBox(width: 12),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.green100,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "ME",
                              style: GoogleFonts.nunito(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.green600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),

          if (_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.blue100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.smart_toy_rounded,
                      size: 16,
                      color: AppColors.blue800,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Thinking...',
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      color: AppColors.gray400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

          // Input Area
          Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              16,
              24,
              110,
            ), // Bottom padding for nav bar
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: AppColors.green100, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: GoogleFonts.nunito(color: AppColors.gray700),
                      decoration: InputDecoration(
                        hintText: 'Ask your coach...',
                        hintStyle: GoogleFonts.nunito(color: AppColors.gray400),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.green500,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.green500.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
