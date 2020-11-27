import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../elements/CartBottomDetailsWidget.dart';
import '../elements/CartItemWidget.dart';
import '../elements/EmptyCartWidget.dart';
import '../models/route_argument.dart';
import '../models/cart.dart';
import '../models/food.dart';

class CartWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  CartWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends StateMVC<CartWidget> {
  CartController _con;

  _CartWidgetState() : super(CartController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForCarts();
    _con.listenForCartsCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var group = groupBy(_con.carts, (obj) => obj.food.restaurant.name);
    var group2 = groupBy(_con.carts, (obj) => obj.food.restaurant.id);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _con.scaffoldKey,
        bottomNavigationBar: CartBottomDetailsWidget(con: _con),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              if (widget.routeArgument.param == '/Food') {
                Navigator.of(context).pop('/Food');
                // Navigator.of(context).pushReplacementNamed('/Food',
                //     arguments: RouteArgument(id: widget.routeArgument.id));
              } else if (widget.routeArgument.param == '/Details') {
                Navigator.of(context).pop('/Details');
                // Navigator.of(context).pushReplacementNamed('/Food',
                //     arguments: RouteArgument(id: widget.routeArgument.id));
              }
              else {
                Navigator.of(context)
                    .pushReplacementNamed('/Pages', arguments: 0);
              }
            },
            icon: Icon(Icons.arrow_back),
            color: Theme.of(context).hintColor,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          //centerTitle: true,
          title: AutoSizeText(
            S.of(context).my_cart + " (${_con.cartCount.toString()})",
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _con.refreshCarts,
          child: _con.carts.isEmpty
              ? EmptyCartWidget()
              : Container(
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    children: <Widget>[
                      //Padding(
                      //  padding: const EdgeInsets.only(left: 20, right: 10),
                      //  child: ListTile(
                      //    contentPadding: EdgeInsets.symmetric(vertical: 0),
                      //    leading: Icon(
                      //      Icons.shopping_cart,
                      //      color: Theme.of(context).hintColor,
                      //    ),
                      //    title: AutoSizeText(
                      //      S.of(context).shopping_cart,
                      //      maxLines: 1,
                      //      overflow: TextOverflow.ellipsis,
                      //      style: Theme.of(context).textTheme.headline4,
                      //    ),
                      //    subtitle: Column(
                      //      crossAxisAlignment: CrossAxisAlignment.start,
                      //      children: <Widget>[
                      //        AutoSizeText(
                      //          S.of(context).verify_your_quantity_and_click_checkout,
                      //          maxLines: 1,
                      //          overflow: TextOverflow.ellipsis,
                      //          style: Theme.of(context).textTheme.caption,
                      //        ),
//
                      //        AutoSizeText(
                      //          S.of(context).swipe_left_or_right_to_cancel,
                      //          maxLines: 1,
                      //          overflow: TextOverflow.ellipsis,
                      //          style: Theme.of(context).textTheme.caption,
                      //        ),
                      //      ],
                      //    )
                      //  ),
                      //),

                      ListView.builder(
                        itemCount: group.length,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (BuildContext context, int index) {
                          String key = group.keys.elementAt(index);
                          String keyRoute = group2.keys.elementAt(index);
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
                                        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Theme.of(context).accentColor,),
                                        onTap: (){
                                          Navigator.of(context).pushNamed('/Details', arguments: RouteArgument(id: keyRoute, heroTag: 'cart_restaurant'));
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Container(
                                          height: 1.0,
                                          width: 380.0,
                                          color: Colors.grey.withOpacity(0.5),
                                        ),
                                      ),
                                      ListView.separated(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        primary: false,
                                        itemCount: group[key].length,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(height: 0);
                                        },
                                        itemBuilder: (context, index) {
                                          var carts = group[key];
                                          return CartItemWidget(
                                            cart: carts.elementAt(index),
                                            heroTag: 'cart',
                                            increment: () {
                                              _con.incrementQuantity(
                                                  carts.elementAt(index));
                                            },
                                            decrement: () {
                                              _con.decrementQuantity(
                                                  carts.elementAt(index));
                                            },
                                            onDismissed: () {
                                              _con.removeFromCart(
                                                  carts.elementAt(index));
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  )),
                              SizedBox(height: 15,),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
