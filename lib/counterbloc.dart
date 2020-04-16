import 'package:flutter/material.dart';


class cbloc extends ChangeNotifier{
  int counter=0;
//  int get counter1=>counter;
//  set counter1(int value){
//    counter=value;
//    notifyListeners();
//  }
  incrementcounter(){
    counter++;
    notifyListeners();
  }
  decrementcounter(){
    counter--;
    notifyListeners();
  }

}