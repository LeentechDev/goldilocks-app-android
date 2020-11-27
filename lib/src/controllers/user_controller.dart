import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/user.dart';
import '../Bloc/shared_pref.dart';
import '../Bloc/auth.dart';
import '../Bloc/Providers.dart';
import '../models/user_model.dart';
import '../repository/user_repository.dart' as repository;

class UserController extends ControllerMVC {
  User user = new User();
  bool hidePassword = true;
  bool hidePassword1 = true;
  bool loading = false;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  FirebaseMessaging _firebaseMessaging;
  OverlayEntry loader;
  UserModel _userModel;


  UserController() {
    loader = Helper.overlayLoader(context);
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((String _deviceToken) {
      user.deviceToken = _deviceToken;
    }).catchError((e) {
      print('An Error has Occurred');
    });
  }

  void login() async {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      print("log in: " + scaffoldKey.toString());
      Overlay.of(context).insert(loader);
      repository.login(user).then((value) {
        if (value != null && value.apiToken != null) {
          Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/GetLocation');
        } else {
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: AutoSizeText(S.of(context).wrong_email_or_password),
          ));
        }
      }).catchError((e) {
        loader.remove();
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: AutoSizeText(S.of(context).please_check_your_credentials),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  } 

  void loginSocial(String email, String password, String dev_id) async {
    Overlay.of(context).insert(loader); 
    repository.loginSocial(email, password, dev_id).then((value) {
      if (value != null && value.apiToken != null) {
        Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/GetLocation');
      } else {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: AutoSizeText(S.of(context).wrong_email_or_password),
        ));
      }
    }).catchError((e) {
      loader.remove();
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: AutoSizeText(S.of(context).please_check_your_credentials),
      ));
    }).whenComplete(() {
      Helper.hideLoader(loader);
    });
  }


  void register() async { 
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      repository.register(user).then((value) {
        if (value != null && value.apiToken != null) {
          Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/SignUp2');
        } else {
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: AutoSizeText(S.of(context).wrong_email_or_password),
          ));
        }
      }).catchError((e) {
        loader?.remove();
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: AutoSizeText(S.of(context).please_check_your_credentials),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  void registerPhone(String phone) async {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      phoneAuth(phone, context).catchError((e) {
        loader?.remove();
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: AutoSizeText(S.of(context).please_check_your_credentials),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }


  void resetPassword() {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      repository.resetPassword(user).then((value) {
        if (value != null && value == true) {
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: AutoSizeText(S.of(context).your_reset_link_has_been_sent_to_your_email),
            action: SnackBarAction(
              label: S.of(context).login,
              onPressed: () {
                Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/Login');
              },
            ),
            duration: Duration(seconds: 10),
          ));
        } else {
          loader.remove();
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: AutoSizeText(S.of(context).error_verify_email_settings),
          ));
        }
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }
}
