import 'package:ai_chat_bot/Theme/theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier{
  ThemeData _themeData=darkMode;

  ThemeData get themeData=>_themeData;

  set themeData(ThemeData themeData){
    _themeData=themeData;
    notifyListeners();
  }

  void toggleTheme(){
    if(_themeData==lightMode){
      _themeData=darkMode;
    }else{
      _themeData=lightMode;
    }
    notifyListeners();
  }
}