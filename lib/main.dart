import 'package:ai_chat_bot/Providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Pages/chat_ui.dart';
import 'package:provider/provider.dart';
import 'Providers/msg_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Hive.initFlutter();
  await Hive.openBox('myBox');
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<MsgProvider>(create: (context)=> MsgProvider()),
    ChangeNotifierProvider<ThemeProvider>(create: (context)=>ThemeProvider()),],
  child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat Bot",
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: ChatUi(),
    );
  }
}