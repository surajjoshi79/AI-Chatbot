import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../my_api_key.dart';

class VoiceAssistantPage extends StatefulWidget {
  const VoiceAssistantPage({super.key});

  @override
  State<VoiceAssistantPage> createState() => _VoiceAssistantPageState();
}

class _VoiceAssistantPageState extends State<VoiceAssistantPage> {
  final model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);
  final SpeechToText speechToText = SpeechToText();
  final FlutterTts textToSpeech=FlutterTts();
  String lastWords = '';
  bool isListening=false;
  final clean="give me a clean response without using unnecessary symbol";
  String? generatedContent;
  @override
  void initState() {
    super.initState();
    initSpeech();
    initText();
  }
  void initSpeech() async{
    await speechToText.initialize();
    setState(() {});
  }
  void initText() async{
    await textToSpeech.setSharedInstance(true);
    setState(() {});
  }
  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }
  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }
  Future<String> getReply(String str) async{
    final prompt=[Content.text(str+clean)];
    final response = await model.generateContent(prompt);
    try{
      return response.text ?? '';
    }catch(e){
      return e.toString();
    }
  }
  Future<void> systemSpeak(String content) async{
    await textToSpeech.speak(content);
  }
  @override
  void dispose() {
    super.dispose();
    textToSpeech.stop();
    speechToText.stop();
  }
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Voice Assistant"),
        elevation: 5,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 35,
            ),
            Center(
              child: CircleAvatar(
                radius: 60,
                child: Image.asset("assets/coding.png"),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if(isListening)
              Column(
                children: [
                  SizedBox(
                    height: size.height/4,
                  ),
                  SpinKitPulse(size: 60,color: Colors.blue),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Listening",style: TextStyle(color: Colors.blue,fontSize: 20)),
                ],
              ),
            if(generatedContent!=null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 2
                      ),
                      borderRadius: BorderRadiusDirectional.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(generatedContent!,style: TextStyle(
                        color:Theme.of(context).colorScheme.secondary,
                        fontSize: 18,
                      )),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 90),
        child: TextButton(
            onPressed: ()async{
              if(await speechToText.hasPermission && speechToText.isNotListening){
                await startListening();
                setState(() {
                  isListening=true;
                  generatedContent=null;
                });
              }else if(speechToText.isListening){
                await stopListening();
                final speech=await getReply(lastWords);
                setState(() {
                  isListening=false;
                  generatedContent=speech;
                });
                await systemSpeak(speech);
              }else{
                initSpeech();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFffe599),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(isListening?'Click to stop':'Click to speak',style: TextStyle(fontSize:25,color: isListening?Colors.red:Colors.green)),
                SizedBox(
                  width: 5,
                ),
                Icon(isListening?Icons.stop:Icons.mic,color: isListening?Colors.red:Colors.green,size: 25),
              ],
            )
        ),
      ),
    );
  }
}
