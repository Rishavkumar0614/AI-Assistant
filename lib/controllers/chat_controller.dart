import 'package:flutter/material.dart';
import 'package:ai_assistant/commons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_assistant/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatController {
  Future<void> registerService(String serviceName) async {
    final docRef = firestore.collection('user_data').doc('$userId');
    DocumentSnapshot docSnap = await docRef.get();
    if (docSnap.exists) {
      final UserData data = UserData.fromSnap(docSnap);
      if (data.chats[serviceName] == null) {
        data.chats[serviceName] = [];
        await docRef.update({'chats': data.chats});
      }
    }
  }

  Future<void> startChat(String serviceName, int chatId) async {
    final docRef = firestore.collection('user_data').doc('$userId');
    DocumentSnapshot docSnap = await docRef.get();
    if (docSnap.exists) {
      final UserData data = UserData.fromSnap(docSnap);
      if (data.chats[serviceName] != null) {
        data.chats[serviceName]!.add({
          'title': 'Conversation ${chatId + 1}',
          'messages': [],
        });
        await docRef.update({'chats': data.chats});
      }
    }
  }

  Future<int> fetchNChats(String serviceName) async {
    final docRef = firestore.collection('user_data').doc('$userId');
    DocumentSnapshot docSnap = await docRef.get();
    if (docSnap.exists) {
      final UserData data = UserData.fromSnap(docSnap);
      if (data.chats[serviceName] != null) {
        return (data.chats[serviceName] as List).length;
      }
    }
    return 0;
  }

  Future<void> saveMessage(
      String serviceName, int chatId, ChatMessage message) async {
    final docRef = firestore.collection('user_data').doc('$userId');
    DocumentSnapshot docSnap = await docRef.get();
    if (docSnap.exists) {
      final UserData data = UserData.fromSnap(docSnap);
      if (data.chats[serviceName] != null) {
        if (data.chats[serviceName][chatId]['messages'] != null) {
          data.chats[serviceName][chatId]['messages'].add({
            'text': message.text,
            'isError': message.isError,
            'isSentByUser': message.isSentByUser,
          });
          await docRef.update({'chats': data.chats});
        }
      }
    }
  }

  Future<List<ChatMessage>> fetchMessages(
      String serviceName, int chatId) async {
    final docRef = firestore.collection('user_data').doc('$userId');
    DocumentSnapshot docSnap = await docRef.get();
    if (docSnap.exists) {
      final UserData data = UserData.fromSnap(docSnap);
      if (data.chats[serviceName] != null) {
        if (data.chats[serviceName][chatId]['messages'] != null) {
          List<ChatMessage> messages = [];
          for (var message in data.chats[serviceName][chatId]['messages']) {
            messages.add(
              ChatMessage(
                text: message['text'],
                content: Text(message['text'],
                    style: GoogleFonts.ibmPlexSans(
                        color: (message['isError'])
                            ? const Color.fromARGB(255, 234, 67, 53)
                            : const Color.fromARGB(255, 52, 168, 83),
                        fontSize: 18)),
                isError: message['isError'],
                isSentByUser: message['isSentByUser'],
              ),
            );
          }
          return messages;
        }
      }
    }
    return [];
  }
}
