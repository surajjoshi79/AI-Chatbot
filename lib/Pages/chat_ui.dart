import 'package:ai_chat_bot/Pages/chat_page.dart';
import 'package:ai_chat_bot/Pages/help_page.dart';
import 'package:ai_chat_bot/Providers/msg_provider.dart';
import 'package:ai_chat_bot/Providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'info_page.dart';

class ChatUi extends StatefulWidget {
  const ChatUi({super.key});

  @override
  State<ChatUi> createState() => _ChatUiState();
}

class _ChatUiState extends State<ChatUi> {
  int count=0;
  ScrollController scr=ScrollController();
  final _myBox=Hive.box('myBox');
  void writeData(List<String> values){
    _myBox.put(1,values);
  }
  List<String> readData(){
    return _myBox.get(1)??[];
  }
  void delete(){
    _myBox.delete(1);
  }
  void scrollDown(){
    if (scr.position.maxScrollExtent > 0 ) {
      scr.animateTo(
          scr.position.maxScrollExtent,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    if(scr.positions.isNotEmpty) {
      scrollDown();
    }
    if(Provider.of<MsgProvider>(context).msg.isNotEmpty) {
      writeData(Provider
          .of<MsgProvider>(context)
          .msg);
    }
    List<String> recent=readData();
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        title: Text("Chatbot",style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        ),
        actions: [
          IconButton(onPressed: (){setState(() {delete(); recent.clear();});}, icon: Icon(Icons.refresh)),
          IconButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context){return HelpPage();}));}, icon: Icon(Icons.help_center)),
          IconButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context){return InfoPage();}));}, icon: Icon(Icons.info)),
        ],
      ),
      body:Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            GestureDetector(
                onTap:(){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context){
                        return ChatPage();
                      }
                  ));
                },
                child: Image.asset("assets/chat_ui_final.png")),
            SizedBox(
              height: 20,
            ),
            Container(
              color: Theme.of(context).colorScheme.primary,
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context){
                      return ChatPage();
                    }
                  ));
                },
                child: ListTile(
                  leading: CircleAvatar(
                    child: Image.asset("assets/chatbot.png"),
                  ),
                  title: Text("Chatbot",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  ),
                  subtitle: Text("Can I help you?",style: TextStyle(
                    fontSize: 16,
                  ),
                  ),
                  trailing: Icon(Icons.chat),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text("Recent Chat",style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24
              )),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  controller: scr,
                  itemCount: recent.length,
                  itemBuilder: (context,index){
                    if(recent[index]=='I am really sorry for your inconvenience but I am unable to find an appropriate response for your query.'){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            BubbleSpecialOne(
                              text:recent[index],
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
                      child: GestureDetector(
                        onLongPress: () async{
                          Clipboard.setData(ClipboardData(text: recent[index]));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Text Copied'),
                            ),
                          );
                        },
                        onDoubleTap: (){
                          setState(() {
                            recent.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Text Deleted'),
                            ),
                          );
                        },
                        child: BubbleSpecialOne(
                          text:recent[index],
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
                    );
                  },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(onPressed: (){
                setState(() {
                  count++;
                });
                Provider.of<ThemeProvider>(context,listen: false).toggleTheme();
              },
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child:count%2!=0?Icon(Icons.dark_mode):Icon(Icons.light_mode)
              )
            )
          ],
        ),
      )
    );
  }
}
