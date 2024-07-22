import 'package:flutter/material.dart';
import 'package:ai_assistant/commons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_assistant/services/Gemini/api_key.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  dynamic apiKey, model;
  GeminiService() {
    apiKey = geminiAPIKEY;
    model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: apiKey);
  }

  Future<ChatMessage> generateContent(String prompt) async {
    try {
      final response = await model.generateContent([Content.text(prompt)]);
      if (response.text != null) {
        return ChatMessage(
            isError: false,
            content: Text(
              response.text!,
              style: GoogleFonts.ibmPlexSans(
                  color: const Color.fromARGB(255, 52, 168, 83), fontSize: 18),
            ),
            text: response.text!,
            isSentByUser: false);
      }
      return ChatMessage(
        isError: true,
        content: Text(
          'An Internal Error Occured.',
          style: GoogleFonts.ibmPlexSans(
              color: const Color.fromARGB(255, 234, 67, 53), fontSize: 18),
        ),
        text: 'An Internal Error Occured.',
        isSentByUser: false,
      );
    } catch (e) {
      return ChatMessage(
        isError: true,
        content: Text(
          'Error Occured. Error: ${e.toString()}',
          style: GoogleFonts.ibmPlexSans(
              color: const Color.fromARGB(255, 234, 67, 53), fontSize: 18),
        ),
        text: 'An Internal Error Occured.',
        isSentByUser: false,
      );
    }
  }
}
