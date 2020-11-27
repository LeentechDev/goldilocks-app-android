import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/food.dart';
import '../models/route_argument.dart';

class FoodGridItemWidget extends StatefulWidget {
  final String heroTag;
  final Food food;
  final VoidCallback onPressed;

  FoodGridItemWidget({Key key, this.heroTag, this.food, this.onPressed}) : super(key: key);

  @override
  _FoodGridItemWidgetState createState() => _FoodGridItemWidgetState();
}

class _FoodGridItemWidgetState extends State<FoodGridItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        Navigator.of(context).pushNamed('/Food', arguments: new RouteArgument(heroTag: this.widget.heroTag, id: this.widget.food.id));
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
         Container(
           padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
           decoration: BoxDecoration(
               boxShadow: [

                 BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 3))
               ],
             borderRadius: BorderRadius.all(Radius.circular(10)),
             color: Theme.of(context).primaryColor
           ),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
               Expanded(
                 child: Hero(
                   tag: widget.heroTag + widget.food.id,
                   child: Container(
                     decoration: BoxDecoration(
                       image: DecorationImage(image: NetworkImage(this.widget.food.image.thumb), fit: BoxFit.cover),
                       borderRadius: BorderRadius.circular(5),
                     ),
                   ),
                 ),
               ),
               SizedBox(height: 5),
               AutoSizeText(
                 widget.food.name,
                 style: Theme.of(context).textTheme.bodyText1,
                 overflow: TextOverflow.ellipsis,
               ),
               SizedBox(height: 2),
               AutoSizeText(
                 widget.food.restaurant.name,
                 style: Theme.of(context).textTheme.caption,
                 overflow: TextOverflow.ellipsis,
               )
             ],
           ),
         ),
          Container(
            margin: EdgeInsets.all(10),
            width: 40,
            height: 40,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                widget.onPressed();
              },
              child: SvgPicture.asset('assets/custom_img/cart_icon.svg', color: Colors.black, width: 23,),
              color: Theme.of(context).accentColor.withOpacity(0.9),
              shape: StadiumBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
