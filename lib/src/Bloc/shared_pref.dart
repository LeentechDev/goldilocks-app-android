import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  int orderType;
  int openNum;
  bool loginType;

  String deviceToken;
  String deviceID;
  String authToken;
  String passwordStatus;

  String Gid, fname, lname, email, phone, password;

  Future<int> getIntOrderType() async {
    final prefs = await SharedPreferences.getInstance();
    orderType = prefs.getInt('OrderType');
    return orderType;
  }

  Future<void> setIntOrderType(int orderType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('OrderType', orderType);
  }

  Future<bool> getIntLoginType() async {
    final prefs = await SharedPreferences.getInstance();
    loginType = prefs.getBool('LoginType');
    return loginType;
  }

  Future<void> setIntLoginType(bool loginType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('LoginType', loginType);
  }

  Future<String> getStringGiD() async {
    final prefs = await SharedPreferences.getInstance();
    Gid = prefs.getString('GiD');
    return Gid;
  }

  Future<void> setStringGiD(String Gid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('GiD', Gid);
  }

  Future<String> getStringFname() async {
    final prefs = await SharedPreferences.getInstance();
    fname = prefs.getString('Fname');
    return fname;
  }

  Future<void> setStringFname(String fname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('Fname', fname);
  }

  Future<String> getStringLname() async {
    final prefs = await SharedPreferences.getInstance();
    lname = prefs.getString('Lname');
    return lname;
  }

  Future<void> setStringLname(String lname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('Lname', lname);
  }

  Future<String> getStringEmail() async {
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('Email');
    return email;
  }

  Future<void> setStringEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('Email', email);
  }

  Future<String> getStringPassword() async {
    final prefs = await SharedPreferences.getInstance();
    password = prefs.getString('Password');
    return password;
  }

  Future<void> setStringPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('Password', password);
  }

  Future<String> getStringPhone() async {
    final prefs = await SharedPreferences.getInstance();
    phone = prefs.getString('Phone');
    return phone;
  }

  Future<void> setStringPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('Phone', phone);
  }

  Future<String> getPasswordStatus() async {
    final prefs = await SharedPreferences.getInstance();
    passwordStatus = prefs.getString('PasswordStatus');
    return passwordStatus;
  }

  Future<void> setPasswordStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('PasswordStatus', status);
  }

}