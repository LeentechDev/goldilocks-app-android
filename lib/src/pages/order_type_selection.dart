import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../elements/CircularLoadingWidget.dart';

import '../models/filter.dart';
import '../controllers/filter_controller.dart';
import '../../generated/l10n.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../Bloc/shared_pref.dart';
import '../Bloc/OrderTypeProvider.dart';

class OrderType extends StatefulWidget {
  final ValueChanged<Filter> onFilter;
  OrderType({Key key, this.onFilter}) : super(key: key);

  @override
  _OrderTypeState createState() => _OrderTypeState();
}

class _OrderTypeState extends StateMVC<OrderType> {
  FilterController _con;

  final SharedPrefs prefs = SharedPrefs();

  int orderType;
  int loginType;
  bool isLoading = false;

  void startTimer() {
    Timer.periodic(const Duration(seconds: 2), (t) {
      
      setState(() {
        isLoading = true; //set loading to false
      });
      Navigator.of(context).pushReplacementNamed(
                                        '/Pages',
                                        arguments: 0);
      t.cancel(); //stops the timer
    });
    
  }

  _OrderTypeState() : super(FilterController()) {
    _con = controller;
  }

  getOrderType() async {
    orderType = await prefs.getIntOrderType();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
                      child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/custom_img/goldilocks_logo_yellow.png',
                      ),
                    ],
                  ),
                ),
                isLoading == false ? Container( 
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 30,
                        child: AutoSizeText(
                            "First things first, select your preferred type of order",
                            minFontSize: 14,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline4.merge(
                              TextStyle(
                                fontSize: 25.0,
                              ),
                            )),
                      ),
                      SizedBox(height: 20.0),
                      AutoSizeText(
                        "You can still change this later.",
                        minFontSize: 10,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).hintColor
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.yellow),
                                    color: Theme.of(context).primaryColor,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.05),
                                          offset: Offset(0, 5),
                                          blurRadius: 5)
                                    ]),
                                child: FlatButton(
                                  color: Colors.transparent,
                                  onPressed: () {
                                    Provider.of<OrderTypeGenerator>(context, listen: false).setOrderTypeValue(1);
                                    setState(() {
                                      //delivery
                                      _con.filter?.delivery = false;
                                      prefs.setIntOrderType(1);
                                      getOrderType();
                                      isLoading = true;
                                    });
                                        startTimer();
                                    // _con.saveFilter().whenComplete(() {
                                    //   widget.onFilter(_con.filter);
                                    // });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30.0, vertical: 30),
                                    child: Container(
                                      width:
                                      MediaQuery.of(context).size.width - 100,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            'assets/custom_img/mail_order.svg',
                                            width: 60,
                                          ),
                                          SizedBox(width: 30.0),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width -
                                                225,
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                AutoSizeText(
                                                  S.of(context).mail_order,
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                  softWrap: false,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                AutoSizeText(
                                                 "We bake your orders as they come. We use USPS priority mail which takes 2-3 days.",
                                                  style:
                                                  TextStyle(fontSize: 10.0),
                                                  textAlign: TextAlign.left,
                                                  softWrap: false,
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container( 
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.yellow),
                                    color: Theme.of(context).primaryColor,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.05),
                                          offset: Offset(0, 5),
                                          blurRadius: 5)
                                    ]),
                                child: FlatButton(
                                  color: Colors.transparent,
                                  onPressed: () {
                                    Provider.of<OrderTypeGenerator>(context, listen: false).setOrderTypeValue(2);
                                    
                                    setState(() {
                                      //mailorder
                                      _con.filter?.delivery = true;
                                      prefs.setIntOrderType(2);
                                      getOrderType();
                                      isLoading = true;
                                    });

                                    // _con.saveFilter().whenComplete(() {
                                    //   widget.onFilter(_con.filter);
                                    // });
                                      startTimer();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30.0, vertical: 30),
                                    child: Container(
                                      width:
                                      MediaQuery.of(context).size.width - 100,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            'assets/custom_img/delivery_icon.svg',
                                            width: 60,
                                          ),
                                          SizedBox(width: 30.0),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width -
                                                225,
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                 AutoSizeText(
                                                  S.of(context).delivery,
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                  softWrap: false,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                AutoSizeText(
                                                  S.of(context).sit_back,
                                                  style:
                                                  TextStyle(fontSize: 10.0),
                                                  softWrap: false,
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.yellow),
                                    color: Theme.of(context).primaryColor,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.05),
                                          offset: Offset(0, 5),
                                          blurRadius: 5)
                                    ]),
                                child: FlatButton(
                                  color: Colors.transparent,
                                  onPressed: () {
                                    Provider.of<OrderTypeGenerator>(context, listen: false).setOrderTypeValue(0);
                                    setState(() {
                                      //storepickup
                                      _con.filter?.delivery = false;
                                      prefs.setIntOrderType(0);
                                      getOrderType();
                                      isLoading = true;
                                    });

                                    // _con.saveFilter().whenComplete(() {
                                    //   widget.onFilter(_con.filter);
                                    // });
                                    startTimer();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30.0, vertical: 30),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          'assets/custom_img/paper_bag.svg',
                                          width: 60,
                                        ),
                                        SizedBox(width: 30.0),
                                        Container(
                                          width:
                                          MediaQuery.of(context).size.width -
                                              230,
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              AutoSizeText(
                                                S.of(context).pickup,
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold),
                                                softWrap: false,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              AutoSizeText(
                                                S.of(context).pick_up_orders,
                                                style: TextStyle(fontSize: 10.0),
                                                softWrap: false,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ):
                Container(
                        width: 130,
                        height: 130,
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child:
                          CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                          )
                          
                        )
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

