import 'package:ai_chat_bot/Providers/msg_provider.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../my_api_key.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final clean="give me a clean response without using unnecessary symbol";
  bool isLoading=false;
  List<String> curChat=[];
  final model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);
  ScrollController scr=ScrollController();
  TextEditingController txt=TextEditingController();
  FocusNode fn=FocusNode();
  void scrollDown(){
    if (scr.position.maxScrollExtent > 0 ) {
      scr.animateTo(
        scr.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn
      );
    }
  }
  String cleanResponse(String response) {
    String cleanedResponse = response.replaceAll('**', '');
    cleanedResponse=cleanedResponse.replaceAll('*', '•');
    cleanedResponse=cleanedResponse.replaceAll('`', '');
    return cleanedResponse;
  }
  Future<void> getReply() async{

    final message = txt.text;
    txt.clear();

    setState(() {
      curChat.add(message);
      Provider.of<MsgProvider>(context,listen:false).addMessage(message);
      isLoading=true;
    });

    final prompt = [Content.text(message+clean)];
    final response = await model.generateContent(prompt);

    setState(() {
      try {
        curChat.add(cleanResponse(response.text ?? ''));
        Provider.of<MsgProvider>(context, listen: false).addMessage(cleanResponse(response.text ?? ''));
      }catch(e){
        curChat.add('I am really sorry for your inconvenience but I am unable to find an appropriate response for your query.');
        Provider.of<MsgProvider>(context, listen: false).addMessage('I am really sorry for your inconvenience but I am unable to find an appropriate response for your query.');
      }
      isLoading=false;
    });
  }
  @override
  void dispose() {
    super.dispose();
    txt.dispose();
    fn.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(scr.positions.isNotEmpty) {
      scrollDown();
    }
    return Scaffold(
      resizeToAvoidBottomInset: curChat.isEmpty?false:true,
      appBar: AppBar(
        title: Text("Chatbot", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 8,
        actions: [
          IconButton(onPressed: (){
            setState(() {});
          }, icon: Icon(Icons.arrow_downward))
        ],
      ),
      body: curChat.isEmpty?
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Ask me anything",style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.secondary,fontSize: 20),) ,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              cursorColor: Theme.of(context).colorScheme.secondary,
              focusNode: fn,
              controller: txt,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
              decoration: InputDecoration(
                hintText: "Enter Prompt",
                hintStyle: TextStyle(
                    fontSize: 14
                ),
                suffixIcon: IconButton(icon: Icon(Icons.send),
                    onPressed: () {
                      fn.unfocus();
                      getReply();
                    }
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                    )
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                    )
                ),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          )
        ],
      ):
      Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ListView.builder(
                  controller: scr,
                  itemCount: curChat.length,
                  itemBuilder: (context,index) {
                    if(curChat[index]=='I am really sorry for your inconvenience but I am unable to find an appropriate response for your query.'){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            BubbleSpecialOne(
                              text:curChat[index],
                              seen: true,
                              sent: true,
                              textStyle: TextStyle(
                                fontSize: 18,
                              ),
                              isSender: false,
                              tail: true,
                              color: Colors.red,
                            ),
                            Icon(Icons.error,color: Colors.red)
                          ],
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onLongPress: () async{
                              Clipboard.setData(ClipboardData(text: curChat[index]));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Text Copied'),
                                ),
                              );
                          },
                            child: BubbleSpecialOne(
                              text:curChat[index],
                              seen: true,
                              sent: true,
                              textStyle: TextStyle(
                                fontSize: 18,
                              ),
                              isSender: index%2==0?true:false,
                              tail: true,
                              color: index%2==0?Colors.blue:Colors.grey,
                            ),
                          ),
                          if(isLoading && index==curChat.length-1)
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Text("thinking",style: TextStyle(color: Colors.lightBlue)),
                                  SizedBox(width: 5),
                                  SpinKitThreeBounce(
                                    color: Colors.lightBlue,
                                    size: 15,
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    );
                  }
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: TextField(
                cursorColor: Theme.of(context).colorScheme.secondary,
                focusNode: fn,
                controller: txt,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                decoration: InputDecoration(
                  hintText: "Enter Prompt",
                  hintStyle: TextStyle(
                    fontSize: 14
                  ),
                  suffixIcon: IconButton(icon: Icon(Icons.send),
                      onPressed: () {
                          fn.unfocus();
                          getReply();
                      }
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2,
                      )
                  ),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          )
        ],
      ),
    );
  }
}