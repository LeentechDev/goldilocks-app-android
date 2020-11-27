import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:country_list_pick/country_list_pick.dart';

import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';
import '../elements/BlockButtonWidget.dart';
import '../Bloc/auth.dart';
import '../Bloc/Providers.dart';
import '../Bloc/shared_pref.dart';
import '../repository/user_repository.dart' as userRepo;
import '../elements/slide_transition.dart';
import '../helpers/app_config.dart' as config;

class OTPPart extends StatefulWidget {
  @override
  _OTPPartState createState() => _OTPPartState();
}

String initialCode = "+1";

class _OTPPartState extends StateMVC<OTPPart> {
  UserController _con;

  final _phoneController = TextEditingController();

  _OTPPartState() : super(UserController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    Pattern pattern = r'^\+?\d*$';
    RegExp regex = new RegExp(pattern);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          key: _con.scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: AutoSizeText(S.of(context).sign_up),
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 5),
              child: StepProgressIndicator(
                totalSteps: 3,
                currentStep: 2,
                selectedColor: Theme.of(context).accentColor,
                unselectedColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          body: ListView(children: <Widget>[
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    AutoSizeText(
                      S.of(context).what_is_your_phone_number,
                      style: TextStyle(
                          color: Theme.of(context).hintColor, fontSize: 30),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AutoSizeText(
                      S.of(context).you_can_also_use_this,
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Form(
                      key: _con.loginFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AutoSizeText(
                            "Phone Number",
                            style: Theme.of(context).textTheme.caption.merge(
                                TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black)),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              CountryListPick(
                                appBar: AppBar(
                                  backgroundColor: Colors.amber,
                                  title: Text('Select Country'),
                                ),
                                pickerBuilder:
                                    (context, CountryCode countryCode) {
                                  return Container(
                                    padding: EdgeInsets.all(9),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)),
                                      color: Theme.of(context).accentColor,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          countryCode.flagUri,
                                          package: 'country_list_pick',
                                          width: 30,
                                          height: 30,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(countryCode.dialCode),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(Icons.keyboard_arrow_down),
                                      ],
                                    ),
                                  );
                                },
                                theme: CountryTheme(
                                  isShowFlag: true,
                                  isShowTitle: false,
                                  isShowCode: true,
                                  isDownIcon: true,
                                  showEnglishName: true,
                                ),
                                initialSelection: '+1',
                                onChanged: (CountryCode code) {
                                  setState(() {
                                    initialCode = code.dialCode;
                                  });
                                  print("initialCode: $initialCode");
                                  print(code.name);
                                  print(code.code);
                                  print(code.dialCode);
                                  print(code.flagUri);
                                },
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 1.8,
                                child: TextFormField(
                                  inputFormatters: [
                                    new LengthLimitingTextInputFormatter(20),
                                  ],
                                  keyboardType: TextInputType.phone,
                                  controller: _phoneController,
                                  onSaved: (input) => _con.user.phone = input,
                                  validator: (input) => input == ""
                                      ? S
                                          .of(context)
                                          .please_enter_a_valid_phone_number
                                      : input.length <= 10
                                          ? S
                                              .of(context)
                                              .please_enter_a_valid_phone_number
                                          : null,
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                        color: Theme.of(context).accentColor),
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: '000 000 0000',
                                    hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .dividerColor
                                            .withOpacity(0.7)),
                                    //prefixIcon: Icon(Icons.phone,
                                    //    color: Theme.of(context).accentColor),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .dividerColor
                                                .withOpacity(0.2))),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .accentColor
                                                .withOpacity(0.5))),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .dividerColor
                                                .withOpacity(0.2))),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    BlockButtonWidget(
                        text: AutoSizeText(
                          S.of(context).next,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        color:
                            Color(0xff313030), //Theme.of(context).accentColor,
                        onPressed: () {
                          final Providers phoneProvider =
                              Provider.of<Providers>(context, listen: false);
                          final SharedPrefs prefs = SharedPrefs();
                          final phone =
                              initialCode + _phoneController.text.trim();
                          prefs.setStringPhone(phone);
                          phoneProvider.setPhoneValue(phone);
                          _con.registerPhone(phone);
                        } //verfiyPhone,
                        ),
                  ],
                ))
          ])),
    );
  }
}
