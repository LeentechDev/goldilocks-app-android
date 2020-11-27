import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../generated/l10n.dart';
import '../controllers/checkout_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../helpers/helper.dart';
import '../models/payment.dart';
import '../models/route_argument.dart';

class OrderSuccessWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  OrderSuccessWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _OrderSuccessWidgetState createState() => _OrderSuccessWidgetState();
}

class _OrderSuccessWidgetState extends StateMVC<OrderSuccessWidget> {
  CheckoutController _con;
  bool isLoading = true;

  void startTimer() {
    Timer.periodic(const Duration(seconds: 5), (t) {
      setState(() {
        isLoading = false; //set loading to false
      });
      t.cancel(); //stops the timer
    });
  }

  _OrderSuccessWidgetState() : super(CheckoutController()) {
    _con = controller;
  }

  @override
  void initState() {
    // route param contains the payment method
    _con.payment = new Payment(widget.routeArgument.param);
    _con.listenForCarts();
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _con.scaffoldKey,
        body:  _con.carts.isEmpty
            ? CircularLoadingWidget(height: 500,)
            : Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              alignment: AlignmentDirectional.center,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(height: 60,),
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/custom_img/success_border_icon.svg',
                        width: 130,
                      ),
                      Container(
                        width: 130,
                        height: 130,
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: isLoading ? 
                          CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                          )
                          : Icon(
                          Icons.check,
                          color: Theme.of(context).highlightColor,
                          size: 50,
                        ),
                        )
                      ),
                      //Positioned(
                      //  right: -30,
                      //  bottom: -50,
                      //  child: Container(
                      //    width: 100,
                      //    height: 100,
                      //    decoration: BoxDecoration(
                      //      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                      //      borderRadius: BorderRadius.circular(150),
                      //    ),
                      //  ),
                      //),
                      //Positioned(
                      //  left: -20,
                      //  top: -50,
                      //  child: Container(
                      //    width: 120,
                      //    height: 120,
                      //    decoration: BoxDecoration(
                      //      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                      //      borderRadius: BorderRadius.circular(150),
                      //    ),
                      //  ),
                      //)
                    ],
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: AutoSizeText(
                      S.of(context).your_order_has_been_successfully_submitted,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3.merge(TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Opacity(
                      opacity: 0.8,
                      child:AutoSizeText(
                        S.of(context).kindly_check_my_orders,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).hintColor)),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 180,
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
                      SizedBox(height: 3),
                      _con.payment.method == 'Pay on Pickup'
                          ? SizedBox(height: 0)
                          : Row(
                        children: <Widget>[
                          // Expanded(
                          //   child: AutoSizeText(
                          //     S.of(context).delivery_fee,
                          //     style: Theme.of(context).textTheme.bodyText1,
                          //   ),
                          // ),
                          // Helper.getPrice(_con.carts[0].food.restaurant.deliveryFee, context, style: Theme.of(context).textTheme.subtitle1
                          // .merge(TextStyle(color: Theme.of(context).dividerColor)))
                        ],
                      ),
                      SizedBox(height: 3),
                      Row(
                        children: <Widget>[
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: AutoSizeText(
                              S.of(context).total,
                              style: Theme.of(context).textTheme.headline6.merge(TextStyle(color: Theme.of(context).dividerColor )),
                            ),
                          ),
                          Helper.getPrice(_con.total, context, style: Theme.of(context).textTheme.headline6.merge(TextStyle(color: Theme.of(context).highlightColor)))
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Theme.of(context).accentColor.withOpacity(0.2), blurRadius: 15, offset: Offset(0, 15)),
          BoxShadow(color: Theme.of(context).accentColor.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 3))
        ],
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/Pages', arguments:2);
                            },
                            padding: EdgeInsets.symmetric(vertical: 14),
                            color: Theme.of(context).accentColor,
                            shape: StadiumBorder(),
                            child: AutoSizeText(
                              S.of(context).go_to_orders,
                              textAlign: TextAlign.start,
                              style: TextStyle(color: Theme.of(context).hintColor),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
