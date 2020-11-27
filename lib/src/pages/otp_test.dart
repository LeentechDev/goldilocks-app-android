import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/services.dart';

import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';
import '../elements/BlockButtonWidget.dart';
import '../helpers/app_config.dart' as config;
import '../repository/user_repository.dart' as userRepo;
import 'package:firebase_auth/firebase_auth.dart';


class OTPTest extends StatefulWidget {
  @override
  _OTPTestState createState() => _OTPTestState();
}

class _OTPTestState extends StateMVC<OTPTest> {
  UserController _con;

  String phoneNo, smssent, verificationId;

  get verifiedSuccess => null;

  _OTPTestState() : super(UserController()) {
    _con = controller;
  }

  //Future<void> verfiyPhone() async{
  //  final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId){
  //    this.verificationId = verId;
  //  };
  //  final PhoneCodeSent smsCodeSent= (String verId, [int forceCodeResent]) {
  //    this.verificationId = verId;
  //    smsCodeDialog(context).then((value){
  //      print("Code Sent");
  //    });
  //  };
  //  final PhoneVerificationCompleted verifiedSuccess= (AuthCredential auth){};
  //  final PhoneVerificationFailed verifyFailed= (AuthException e){
  //    print('${e.message}');
  //  };
  //  await FirebaseAuth.instance.verifyPhoneNumber(
  //    phoneNumber: phoneNo,
  //    timeout: const Duration(seconds: 5),
  //    verificationCompleted : verifiedSuccess,
  //    verificationFailed: verifyFailed,
  //    codeSent: smsCodeSent,
  //    codeAutoRetrievalTimeout: autoRetrieve,
//
  //  );
//
  //}
  //Future<bool> smsCodeDialog(BuildContext context){
  //  return showDialog(context: context,
  //      barrierDismissible: false,
  //      builder: (BuildContext context){
  //        return new AlertDialog(
  //          title: AutoSizeText('Enter OTP'),
  //          content: TextField(
  //            onChanged: (value){
  //              this.smssent = value;
  //            },
  //          ),
  //          contentPadding: EdgeInsets.all(10.0),
  //          actions: <Widget>[
  //            FlatButton(
  //              onPressed: (){
  //                FirebaseAuth.instance.currentUser().then((user){
  //                  if(user != null){
  //                    Navigator.of(context).pop();
  //                    Navigator.of(context).pushReplacementNamed('/OtpTestResult');
  //                  }
  //                  else{
  //                    Navigator.of(context).pop();
  //                    signIn(smssent);
  //                  }
  //                });
  //              },
  //              child: AutoSizeText('Submit',
  //                style:TextStyle(color: Colors.black) ,),
  //            ),
  //          ],
//
  //        );
  //      }
  //  );
  //}






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
            Positioned(
              top: 0,
              child: Container(
                width: config.App(context).appWidth(100),
                height: config.App(context).appHeight(37),
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
            Positioned(
              top: config.App(context).appHeight(25) - 50,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 50,
                        color: Theme.of(context).hintColor.withOpacity(0.2),
                      )
                    ]),
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                padding:
                EdgeInsets.only(top: 50, right: 27, left: 27, bottom: 20),
                width: config.App(context).appWidth(88),
//              height: config.App(context).appHeight(55),
                child: Form(
                  key: _con.loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AutoSizeText(
                        S.of(context).phone,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),

                      SizedBox(height: 35),

                      TextFormField(
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(20),
                        ],
                        keyboardType: TextInputType.phone,
                        onChanged: (value){
                          this.phoneNo= value;
                        },
                        onSaved: (input) => _con.user.phone = input,
                        validator: (input) => !input.contains('@')
                            ? S.of(context).should_be_a_valid_email
                            : null,
                        decoration: InputDecoration(
                          //labelText: S.of(context).email,
                          labelStyle:
                          TextStyle(color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: 'Phone',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.7)),
                          prefixIcon: Icon(Icons.phone,
                              color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                        ),
                      ),


                      SizedBox(height: 30),
                      BlockButtonWidget(
                        text: AutoSizeText(
                          S.of(context).submit,
                          style:
                          TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        color: Theme.of(context).accentColor,
                        onPressed: () {}//verfiyPhone,
                      ),
                      SizedBox(height: 15),

                      // FlatButton(
                      //   onPressed: () {
                      //     Navigator.of(context)
                      //         .pushReplacementNamed('/Pages', arguments: 2);
                      //   },
                      //   shape: StadiumBorder(),
                      //   textColor: Theme.of(context).hintColor,
                      //   child: AutoSizeText(S.of(context).skip),
                      //   padding:
                      //       EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                      // ),
//                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),


            Positioned(
              bottom: 20,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      height: 1.0,
                      width: 300.0,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      AutoSizeText(
                        "Got an Account?  ",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/Login');
                        },
                        textColor: Colors.blue,
                        child: AutoSizeText(S.of(context).login),
                      ),
                    ],
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
