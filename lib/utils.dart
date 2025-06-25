import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async{
  final imagePicker=ImagePicker();
  XFile? file=await imagePicker.pickImage(source: source);
  if(file!=null){
    return file.readAsBytes();
  }
  else{
    return null;
  }
}

class SharedPref{
  late final SharedPreferences sharedPreferences;
  Future<void> init() async{
    sharedPreferences=await SharedPreferences.getInstance();
  }
}

final sharedPref=SharedPref();