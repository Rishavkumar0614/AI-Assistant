import 'package:flutter/material.dart';
import 'package:ai_assistant/commons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_assistant/services/Chat%20GPT/openai_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.chatId,
  });
  final int chatId;

  @override
  State<ChatPage> createState() => ChatPageState(chatId: chatId);
}

class ChatPageState extends State<ChatPage> {
  bool flag = true;
  final int chatId;
  BuildContext? _context;
  final int serviceId = 1;
  ChatPageState({required this.chatId});
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      flag = false;
      String text = _controller.text;
      _controller.clear();
      setState(() {
        messages[serviceId][chatId].add(ChatMessage(
          text: text,
          isError: false,
          isSentByUser: true,
          content: Text(text,
              style: GoogleFonts.ibmPlexSans(color: Colors.blue, fontSize: 18)),
        ));
        saveMessage(
            serviceId,
            chatId,
            ChatMessage(
              text: text,
              isError: false,
              isSentByUser: true,
              content: Text(text,
                  style: GoogleFonts.ibmPlexSans(
                      color: Colors.blue, fontSize: 18)),
            ),
            context);
      });
      ChatMessage temp = await OpenAIService().isArtPromptAPI(text);
      messages[serviceId][chatId].add(temp);
      await saveMessage(serviceId, chatId, temp, context);
      setState(() {
        flag = true;
      });
    } else {
      showSnackBar(_context!, 'Please enter a message', 2);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Conversation ${chatId + 1}',
            style: GoogleFonts.ibmPlexSans(fontSize: 20),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages[serviceId][chatId].length,
              itemBuilder: (context, index) {
                return ChatMessageWidget(
                  message: messages[serviceId][chatId][index],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type Your Message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (flag) {
                      _sendMessage();
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
