import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/terms_and_condition.dart';
import '../repository/terms_and_condition_repository.dart';

class TermsAndConditionController extends ControllerMVC {
  List<TermsAndCondition> terms = <TermsAndCondition>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  TermsAndConditionController() {
    scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForTermsAndCondition();
  }

  void listenForTermsAndCondition({String message}) async {
    final Stream<TermsAndCondition> stream = await getPrivacyPolicy();
    stream.listen((TermsAndCondition _termsandcondition) {
      setState(() {
        terms.add(_termsandcondition);
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

  Future<void> refreshTermsAndCondition() async {
    terms.clear();
    listenForTermsAndCondition(message: S.of(context).termsAndConditionRefreshedSuccessfuly);
  }
}
