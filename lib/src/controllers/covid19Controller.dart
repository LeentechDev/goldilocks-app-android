import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/covid.dart';
import '../repository/covid_repository.dart';

class CovidController extends ControllerMVC {
  List<Covid19> covidV = <Covid19>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  CovidController() {
    scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForCovid19();
  }

  void listenForCovid19({String message}) async {
    final Stream<Covid19> stream = await getPrivacyPolicy();
    stream.listen((Covid19 _covid19) {
      setState(() {
        covidV.add(_covid19);
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
    covidV.clear();
    listenForCovid19(message: S.of(context).termsAndConditionRefreshedSuccessfuly);
  }
}
