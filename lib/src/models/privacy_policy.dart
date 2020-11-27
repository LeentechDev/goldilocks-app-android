import '../helpers/custom_trace.dart';

class PrivacyPolicy {
  String id;
  String titlename;
  String name;

  PrivacyPolicy();

  PrivacyPolicy.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      titlename = jsonMap['titlename'] != null ? jsonMap['titlename'] : '';
      name = jsonMap['name'] != null ? jsonMap['name'] : '';

    } catch (e) {
      id = '';
      titlename = '';
      name = '';

      print(CustomTrace(StackTrace.current, message: e));
    }
  }
}

