import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ai_assistant/commons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_assistant/services/Chat%20GPT/secret_key.dart';

class OpenAIService {
  final List<Map<String, String>> messages = [];

  Future<ChatMessage> isArtPromptAPI(String prompt) async {
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo-0125",
          "messages": [
            {
              'role': 'user',
              'content':
                  'Does this message want to generate an AI picture, image, art or anything similar? $prompt . Simply answer with a yes or no.',
            }
          ],
        }),
      );
      print(res.statusCode);
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();
        if (content == 'Yes' ||
            content == 'yes' ||
            content == 'Yes.' ||
            content == 'yes.') {
          final res = await dallEAPI(prompt);
          return ChatMessage(
            text: res,
            isError: false,
            isSentByUser: false,
            content: Image.network(res),
          );
        } else if (content == 'No' ||
            content == 'no' ||
            content == 'No.' ||
            content == 'no.') {
          final res = await chatGPTAPI(prompt);
          return ChatMessage(
              isError: false,
              content: Text(
                res,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 18,
                  color: Colors.grey[300],
                ),
              ),
              text: res,
              isSentByUser: false);
        }
      }
      return ChatMessage(
          isError: true,
          content: Text(
            'An Internal Error Occured. Please Try Again',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 18,
              color: Colors.red,
            ),
          ),
          text: 'An Internal Error Occured. Please Try Again',
          isSentByUser: false);
    } catch (e) {
      return ChatMessage(
          isError: false,
          content: Text(
            'An Error Occured. Error: ${e.toString()}',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 18,
              color: Colors.red,
            ),
          ),
          text: 'An Error Occured. Error: ${e.toString()}',
          isSentByUser: false);
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    messages.add({'role': 'user', 'content': prompt});

    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": messages,
        }),
      );
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({'role': 'assistant', 'content': content});
        return content;
      }
      return 'An Internal Error Occured';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });

    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKey',
        },
        body: jsonEncode({
          'prompt': prompt,
          'n': 1,
        }),
      );

      if (res.statusCode == 200) {
        String imageUrl = jsonDecode(res.body)['data'][0]['url'];
        imageUrl = imageUrl.trim();

        messages.add({
          'role': 'assistant',
          'content': imageUrl,
        });
        return imageUrl;
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }
}
