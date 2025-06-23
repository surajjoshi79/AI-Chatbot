import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  late final SharedPreferences sharedPreferences;
  Future<void> init() async{
    sharedPreferences=await SharedPreferences.getInstance();
  }
}

final sharedPref=SharedPref();