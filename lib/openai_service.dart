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
            "model": "gpt-3.5-turbo",
            "messages": [
              {
                "role": "user",
                "content":
                    "Does this message want to generate an AI picture, image, art or anything similar? $prompt . Simply answer with a yes or no."
              }
            ]
          },
        ),
      );
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['messages']['content'];
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
    msgs.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAiApiKey',
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo",
            "messages": msgs,
          },
        ),
      );
      if (res.statusCode == 200) {
        String content = jsonDecode(res.body)['choices'][0]['text'];
        content = content.trim();
        msgs.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
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
