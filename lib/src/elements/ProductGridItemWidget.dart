import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../helpers/helper.dart';
import '../models/food.dart';
import '../models/route_argument.dart';


class ProductGridItemWidget extends StatelessWidget {

  final Food food;
  final String heroTag;


  ProductGridItemWidget({Key key, this.food, this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        Navigator.of(context).pushNamed('/Food', arguments: RouteArgument(id: food.id, heroTag: heroTag));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.05), offset: Offset(0, 5), blurRadius: 5)]),
        child: Wrap(
          children: <Widget>[
           Stack(
             children: <Widget>[
               ClipRRect(
                 borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                 child: Hero(
                   tag: heroTag + food.id,
                   child: CachedNetworkImage(
                     height: 100,
                     width: double.infinity,
                     fit: BoxFit.cover,
                     imageUrl: food.image.thumb,
                     placeholder: (context, url) => Image.asset(
                       'assets/img/loading.gif',
                       fit: BoxFit.cover,
                       width: double.infinity,
                       height: 82,
                     ),
                     errorWidget: (context, url, error) => Icon(Icons.error),
                   ),
                 ),
               ),

               Container(
                 margin: EdgeInsetsDirectional.only(end: 10, top: 5, start: 80),
                 padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.all(Radius.circular(100)),
                   color: food.discountPrice > 0 ? Colors.red : Theme.of(context).accentColor,
                 ),
                 alignment: AlignmentDirectional.topEnd,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: <Widget>[
                     Helper.getPrice(
                       food.price,
                       context,
                       style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Theme.of(context).primaryColor)),
                     ),
                   ],
                 ),
               ),
             ],
           ),


            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      SizedBox(
                        width: 120,
                        child: AutoSizeText(
                          food.name,
                          style: Theme.of(context).textTheme.bodyText2,
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                      ),


                      SizedBox(
                        width: 120,
                        child: AutoSizeText(
                          food.restaurant.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 8,
                          ),
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),


                  SizedBox(width: 5),


                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
