import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/privacy_policy.dart';
import '../repository/privacy_policy_repository.dart';

class PrivacyPolicyController extends ControllerMVC {
  List<PrivacyPolicy> policies = <PrivacyPolicy>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  PrivacyPolicyController() {
    scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForPrivacyPolicy();
  }

  void listenForPrivacyPolicy({String message}) async {
    final Stream<PrivacyPolicy> stream = await getPrivacyPolicy();
    stream.listen((PrivacyPolicy _privacyPolicy) {
      setState(() {
        policies.add(_privacyPolicy);
      });
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: AutoSizeText(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: AutoSizeText(message),
        ));
      }
    });
  }

  Future<void> refreshPrivacyPolicy() async {
    policies.clear();
    listenForPrivacyPolicy(message: S.of(context).faqsRefreshedSuccessfuly);
  }
}
