import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../generated/l10n.dart';
import '../models/user.dart';
import '../Bloc/shared_pref.dart';
import 'package:provider/provider.dart';
import '../Bloc/Providers.dart';
import '../repository/settings_repository.dart' as settingsRepo;

class ProfileSettingsDialog extends StatefulWidget {
  final User user;
  final VoidCallback onChanged;

  ProfileSettingsDialog({Key key, this.user, this.onChanged}) : super(key: key);

  @override
  _ProfileSettingsDialogState createState() => _ProfileSettingsDialogState();
}

class _ProfileSettingsDialogState extends State<ProfileSettingsDialog> {
  GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var name = widget.user.name ?? "";
    var trimedleft = name.lastIndexOf(' ');
    var resultleft = (trimedleft != -1) ? name.substring(0, trimedleft) : name;
    var initialleft = resultleft.trimRight();
    var trimedright = name.lastIndexOf(' ');
    var resultright = (trimedright != -1) ? name.substring(trimedright) : name;

    final fNameController = TextEditingController(text: initialleft);
    return FlatButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  child: Form(
                    key: _profileSettingsFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AutoSizeText(
                          S.of(context).edit_profile,
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .merge(TextStyle(fontSize: 20)),
                        ),
                        SizedBox(height: 30),
                        new TextFormField(
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(25),
                          ],
                          controller: fNameController,
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                              hintText: resultleft ?? "",
                              labelText: S.of(context).first_name),
                          validator: (input) => input.trim().length < 3
                              ? S.of(context).not_a_valid_first_name
                              : null,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        new TextFormField(
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(25),
                            ],
                            style: TextStyle(color: Theme.of(context).hintColor),
                            keyboardType: TextInputType.text,
                            decoration: getInputDecoration(
                                hintText: 'Doe',
                                labelText: S.of(context).last_name),
                            initialValue: resultright ?? "",
                            validator: (input) => input.trim().length < 3
                                ? S.of(context).not_a_valid_last_name
                                : null,
                            onSaved: (input) => widget.user.name =
                                fNameController.text + " " + input),
                        SizedBox(
                          height: 20,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.phone,
                          decoration: getInputDecoration(
                              hintText: S.of(context).phone_number,
                              labelText: S.of(context).phone_number),
                          validator: (input) => input.trim().length < 3
                              ? S.of(context).not_a_valid_phone
                              : null,
                          initialValue: widget.user.phone ?? "",
                          onSaved: (input) => widget.user.phone = input,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.emailAddress,
                          decoration: getInputDecoration(
                              hintText: S.of(context).email,
                              labelText: S.of(context).email),
                          initialValue: widget.user.email ?? "",
                          validator: (input) => !input.contains('@')
                              ? S.of(context).not_a_valid_email
                              : null,
                          onSaved: (input) => widget.user.email = input,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        new TextFormField(
                          enabled: false,
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                              hintText: S.of(context).your_address,
                              labelText: S.of(context).address),
                          initialValue:
                          settingsRepo.deliveryAddress.value?.address ?? "",
                          validator: (input) => input.trim().length < 3
                              ? S.of(context).not_a_valid_address
                              : null,
                          onSaved: (input) => widget.user.address = input,
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              //decoration: BoxDecoration(
                              //  boxShadow: [
                              //    BoxShadow(
                              //        color: Theme.of(context)
                              //            .dividerColor
                              //            .withOpacity(0.2),
                              //        blurRadius: 15,
                              //        offset: Offset(0, 15)),
                              //    BoxShadow(
                              //        color: Theme.of(context)
                              //            .dividerColor
                              //            .withOpacity(0.2),
                              //        blurRadius: 5,
                              //        offset: Offset(0, 3))
                              //  ],
                              //  borderRadius: BorderRadius.all(
                              //      Radius.circular(100)),
                              //),
                              child: FlatButton(
                                //color: Theme.of(context).primaryColor.withAlpha(200),
                                //shape: StadiumBorder(),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                padding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 40),
                                child: AutoSizeText(S.of(context).cancel),
                              ),
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
                                  _submit();
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
            });
      },
      child: AutoSizeText(
        S.of(context).edit,
        style: Theme.of(context).textTheme.bodyText2.merge(
              TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
      ),
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

  void _submit() {
    if (_profileSettingsFormKey.currentState.validate()) {
      _profileSettingsFormKey.currentState.save();

      widget.onChanged();
      Navigator.of(context).pushReplacementNamed('/Pages', arguments: 3);
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Container(

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(20),
                    child: Material(
                      color: Colors.white,
                      child: SingleChildScrollView(
                                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Form(
                              key: _profileSettingsFormKey,
                              child: Padding(
                                padding: const EdgeInsets.only(top:20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    AutoSizeText(
                                      S.of(context).edit_profile,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .merge(TextStyle(fontSize: 20)),
                                    ),
                                    SizedBox(height: 30),

                                    new TextFormField(
                                      inputFormatters: [
                             new LengthLimitingTextInputFormatter(25),
                           ],
                                      controller: fNameController,
                                      style: TextStyle(
                                          color: Theme.of(context).hintColor),
                                      keyboardType: TextInputType.text,
                                      decoration: getInputDecoration(
                                          hintText: resultleft,
                                          labelText: S.of(context).first_name),
                                      validator: (input) => input.trim().length < 3
                                          ? S.of(context).not_a_valid_first_name
                                          : null,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    new TextFormField(
                                      inputFormatters: [
                             new LengthLimitingTextInputFormatter(25),
                           ],
                                      style: TextStyle(
                                          color: Theme.of(context).hintColor),
                                      keyboardType: TextInputType.text,
                                      decoration: getInputDecoration(
                                          hintText: 'Doe',
                                          labelText: S.of(context).last_name),
                                          initialValue: resultright,
                                      validator: (input) => input.trim().length < 3
                                          ? S.of(context).not_a_valid_last_name
                                          : null,
                                      onSaved: (input) => widget.user.name = fNameController.text + " " + input
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    new TextFormField(
                                      controller: _phoneController,
                                      style: TextStyle(
                                          color: Theme.of(context).hintColor),
                                      keyboardType: TextInputType.text,
                                      decoration: getInputDecoration(
                                          hintText: S.of(context).phone_number,
                                          labelText: S.of(context).phone_number),
                                      validator: (input) => input.trim().length < 3
                                          ? S.of(context).not_a_valid_phone
                                          : null,
                                      onSaved: (input) => widget.user.phone = input,
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    new TextFormField(
                                      style: TextStyle(
                                          color: Theme.of(context).hintColor),
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: getInputDecoration(
                                          hintText: S.of(context).email,
                                          labelText: S.of(context).email),
                                          initialValue: widget.user.email,
                                      validator: (input) => !input.contains('@')
                                          ? S.of(context).not_a_valid_email
                                          : null,
                                      onSaved: (input) => widget.user.email = input,
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    new TextFormField(
                                      enabled: false,
                                      style: TextStyle(
                                          color: Theme.of(context).hintColor),
                                      keyboardType: TextInputType.text,
                                      decoration: getInputDecoration(
                                          hintText: S.of(context).your_address,
                                          labelText: S.of(context).address),
                                      initialValue: settingsRepo
                                          .deliveryAddress.value?.address ??
                                          null,
                                      validator: (input) => input.trim().length < 3
                                          ? S.of(context).not_a_valid_address
                                          : null,
                                      onSaved: (input) =>
                                      widget.user.address = input,
                                    ),
                                    SizedBox(
                                      height : 30
                                    ),
                                    Positioned(
                                        child: Container(
                                      alignment: Alignment.bottomRight,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            //decoration: BoxDecoration(
                                            //  boxShadow: [
                                            //    BoxShadow(
                                            //        color: Theme.of(context)
                                            //            .dividerColor
                                            //            .withOpacity(0.2),
                                            //        blurRadius: 15,
                                            //        offset: Offset(0, 15)),
                                            //    BoxShadow(
                                            //        color: Theme.of(context)
                                            //            .dividerColor
                                            //            .withOpacity(0.2),
                                            //        blurRadius: 5,
                                            //        offset: Offset(0, 3))
                                            //  ],
                                            //  borderRadius: BorderRadius.all(
                                            //      Radius.circular(100)),
                                            //),
                                            child: FlatButton(
                                              //color: Theme.of(context).primaryColor.withAlpha(200),
                                              //shape: StadiumBorder(),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 14, horizontal: 40),
                                              child: AutoSizeText(S.of(context).cancel),
                                            ),
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
                                              onPressed: (){
                                                final SharedPrefs prefs = SharedPrefs();
                                                prefs.setStringPhone(_phoneController.text);
                                                _submit();
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            });

        /*@override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
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
                  height: MediaQuery.of(context).size.height - 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(20),
                  child: Material(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[

                        Form(
                          key: _profileSettingsFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              AutoSizeText(
                                S.of(context).edit_profile,
                                style: Theme.of(context).textTheme.headline4.merge(TextStyle(fontSize: 20)),
                              ),
                              SizedBox(height: 30),
                              new TextFormField(
                                style: TextStyle(
                                    color: Theme.of(context).hintColor),
                                keyboardType: TextInputType.text,
                                decoration: getInputDecoration(
                                    hintText: S.of(context).john_doe,
                                    labelText: S.of(context).full_name),
                                initialValue: widget.user.name,
                                validator: (input) => input.trim().length < 3
                                    ? S.of(context).not_a_valid_full_name
                                    : null,
                                onSaved: (input) => widget.user.name = input,
                              ),
                              SizedBox(height: 20,),
                              new TextFormField(
                                style: TextStyle(
                                    color: Theme.of(context).hintColor),
                                keyboardType: TextInputType.emailAddress,
                                decoration: getInputDecoration(
                                    hintText: 'johndo@gmail.com',
                                    labelText: S.of(context).email_address),
                                initialValue: widget.user.email,
                                validator: (input) => !input.contains('@')
                                    ? S.of(context).not_a_valid_email
                                    : null,
                                onSaved: (input) => widget.user.email = input,
                              ),
                              SizedBox(height: 20,),
                              new TextFormField(
                                style: TextStyle(
                                    color: Theme.of(context).hintColor),
                                keyboardType: TextInputType.text,
                                decoration: getInputDecoration(
                                    hintText: '+136 269 9765',
                                    labelText: S.of(context).phone),
                                initialValue: widget.user.phone,
                                validator: (input) => input.trim().length < 3
                                    ? S.of(context).not_a_valid_phone
                                    : null,
                                onSaved: (input) => widget.user.phone = input,
                              ),
                              SizedBox(height: 10,),
                              new TextFormField(
                                style: TextStyle(
                                    color: Theme.of(context).hintColor),
                                keyboardType: TextInputType.text,
                                decoration: getInputDecoration(
                                    hintText: S.of(context).your_address,
                                    labelText: S.of(context).address),
                                initialValue: widget.user.address,
                                validator: (input) => input.trim().length < 3
                                    ? S.of(context).not_a_valid_address
                                    : null,
                                onSaved: (input) => widget.user.address = input,
                              ),
                              SizedBox(height: 20,),
                              //new TextFormField(
                              //  style: TextStyle(
                              //      color: Theme.of(context).hintColor),
                              //  keyboardType: TextInputType.text,
                              //  decoration: getInputDecoration(
                              //      hintText: S.of(context).your_biography,
                              //      labelText: S.of(context).about),
                              //  initialValue: widget.user.bio,
                              //  validator: (input) => input.trim().length < 3
                              //      ? S.of(context).not_a_valid_biography
                              //      : null,
                              //  onSaved: (input) => widget.user.bio = input,
                              //),

                              Positioned(
                                child: Container(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: AutoSizeText(S.of(context).cancel),
                                      ),

                                      SizedBox(width: 20,),
                                      FlatButton(
                                        onPressed: _submit,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 14, horizontal: 20),
                                        color:
                                        Theme.of(context).accentColor,
                                        shape: StadiumBorder(),
                                        child: AutoSizeText(
                                          S.of(context).save,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .hintColor),
                                        ),
                                      ),
                                    ],

                                  ),
                                )
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              );
            });*/
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
        //            key: _profileSettingsFormKey,
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
        style: Theme.of(context).textTheme.bodyText2.merge(
              TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
            ),
      ),
    );
 */
