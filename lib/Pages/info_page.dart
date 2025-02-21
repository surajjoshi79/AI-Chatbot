import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        title: Text("Info Center",style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Text("1. User Interface (UI)\n\nFlutter: The chatbot features a sleek, responsive, and intuitive UI created with Flutter's rich set of widgets and its flexible design capabilities. Users enjoy a smooth and engaging experience across both Android and iOS platforms.\n",style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),
              ),
              Text("2. Backend & AI Integration\n\nGemini AI: The chatbot leverages Gemini AI for natural language understanding (NLU) and generation (NLG). It can comprehend user queries, process them intelligently, and generate human-like responses, making the interaction seamless and enjoyable.\n\nCommunication: The chatbot connects with Gemini AI through API calls to process user inputs and receive responses in real-time.\n",style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),
              ),
              Text("3. Data Management\n\nHive Database: The Hive database handles all local data storage requirements efficiently. It stores user session data, chat history, user preferences, and other relevant information securely.\n\nEfficiency: Hive ensures that data retrieval is lightning-fast, and the app remains performant even with large datasets.",style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
