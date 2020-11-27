import 'dart:convert' as convert;
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import '../Bloc/shared_pref.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
final SharedPrefs prefs = SharedPrefs();
Future<String> _getId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId; // unique ID on Android
  }
}

Future<bool> getAuthToken() async {
  // var url = 'http://devapi.supershow.app/api/token/get';
  String deviceToken = await _firebaseMessaging.getToken();
  String deviceId = await _getId();
  print(deviceToken);
  print(deviceId);
  //set device token and device id to shared prefs
  //prefs.setStringDeviceToken(deviceToken);
  //prefs.setStringDeviceID(deviceId);
  var params = {
    "appkey":
        "WGKCSGGW9ryfzLrCc5kt3uRSW5ACa62uDHzpTgd8h969KMHXxFrzp7FdtcfX2bSLjfRw79TXs9e3fJ4JcQAefHpWtVEHUFx23jbd",
    "device_token": deviceToken,
  };
  Uri uri = Uri.parse("https://goldilocks.ml/api/register");
  final newURI = uri.replace(queryParameters: params);
  var response = await http.get(newURI, headers: {
    "Content-Type": "application/x-www-form-urlencoded",
    "Devicetoken": deviceToken,
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    String authToken = jsonResponse["data"]["token"];
    print(authToken);
    //prefs.setStringAuthToken(authToken);
    return true;
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return false;
  }
}
