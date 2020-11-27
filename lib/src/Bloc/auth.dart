import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_delivery_app/src/Bloc/shared_pref.dart';
import 'package:food_delivery_app/src/elements/BlockButtonWidget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';

import '../controllers/user_controller.dart';

import '../Bloc/Providers.dart';
import '../models/user_model.dart';
import '../repository/user_repository.dart' as userRepo;

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final FacebookLogin fbLogin = new FacebookLogin();
UserController _con;

bool isFacebookLoginIn = false;
String errorMessage = '';
String successMessage = '';

String name;
String email;
String googleID;

get verifiedSuccess => null;

final SharedPrefs prefs = SharedPrefs();
UserModel _userModel;

Future<String> signInWithGoogle(BuildContext context) async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;
  print("Email: " + user.toString());

  // Checking if email and name is null
  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);

  Providers userDetailsProvider =
      Provider.of<Providers>(context, listen: false);

  userDetailsProvider.setNameValue(user.displayName);
  userDetailsProvider.setEmailValue(user.email);
  userDetailsProvider.setGIDValue(user.uid);

  prefs.setStringFname(user.displayName);
  prefs.setStringEmail(user.email);
  prefs.setStringGiD(user.uid);

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  return 'signInWithGoogle succeeded: $user';
}

void signOutGoogle() async {
  await googleSignIn.signOut();
  print("User Sign Out");
}

Future<FirebaseUser> facebookLogin(BuildContext context) async {
  FirebaseUser currentUser;
  fbLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
  // if you remove above comment then facebook login will take username and password for login in Webview
  try {
    final FacebookLoginResult facebookLoginResult =
        await fbLogin.logIn(['email', 'public_profile']);
    if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
      FacebookAccessToken facebookAccessToken = facebookLoginResult.accessToken;
      final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: facebookAccessToken.token);
      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      Providers userDetailsProvider =
          Provider.of<Providers>(context, listen: false);

      userDetailsProvider.setNameValue(user.displayName);
      userDetailsProvider.setEmailValue(user.email);
      userDetailsProvider.setGIDValue(user.uid);

      return currentUser;
    }
  } catch (e) {
    print(e);
  }
  return currentUser;
}

void signOutFacebook() async {
  await fbLogin.logOut();
  print("User Sign Out");
}

Future<UserModel> createUser(String name, String email, String password) async {
  final String apiUrl = "https://goldilocks.ml/api/register";
  final response = await http.post(apiUrl, body: {
    "name": name,
    "email": email,
    "password": password,
  });
  if (response.statusCode == 201) {
    final String responseString = response.body;
    return userModelFromJson(responseString);
  } else {
    print("Failed: " + response.body);
  }
}

Future<bool> phoneAuth(String phone, BuildContext context) async {
  final _codeController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async {
        Navigator.of(context).pop();

        AuthResult result = await _auth.signInWithCredential(credential);

        FirebaseUser user = result.user;

        if (user != null) {
          Navigator.of(context).pushReplacementNamed('/GetLocation');
          print('Success');
        } else {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 400,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SvgPicture.asset(
                            'assets/custom_img/question_dialog_icon.svg',
                            width: 100,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: AutoSizeText(
                              'This Phone number is in use, Please use another number instead',
                              style: Theme.of(context).textTheme.headline4,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: BlockButtonWidget(
                              color: Theme.of(context).accentColor,
                              text: AutoSizeText('Okay'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        }
      },

      //This callback would gets called when verification is done automatically

      verificationFailed: (AuthException exception) {
        String errorMsg;
        if(exception.code == 'invalidCredential'){
          errorMsg = "Invalid format \nthe format must be like , \n[+][Country Code][Phone Number] \ne.g +63 966 237 4764";
        }
        else{
          String errorMsg =  exception.message;
        }
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SvgPicture.asset(
                        'assets/custom_img/question_dialog_icon.svg',
                        width: 100,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: AutoSizeText(
                          errorMsg,
                          style: Theme.of(context).textTheme.headline4,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: BlockButtonWidget(
                          color: Theme.of(context).accentColor,
                          text: AutoSizeText('Okay'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              );
            });
      },
      codeSent: (String verificationId, [int forceResendingToken]) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SvgPicture.asset(
                        'assets/custom_img/welcome_logo.svg',
                        width: 100,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      AutoSizeText(
                        'Almost Done',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .merge(TextStyle(fontSize: 30)),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AutoSizeText(
                        'Please Enter the 6 digit code that we sent you',
                        style: Theme.of(context).textTheme.caption,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextField(
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(6),
                        ],
                        textAlign: TextAlign.center,
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          //labelText: S.of(context).email,
                          labelStyle:
                          TextStyle(color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: '000000',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .dividerColor
                                  .withOpacity(0.7)),
                          //prefixIcon: Icon(Icons.phone,
                          //    color: Theme.of(context).accentColor),
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
                      SizedBox(
                        height: 25,
                      ),
                      BlockButtonWidget(
                        color: Theme.of(context).accentColor,
                        text: AutoSizeText('Finish'),
                        onPressed: () async {
                          final code = _codeController.text.trim();
                          AuthCredential credential =
                          PhoneAuthProvider.getCredential(
                              verificationId: verificationId,
                              smsCode: code);

                          AuthResult result =
                          await _auth.signInWithCredential(credential);

                          FirebaseUser user = result.user;

                          if (user != null) {
                            final Providers phoneProvider =
                            Provider.of<Providers>(context,
                                listen: false);
                            String phone = phoneProvider.Phone.toString();
                            userRepo.updateUserPhone(phone);
                            Navigator.of(context)
                                .pushReplacementNamed('/GetLocation');
                          } else {
                            print("Error");
                          }
                        },
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              );
            });

        /*
       Scaffold(
                appBar: AppBar(
                  leading: Icon(Icons.arrow_back),
                  title: Text('Verify'),
                ),
                body: Column(
                  children: <Widget>[
                    TextField(
                      controller: _codeController,
                    ),
                    FlatButton(
                      child: Text("Confirm"),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async {
                        final code = _codeController.text.trim();
                        AuthCredential credential =
                        PhoneAuthProvider.getCredential(
                            verificationId: verificationId, smsCode: code);
                        AuthResult result =
                        await _auth.signInWithCredential(credential);
                        FirebaseUser user = result.user;
                        if (user != null) {
                          Navigator.of(context).pushReplacementNamed('');
                        } else {
                          print("Error");
                        }
                      },
                    )
                  ],
                ),
              );
         */
      },
      codeAutoRetrievalTimeout: null);
}
