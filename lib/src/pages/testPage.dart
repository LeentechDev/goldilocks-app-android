import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/user_controller.dart';
import '../../generated/l10n.dart';
import '../Bloc/auth.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends StateMVC<TestPage> {
  UserController _con;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            width: MediaQuery.of(context).size.width - 40,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  'assets/custom_img/welcome_logo.svg',
                  width: 150,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Text('Welcome to the Goldilocks App', style: Theme.of(context).textTheme.headline4,),
                ),

                Form(
                  //key: _con.loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      FocusScope(
                        canRequestFocus: false,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          initialValue: name,
                          onSaved: (input) => _con.user.name = input,
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
                                    color: Colors.transparent)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent)),
                          ),
                        ),
                      ),

                      FocusScope(
                        canRequestFocus: false,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          initialValue: email,
                          onSaved: (input) => _con.user.email = input,
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
                                    color: Colors.transparent)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent)),
                          ),
                        ),
                      ),


                    ],
                  ),

                ),


              ],
            )),
      ),
    );
  }
}


/*
Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              AutoSizeText(
                uID,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              AutoSizeText(
                'NAME',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              AutoSizeText(
                name,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              AutoSizeText(
                'EMAIL',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              AutoSizeText(
                email,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              RaisedButton(
                onPressed: () {
                  signOutGoogle();
                  Navigator.of(context).pushNamed('/Login');
                },
                color: Colors.deepPurple,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    'Sign Out',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
              ),
            ],
          ),
        ),
      ),
 */
