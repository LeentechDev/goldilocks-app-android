import '../helpers/custom_trace.dart';

class TermsAndCondition {
  String id;
  String titleterms;
  String termsandcondition;
  String updated_at;
  String created_at;


  TermsAndCondition();

  TermsAndCondition.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      titleterms = jsonMap['titleterms'] != null ? jsonMap['titleterms'] : '';
      termsandcondition = jsonMap['termsandcondition'] != null ? jsonMap['termsandcondition'] : '';
      updated_at = jsonMap['updated_at'] != null ? jsonMap['updated_at'] : '';
      created_at = jsonMap['created_at'] != null ? jsonMap['created_at'] : '';
    } catch (e) {
      id = '';
      titleterms = '';
      termsandcondition = '';
      updated_at = '';
      created_at = '';
      print(CustomTrace(StackTrace.current, message: e));
    }
  }
}

