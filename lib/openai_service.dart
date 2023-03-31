import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rox/secrets.dart';

class OpenAIService {
  final List<Map<String, String>> msgs = [];

  Future<String> isArtPrompAPI(String prompt) async {
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAiApiKey',
        },
        body: jsonEncode(
          {
            "model": "text-davinci-003",
            "prompt":
                "Does this message want to generate an AI picture, image, art or anything similar? $prompt . Simply answer with a yes or no.",
          },
        ),
      );
      if (res.statusCode == 200) {
        String content = jsonDecode(res.body)['choices'][0]['text'];
        content = content.trim();
        switch (content) {
          case 'yes':
          case 'yes.':
          case 'Yes.':
          case 'Yes':
            final res = await dallEAPI(prompt);
            return res;
          default:
            final res = await chatGPTAPI(prompt);
            return res;
        }
      }
      return 'An Internal Error Occured';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    // msgs.add(prompt);
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAiApiKey',
        },
        body: jsonEncode(
          {
            "model": "text-davinci-003",
            "prompt":
                "Does this message want to generate an AI picture, image, art or anything similar? $prompt . Simply answer with a yes or no.",
          },
        ),
      );
      if (res.statusCode == 200) {
        String content = jsonDecode(res.body)['choices'][0]['text'];
        content = content.trim();
      }
      return 'An Internal Error Occured';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async {
    return 'DALL-E';
  }
}
