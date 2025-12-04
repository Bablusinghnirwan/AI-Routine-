import 'dart:convert';
import 'package:http/http.dart' as http;
import '../features/goals/goal_model.dart';
import '../features/progress/progress_model.dart';

class GeminiService {
  static const String _apiKey =
      'AIzaSyATR1ZtkF2UXKOvkqG6uYl758y1oFNvsYM'; // Replace with secure storage in production
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  Future<Map<String, dynamic>> generateGoalPlan(GoalModel goal) async {
    final prompt =
        '''
You are an AI Personal Coach.
Create a detailed plan based on the user's long term goal.

Goal: ${goal.title}
Description: ${goal.description}
Target Date: ${goal.targetDate.toIso8601String()}
Category: ${goal.category}

Your output MUST include:
1. Daily micro-goals (exact list for each day)
2. Weekly targets
3. Difficulty progression each week
4. One-line advice for each day
5. A full schedule until the target date
6. Expected progress milestones
7. Risk points and how to avoid them
8. Motivation line for the entire journey

Keep everything structured and short.
Return ONLY JSON-formatted plan with keys: "daily_plan", "weekly_targets", "milestones", "risks", "motivation".
''';

    return _callGemini(prompt);
  }

  Future<Map<String, dynamic>> generateRecoveryPlan(
    ProgressModel stats,
    int missedCount,
  ) async {
    final prompt =
        '''
You are an AI Personal Coach.
The user has missed $missedCount tasks recently.

User Stats:
Discipline Score: ${stats.disciplineScore}
Consistency Rate: ${stats.consistencyRate}%

Generate:
1. Short recovery strategy
2. Adjusted goals for next 3 days
3. One motivational line

Return ONLY JSON-formatted plan with keys: "recovery_strategy", "adjusted_goals", "motivation".
''';

    return _callGemini(prompt);
  }

  Future<String> getDailyAdvice() async {
    final prompt = 'Give me one short, punchy motivational line for today.';
    final response = await _callGemini(prompt);
    return response['advice'] ?? response['text'] ?? 'Stay consistent!';
  }

  Future<String> chat(String message, {String? context}) async {
    final prompt =
        '''
You are "Challbot", a super friendly AI friend and coach for a 10-year-old kid.
Your tone should be enthusiastic, simple, and encouraging. Use emojis! 🌟
Current Time (India Standard Time): ${DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30))}

Context about the user:
${context ?? "No specific context provided."}

If the user asks you to do something (like "add task", "create note", "set reminder"), 
you MUST return a JSON object with an "action" key.

Supported Actions:
1. Add Task: {"action": "add_task", "parameters": {"title": "Task Title", "time": "HH:MM"}}
2. Create Note: {"action": "create_note", "parameters": {"content": "Note Content"}}

If it's just a chat, return a normal text response.
User: $message
''';

    final response = await _callGemini(prompt);

    // Check if response is JSON action (if _callGemini parsed it as Map)
    if (response.containsKey('action')) {
      return jsonEncode(response); // Return JSON string for UI to parse
    }

    return response['response'] ?? response['text'] ?? 'I am listening...';
  }

  Future<Map<String, dynamic>> _callGemini(String text) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": text},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['candidates'][0]['content']['parts'][0]['text'];

        // Clean markdown code blocks if present
        String cleanJson = content
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();

        try {
          return jsonDecode(cleanJson);
        } catch (e) {
          // If not JSON, return as text field
          return {'text': cleanJson};
        }
      } else {
        throw Exception('Failed to load AI response: ${response.body}');
      }
    } catch (e) {
      print('Gemini Error: $e');
      return {'error': e.toString()};
    }
  }
}
