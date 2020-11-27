import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/helper.dart';
import '../models/terms_and_condition.dart';

Future<Stream<TermsAndCondition>> getPrivacyPolicy() async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}termsandcondition';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return TermsAndCondition.fromJSON(data);
  });
}
