import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/repository/user_repository.dart';

import '../../generated/l10n.dart';
import '../models/user.dart';
import '../controllers/settings_controller.dart';

class ChangePasswordDialog extends StatefulWidget {
  final User user;
  final VoidCallback onChanged;

  ChangePasswordDialog({Key key, this.user, this.onChanged}) : super(key: key);

  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  GlobalKey<FormState> _changePasswordFormKey = new GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _newconfirmPass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final RegExp _passwordRegex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: AutoSizeText(
        S.of(context).edit,
        style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(
            color: Theme.of(context).focusColor,
            fontWeight: FontWeight.bold,
            fontSize: 16)),
      ),
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                child: Form(
                  key: _changePasswordFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        S.of(context).change_password,
                        style: Theme.of(context).textTheme.headline4.merge(
                            TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: 30),
                      new TextFormField(
                          controller: _pass,
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                              hintText: '',
                              labelText: S.of(context).old_password),
                          obscureText: true,
                          validator: (input) => input.trim().length < 3
                              ? S.of(context).dont_leave_it_blank
                              : null,
                          onSaved: (input) {
                            widget.user.password = input;
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      new TextFormField(
                        controller: _newconfirmPass,
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(
                            labelText: S.of(context).new_password),
                        validator: (input) => input.isEmpty
                            ? S.of(context).dont_leave_it_blank
                            : _passwordRegex.hasMatch(input) == false
                                ? S.of(context).password_must_contain
                                : null,
                        // onSaved: (input) {
                        // widget.user.newpassword = input;
                        // }
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      new TextFormField(
                          controller: _confirmPass,
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                              labelText: S.of(context).confirm_password),
                          validator: (input) => input.isEmpty
                              ? S.of(context).dont_leave_it_blank
                              : _newconfirmPass.text != _confirmPass.text
                                  ? S.of(context).password_dont_match
                                  : _passwordRegex.hasMatch(input) == false
                                      ? S.of(context).password_must_contain
                                      : null,
                          onSaved: (input) {
                            widget.user.newpassword = input;
                          }),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            color: Theme.of(context)
                                .primaryColor
                                .withAlpha(200),
                            shape: StadiumBorder(),
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 40),
                            onPressed: () {
                              _pass.text = '';
                              _confirmPass.text = '';
                              _newconfirmPass.text = '';
                              Navigator.pop(context);
                            },
                            child: AutoSizeText(S.of(context).cancel),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2),
                                    blurRadius: 15,
                                    offset: Offset(0, 15)),
                                BoxShadow(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2),
                                    blurRadius: 5,
                                    offset: Offset(0, 3))
                              ],
                              borderRadius:
                              BorderRadius.all(Radius.circular(100)),
                            ),
                            child: FlatButton(
                              onPressed: () {
                                _changepassword(currentUser);
                              },
                              padding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 40),
                              color: Theme.of(context).accentColor,
                              shape: StadiumBorder(),
                              child: AutoSizeText(
                                S.of(context).save,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Theme.of(context).hintColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
      border: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).dividerColor.withOpacity(0.2))),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).accentColor.withOpacity(0.5))),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).dividerColor.withOpacity(0.2))),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void _changepassword(ValueNotifier<User> currentUser) {
    if (_changePasswordFormKey.currentState.validate()) {
      _changePasswordFormKey.currentState.save();
      widget.onChanged();
      Navigator.pop(context);
      changepassword(currentUser.value);
      _pass.text = '';
      _confirmPass.text = '';
      _newconfirmPass.text = '';
    }
  }
}

/*
showGeneralDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel:
                MaterialLocalizations.of(context).modalBarrierDismissLabel,
            barrierColor: Colors.black45,
            transitionDuration: const Duration(milliseconds: 200),
            pageBuilder: (BuildContext buildContext, Animation animation,
                Animation secondaryAnimation) {
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width - 60,
                  height: MediaQuery.of(context).size.height /1.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(20),
                  child: Material(
                    color: Colors.white,
                    child: SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 40.0),
                                            child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Form(
                            key: _changePasswordFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                AutoSizeText(
                                  S.of(context).change_password,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .merge(TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(height: 30),
                                new TextFormField(
                                  controller: _pass,
                                  style: TextStyle(
                                      color: Theme.of(context).hintColor),
                                  keyboardType: TextInputType.text,
                                  decoration: getInputDecoration(
                                      hintText: '',
                                      labelText: S.of(context).old_password),
                                  obscureText: true,
                                  validator: (input) => input.trim().length < 3
                                      ? S.of(context).dont_leave_it_blank
                                      : null,
                                      onSaved: (input) {
                                      widget.user.password = input;
                                      }
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                new TextFormField(
                                  controller: _newconfirmPass,
                                  style: TextStyle(
                                      color: Theme.of(context).hintColor),
                                  keyboardType: TextInputType.text,
                                  decoration: getInputDecoration(
                                      labelText: S.of(context).new_password),
                                  validator: (input) => input.isEmpty
                                      ? S.of(context).dont_leave_it_blank
                                      : _passwordRegex.hasMatch(input) == false
                                      ? S.of(context).password_must_contain
                                      : null,
                                      // onSaved: (input) {
                                      // widget.user.newpassword = input;
                                      // }
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                new TextFormField(
                                  controller: _confirmPass,
                                  style: TextStyle(
                                      color: Theme.of(context).hintColor),
                                  keyboardType: TextInputType.text,
                                  decoration: getInputDecoration(
                                      labelText: S.of(context).confirm_password),
                                  validator: (input) => input.isEmpty
                                      ? S.of(context).dont_leave_it_blank
                                      : _newconfirmPass.text != _confirmPass.text
                                      ? S.of(context).password_dont_match
                                      : _passwordRegex.hasMatch(input) == false
                                      ? S.of(context).password_must_contain
                                      : null,
                                      onSaved: (input) {
                                      widget.user.newpassword = input;
                                      }
                                ),

                                SizedBox(
                                  height: 30,
                                ),
                                Positioned(
                                    child: Container(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      FlatButton(
                                        color: Theme.of(context)
                                              .primaryColor
                                              .withAlpha(200),
                                        shape: StadiumBorder(),
                                        padding: EdgeInsets.symmetric(
                                              vertical: 14, horizontal: 40),
                                        onPressed: () {
                                          _pass.text = '';
                                          _confirmPass.text = '';
                                          _newconfirmPass.text = '';
                                            Navigator.pop(context);
                                        },
                                        child: AutoSizeText(S.of(context).cancel),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Theme.of(context)
                                                      .accentColor
                                                      .withOpacity(0.2),
                                                  blurRadius: 15,
                                                  offset: Offset(0, 15)),
                                              BoxShadow(
                                                  color: Theme.of(context)
                                                      .accentColor
                                                      .withOpacity(0.2),
                                                  blurRadius: 5,
                                                  offset: Offset(0, 3))
                                            ],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100)),
                                        ),
                                        child: FlatButton(
                                            onPressed:(){
                                                 _changepassword(currentUser);
                                            },
                                            padding: EdgeInsets.symmetric(
                                                vertical: 14, horizontal: 40),
                                            color: Theme.of(context).accentColor,
                                            shape: StadiumBorder(),
                                            child: AutoSizeText(
                                              S.of(context).save,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color:
                                                      Theme.of(context).hintColor),
                                            ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                                          ),
                    ),
                  ),
                ),
              );
            });
        //showDialog(
        //    context: context,
        //    builder: (context) {
        //      return SimpleDialog(
        //        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        //        titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        //        title: Row(
        //          children: <Widget>[
        //            AutoSizeText(
        //              S.of(context).edit_profile,
        //              style: Theme.of(context).textTheme.headline4,
        //            )
        //          ],
        //        ),
        //        children: <Widget>[
        //          Form(
        //            key: _changePasswordFormKey,
        //            child: Column(
        //              children: <Widget>[
        //                new TextFormField(
        //                  style: TextStyle(color: Theme.of(context).hintColor),
        //                  keyboardType: TextInputType.text,
        //                  decoration: getInputDecoration(hintText: S.of(context).john_doe, labelText: S.of(context).full_name),
        //                  initialValue: widget.user.name,
        //                  validator: (input) => input.trim().length < 3 ? S.of(context).not_a_valid_full_name : null,
        //                  onSaved: (input) => widget.user.name = input,
        //                ),
        //                new TextFormField(
        //                  style: TextStyle(color: Theme.of(context).hintColor),
        //                  keyboardType: TextInputType.emailAddress,
        //                  decoration: getInputDecoration(hintText: 'johndo@gmail.com', labelText: S.of(context).email_address),
        //                  initialValue: widget.user.email,
        //                  validator: (input) => !input.contains('@') ? S.of(context).not_a_valid_email : null,
        //                  onSaved: (input) => widget.user.email = input,
        //                ),
        //                new TextFormField(
        //                  style: TextStyle(color: Theme.of(context).hintColor),
        //                  keyboardType: TextInputType.text,
        //                  decoration: getInputDecoration(hintText: '+136 269 9765', labelText: S.of(context).phone),
        //                  initialValue: widget.user.phone,
        //                  validator: (input) => input.trim().length < 3 ? S.of(context).not_a_valid_phone : null,
        //                  onSaved: (input) => widget.user.phone = input,
        //                ),
        //                new TextFormField(
        //                  style: TextStyle(color: Theme.of(context).hintColor),
        //                  keyboardType: TextInputType.text,
        //                  decoration: getInputDecoration(hintText: S.of(context).your_address, labelText: S.of(context).address),
        //                  initialValue: widget.user.address,
        //                  validator: (input) => input.trim().length < 3 ? S.of(context).not_a_valid_address : null,
        //                  onSaved: (input) => widget.user.address = input,
        //                ),
        //                new TextFormField(
        //                  style: TextStyle(color: Theme.of(context).hintColor),
        //                  keyboardType: TextInputType.text,
        //                  decoration: getInputDecoration(hintText: S.of(context).your_biography, labelText: S.of(context).about),
        //                  initialValue: widget.user.bio,
        //                  validator: (input) => input.trim().length < 3 ? S.of(context).not_a_valid_biography : null,
        //                  onSaved: (input) => widget.user.bio = input,
        //                ),
        //              ],
        //            ),
        //          ),
        //          SizedBox(height: 20),
        //          Row(
        //            children: <Widget>[
        //              MaterialButton(
        //                onPressed: () {
        //                  Navigator.pop(context);
        //                },
        //                child: AutoSizeText(S.of(context).cancel),
        //              ),
        //              MaterialButton(
        //                onPressed: _submit,
        //                child: AutoSizeText(
        //                  S.of(context).save,
        //                  style: TextStyle(color: Theme.of(context).accentColor),
        //                ),
        //              ),
        //            ],
        //            mainAxisAlignment: MainAxisAlignment.end,
        //          ),
        //          SizedBox(height: 10),
        //        ],
        //      );
        //    });
      },
      child: AutoSizeText(
        S.of(context).edit,
        style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(
            color: Theme.of(context).focusColor, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
 */
