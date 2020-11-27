import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/src/controllers/controller.dart';

import '../../generated/l10n.dart';
import '../models/credit_card.dart';
import 'package:credit_card_validate/credit_card_validate.dart';

// ignore: must_be_immutable
class PaymentSettingsDialog extends StatefulWidget {
  CreditCard creditCard;
  VoidCallback onChanged;

  PaymentSettingsDialog({Key key, this.creditCard, this.onChanged})
      : super(key: key);

  @override
  _PaymentSettingsDialogState createState() => _PaymentSettingsDialogState();
}

class _PaymentSettingsDialogState extends State<PaymentSettingsDialog> {
  GlobalKey<FormState> _paymentSettingsFormKey = new GlobalKey<FormState>();
  // DateTime selectedDate = DateTime.now();

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       firstDate: DateTime(2020),
  //       lastDate: DateTime(2101));
  //   if (picked != null && picked != selectedDate)
  //     setState(() {
  //       selectedDate = picked;
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    var currDt = DateTime.now();
    final TextEditingController ccvalidator =
        new TextEditingController(text: widget.creditCard.expMonth);
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
                    key: _paymentSettingsFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          S.of(context).payment_settings,
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .merge(TextStyle(fontSize: 20)),
                        ),
                        SizedBox(height: 30),
                        new TextFormField(
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(16),
                          ],
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.number,
                          decoration: getInputDecoration(
                              hintText: '0000 0000 0000 0000',
                              labelText: S.of(context).number),
                          initialValue: widget.creditCard.number.isNotEmpty
                              ? widget.creditCard.number
                              : null,
                          validator: (input) => input.trim().length < 13
                              ? S.of(context).not_a_valid_number
                              : CreditCardValidator.isCreditCardValid(
                                      cardNumber: input)
                                  ? null
                                  : S.of(context).invalid_creditcard,
                          onSaved: (input) => widget.creditCard.number = input,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Container(
                        //   padding: const EdgeInsets.all(10.0),
                        //   decoration: BoxDecoration(

                        //     border: Border.all(
                        //       width: 0.5,
                        //       color: Theme.of(context).dividerColor),
                        //   ),
                        //                                 child: Row(
                        //     children: <Widget>[
                        //       Text ("${selectedDate.toLocal()}".split(' ')[0].replaceAll('-', '/')),

                        //                                                 // ('month/year',
                        //                                                 // style: TextStyle(
                        //                                                 //   color: Theme.of(context).hintColor
                        //                                                 // ),),
                        //       IconButton(icon: Icon(Icons.calendar_today,
                        //       color: Theme.of(context).accentColor),
                        //       onPressed: () => _selectDate(context),)
                        //     ],
                        //   ),
                        // ),

                        new Row(
                          children: <Widget>[
                            Container(
                              width: 90,
                              child: TextFormField(
                                  controller: ccvalidator,
                                  maxLength: 2,
                                  style: TextStyle(
                                      color: Theme.of(context).hintColor),
                                  keyboardType: TextInputType.datetime,
                                  decoration: getInputDecoration(
                                    hintText: 'mm',
                                    labelText: S.of(context).exp_month,
                                  ),
                                  // initialValue: widget
                                  //         .creditCard.expMonth.isNotEmpty
                                  //     ? widget.creditCard.expMonth
                                  //     : null,
                                  // TODO validate date
                                  validator: (input) => int.parse(input) > 12 ||
                                          input == null ||
                                          int.parse(input) < 1
                                      ? S.of(context).not_a_valid_number
                                      : null,
                                  onSaved: (input) {
                                    widget.creditCard.expMonth = input;
                                  }),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: AutoSizeText('/'),
                            ),
                            Container(
                              width: 90,
                              child: TextFormField(
                                  maxLength: 2,
                                  style: TextStyle(
                                      color: Theme.of(context).hintColor),
                                  keyboardType: TextInputType.datetime,
                                  decoration: getInputDecoration(
                                      hintText: 'yy',
                                      labelText: S.of(context).exp_year),
                                  initialValue:
                                      widget.creditCard.expMonth.isNotEmpty
                                          ? widget.creditCard.expYear
                                          : null,
                                  // TODO validate date
                                  validator: (input) => input == null
                                      ? S.of(context).not_a_valid_number
                                      : null,
                                  onSaved: (input) {
                                    widget.creditCard.expYear = input;
                                  }),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        new TextFormField(
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(3),
                          ],
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.number,
                          decoration: getInputDecoration(
                              hintText: '253', labelText: S.of(context).cvc),
                          initialValue: widget.creditCard.cvc.isNotEmpty
                              ? widget.creditCard.cvc
                              : null,
                          validator: (input) => input.trim().length != 3
                              ? S.of(context).not_a_valid_cvc
                              : null,
                          onSaved: (input) => widget.creditCard.cvc = input,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
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
                                onPressed: _submit,
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
                            SizedBox(
                              height: 20,
                            ),
                            FlatButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 40),
                              color: Colors.transparent,
                              shape: StadiumBorder(),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: AutoSizeText(S.of(context).cancel),
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
        });
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      counterText: '',
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

  //@override
  //Widget build(BuildContext context) {
  //  return FlatButton(
  //    onPressed: () {
  //      showDialog(
  //          context: context,
  //          builder: (context) {
  //            return SimpleDialog(
  //              contentPadding: EdgeInsets.symmetric(horizontal: 20),
  //              titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
  //              title: Row(
  //                children: <Widget>[
  //                  Icon(Icons.person),
  //                  SizedBox(width: 10),
  //                  AutoSizeText(
  //                    S.of(context).payment_settings,
  //                    style: Theme.of(context).textTheme.bodyText1,
  //                  )
  //                ],
  //              ),
  //              children: <Widget>[
  //                Form(
  //                  key: _paymentSettingsFormKey,
  //                  child: Column(
  //                    children: <Widget>[
  //                      new TextFormField(
  //                        style: TextStyle(color: Theme.of(context).hintColor),
  //                        keyboardType: TextInputType.number,
  //                        decoration: getInputDecoration(hintText: '4242 4242 4242 4242', labelText: S.of(context).number),
  //                        initialValue: widget.creditCard.number.isNotEmpty ? widget.creditCard.number : null,
  //                        validator: (input) => input.trim().length != 16 ? S.of(context).not_a_valid_number : null,
  //                        onSaved: (input) => widget.creditCard.number = input,
  //                      ),
  //                      new TextFormField(
  //                          style: TextStyle(color: Theme.of(context).hintColor),
  //                          keyboardType: TextInputType.datetime,
  //                          decoration: getInputDecoration(hintText: 'mm/yy', labelText: S.of(context).exp_date),
  //                          initialValue: widget.creditCard.expMonth.isNotEmpty ? widget.creditCard.expMonth + '/' + widget.creditCard.expYear : null,
  //                          // TODO validate date
  //                          validator: (input) => !input.contains('/') || input.length != 5 ? S.of(context).not_a_valid_date : null,
  //                          onSaved: (input) {
  //                            widget.creditCard.expMonth = input.split('/').elementAt(0);
  //                            widget.creditCard.expYear = input.split('/').elementAt(1);
  //                          }),
  //                      new TextFormField(
  //                        style: TextStyle(color: Theme.of(context).hintColor),
  //                        keyboardType: TextInputType.number,
  //                        decoration: getInputDecoration(hintText: '253', labelText: S.of(context).cvc),
  //                        initialValue: widget.creditCard.cvc.isNotEmpty ? widget.creditCard.cvc : null,
  //                        validator: (input) => input.trim().length != 3 ? S.of(context).not_a_valid_cvc : null,
  //                        onSaved: (input) => widget.creditCard.cvc = input,
  //                      ),
  //                    ],
  //                  ),
  //                ),
  //                SizedBox(height: 20),
  //                Row(
  //                  children: <Widget>[
  //                    MaterialButton(
  //                      onPressed: () {
  //                        Navigator.pop(context);
  //                      },
  //                      child: AutoSizeText(S.of(context).cancel),
  //                    ),
  //                    MaterialButton(
  //                      onPressed: _submit,
  //                      child: AutoSizeText(
  //                        S.of(context).save,
  //                        style: TextStyle(color: Theme.of(context).accentColor),
  //                      ),
  //                    ),
  //                  ],
  //                  mainAxisAlignment: MainAxisAlignment.end,
  //                ),
  //                SizedBox(height: 10),
  //              ],
  //            );
  //          });
  //    },
  //    child: AutoSizeText(
  //      S.of(context).edit,
  //      style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Theme.of(context).focusColor)),
  //    ),
  //  );
  //}
//
  //InputDecoration getInputDecoration({String hintText, String labelText}) {
  //  return new InputDecoration(
  //    hintText: hintText,
  //    labelText: labelText,
  //    hintStyle: Theme.of(context).textTheme.bodyText2.merge(
  //          TextStyle(color: Theme.of(context).focusColor),
  //        ),
  //    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
  //    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor)),
  //    floatingLabelBehavior: FloatingLabelBehavior.auto,
  //    labelStyle: Theme.of(context).textTheme.bodyText2.merge(
  //          TextStyle(color: Theme.of(context).hintColor),
  //        ),
  //  );
  //}

  void _submit() {
    if (_paymentSettingsFormKey.currentState.validate()) {
      _paymentSettingsFormKey.currentState.save();
      widget.onChanged();
      Navigator.pop(context);
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
                  width: MediaQuery.of(context).size.width - 50,
                  height: MediaQuery.of(context).size.height /1.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(20),
                  child: Material(
                    color: Colors.white,
                    child: SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 20),
                                            child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          AutoSizeText(
                            S.of(context).payment_settings,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .merge(TextStyle(fontSize: 20)),
                          ),
                          SizedBox(height: 30),
                          Form(
                            key: _paymentSettingsFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new TextFormField(
                                  inputFormatters: [
                           new LengthLimitingTextInputFormatter(16),
                         ],
                                  style: TextStyle(
                                      color: Theme.of(context).hintColor),
                                  keyboardType: TextInputType.number,
                                  decoration: getInputDecoration(
                                      hintText: '4242 4242 4242 4242',
                                      labelText: S.of(context).number),
                                  initialValue:
                                      widget.creditCard.number.isNotEmpty
                                            ? widget.creditCard.number
                                            : null,
                                  validator: (input) =>
                                  input.trim().length < 13
                                      ? S.of(context).not_a_valid_number
                                      : CreditCardValidator.isCreditCardValid(cardNumber: input) ?
                                      null : S.of(context).invalid_creditcard,
                                  onSaved: (input) =>
                                      widget.creditCard.number = input,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                // Container(
                                //   padding: const EdgeInsets.all(10.0),
                                //   decoration: BoxDecoration(

                                //     border: Border.all(
                                //       width: 0.5,
                                //       color: Theme.of(context).dividerColor),
                                //   ),
                                //                                 child: Row(
                                //     children: <Widget>[
                                //       Text ("${selectedDate.toLocal()}".split(' ')[0].replaceAll('-', '/')),

                                //                                                 // ('month/year',
                                //                                                 // style: TextStyle(
                                //                                                 //   color: Theme.of(context).hintColor
                                //                                                 // ),),
                                //       IconButton(icon: Icon(Icons.calendar_today,
                                //       color: Theme.of(context).accentColor),
                                //       onPressed: () => _selectDate(context),)
                                //     ],
                                //   ),
                                // ),

                                new Row(
                                  children: <Widget>[
                                    Container(
                                      width: 90,
                                      child: TextFormField(
                                        controller: ccvalidator,
                                            maxLength: 2,
                                            style: TextStyle(
                                                color: Theme.of(context).hintColor),
                                            keyboardType: TextInputType.datetime,
                                            decoration: getInputDecoration(
                                              hintText: 'mm',
                                              labelText: S.of(context).exp_month,
                                            ),
                                            // initialValue: widget
                                            //         .creditCard.expMonth.isNotEmpty
                                            //     ? widget.creditCard.expMonth
                                            //     : null,
                                            // TODO validate date
                                            validator: (input) => int.parse(input) >
                                                        12 || input == null ||
                                                    int.parse(input) < 1
                                                ? S.of(context).not_a_valid_number
                                                : null,
                                            onSaved: (input) {
                                              widget.creditCard.expMonth = input;
                                            }),
                                    ),
                                    Padding(
                                      padding:
                                            EdgeInsets.symmetric(horizontal: 30),
                                      child: AutoSizeText('/'),
                                    ),
                                    Container(
                                      width: 90,
                                      child: TextFormField(
                                            maxLength: 2,
                                            style: TextStyle(
                                                color: Theme.of(context).hintColor),
                                            keyboardType: TextInputType.datetime,
                                            decoration: getInputDecoration(
                                                hintText: 'yy',
                                                labelText: S.of(context).exp_year),
                                            initialValue: widget
                                                    .creditCard.expMonth.isNotEmpty
                                                ? widget.creditCard.expYear
                                                : null,
                                            // TODO validate date
                                            validator: (input) => input == null
                                                ? S.of(context).not_a_valid_number
                                                : null,
                                            onSaved: (input) {
                                              widget.creditCard.expYear = input;
                                            }),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                new TextFormField(
                                  inputFormatters: [
                           new LengthLimitingTextInputFormatter(3),
                         ],
                                  style: TextStyle(
                                      color: Theme.of(context).hintColor),
                                  keyboardType: TextInputType.number,
                                  decoration: getInputDecoration(
                                      hintText: '253',
                                      labelText: S.of(context).cvc),
                                  initialValue: widget.creditCard.cvc.isNotEmpty
                                      ? widget.creditCard.cvc
                                      : null,
                                  validator: (input) => input.trim().length != 3
                                      ? S.of(context).not_a_valid_cvc
                                      : null,
                                  onSaved: (input) =>
                                      widget.creditCard.cvc = input,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Positioned(
                                    child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
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
                                            onPressed: _submit,
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
                                      SizedBox(
                                        height: 20,
                                      ),
                                      FlatButton(
                                        padding: EdgeInsets.symmetric(
                                              vertical: 14, horizontal: 40),
                                        color: Colors.transparent,
                                        shape: StadiumBorder(),
                                        onPressed: () {
                                            Navigator.pop(context);
                                        },
                                        child: AutoSizeText(S.of(context).cancel),
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
      },
      child: AutoSizeText(
        S.of(context).edit,
        style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(
            color: Theme.of(context).focusColor, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
 */
