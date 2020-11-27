import '../helpers/custom_trace.dart';

class Covid19 {
  String id;
  String covidname;
  String covid;
  String updated_at;
  String created_at;


  Covid19();

  Covid19.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      covidname = jsonMap['covidname'] != null ? jsonMap['covidname'] : '';
      covid = jsonMap['covid'] != null ? jsonMap['covid'] : '';
      updated_at = jsonMap['updated_at'] != null ? jsonMap['updated_at'] : '';
      created_at = jsonMap['created_at'] != null ? jsonMap['created_at'] : '';
    } catch (e) {
      id = '';
      covidname = '';
      covid = '';
      updated_at = '';
      created_at = '';
      print(CustomTrace(StackTrace.current, message: e));
    }
  }
}

