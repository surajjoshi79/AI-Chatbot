import 'package:ai_chat_bot/Theme/theme.dart';
import 'package:ai_chat_bot/utils.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier{

  void toggleTheme(){
    sharedPref.sharedPreferences.setBool("isLight?", !(sharedPref.sharedPreferences.getBool("isLight?")??true));
    notifyListeners();
  }

  ThemeData getTheme(){
    if(sharedPref.sharedPreferences.getBool("isLight?")??true){
      return darkMode;
    }
    return lightMode;
  }
}