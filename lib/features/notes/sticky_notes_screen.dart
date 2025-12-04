import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_routine/core/theme.dart';
import 'package:my_routine/core/clay_widgets.dart';

class StickyNote {
  final String id;
  String title;
  String content;
  final Color color;
  final double rotateAngle;
  final String date;

  StickyNote({
    required this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.rotateAngle,
    required this.date,
  });
}

class StickyNotesScreen extends StatefulWidget {
  const StickyNotesScreen({super.key});

  @override
  State<StickyNotesScreen> createState() => _StickyNotesScreenState();
}

class _StickyNotesScreenState extends State<StickyNotesScreen> {
  final List<StickyNote> _notes = [];
  StickyNote? _selectedNote;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final List<Color> _noteColors = [
    AppColors.yellow100,
    AppColors.blue100,
    AppColors.pink100,
    AppColors.green100,
    AppColors.purple100,
    AppColors.orange100,
  ];

  @override
  void initState() {
    super.initState();
    _generateInitialNotes();
  }

  void _generateInitialNotes() {
    final random = Random();
    for (int i = 0; i < 6; i++) {
      _notes.add(
        StickyNote(
          id: DateTime.now().add(Duration(milliseconds: i)).toString(),
          title: 'Note #${i + 1}',
          content: i % 2 == 0
              ? "Meeting at 10 AM..."
              : "Don't forget to drink water!",
          color: _noteColors[random.nextInt(_noteColors.length)],
          rotateAngle: (random.nextDouble() * 0.1) - 0.05, // Small rotation
          date: DateFormat('MM/dd/yyyy').format(DateTime.now()),
        ),
      );
    }
  }

  void _addNote() {
    final random = Random();
    final newNote = StickyNote(
      id: DateTime.now().toString(),
      title: "New Idea",
      content: "",
      color: _noteColors[random.nextInt(_noteColors.length)],
      rotateAngle: (random.nextDouble() * 0.1) - 0.05,
      date: DateFormat('MM/dd/yyyy').format(DateTime.now()),
    );
    setState(() {
      _notes.insert(0, newNote);
      _openNote(newNote);
    });
  }

  void _openNote(StickyNote note) {
    setState(() {
      _selectedNote = note;
      _titleController.text = note.title;
      _contentController.text = note.content;
    });
  }

  void _closeNote() {
    setState(() {
      _selectedNote = null;
    });
  }

  void _saveNote() {
    if (_selectedNote == null) return;
    setState(() {
      _selectedNote!.title = _titleController.text;
      _selectedNote!.content = _contentController.text;
    });
    _closeNote();
  }

  void _deleteNote() {
    if (_selectedNote == null) return;
    setState(() {
      _notes.removeWhere((n) => n.id == _selectedNote!.id);
    });
    _closeNote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: CustomPaint(painter: DotGridPainter()),
            ),
          ),

          Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  border: Border(bottom: BorderSide(color: AppColors.gray100)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildCircleButton(
                          icon: Icons.chevron_left_rounded,
                          onTap: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Idea Wall 📌',
                          style: GoogleFonts.fredoka(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppColors.gray800,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _addNote,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Add',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    final note = _notes[index];
                    return GestureDetector(
                      onTap: () => _openNote(note),
                      child: Transform.rotate(
                        angle: note.rotateAngle,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: note.color,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Pin
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.red[300],
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.5),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Text(
                                    note.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.nunito(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.gray800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Expanded(
                                    child: Text(
                                      note.content.isEmpty
                                          ? "Empty note..."
                                          : note.content,
                                      style: GoogleFonts.nunito(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.gray700.withOpacity(
                                          0.8,
                                        ),
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        note.date,
                                        style: GoogleFonts.nunito(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.gray500,
                                        ),
                                      ),
                                      Icon(
                                        Icons.open_in_full_rounded,
                                        size: 12,
                                        color: AppColors.gray400,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Modal Overlay
          if (_selectedNote != null)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.7,
                    decoration: BoxDecoration(
                      color: _selectedNote!.color,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Modal Header
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _titleController,
                                  style: GoogleFonts.fredoka(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.gray800,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Title...',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: AppColors.gray500,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  _buildIconButton(
                                    icon: Icons.download_rounded,
                                    onTap: () {}, // Placeholder for download
                                  ),
                                  const SizedBox(width: 8),
                                  _buildIconButton(
                                    icon: Icons.close_rounded,
                                    onTap: _closeNote,
                                    isDestructive: true,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Colors.black12),

                        // Modal Content
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: TextField(
                              controller: _contentController,
                              maxLines: null,
                              expands: true,
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.gray800,
                                height: 1.6,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Start typing...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: AppColors.gray500.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Modal Footer
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.05),
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(28),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedNote!.date,
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.gray600,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                    ),
                                    color: Colors.red[400],
                                    onPressed: _deleteNote,
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: _saveNote,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.gray900,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.save_rounded,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Save',
                                            style: GoogleFonts.nunito(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.gray500, size: 20),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDestructive ? Colors.red[400] : AppColors.gray700,
        ),
      ),
    );
  }
}

class DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gray300
      ..strokeWidth = 1;

    const double spacing = 24.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
