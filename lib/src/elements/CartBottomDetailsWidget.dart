import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

import '../controllers/cart_controller.dart';

import '../helpers/helper.dart';

class CartBottomDetailsWidget extends StatelessWidget {
  const CartBottomDetailsWidget({
    Key key,
    @required CartController con,
  })  : _con = con,
        super(key: key);

  final CartController _con;

  @override
  Widget build(BuildContext context) {
    return _con.carts.isEmpty
        ? SizedBox(height: 0)
        : Container(
            height: 100,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).hintColor.withOpacity(0.15),
                      offset: Offset(0, -2),
                      blurRadius: 5.0)
                ]),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        AutoSizeText(
                          S.of(context).total,
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Helper.getPrice(
                          _con.total,
                          context,
                          style: Theme.of(context).textTheme.headline4.merge(
                              TextStyle(color: Color(0xFFFEA300))),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width - 180,
                    child: Container(
                      decoration: !_con.carts[0].food.restaurant.closed ?
                      BoxDecoration(
        boxShadow: [
          BoxShadow(color: Theme.of(context).accentColor.withOpacity(0.2), blurRadius: 15, offset: Offset(0, 15)),
          BoxShadow(color: Theme.of(context).accentColor.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 3))
        ],
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ):
      BoxDecoration(
        boxShadow: [
          BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.2), blurRadius: 15, offset: Offset(0, 15)),
          BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 3))
        ],
        borderRadius: BorderRadius.all(Radius.circular(100)),
      )
      ,
                      child: FlatButton(
                        onPressed: () {
                          _con.goCheckout(context);
                        },
                        disabledColor:
                            Theme.of(context).focusColor.withOpacity(0.5),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        color: !_con.carts[0].food.restaurant.closed
                            ? Theme.of(context).accentColor
                            : Theme.of(context).hintColor.withOpacity(0.5),
                        shape: StadiumBorder(),
                        child: AutoSizeText(
                          S.of(context).proceed_to_checkout,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyText1.merge(
                              TextStyle(color: Theme.of(context).hintColor)),
                        ),
                      ),
                    ),
                  ),

                  //Row(

                  //  children: <Widget>[

                  //    Expanded(

                  //      child: AutoSizeText(

                  //        S.of(context).subtotal,

                  //        style: Theme.of(context).textTheme.bodyText1,

                  //      ),

                  //    ),

                  //    Helper.getPrice(_con.subTotal, context, style: Theme.of(context).textTheme.subtitle1)

                  //  ],

                  //),

                  //SizedBox(height: 5),

                  //Row(

                  //  children: <Widget>[

                  //    Expanded(

                  //      child: AutoSizeText(

                  //        S.of(context).delivery_fee,

                  //        style: Theme.of(context).textTheme.bodyText1,

                  //      ),

                  //    ),

                  //    if (Helper.canDelivery(_con.carts[0].food.restaurant, carts: _con.carts))

                  //      Helper.getPrice(_con.carts[0].food.restaurant.deliveryFee, context, style: Theme.of(context).textTheme.subtitle1)

                  //    else

                  //      Helper.getPrice(0, context, style: Theme.of(context).textTheme.subtitle1)

                  //  ],

                  //),

                  //Row(

                  //  children: <Widget>[

                  //    Expanded(

                  //      child: AutoSizeText(

                  //        '${S.of(context).tax} (${_con.carts[0].food.restaurant.defaultTax}%)',

                  //        style: Theme.of(context).textTheme.bodyText1,

                  //      ),

                  //    ),

                  //    Helper.getPrice(_con.taxAmount, context, style: Theme.of(context).textTheme.subtitle1)

                  //  ],

                  //),

//

                  //Row(

                  //  children: <Widget>[

                  //    Expanded(

                  //      child: AutoSizeText(

                  //        'Total',

                  //        style: Theme.of(context).textTheme.bodyText1,

                  //      ),

                  //    ),

                  //    Helper.getPrice(

                  //      _con.total,

                  //      context,

                  //      style: Theme.of(context).textTheme.headline4.merge(TextStyle(color: Theme.of(context).accentColor)),

                  //    ),

                  //  ],

                  //),

                  //SizedBox(height: 10),

                  //Stack(

                  //  fit: StackFit.loose,

                  //  alignment: AlignmentDirectional.centerEnd,

                  //  children: <Widget>[

                  //    SizedBox(

                  //      width: MediaQuery.of(context).size.width - 40,

                  //      child: FlatButton(

                  //        onPressed: () {

                  //          _con.goCheckout(context);

                  //        },

                  //        disabledColor: Theme.of(context).focusColor.withOpacity(0.5),

                  //        padding: EdgeInsets.symmetric(vertical: 14),

                  //        color: !_con.carts[0].food.restaurant.closed ? Theme.of(context).accentColor : Theme.of(context).focusColor.withOpacity(0.5),

                  //        shape: StadiumBorder(),

                  //        child: AutoSizeText(

                  //          S.of(context).checkout,

                  //          textAlign: TextAlign.start,

                  //          style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Theme.of(context).primaryColor)),

                  //        ),

                  //      ),

                  //    ),

                  //  ],

                  //),

                  //SizedBox(height: 10),
                ],
              ),
            ),
          );
  }
}
