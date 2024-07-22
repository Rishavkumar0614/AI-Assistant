import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ai_assistant/controllers/auth_controller.dart';
import 'package:ai_assistant/controllers/chat_controller.dart';
import 'package:ai_assistant/services/Gemini/home_page.dart'
    as gemini_home_page;
import 'package:ai_assistant/services/Chat%20GPT/home_page.dart'
    as chat_gpt_home_page;

Widget showLoadingScreen(context) {
  return Container(
    color: Colors.white,
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Loading... Please Wait',
          style: GoogleFonts.ibmPlexSans(
            fontSize: 20,
            color: Colors.blue,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    ),
  );
}

void showSnackBar(BuildContext context, String message, int time) {
  if (time > 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.ibmPlexSans(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        duration: Duration(seconds: time),
        backgroundColor: Colors.grey[900],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isError;
  final Widget content;
  final bool isSentByUser;

  ChatMessage(
      {required this.text,
      required this.isError,
      required this.content,
      required this.isSentByUser});
}

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;
  const ChatMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Align(
        alignment: ((message.isSentByUser)
            ? Alignment.bottomRight
            : Alignment.bottomLeft),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2.0, // Border width
              color: Colors.grey[500]!, // Border color
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: message.content,
        ),
      ),
    );
  }
}

final List<List<List<ChatMessage>>> messages = [[], []];

Future<int> startChat(int serviceId, BuildContext? context) async {
  if (messages.length >= serviceId) {
    messages[serviceId].add([]);
    await chatController.startChat(
        serviceNames[serviceId], (messages[serviceId].length - 1));
    return (messages[serviceId].length - 1);
  } else {
    if (context != null) {
      showSnackBar(context, 'Invalid Service ID', 2);
    }
    return -1;
  }
}

Future<bool> saveMessage(int serviceId, int chatId, ChatMessage message,
    BuildContext? context) async {
  if (messages.length > serviceId) {
    if (messages[serviceId].length > chatId) {
      await chatController.saveMessage(
          serviceNames[serviceId], chatId, message);
      return true;
    } else {
      if (context != null) {
        showSnackBar(context, 'Invalid Chat ID', 2);
      }
    }
  } else {
    if (context != null) {
      showSnackBar(context, 'Invalid Service ID', 2);
    }
  }
  return false;
}

// CONTROLLERS
var authController = AuthController();
var chatController = ChatController();

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firestore = FirebaseFirestore.instance;
var firebaseStorage = FirebaseStorage.instance;

// USER ID
String? userId;

List<Widget> services = [
  const gemini_home_page.HomePage(),
  const chat_gpt_home_page.HomePage()
];
List<String> serviceNames = ['Gemini', 'ChatGPT'];
List<ImageProvider> servicesLogo = [
  const AssetImage('assets/Services Logo/Gemini logo.png'),
  const AssetImage('assets/Services Logo/ChatGPT logo.jpg'),
];
