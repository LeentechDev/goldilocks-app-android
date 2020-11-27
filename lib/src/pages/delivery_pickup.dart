import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/elements/CircularLoadingWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:collection/collection.dart';

import '../../generated/l10n.dart';
import '../controllers/delivery_pickup_controller.dart';
import '../elements/CheckOutBottomDetailsWidget.dart';
import '../elements/DeliveryAddressDialog.dart';
import '../elements/DeliveryAddressesItemWidget.dart';
import '../elements/NotDeliverableAddressesItemWidget.dart';
import '../elements/CheckOutItemWidget.dart';
import '../elements/PickUpMethodItemWidget.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/payment_method.dart';
import '../models/route_argument.dart';
import '../Bloc/shared_pref.dart';
import '../repository/user_repository.dart';

class DeliveryPickupWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  DeliveryPickupWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _DeliveryPickupWidgetState createState() => _DeliveryPickupWidgetState();
}

class _DeliveryPickupWidgetState extends StateMVC<DeliveryPickupWidget> {
  DeliveryPickupController _con;

  final SharedPrefs prefs = SharedPrefs();

  int orderTypeNumber;
  bool isLoading = true;
  bool itemLoading = true;

  _DeliveryPickupWidgetState() : super(DeliveryPickupController()) {
    _con = controller;
  }

  @override
  Future<bool> initState() {
    getOrderType();
    super.initState();
  }

  getOrderType() async {
    int orderType = await prefs.getIntOrderType();
    print("ORDERTYPE:   $orderType");

    if (orderType == 1) {
      orderTypeNumber = 1;
    } else {
      orderTypeNumber = 2;
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_con.list == null) {
      _con.list = new PaymentMethodList(context);
//      widget.pickup = widget.list.pickupList.elementAt(0);
//      widget.delivery = widget.list.pickupList.elementAt(1);
    }

    var group = groupBy(_con.carts, (obj) => obj.food.restaurant.name);
    double total = 0;
    double total1 = 0;
    int itemTotal = 0;

    group.forEach((key, value) {
      var items = group[key];
      items.forEach((element) {
        itemTotal = itemTotal + 1;
      });
    });

    return Scaffold(
        key: _con.scaffoldKey,
        bottomNavigationBar: CheckOutBottomDetailsWidget(con: _con),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          //centerTitle: true,
          title: AutoSizeText(
            S.of(context).checkout,
            style: Theme.of(context).textTheme.headline4,
          ),
          //actions: <Widget>[
          //  new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
          //],
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CircularLoadingWidget(
                                height: 100,
                              ),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              //borderRadius: BorderRadius.circular(6),
                              //boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
                            ),
                            child: ListView(
                              shrinkWrap: true,
                              primary: false,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: ListTile(
                                    title: AutoSizeText(
                                      S.of(context).billing_details,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    trailing: FlatButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed('/BillingDetails');
                                      },
                                      child: AutoSizeText(
                                        S.of(context).edit,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: ListTile(
                                    title: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        AutoSizeText(
                                          currentUser.value.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .merge(TextStyle(
                                                  color: Theme.of(context)
                                                      .hintColor)),
                                        ),
                                        SizedBox(height: 15),
                                        AutoSizeText(
                                          currentUser.value.phone,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .merge(TextStyle(
                                                  color: Theme.of(context)
                                                      .hintColor)),
                                        ),
                                        SizedBox(height: 15),
                                        AutoSizeText(
                                          currentUser.value.email,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .merge(TextStyle(
                                                  color: Theme.of(context)
                                                      .hintColor)),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          group.keys.contains("Goldilocks Mail Order")
                              ? Container(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    //borderRadius: BorderRadius.circular(6),
                                    //boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
                                  ),
                                  child: ListView(
                                    shrinkWrap: true,
                                    primary: false,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        child: ListTile(
                                          title: AutoSizeText(
                                            S.of(context).delivery_details,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: ListTile(
                                          title: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              AutoSizeText(
                                                currentUser.value.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    .merge(TextStyle(
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                              ),
                                              SizedBox(height: 15),
                                              AutoSizeText(
                                                currentUser.value.phone,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    .merge(TextStyle(
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                              ),
                                              SizedBox(height: 15),
                                              AutoSizeText(
                                                currentUser.value.email,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    .merge(TextStyle(
                                                        color: Theme.of(context)
                                                            .hintColor)),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : CircularLoadingWidget(
                                  height: 100,
                                ),
                          ListView.builder(
                            itemCount: group.length,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (BuildContext context, int index) {
                              String key = group.keys.elementAt(index);
                              var price = group[key];
                              double Stotal = 0;

                              price.forEach((element) { 
                                price == price
                                    ? {
                                        Stotal = (element.food.price *
                                                element.quantity) +
                                            Stotal,
                                        total = Stotal
                                      }
                                    : Stotal = element.food.price;
                              });
                              total1 = Stotal;
                              print('KEY $key');
                              return new Column(
                                children: <Widget>[
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.9),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Theme.of(context)
                                                  .hintColor
                                                  .withOpacity(0.1),
                                              blurRadius: 5,
                                              offset: Offset(0, 2)),
                                        ],
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            leading: SvgPicture.asset(
                                                'assets/custom_img/store_icon.svg',
                                                width: 30),
                                            title: AutoSizeText(
                                              key,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Container(
                                              height: 1.0,
                                              width: 380.0,
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                            ),
                                          ),
                                          ListView.separated(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15),
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            primary: false,
                                            itemCount: group[key].length,
                                            separatorBuilder: (context, index) {
                                              return SizedBox(height: 0);
                                            },
                                            itemBuilder: (context, index) {
                                              var carts = group[key];
                                              return CheckOutItemWidget(
                                                cart: carts.elementAt(index),
                                                heroTag: 'cart',
                                              );
                                            },
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Container(
                                              height: 2,
                                              width: 380.0,
                                              color:
                                                  Theme.of(context).hintColor,
                                            ),
                                          ),
                                          ListTile(
                                            title: AutoSizeText(
                                              "Subtotal (" +
                                                  group[key].length.toString() +
                                                  " items)",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                            ),
                                            trailing: Helper.getPrice(
                                                total1, context,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    .merge(TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .hintColor))),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: <Widget>[
                              //Padding(
                              //  padding: const EdgeInsets.only(
                              //      top: 20,
                              //      bottom: 10,
                              //      left: 20,
                              //      right: 10),
                              //  child: ListTile(
                              //    contentPadding:
                              //        EdgeInsets.symmetric(vertical: 0),
                              //    leading: Icon(
                              //      Icons.map,
                              //      color: Theme.of(context).hintColor,
                              //    ),
                              //    title: AutoSizeText(
                              //      S.of(context).mail_order,
                              //      maxLines: 1,
                              //      overflow: TextOverflow.ellipsis,
                              //      style: Theme.of(context)
                              //          .textTheme
                              //          .headline4,
                              //    ),
                              //    subtitle: _con.carts.isNotEmpty &&
                              //            Helper.canDelivery(
                              //                _con.carts[0].food.restaurant,
                              //                carts: _con.carts)
                              //        ? AutoSizeText(
                              //            S
                              //                .of(context)
                              //                .click_to_confirm_your_address_and_pay_or_long_press,
                              //            maxLines: 3,
                              //            overflow: TextOverflow.ellipsis,
                              //            style: Theme.of(context)
                              //                .textTheme
                              //                .caption,
                              //          )
                              //        : AutoSizeText(
                              //            S
                              //                .of(context)
                              //                .deliveryMethodNotAllowed,
                              //            maxLines: 3,
                              //            overflow: TextOverflow.ellipsis,
                              //            style: Theme.of(context)
                              //                .textTheme
                              //                .caption,
                              //          ),
                              //  ),
                              //),
                              // _con.carts.isNotEmpty &&
                              //         Helper.canDelivery(
                              //             _con.carts[0].food.restaurant,
                              //             carts: _con.carts)
                              //     ? DeliveryAddressesItemWidget(
                              //         paymentMethod: _con.getDeliveryMethod(),
                              //         address: _con.deliveryAddress,
                              //         onPressed: (Address _address) {
                              //           if (_con.deliveryAddress.id == null ||
                              //               _con.deliveryAddress.id == 'null') {
                              //             DeliveryAddressDialog(
                              //               context: context,
                              //               address: _address,
                              //               onChanged: (Address _address) {
                              //                 _con.addAddress(_address);
                              //               },
                              //             );
                              //           } else {
                              //             _con.toggleDelivery();
                              //           }
                              //         },
                              //         onLongPress: (Address _address) {
                              //           DeliveryAddressDialog(
                              //             context: context,
                              //             address: _address,
                              //             onChanged: (Address _address) {
                              //               _con.updateAddress(_address);
                              //             },
                              //           );
                              //         },
                              //       )
                              //     : NotDeliverableAddressesItemWidget()
                            ],
                          ),
                        ],
                      ),
              ],
            )));
  }
}

/*
//orderTypeNumber == 1
                        // ? 
                        // : Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     mainAxisSize: MainAxisSize.max,
                        //     children: <Widget>[
                        //         Container(
                        //           margin: EdgeInsets.symmetric(vertical: 15),
                        //           decoration: BoxDecoration(
                        //             color: Theme.of(context).primaryColor,
                        //             //borderRadius: BorderRadius.circular(6),
                        //             //boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
                        //           ),
                        //           child: ListView(
                        //             shrinkWrap: true,
                        //             primary: false,
                        //             children: <Widget>[
                        //               Padding(
                        //                 padding: EdgeInsets.symmetric(
                        //                   horizontal: 5,
                        //                 ),
                        //                 child: ListTile(
                        //                   title: AutoSizeText(
                        //                     S.of(context).billing_details,
                        //                     style: Theme.of(context)
                        //                         .textTheme
                        //                         .headline4,
                        //                   ),
                        //                   trailing: FlatButton(
                        //                     onPressed: () {
                        //                       Navigator.of(context)
                        //                           .pushNamed('/BillingDetails');
                        //                     },
                        //                     child: AutoSizeText(
                        //                       S.of(context).edit,
                        //                       style: Theme.of(context)
                        //                           .textTheme
                        //                           .subtitle2,
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ),
                        //               Padding(
                        //                 padding:
                        //                     EdgeInsets.symmetric(horizontal: 5),
                        //                 child: ListTile(
                        //                   title: Column(
                        //                     mainAxisAlignment:
                        //                         MainAxisAlignment.spaceBetween,
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.start,
                        //                     children: <Widget>[
                        //                       AutoSizeText(
                        //                         currentUser.value.name,
                        //                         style: Theme.of(context)
                        //                             .textTheme
                        //                             .subtitle1
                        //                             .merge(TextStyle(
                        //                                 color: Theme.of(context)
                        //                                     .hintColor)),
                        //                       ),
                        //                       SizedBox(height: 15),
                        //                       AutoSizeText(
                        //                         currentUser.value.phone,
                        //                         style: Theme.of(context)
                        //                             .textTheme
                        //                             .subtitle1
                        //                             .merge(TextStyle(
                        //                                 color: Theme.of(context)
                        //                                     .hintColor)),
                        //                       ),
                        //                       SizedBox(height: 15),
                        //                       AutoSizeText(
                        //                         currentUser.value.address,
                        //                         style: Theme.of(context)
                        //                             .textTheme
                        //                             .subtitle1
                        //                             .merge(TextStyle(
                        //                                 color: Theme.of(context)
                        //                                     .hintColor)),
                        //                       ),
                        //                       SizedBox(
                        //                         height: 20,
                        //                       )
                        //                     ],
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //         Container(
                        //           margin: EdgeInsets.symmetric(vertical: 15),
                        //           decoration: BoxDecoration(
                        //             color: Theme.of(context).primaryColor,
                        //             //borderRadius: BorderRadius.circular(6),
                        //             //boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
                        //           ),
                        //           child: ListView(
                        //             shrinkWrap: true,
                        //             primary: false,
                        //             children: <Widget>[
                        //               Padding(
                        //                 padding: EdgeInsets.symmetric(
                        //                   horizontal: 5,
                        //                 ),
                        //                 child: ListTile(
                        //                   title: AutoSizeText(
                        //                     S.of(context).delivery_details,
                        //                     style: Theme.of(context)
                        //                         .textTheme
                        //                         .headline4,
                        //                   ),
                        //                   trailing: FlatButton(
                        //                     onPressed: () {
                        //                       Navigator.of(context).pushNamed(
                        //                           '/DeliveryDetails');
                        //                     },
                        //                     child: AutoSizeText(
                        //                       S.of(context).edit,
                        //                       style: Theme.of(context)
                        //                           .textTheme
                        //                           .subtitle2,
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ),
                        //               Padding(
                        //                 padding:
                        //                     EdgeInsets.symmetric(horizontal: 5),
                        //                 child: ListTile(
                        //                   title: Column(
                        //                     mainAxisAlignment:
                        //                         MainAxisAlignment.spaceBetween,
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.start,
                        //                     children: <Widget>[
                        //                       AutoSizeText(
                        //                         currentUser.value.name,
                        //                         style: Theme.of(context)
                        //                             .textTheme
                        //                             .subtitle1
                        //                             .merge(TextStyle(
                        //                                 color: Theme.of(context)
                        //                                     .hintColor)),
                        //                       ),
                        //                       SizedBox(height: 15),
                        //                       AutoSizeText(
                        //                         currentUser.value.phone,
                        //                         style: Theme.of(context)
                        //                             .textTheme
                        //                             .subtitle1
                        //                             .merge(TextStyle(
                        //                                 color: Theme.of(context)
                        //                                     .hintColor)),
                        //                       ),
                        //                       SizedBox(height: 15),
                        //                       AutoSizeText(
                        //                         currentUser.value.address,
                        //                         style: Theme.of(context)
                        //                             .textTheme
                        //                             .subtitle1
                        //                             .merge(TextStyle(
                        //                                 color: Theme.of(context)
                        //                                     .hintColor)),
                        //                       ),
                        //                       SizedBox(
                        //                         height: 20,
                        //                       )
                        //                     ],
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //         ListView.builder(
                        //           itemCount: group.length,
                        //           padding: EdgeInsets.symmetric(vertical: 15),
                        //           scrollDirection: Axis.vertical,
                        //           shrinkWrap: true,
                        //           primary: false,
                        //           itemBuilder:
                        //               (BuildContext context, int index) {
                        //             String key = group.keys.elementAt(index);
                        //             print('KEY $key');
                        //             return new Column(
                        //               children: <Widget>[
                        //                 Container(
                        //                     decoration: BoxDecoration(
                        //                       color: Theme.of(context)
                        //                           .primaryColor
                        //                           .withOpacity(0.9),
                        //                       boxShadow: [
                        //                         BoxShadow(
                        //                             color: Theme.of(context)
                        //                                 .hintColor
                        //                                 .withOpacity(0.1),
                        //                             blurRadius: 5,
                        //                             offset: Offset(0, 2)),
                        //                       ],
                        //                     ),
                        //                     child: Column(
                        //                       children: <Widget>[
                        //                         ListTile(
                        //                           leading: SvgPicture.asset(
                        //                               'assets/custom_img/store_icon.svg',
                        //                               width: 30),
                        //                           title: AutoSizeText(
                        //                             key,
                        //                             style: Theme.of(context)
                        //                                 .textTheme
                        //                                 .subtitle1,
                        //                           ),
                        //                         ),
                        //                         Padding(
                        //                           padding: EdgeInsets.symmetric(
                        //                               horizontal: 10.0),
                        //                           child: Container(
                        //                             height: 1.0,
                        //                             width: 380.0,
                        //                             color: Colors.grey
                        //                                 .withOpacity(0.5),
                        //                           ),
                        //                         ),
                        //                         ListView.separated(
                        //                           padding: EdgeInsets.symmetric(
                        //                               vertical: 15),
                        //                           scrollDirection:
                        //                               Axis.vertical,
                        //                           shrinkWrap: true,
                        //                           primary: false,
                        //                           itemCount: group[key].length,
                        //                           separatorBuilder:
                        //                               (context, index) {
                        //                             return SizedBox(height: 0);
                        //                           },
                        //                           itemBuilder:
                        //                               (context, index) {
                        //                             var carts = group[key];
                        //                             return CheckOutItemWidget(
                        //                               cart: carts
                        //                                   .elementAt(index),
                        //                               heroTag: 'cart',
                        //                             );
                        //                           },
                        //                         ),
                        //                         Padding(
                        //                           padding: EdgeInsets.symmetric(
                        //                               horizontal: 10.0),
                        //                           child: Container(
                        //                             height: 2,
                        //                             width: 380.0,
                        //                             color: Theme.of(context)
                        //                                 .hintColor,
                        //                           ),
                        //                         ),
                        //                         ListTile(
                        //                           title: AutoSizeText(
                        //                             group[key]
                        //                                     .length
                        //                                     .toString() +
                        //                                 " Item(s)Total",
                        //                             style: Theme.of(context)
                        //                                 .textTheme
                        //                                 .subtitle1,
                        //                           ),
                        //                           trailing: AutoSizeText(
                        //                             '\$' + " Sub",
                        //                             style: Theme.of(context)
                        //                                 .textTheme
                        //                                 .subtitle1,
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     )),
                        //                 SizedBox(
                        //                   height: 15,
                        //                 ),
                        //               ],
                        //             );
                        //           },
                        //         ),
                        //         Column(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             mainAxisAlignment: MainAxisAlignment.start,
                        //             mainAxisSize: MainAxisSize.max,
                        //             children: <Widget>[
                        //               PickUpMethodItem(
                        //                   paymentMethod: _con.getPickUpMethod(),
                        //                   onPressed: (paymentMethod) {
                        //                     _con.togglePickUp();
                        //                   }),
                        //             ])
                        //       ]),

body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[

          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  Icons.domain,
                  color: Theme.of(context).hintColor,
                ),
                title: AutoSizeText(
                  S.of(context).store_pick_up,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline4,
                ),
                subtitle: AutoSizeText(
                  S.of(context).pickup_your_food_from_the_store,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ),
            PickUpMethodItem(
                paymentMethod: _con.getPickUpMethod(),
                onPressed: (paymentMethod) {
                  _con.togglePickUp();
                }),

            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    leading: Icon(
                      Icons.map,
                      color: Theme.of(context).hintColor,
                    ),
                    title: AutoSizeText(
                      S.of(context).mail_order,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    subtitle: _con.carts.isNotEmpty && Helper.canDelivery(_con.carts[0].food.restaurant, carts: _con.carts)
                        ? AutoSizeText(
                            S.of(context).click_to_confirm_your_address_and_pay_or_long_press,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          )
                        : AutoSizeText(
                            S.of(context).deliveryMethodNotAllowed,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          ),
                  ),
                ),
                _con.carts.isNotEmpty && Helper.canDelivery(_con.carts[0].food.restaurant, carts: _con.carts)
                    ? DeliveryAddressesItemWidget(
                        paymentMethod: _con.getDeliveryMethod(),
                        address: _con.deliveryAddress,
                        onPressed: (Address _address) {
                          if (_con.deliveryAddress.id == null || _con.deliveryAddress.id == 'null') {
                            DeliveryAddressDialog(
                              context: context,
                              address: _address,
                              onChanged: (Address _address) {
                                _con.addAddress(_address);
                              },
                            );
                          } else {
                            _con.toggleDelivery();
                          }
                        },
                        onLongPress: (Address _address) {
                          DeliveryAddressDialog(
                            context: context,
                            address: _address,
                            onChanged: (Address _address) {
                              _con.updateAddress(_address);
                            },
                          );
                        },
                      )
                    : NotDeliverableAddressesItemWidget()
              ],
            ),
          ],
        ),

          ],
        ),
      ),


 */
