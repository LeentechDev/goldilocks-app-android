import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../helpers/helper.dart';
import '../models/cart.dart';
import '../models/route_argument.dart';
import '../../generated/l10n.dart';

// ignore: must_be_immutable
class CheckOutItemWidget extends StatefulWidget {
  String heroTag;
  Cart cart;
  CheckOutItemWidget({Key key, this.cart, this.heroTag}) : super(key: key);

  @override
  _CheckOutItemWidgetState createState() => _CheckOutItemWidgetState();
}

class _CheckOutItemWidgetState extends State<CheckOutItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      //onTap: () {
      //  Navigator.of(context).pushNamed('/Food', arguments: RouteArgument(id: widget.cart.food.id, heroTag: widget.heroTag));
      //},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: widget.cart.food.image.thumb.toString() == "https://goldilocks.ml/images/image_default.png" ?  Image.asset(
                'assets/custom_img/place_holder_g.png',
                fit: BoxFit.cover,
                height: 90,
                width: 90,
              ) : CachedNetworkImage(
                height: 90,
                width: 90,
                fit: BoxFit.cover,
                imageUrl: widget.cart.food.image.thumb,
                placeholder: (context, url) => Image.asset(
                  'assets/img/loading.gif',
                  fit: BoxFit.cover,
                  height: 90,
                  width: 90,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          widget.cart.food.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),

                        Wrap(
                          children: List.generate(widget.cart.extras.length, (index) {
                            return AutoSizeText(
                              widget.cart.extras.elementAt(index).name + ', ',
                              style: Theme.of(context).textTheme.caption,
                            );
                          }),
                        ),
                        Helper.getPrice(widget.cart.food.price, context, style: Theme.of(context).textTheme.headline4),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      AutoSizeText("x" + widget.cart.quantity.round().toString(), style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).dividerColor))),

                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
