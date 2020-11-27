import 'package:flutter/material.dart';

class Providers extends ChangeNotifier {
  String _OType = "";
  String _LType = "";
  String _CategoryID = "";
  String _Email = "";
  String _Name = "";
  String _GID = "";
  String _Phone = "";
  String _Url = "";
  String _Address = "";

  String get OType => _OType;
  String get LType => _LType;
  String get CategoryID => _CategoryID;
  String get Email => _Email;
  String get Name => _Name;
  String get GID => _GID;
  String get Phone => _Phone;
  String get Url => _Url;
  String get  Address => _Address;

  set setUrl(String value){
    _Url = value;
    print(_Url);
    notifyListeners();
  }


  set setOrderType(String value) {
    _OType = value;
    print(_OType);
    notifyListeners();
  }

  set setLoginType(String value) {
    _LType = value;
    print(_LType);
    notifyListeners();
  }

  set setCategory(String value) {
    _CategoryID = value;
    print(_CategoryID);
    notifyListeners();
  }

  set setEmail(String value) {
    _Email = value;
    print(_Email);
    notifyListeners();
  }

  set setName(String value) {
    _Name = value;
    print(_Name);
    notifyListeners();
  }

  set setGID(String value) {
    _GID = value;
    print(_GID);
    notifyListeners();
  }

  set setPhone(String value) {
    _Phone = value;
    print(_Phone);
    notifyListeners();
  }

  set setCategoryId(String value) {
    _CategoryID = value;
    print(_CategoryID);
    notifyListeners();
  }

  set setAddress(String value) {
    _Address = value;
    print(_Address);
    notifyListeners();
  }

  setCategoryValue(String CiD) {
    setOrderType = CiD;
    notifyListeners();
  }

  setLoginValue(String LoginID) {
    setLoginType = LoginID;
    notifyListeners();
  }

  setEmailValue(String EmailV) {
    setEmail = EmailV;
    notifyListeners();
  }

  setNameValue(String NameV) {
    setName = NameV;
    notifyListeners();
  }

  setGIDValue(String GIDV) {
    setGID = GIDV;
    notifyListeners();
  }

  setOrderTypePickup() {
    setOrderType = "Store Pick Up";
    notifyListeners();
  }

  setOrderTypeDelivery() {
    setOrderType = "Delivery";
    notifyListeners();
  }

  setPhoneValue(String PhV) {
    setPhone = PhV;
    notifyListeners();
  }

  setCategoryIDValue(String CategoryIDV) {
    setCategoryId = CategoryIDV;
    notifyListeners();
  }

  setUrlValue(String UrlV){
    setUrl = UrlV;
    notifyListeners();
  }

  setAddressValue(String AddressV){
    setAddress = AddressV;
    notifyListeners();
  }
}
