import '../helpers/custom_trace.dart';

class Notification {
  String id;
  String type;
  String data;
  String status;

  bool read;
  DateTime createdAt;

  Notification();

  Notification.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      type = jsonMap['type'] != null ? jsonMap['type'].toString() : '';
      data = jsonMap['data'].toString();
      status = jsonMap['order_status'].toString();
      read = jsonMap['read_at'] != null ? true : false;
      createdAt = DateTime.parse(jsonMap['created_at']);
    } catch (e) {
      id = '';
      type = '';
      data = '';
      status = '';
      read = false;
      createdAt = new DateTime(0);
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  Map markReadMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["read_at"] = !read;
    return map;
  }
}
