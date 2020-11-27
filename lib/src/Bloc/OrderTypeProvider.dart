import 'package:flutter/material.dart';

class OrderTypeGenerator extends ChangeNotifier {
  int _OType;
  // int get OType => _OType;

  // set setOrderType (int value){
  //   _OType = value;
  //   //print(_OType);
  //   notifyListeners();
  // }

  // setOrderTypeValue(int OrderType){
  //   setOrderType = OrderType;
  //   notifyListeners();
  // }
  int get OType {return _OType;}

  setOrderTypeValue(int value){
    _OType = value;
    notifyListeners();
  }
}