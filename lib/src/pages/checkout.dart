import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/checkout_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/CreditCardsWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

class CheckoutWidget extends StatefulWidget {
//  RouteArgument routeArgument;
//  CheckoutWidget({Key key, this.routeArgument}) : super(key: key);
  @override
  _CheckoutWidgetState createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends StateMVC<CheckoutWidget> {
  CheckoutController _con;

  _CheckoutWidgetState() : super(CheckoutController()) {
    _con = controller;
  }
  @override
  void initState() {
    _con.listenForCarts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        //centerTitle: true,
        title: AutoSizeText(
          S.of(context).checkout,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      body: _con.carts.isEmpty
          ? CircularLoadingWidget(height: 400)
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 190),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              Icons.payment,
                              color: Theme.of(context).hintColor,
                            ),
                            title: AutoSizeText(
                              S.of(context).payment_mode,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            subtitle: AutoSizeText(
                              S.of(context).select_your_preferred_payment_mode,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        new CreditCardsWidget(
                            creditCard: _con.creditCard,
                            onChanged: (creditCard) {
                              _con.updateCreditCard(creditCard);
                            }),
                        SizedBox(height: 40),
                        setting.value.payPalEnabled
                            ? AutoSizeText(
                                S.of(context).or_checkout_with,
                                style: Theme.of(context).textTheme.caption,
                              )
                            : SizedBox(
                                height: 0,
                              ),
                        SizedBox(height: 40),
                        setting.value.payPalEnabled
                            ? SizedBox(
                                width: 320,
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacementNamed('/PayPal');
                                  },
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  color: Theme.of(context).focusColor.withOpacity(0.2),
                                  shape: StadiumBorder(),
                                  child: Image.asset(
                                    'assets/img/paypal2.png',
                                    height: 28,
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 0,
                              ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 185,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                        boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), offset: Offset(0, -2), blurRadius: 5.0)]),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: AutoSizeText(
                                  S.of(context).total,
                                  style: Theme.of(context).textTheme.headline6.merge(TextStyle(color: Theme.of(context).hintColor)),
                                ),
                              ),
                              Helper.getPrice(_con.total, context, style: Theme.of(context).textTheme.headline6.merge(TextStyle(color: Theme.of(context).highlightColor)))
                            ],
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 40,
                            child: FlatButton(
                              onPressed: () {
                                if (_con.creditCard.validated()) {
                                  Navigator.of(context).pushNamed('/OrderSuccess', arguments: new RouteArgument(param: 'Credit Card (Stripe Gateway)'));
                                } else {
                                  _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
                                    content: AutoSizeText(S.of(context).your_credit_card_not_valid),
                                  ));
                                }
                              },
                              padding: EdgeInsets.symmetric(vertical: 14),
                              color: Theme.of(context).accentColor,
                              shape: StadiumBorder(),
                              child: AutoSizeText(
                                S.of(context).confirm_payment,
                                textAlign: TextAlign.start,
                                style: TextStyle(color: Theme.of(context).hintColor),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
