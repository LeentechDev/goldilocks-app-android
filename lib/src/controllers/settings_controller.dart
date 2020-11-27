import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/credit_card.dart';
import '../models/user.dart';
import '../Bloc/shared_pref.dart';
import '../repository/user_repository.dart' as repository;

class SettingsController extends ControllerMVC {
  CreditCard creditCard = new CreditCard();
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;

  SettingsController() {
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void update(User user) async {
    user.deviceToken = null;
    repository.update(user).then((value) {
      setState(() {});
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: AutoSizeText(S.of(context).profile_settings_updated_successfully),
      ));
    });
  }

  void changepassword(User user) {
    user.deviceToken = null;
    repository.changepassword(user).then((value) async {

      final SharedPrefs prefs = SharedPrefs();
      String status = await prefs.getPasswordStatus();
      String statusX;

      if(status == 'Password does not match'){
        statusX = 'Old password does not match';
      }
      else{
        statusX = status;
      }

      setState(() {});
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: AutoSizeText(statusX),
      ));
    }
    ).catchError((e){
      setState(() {});
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: AutoSizeText(S.of(context).incorrect_old_password),
      ));
    });
  }

  void updateCreditCard(CreditCard creditCard) {
    repository.setCreditCard(creditCard).then((value) {
      setState(() {});
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: AutoSizeText(S.of(context).payment_settings_updated_successfully),
      ));
    });
  }

  void listenForUser() async {
    creditCard = await repository.getCreditCard();
    setState(() {});
  }

  Future<void> refreshSettings() async {
    creditCard = new CreditCard();
  }
}
