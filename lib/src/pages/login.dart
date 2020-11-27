import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info/device_info.dart';

import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';
import '../elements/BlockButtonWidget.dart';
import '../elements/GBlockButtonWidget.dart';
import '../elements/FBlockButtonWidget.dart';
import '../Bloc/auth.dart';
import '../Bloc/Providers.dart';
import '../models/user_model.dart';
import '../Bloc/shared_pref.dart';

import '../helpers/app_config.dart' as config;
import '../repository/user_repository.dart' as userRepo;

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends StateMVC<LoginWidget> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  UserController _con;
  OverlayEntry loader;
  final SharedPrefs prefs = SharedPrefs();
  String GEmail, GName, GUid;

  getGoogleInfo() async {
    GEmail = await prefs.getStringEmail();
    GName = await prefs.getStringFname();
    GUid = await prefs.getStringGiD();
    print("Prefs Saved");
  }

  _LoginWidgetState() : super(UserController()) {
    _con = controller;
  }
  final RegExp _emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  UserModel _userModel;

  Future<UserModel> createUser(
      String name, String email, String password) async {
    final String apiUrl = "https://goldilocks.ml/api/register";
    String devicetoken = await _firebaseMessaging.getToken();
    final response = await http.post(apiUrl, body: {
      "name": name,
      "email": email,
      "password": password,
      "device_token": devicetoken
    });

    if (response.statusCode == 201) {
      final String responseString = response.body;
      return userModelFromJson(responseString);
    } else {
      print("Failed: " + response.body);
    }
  }

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  @override
  void initState() {
    super.initState();
    if (userRepo.currentUser.value.apiToken != null) {
      Navigator.of(context).pushReplacementNamed('/Pages', arguments: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _con.scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            // Container(
            //   width: config.App(context).appWidth(100),
            //   height: config.App(context).appHeight(37),
            //   decoration: BoxDecoration(color: Theme.of(context).accentColor),
            // ),
            Column(
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'assets/custom_img/login_background.png',
                    width: 1000,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
              ],
            ),
            Positioned(
              top: config.App(context).appHeight(30) - 100,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                width: config.App(context).appWidth(86),
                //height: config.App(context).appHeight(37),
                decoration: BoxDecoration(
                  color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Form(
                  key: _con.loginFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AutoSizeText(S.of(context).login,
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .merge(
                            TextStyle(
                              fontSize: 30,
                            ),
                          )),
                      SizedBox(height: 25),
                      TextFormField(
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(70),
                        ],
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (input) => _con.user.email = input,
                        validator: (input) => !input.contains('@')
                            ? S.of(context).should_be_a_valid_email
                            : null,
                        decoration: InputDecoration(
                          //labelText: S.of(context).email,
                          labelStyle: TextStyle(
                              color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: 'Email',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .dividerColor
                                  .withOpacity(0.7)),
                          prefixIcon: Icon(Icons.person_outline,
                              color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withOpacity(0.2))),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(30),
                        ],
                        keyboardType: TextInputType.text,
                        onSaved: (input) => _con.user.password = input,
                        validator: (input) => input.length < 8
                            ? S
                            .of(context)
                            .should_be_more_than_8_characters
                            : null,
                        obscureText: _con.hidePassword,
                        decoration: InputDecoration(
                          //labelText: S.of(context).password,
                          labelStyle: TextStyle(
                              color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .dividerColor
                                  .withOpacity(0.7)),
                          prefixIcon: Icon(Icons.lock_outline,
                              color: Theme.of(context).accentColor),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _con.hidePassword = !_con.hidePassword;
                              });
                            },
                            color: Theme.of(context).dividerColor,
                            icon: Icon(_con.hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withOpacity(0.2))),
                        ),
                      ),
                      SizedBox(height: 30),
                      BlockButtonWidget(
                        text: AutoSizeText(
                          S.of(context).login,
                          style: TextStyle(
                              color: Theme.of(context).hintColor),
                        ),
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          prefs.setIntLoginType(false);
                          _con.login();
                        },
                      ),
                      SizedBox(height: 15),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed('/ForgetPassword');
                        },
                        textColor: Theme.of(context).focusColor,
                        child:
                        AutoSizeText(S.of(context).forgot_password),
                      ),

                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 10,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Container(
                      height: 1.0,
                      width: 300.0,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 14,
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          AutoSizeText("Don\'t have an Account? ",
                              style:
                                  Theme.of(context).textTheme.headline3.merge(
                                        TextStyle(fontSize: 12),
                                      )),
                          new GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('/SignUp');
                            },
                            child: AutoSizeText(
                              S.of(context).sign_up,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  .merge(TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).focusColor)),
                            ),
                          ),
                          // FlatButton(
                          //   onPressed: () {
                          //     Navigator.of(context).pushReplacementNamed('/SignUp');
                          //   },
                          //   child: AutoSizeText(
                          //     S.of(context).sign_up,
                          //     style: Theme.of(context).textTheme.headline3.merge(
                          //         TextStyle(
                          //             fontSize: 12,
                          //             color: Theme.of(context).focusColor)),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*
 SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 50,
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.2),
                            )
                          ]),
                      margin: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      padding: EdgeInsets.only(
                          top: 30, right: 27, left: 27, bottom: 10),
                      // width: config.App(context).appWidth(88),
//              height: config.App(context).appHeight(55),
                      child: Form(
                        key: _con.loginFormKey,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              AutoSizeText(S.of(context).login,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .merge(
                                        TextStyle(
                                          fontSize: 30,
                                        ),
                                      )),
                              SizedBox(height: 35),
                              TextFormField(
                                inputFormatters: [
                                  new LengthLimitingTextInputFormatter(70),
                                ],
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (input) => _con.user.email = input,
                                validator: (input) => !input.contains('@')
                                    ? S.of(context).should_be_a_valid_email
                                    : null,
                                decoration: InputDecoration(
                                  //labelText: S.of(context).email,
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).accentColor),
                                  contentPadding: EdgeInsets.all(12),
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .dividerColor
                                          .withOpacity(0.7)),
                                  prefixIcon: Icon(Icons.person_outline,
                                      color: Theme.of(context).accentColor),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .dividerColor
                                              .withOpacity(0.2))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .accentColor
                                              .withOpacity(0.5))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .dividerColor
                                              .withOpacity(0.2))),
                                ),
                              ),
                              SizedBox(height: 15),
                              TextFormField(
                                inputFormatters: [
                                  new LengthLimitingTextInputFormatter(30),
                                ],
                                keyboardType: TextInputType.text,
                                onSaved: (input) => _con.user.password = input,
                                validator: (input) => input.length < 8
                                    ? S
                                        .of(context)
                                        .should_be_more_than_8_characters
                                    : null,
                                obscureText: _con.hidePassword,
                                decoration: InputDecoration(
                                  //labelText: S.of(context).password,
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).accentColor),
                                  contentPadding: EdgeInsets.all(12),
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .dividerColor
                                          .withOpacity(0.7)),
                                  prefixIcon: Icon(Icons.lock_outline,
                                      color: Theme.of(context).accentColor),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _con.hidePassword = !_con.hidePassword;
                                      });
                                    },
                                    color: Theme.of(context).dividerColor,
                                    icon: Icon(_con.hidePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .dividerColor
                                              .withOpacity(0.2))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .accentColor
                                              .withOpacity(0.5))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .dividerColor
                                              .withOpacity(0.2))),
                                ),
                              ),
                              SizedBox(height: 30),
                              BlockButtonWidget(
                                text: AutoSizeText(
                                  S.of(context).login,
                                  style: TextStyle(
                                      color: Theme.of(context).hintColor),
                                ),
                                color: Theme.of(context).accentColor,
                                onPressed: () {
                                  prefs.setIntLoginType(false);
                                  _con.login();
                                },
                              ),
                              SizedBox(height: 15),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/ForgetPassword');
                                },
                                textColor: Theme.of(context).focusColor,
                                child:
                                    AutoSizeText(S.of(context).forgot_password),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  FBlockButtonWidget(
                    row: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FaIcon(FontAwesomeIcons.facebookF,
                            color: Theme.of(context).primaryColor),
                        SizedBox(
                          width: 5,
                        ),
                        AutoSizeText(
                          "Continue Using Facebook",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                    color: Color(0xFF3b5998),
                    onPressed: () {
                      prefs.setIntLoginType(true);
                      facebookLogin(context).then((user) {
                        if (user != null) {
                          facebookLogin(context).whenComplete(() async {
                            String devicetoken =
                                await _firebaseMessaging.getToken();
                            final String FBname =
                                Provider.of<Providers>(context, listen: false)
                                    .Name
                                    .toString();
                            final String FBemail =
                                Provider.of<Providers>(context, listen: false)
                                    .Email
                                    .toString();
                            final String FBID =
                                Provider.of<Providers>(context, listen: false)
                                    .GID
                                    .toString();

                            final UserModel newUser =
                                await createUser(FBname, FBemail, FBID);

                            setState(() {
                              _userModel = newUser;
                              isFacebookLoginIn = true;
                              successMessage =
                                  'Logged in successfully.\nEmail : ${user.email}\nYou can now navigate to Home Page.';
                            });
                            print("Device Token " + devicetoken);
                            _con.loginSocial(FBemail, FBID, devicetoken);
                          }).catchError((onError) {
                            print("Error $onError");
                          });
                        } else {
                          print('Error while Login.');
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GBlockButtonWidget(
                    row: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/custom_img/google_logo.png',
                          width: 25,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        AutoSizeText(
                          "Continue Using Google",
                        ),
                      ],
                    ),
                    color: Colors.white,
                    onPressed: () {
                      prefs.setIntLoginType(true);
                      signInWithGoogle(context).then((user) {
                        if (user != null) {
                          signInWithGoogle(context).whenComplete(() async {
                            String devicetoken =
                                await _firebaseMessaging.getToken();
                            final String Gname =
                                Provider.of<Providers>(context, listen: false)
                                    .Name
                                    .toString();
                            final String Gemail =
                                Provider.of<Providers>(context, listen: false)
                                    .Email
                                    .toString();
                            final String GgoogleID =
                                Provider.of<Providers>(context, listen: false)
                                    .GID
                                    .toString();

                            final UserModel newUser =
                                await createUser(Gname, Gemail, GgoogleID);

                            setState(() {
                              _userModel = newUser;
                            });

                            _con.loginSocial(Gemail, GgoogleID, devicetoken);
                          }).catchError((onError) {
                            print("Error $onError");
                          });
                        } else {
                          print('Error Log in');
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
 */