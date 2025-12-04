import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:my_routine/features/notes/note_model.dart';
import 'dart:math';

class NoteController extends ChangeNotifier {
  Box<Note>? _noteBox;
  final Uuid _uuid = const Uuid();
  final Random _random = Random();

  List<Note> _notes = [];
  List<Note> get notes => _notes;

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(NoteAdapter());
    }
    _noteBox = await Hive.openBox<Note>('notes');
    loadNotes();
  }

  void loadNotes() {
    if (_noteBox != null) {
      _notes = _noteBox!.values.toList();
      // Sort by date descending
      _notes.sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
    }
  }

  Future<void> addNote(String content, DateTime date, String color) async {
    if (_noteBox == null) return;

    final note = Note(
      id: _uuid.v4(),
      content: content,
      date: date,
      color: color,
      rotation:
          (_random.nextDouble() * 0.1) -
          0.05, // Random rotation between -0.05 and 0.05
    );

    await _noteBox!.add(note);
    loadNotes();
  }

  Future<void> updateNote(Note note, String newContent) async {
    note.content = newContent;
    await note.save();
    loadNotes();
  }

  Future<void> deleteNote(Note note) async {
    await note.delete();
    loadNotes();
  }

  List<Note> getNotesForDate(DateTime date) {
    return _notes
        .where(
          (note) =>
              note.date.year == date.year &&
              note.date.month == date.month &&
              note.date.day == date.day,
        )
        .toList();
  }
}
