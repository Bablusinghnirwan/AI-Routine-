import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_routine/core/theme.dart';
import 'package:my_routine/core/clay_widgets.dart';
import 'package:my_routine/features/diary/diary_controller.dart';
import 'package:my_routine/features/diary/diary_model.dart';

class DiaryDetailScreen extends StatefulWidget {
  final DiaryModel? entry;

  const DiaryDetailScreen({super.key, this.entry});

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  final _textController = TextEditingController();
  bool _isEditing = false;
  String _selectedMood = '😊';
  Color _selectedColor = AppColors.cream;

  final List<String> _moods = ['😊', '😢', '😡', '😴', '🤩', '🤔', '🥳'];

  // Clay-friendly colors
  final List<Color> _colors = [
    AppColors.cream,
    AppColors.green50,
    AppColors.blue50,
    AppColors.pink100,
    AppColors.yellow50,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _textController.text = widget.entry!.rawText;
      _selectedMood = widget.entry!.mood;
      // Map legacy integer colors to new Color objects if needed, or just use default
      _selectedColor = AppColors.cream;
      _isEditing = true;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _saveEntry() {
    if (_textController.text.isEmpty) return;

    if (!_isEditing) {
      Provider.of<DiaryController>(context, listen: false).addEntry(
        _textController.text,
        mood: _selectedMood,
        color: _selectedColor.value,
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isReadOnly = widget.entry != null;

    return Scaffold(
      backgroundColor: AppColors.green100,
      appBar: AppBar(
        title: Text(
          isReadOnly
              ? DateFormat('MMM d, yyyy').format(widget.entry!.date)
              : 'New Entry',
          style: GoogleFonts.fredoka(color: AppColors.gray700),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.gray700),
        actions: [
          if (!isReadOnly)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                icon: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.green600,
                  size: 32,
                ),
                onPressed: _saveEntry,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          if (!isReadOnly) ...[
            // Mood Selector
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                itemCount: _moods.length,
                itemBuilder: (context, index) {
                  final mood = _moods[index];
                  final isSelected = mood == _selectedMood;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedMood = mood),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.green200 : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: isSelected ? 8 : 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: isSelected
                            ? Border.all(color: AppColors.green500, width: 2)
                            : null,
                      ),
                      child: Text(mood, style: const TextStyle(fontSize: 24)),
                    ),
                  );
                },
              ),
            ),

            // Color Selector
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                itemCount: _colors.length,
                itemBuilder: (context, index) {
                  final color = _colors[index];
                  final isSelected = color == _selectedColor;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.gray600
                              : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],

          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Column(
                  children: [
                    if (isReadOnly)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Text(
                              _selectedMood,
                              style: const TextStyle(fontSize: 32),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          controller: _textController,
                          readOnly: isReadOnly,
                          maxLines: null,
                          expands: true,
                          style: GoogleFonts.nunito(
                            color: Colors.black87, // Darker text
                            fontSize: 18,
                            height: 1.5,
                          ),
                          decoration: InputDecoration(
                            hintText: "Dear Diary...",
                            hintStyle: GoogleFonts.nunito(
                              color: Colors.black38, // Visible hint
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
