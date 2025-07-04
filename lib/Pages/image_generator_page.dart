import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gal/gal.dart';

class ImageGeneratorPage extends StatefulWidget {
  const ImageGeneratorPage({super.key});

  @override
  State<ImageGeneratorPage> createState() => _ImageGeneratorPageState();
}

class _ImageGeneratorPageState extends State<ImageGeneratorPage> {
  TextEditingController txt=TextEditingController();
  FocusNode fn=FocusNode();
  String? imageUrl;
  void generateImageUrl() {
    final prompt=txt.text;
    setState(() {
      txt.clear();
    });
    final encodedPrompt = Uri.encodeComponent(prompt);
    setState(() {
      imageUrl='https://image.pollinations.ai/prompt/$encodedPrompt?&enhance=true&seed=12345&nologo=true';
    });
  }
  Future<void> saveImageToGallery(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    try {
      await Gal.putImageBytes(response.bodyBytes);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image saved in gallery")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to save image")));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Image Generator"),
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            TextField(
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
                      setState(() {
                        fn.unfocus();
                      });
                      if(txt.text.trim().isNotEmpty) {
                        generateImageUrl();
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a prompt")));
                      }
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
              textCapitalization: TextCapitalization.sentences,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height/1.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 2
                ),
                borderRadius: BorderRadiusDirectional.circular(10),
              ),
              child: imageUrl==null?
              Center(
                  child: SizedBox(
                      height:100,
                      width:100,
                      child: Image.asset("assets/image_icon.png")
                  )
              ):
              Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(imageUrl!,fit: BoxFit.fill)
                    ),
                  )
              ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 90),
        child: TextButton(
            onPressed: (){
              if(imageUrl!=null) {
                saveImageToGallery(imageUrl!);
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to save image")));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFffe599),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Save to gallery',style: TextStyle(fontSize:25,color:Theme.of(context).colorScheme.primary)),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.save,color:Theme.of(context).colorScheme.primary,size: 25),
              ],
            )
        ),
      ),
    );
  }
}
