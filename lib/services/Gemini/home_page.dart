import 'package:flutter/material.dart';
import 'package:ai_assistant/commons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_assistant/services/Gemini/chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final int serviceId = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    int nChats = await chatController.fetchNChats(serviceNames[serviceId]);
    if (messages[serviceId].length < nChats) {
      final List<int> chatIds = List.generate(nChats, (i) => i);
      Future.forEach(chatIds, (chatId) async {
        messages[serviceId].add(await chatController.fetchMessages(
            serviceNames[serviceId], chatId));
      }).then((value) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Conversations',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                hintStyle: GoogleFonts.ibmPlexSans(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Recent Conversations',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 66, 133, 234),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: messages[serviceId].length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            chatId: index,
                          ),
                        ),
                      );
                      setState(() {});
                    },
                    child: ListTile(
                      title: Text(
                        'Conversation ${index + 1}',
                        style: GoogleFonts.ibmPlexSans(fontSize: 16),
                      ),
                      leading: const Icon(
                        Icons.chat,
                        size: 30,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FutureBuilder<int>(
                future: startChat(serviceId, context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return showLoadingScreen(context);
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    int chatId = snapshot.data!;
                    return ChatPage(chatId: chatId);
                  } else {
                    return const Text('Something went wrong');
                  }
                },
              ),
            ),
          );
          setState(() {});
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
