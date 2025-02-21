import 'package:flutter/material.dart';

class MsgProvider extends ChangeNotifier{
  List<String> msg=[];
  void addMessage(String m){
    msg.add(m);
    notifyListeners();
  }
  void deleteMessage(String m){
    msg.remove(m);
    notifyListeners();
  }
}