import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        title: Text("Help Center",style: TextStyle(
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
              Align(
                alignment: Alignment.center,
                child: Text("FAQs",style: TextStyle(
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text("1.How to start chat sessions?\nFor entering into a new chat session you can either click on the image or click on the chatbot tile.\n",style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),
              ),
              Divider(
                thickness: 1.5,
              ),
              Text("2.How to clean the recent chat section?\nYou can click on refresh icon in home page for cleaning the recent chat section and it will automatically clear after starting new chatting session.\n",style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),),
              Divider(
                thickness: 1.5,
              ),
              Text("3.What is the use of downwards arrow in chat section?\nIt is used to move at the end of the chat section.\n",style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),),
              Divider(
                thickness: 1.5,
              ),
              Text("4.What to do if chatbot takes a long interval to answer?\nIf the chatbot is experiencing a delayed response, it may be due to a network connectivity issue. Please ensure your device has a stable internet connection. If your network is functioning correctly, restarting the application may resolve any underlying internal issues causing the delay.\n",style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),),
              Divider(
                thickness: 1.5,
              ),
              Text("5.What to do if it shows random errors?\nShould you encounter random errors, these could be attributed to an unforeseen software bug or a memory-related problem. To address this, we recommend clearing the application's cache. If the issue persists, clearing the app data may be necessary to restore optimal functionality and eliminate persistent errors.\n",style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),),
              Divider(
                thickness: 1.5,
              ),
              Text("6.How to copy a text to the clipboard?\nYou can long press on any message to copy it to the clipboard.\n",style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),),
              Divider(
                thickness: 1.5,
              ),
              Text("7.How to delete a select text from recent chat?\nYou can double tap on any message to delete it from recent.\n",style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),),
            ],
          ),
        ),
      ),
    );
  }
}
