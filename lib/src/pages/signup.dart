import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';
import '../elements/BlockButtonWidget.dart';
import '../helpers/app_config.dart' as config;
import '../Bloc/shared_pref.dart';
import '../models/user_model.dart';
import '../pages/phone_verification.dart';
import '../Bloc/auth.dart';

import '../Bloc/Providers.dart';

import 'package:regexed_validator/regexed_validator.dart';

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends StateMVC<SignUpWidget> {
  UserController _con;
  String _password;

  final FNameController = TextEditingController();
  final LNameController = TextEditingController();
  final EmailController = TextEditingController();
  final PasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  final SharedPrefs prefs = SharedPrefs();
  final RegExp _passwordRegex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~\_]).{8,}$');

  final RegExp _emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  String phone;
  String LastName;
  String Email;
  String Password;
  bool isvalid = false;

  UserModel _userModel;

  _SignUpWidgetState() : super(UserController()) {
    _con = controller;
  }

  getStringPhone() async {
    phone = await prefs.getStringPhone();
    print(phone);
  }

  @override
  void initState() {
    getStringPhone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _con.scaffoldKey,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/Login');
            },
          ),
          title: AutoSizeText(
            S.of(context).sign_up,
            style: TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold),
          ),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 5),
            child: StepProgressIndicator(
              totalSteps: 3,
              currentStep: 1,
              selectedColor: Theme.of(context).accentColor,
              unselectedColor: Theme.of(context).primaryColor,
            ),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AutoSizeText(S.of(context).your_details,
                      style: Theme.of(context).textTheme.headline4.merge(
                          TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 35))),
                  SizedBox(
                    height: 5,
                  ),
                  AutoSizeText(
                    S.of(context).fill_up_necessary_information,
                    minFontSize: 16,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.subtitle1.merge(
                          TextStyle(
                              color: Theme.of(context).hintColor, fontSize: 20),
                        ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: _con.loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          "First Name",
                          style: Theme.of(context).textTheme.caption.merge(
                              TextStyle(
                                  color: Theme.of(context).hintColor.withOpacity(0.7),
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(height: 5),
                        TextFormField(
                          inputFormatters: [
                           new LengthLimitingTextInputFormatter(25),
                         ],
                          keyboardType: TextInputType.text,
                          controller: FNameController,
                          //onSaved: (input) => _con.user.name = input,
                          validator: (input) => input.length < 3
                              ? S.of(context).should_be_more_than_3_letters
                              : null,
                          decoration: InputDecoration(
                            //labelText: S.of(context).full_name,
                            labelStyle:
                                TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText: S.of(context).eg_john,
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .dividerColor
                                    .withOpacity(0.7)),
                            //prefixIcon: Icon(Icons.person_outline, color: Theme.of(context).accentColor),
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
                        AutoSizeText(
                          "Last Name",
                          style: Theme.of(context).textTheme.caption.merge(
                              TextStyle(
                                  color: Theme.of(context).hintColor.withOpacity(0.7),
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(height: 5),
                        TextFormField(
                          inputFormatters: [
                           new LengthLimitingTextInputFormatter(25),
                         ],
                          keyboardType: TextInputType.text,
                          controller: LNameController,
                          onSaved: (input) => _con.user.name =
                              FNameController.text + " " + input,
                          validator: (input) => input.length < 3
                              ? S.of(context).should_be_more_than_3_letters
                              : null,
                          decoration: InputDecoration(
                            //labelText: S.of(context).full_name,
                            labelStyle:
                                TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText: S.of(context).eg_doe,
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .dividerColor
                                    .withOpacity(0.7)),
                            //prefixIcon: Icon(Icons.person_outline, color: Theme.of(context).accentColor),
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
                        //SizedBox(height: 30),
                        //AutoSizeText(
                        //  "Phone Number",
                        //  style: Theme.of(context)
                        //      .textTheme
                        //      .caption
                        //      .merge(TextStyle(color :Theme.of(context).hintColor, fontWeight: FontWeight.w500)),
                        //),
                        //SizedBox(height: 5),
                        //TextFormField(
                        //  inputFormatters: [
                        //    new LengthLimitingTextInputFormatter(20),
                        //  ],
                        //  keyboardType: TextInputType.phone,
                        //  controller: _phoneController,
                        //  onSaved: (input) => _con.user.phone = input,
                        //  validator: (input) => input.length == "10"
                        //      ? S.of(context).please_enter_a_valid_phone_number
                        //      : null,
                        //  decoration: InputDecoration(
                        //    //labelText: S.of(context).email,
                        //    labelStyle:
                        //        TextStyle(color: Theme.of(context).accentColor),
                        //    contentPadding: EdgeInsets.all(12),
                        //    hintText: '000 000 0000',
                        //    hintStyle: TextStyle(
                        //        color: Theme.of(context)
                        //            .dividerColor
                        //            .withOpacity(0.7)),
                        //    //prefixIcon: Icon(Icons.phone,
                        //    //    color: Theme.of(context).accentColor),
                        //    border: OutlineInputBorder(
                        //        borderSide: BorderSide(
                        //            color: Theme.of(context)
                        //                .dividerColor
                        //                .withOpacity(0.2))),
                        //    focusedBorder: OutlineInputBorder(
                        //        borderSide: BorderSide(
                        //            color: Theme.of(context)
                        //                .accentColor
                        //                .withOpacity(0.5))),
                        //    enabledBorder: OutlineInputBorder(
                        //        borderSide: BorderSide(
                        //            color: Theme.of(context)
                        //                .dividerColor
                        //                .withOpacity(0.2))),
                        //
                        //  ),
                        //
                        //),
                        //SizedBox(height: 8),
                        //AutoSizeText(
                        //  "We'll send you a 6-digit code shortly.",
                        //  style: Theme.of(context)
                        //      .textTheme
                        //      .caption
                        //      .merge(TextStyle(color :Theme.of(context).hintColor)),
                        //),
                        SizedBox(height: 30),

                        //AutoSizeText(
                        //  "Phone",
                        //  style: Theme.of(context)
                        //      .textTheme
                        //      .caption
                        //      .merge(TextStyle(fontWeight: FontWeight.w300)),
                        //),
                        //SizedBox(height: 5),
                        //TextFormField(
                        //  inputFormatters: [
                        //    new LengthLimitingTextInputFormatter(20),
                        //  ],
                        //  keyboardType: TextInputType.phone,
                        //  controller: _phoneController,
                        //  onSaved: (input) => _con.user.phone = input,
                        //  validator: (input) => input.length == "10"
                        //      ? S.of(context).please_enter_a_valid_phone_number
                        //      : null,
                        //  decoration: InputDecoration(
                        //    //labelText: S.of(context).email,
                        //    labelStyle:
                        //        TextStyle(color: Theme.of(context).accentColor),
                        //    contentPadding: EdgeInsets.all(12),
                        //    hintText: '000 000 0000',
                        //    hintStyle: TextStyle(
                        //        color: Theme.of(context)
                        //            .dividerColor
                        //            .withOpacity(0.7)),
                        //    //prefixIcon: Icon(Icons.phone,
                        //    //    color: Theme.of(context).accentColor),
                        //    border: OutlineInputBorder(
                        //        borderSide: BorderSide(
                        //            color: Theme.of(context)
                        //                .dividerColor
                        //                .withOpacity(0.2))),
                        //    focusedBorder: OutlineInputBorder(
                        //        borderSide: BorderSide(
                        //            color: Theme.of(context)
                        //                .accentColor
                        //                .withOpacity(0.5))),
                        //    enabledBorder: OutlineInputBorder(
                        //        borderSide: BorderSide(
                        //            color: Theme.of(context)
                        //                .dividerColor
                        //                .withOpacity(0.2))),
                        //  ),
                        //),
                        //SizedBox(height: 30),
                        //AutoSizeText(
                        //  "Phone Number",
                        //  style: Theme.of(context)
                        //      .textTheme
                        //      .caption
                        //      .merge(TextStyle(color :Theme.of(context).hintColor, fontWeight: FontWeight.w500)),
                        //),
                        //SizedBox(height: 5),
                        //TextFormField(
                        //  inputFormatters: [
                        //    new LengthLimitingTextInputFormatter(20),
                        //  ],
                        //  keyboardType: TextInputType.phone,
                        //  controller: _phoneController,
                        //  onSaved: (input) => _con.user.phone = input,
                        //  validator: (input) => input.length == "10"
                        //      ? S.of(context).please_enter_a_valid_phone_number
                        //      : null,
                        //  decoration: InputDecoration(
                        //    //labelText: S.of(context).email,
                        //    labelStyle:
                        //        TextStyle(color: Theme.of(context).accentColor),
                        //    contentPadding: EdgeInsets.all(12),
                        //    hintText: '000 000 0000',
                        //    hintStyle: TextStyle(
                        //        color: Theme.of(context)
                        //            .dividerColor
                        //            .withOpacity(0.7)),
                        //    //prefixIcon: Icon(Icons.phone,
                        //    //    color: Theme.of(context).accentColor),
                        //    border: OutlineInputBorder(
                        //        borderSide: BorderSide(
                        //            color: Theme.of(context)
                        //                .dividerColor
                        //                .withOpacity(0.2))),
                        //    focusedBorder: OutlineInputBorder(
                        //        borderSide: BorderSide(
                        //            color: Theme.of(context)
                        //                .accentColor
                        //                .withOpacity(0.5))),
                        //    enabledBorder: OutlineInputBorder(
                        //        borderSide: BorderSide(
                        //            color: Theme.of(context)
                        //                .dividerColor
                        //                .withOpacity(0.2))),
                        //
                        //  ),
                        //
                        //),
                        SizedBox(height: 8),
                        //AutoSizeText(
                        //  "We'll send you a 6-digit code shortly.",
                        //  style: Theme.of(context)
                        //      .textTheme
                        //      .caption
                        //      .merge(TextStyle(color :Theme.of(context).hintColor)),
                        //),
                        AutoSizeText(
                          "Email",
                          style: Theme.of(context).textTheme.caption.merge(
                              TextStyle(
                                  color: Theme.of(context).hintColor.withOpacity(0.7),
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(height: 5),
                        TextFormField(
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(70),
                          ],
                          controller: EmailController,
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (input) => _con.user.email = input,
                          validator: (input) =>
                              _emailRegex.hasMatch(input) == false
                                  ? S.of(context).should_be_a_valid_email
                                  : null,
                          decoration: InputDecoration(
                            //labelText: S.of(context).email,
                            labelStyle:
                                TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(12),
                            hintText: S.of(context).eg_johndoe,
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .dividerColor
                                    .withOpacity(0.7)),
                            //prefixIcon: Icon(Icons.mail_outline, color: Theme.of(context).accentColor),
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
                        AutoSizeText(
                          "Password",
                          style: Theme.of(context).textTheme.caption.merge(
                              TextStyle(
                                  color: Theme.of(context).hintColor.withOpacity(0.7),
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(height: 5),
                        TextFormField(
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(30),
                          ],
                          obscureText: _con.hidePassword,
                          controller: PasswordController,
                          onChanged: (input) {
                            setState(() {
                              prefs.setStringPassword(input);
                            });
                          },
                          onSaved: (input) => _con.user.password = input,
                          validator: (input) => input.length <= 8
                              ? S.of(context).should_be_atleast_8_characters
                              : input.isEmpty
                                  ? S.of(context).dont_leave_it_blank
                                  : _passwordRegex.hasMatch(input) == false
                                      ? S.of(context).password_must_contain
                                      : null,
                          decoration: InputDecoration(
                            //labelText: S.of(context).password,
                            labelStyle:
                                TextStyle(color: Theme.of(context).accentColor),
                            contentPadding: EdgeInsets.all(12),
                            //hintText: S.of(context).password,//'••••••••••••',
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .dividerColor
                                    .withOpacity(0.7)),
                            //prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).accentColor),
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
                        SizedBox(height: 25),

                        AutoSizeText(S.of(context).by_creating_an_account),
                        new GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/TermsAndConditionsRegister');
                          },
                          child: new AutoSizeText(
                            S.of(context).terms_and_condition,
                            style:
                                TextStyle(color: Theme.of(context).focusColor),
                          ),
                        ),

                        SizedBox(height: 30),

                        BlockButtonWidget(
                          text: AutoSizeText(
                            S.of(context).next,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                          color: Color(
                              0xff313030), //Theme.of(context).accentColor,
                          onPressed: () {
                          // async {
                          //   String name = "${FNameController.text} " + LNameController.text;
                          //   String email = EmailController.text;
                          //   String password = PasswordController.text;

                          //   Providers userDetailsProvider =
                          //   Provider.of<Providers>(context, listen: false);

                          //   userDetailsProvider.setNameValue(name);
                          //   userDetailsProvider.setEmailValue(email);
                          //   userDetailsProvider.setGIDValue(password);

                          //   _con.registerV2(name,email,password);


                            _con.register();
                            // final phone =  _phoneController.text.toString();
                            // phoneAuth(phone, context);
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                height: 1.0,
                                width: 300.0,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                AutoSizeText(
                                  "Already have an account? ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .merge(
                                        TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context).hintColor.withOpacity(0.7),
                                            fontWeight: FontWeight.w600),
                                      ),
                                ),

                                new GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).pushReplacementNamed('/Login');
                                                },
                                                child: AutoSizeText(
                                    S.of(context).login,
                                    style: Theme.of(context).textTheme.headline3.merge(
                                        TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context).focusColor)),
                                              ),
                                    ),
                                // ButtonTheme(
                                //   minWidth: 60,
                                //   child: FlatButton(
                                //     padding: EdgeInsets.all(0),
                                //     onPressed: () {
                                //       Navigator.of(context)
                                //           .pushReplacementNamed('/Login');
                                //     },
                                //     textColor: Colors.blue,
                                //     child: AutoSizeText(S.of(context).login),
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
Scaffold(
        key: _con.scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Positioned(
              top: 0,
              child: Container(
                width: config.App(context).appWidth(100),
                height: config.App(context).appHeight(29.5),
                decoration: BoxDecoration(color: Theme.of(context).accentColor),
              ),
            ),
            Positioned(
              top: config.App(context).appHeight(20) - 130,
              child: Container(
                width: config.App(context).appWidth(100),
                height: config.App(context).appHeight(50),
                child: Column(
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
              ),
            ),
            //Positioned(
            //  top: config.App(context).appHeight(29.5) - 130,
            //  child: Container(
            //    width: config.App(context).appWidth(84),
            //    height: config.App(context).appHeight(29.5),
            //    child: AutoSizeText(
            //      "Create Account",//S.of(context).lets_start_with_register,
            //      textAlign: TextAlign.center,
            //      style: Theme.of(context).textTheme.headline2.merge(TextStyle(color: Theme.of(context).primaryColor)),
            //    ),
            //  ),
            //),
            Positioned(
              top: config.App(context).appHeight(25) - 50,
              child: Container(
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.all(Radius.circular(10)), boxShadow: [
                  BoxShadow(
                    blurRadius: 50,
                    color: Theme.of(context).hintColor.withOpacity(0.2),
                  )
                ]),
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 27),
                width: config.App(context).appWidth(88),
//              height: config.App(context).appHeight(55),
                child: Form(
                  key: _con.loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      AutoSizeText(
                        S.of(context).sign_up,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),

                      SizedBox(height: 25),

SizedBox(height:20),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        onSaved: (input) => _con.user.name = input,
                        validator: (input) => input.length < 3 ? S.of(context).should_be_more_than_3_letters : null,
                        decoration: InputDecoration(
                          //labelText: S.of(context).full_name,
                          labelStyle: TextStyle(color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: S.of(context).full_name,
                          hintStyle: TextStyle(color: Theme.of(context).dividerColor.withOpacity(0.7)),
                          prefixIcon: Icon(Icons.person_outline, color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.2))),
                        ),
                      ),
                      SizedBox(height: 15),

SizedBox(height:20),
                      TextFormField(
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(11),
                        ],
                        keyboardType: TextInputType.phone,
                        onSaved: (input) => _con.user.phone = input,
                        validator: (input) => input.length < 12 ? S.of(context).should_be_more_than_11_numbers : null,
                        decoration: InputDecoration(
                          //labelText: "Phone",//S.of(context).email,
                          labelStyle: TextStyle(color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: "Phone",//'+63 9123456789',
                          hintStyle: TextStyle(color: Theme.of(context).dividerColor.withOpacity(0.7)),
                          prefixIcon: Icon(Icons.phone_iphone, color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.2))),
                        ),
                      ),
                      SizedBox(height: 15),

SizedBox(height:20),
                      TextFormField(
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(70),
                        ],
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (input) => _con.user.email = input,
                        validator: (input) => !input.contains('@') ? S.of(context).should_be_a_valid_email : null,
                        decoration: InputDecoration(
                          //labelText: S.of(context).email,
                          labelStyle: TextStyle(color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: S.of(context).email,
                          hintStyle: TextStyle(color: Theme.of(context).dividerColor.withOpacity(0.7)),
                          prefixIcon: Icon(Icons.mail_outline, color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.2))),
                        ),
                      ),
                      SizedBox(height: 15),


SizedBox(height:20),
                      TextFormField(
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(30),
                        ],
                        obscureText: _con.hidePassword,
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                            });
                          },
                        onSaved: (input) => _con.user.password = input,
                        validator: (input) => input.length >= 8 ? S.of(context).should_be_atleast_8_characters : null,
                        decoration: InputDecoration(
                          //labelText: S.of(context).password,
                          labelStyle: TextStyle(color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: S.of(context).password,//'••••••••••••',
                          hintStyle: TextStyle(color: Theme.of(context).dividerColor.withOpacity(0.7)),
                          prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).accentColor),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _con.hidePassword = !_con.hidePassword;
                              });
                            },
                            color: Theme.of(context).dividerColor,
                            icon: Icon(_con.hidePassword ? Icons.visibility : Icons.visibility_off),
                          ),
                          border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.2))),
                        ),
                      ),

                      SizedBox(height: 15),

                     // FlutterPasswordStrength(
                     //     password: _password,
                     //     strengthCallback: (strength){
                     //       debugPrint(strength.toString());
                     //     }
                     // ),

                      SizedBox(height: 10),

                      BlockButtonWidget(
                        text: AutoSizeText(
                          S.of(context).sign_up,
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          _con.register();
                        },
                      ),

//                      FlatButton(
//                        onPressed: () {
//                          Navigator.of(context).pushNamed('/MobileVerification');
//                        },
//                        padding: EdgeInsets.symmetric(vertical: 14),
//                        color: Theme.of(context).accentColor.withOpacity(0.1),
//                        shape: StadiumBorder(),
//                        child: AutoSizeText(
//                          'Register with Google',
//                          textAlign: TextAlign.start,
//                          style: TextStyle(
//                            color: Theme.of(context).accentColor,
//                          ),
//                        ),
//                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 45,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/Login');
                },
                textColor: Theme.of(context).hintColor,
                child: AutoSizeText(S.of(context).i_have_account_back_to_login),
              ),
            ),

            Positioned(
              bottom: 10,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/OtpTest');
                },
                textColor: Theme.of(context).hintColor,
                child: AutoSizeText(S.of(context).sign_up_with_mobile_number),
              ),
            )
          ],
        ),
      ),
 */
