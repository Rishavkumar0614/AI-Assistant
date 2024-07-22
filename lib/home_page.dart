import 'package:flutter/material.dart';
import 'package:ai_assistant/commons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int activeServiceIdx = 0;

  @override
  void initState() {
    super.initState();
    Future.forEach(serviceNames, (serviceName) async {
      await chatController.registerService(serviceName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        backgroundColor: Colors.white,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (int i = 0; i < services.length; i++)
                InkWell(
                  onTap: () {
                    activeServiceIdx = i;
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            width: 2,
                            color: (activeServiceIdx == i)
                                ? const Color.fromARGB(255, 66, 133, 244)
                                : Colors.white),
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundImage: servicesLogo[i],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      body: services[activeServiceIdx],
    );
  }
}
