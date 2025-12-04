import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _apiKey = 'AIzaSyATR1ZtkF2UXKOvkqG6uYl758y1oFNvsYM';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  Future<String> generateDailyFeedback({
    required String mood,
    required String challenges,
    required String proud,
  }) async {
    final prompt =
        '''
You are an AI productivity coach. 
Analyze the user's daily reflection and generate a short summary.

User Input:
Mood: $mood
Challenges: $challenges
Proud of: $proud

Your Output MUST include:
1. Productivity Score (0–100)
2. Day Sentiment (Positive/Neutral/Negative)
3. What they did well
4. What they should improve
5. Personalized advice for tomorrow
6. One motivational line

Keep the tone friendly, short, and encouraging.
''';

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // NEW JSON STRUCTURE FOR GEMINI 2.0
        final text = data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"];

        if (text != null) return text;
      }

      return "Unable to generate feedback at this time. Please try again later.";
    } catch (e) {
      return "AI Error: $e";
    }
  }
}
