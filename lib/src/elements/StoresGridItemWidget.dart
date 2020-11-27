import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../helpers/helper.dart';
import '../models/restaurant.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';


class StoresGridItemWidget extends StatelessWidget {

  final Restaurant restaurant;
  final String heroTag;


  StoresGridItemWidget({Key key, this.restaurant, this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        Navigator.of(context).pushNamed('/Details', arguments: RouteArgument(id: restaurant.id, heroTag: heroTag));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.05), offset: Offset(0, 5), blurRadius: 5)]),
        child: Wrap(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: Hero(
                tag: heroTag + restaurant.id,
                child: restaurant.image.url.toString() == "https://goldilocks.ml/images/image_default.png" ?  Image.asset(
                  'assets/custom_img/place_holder_g.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ) : CachedNetworkImage(
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: restaurant.image.url,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 15,bottom: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: (MediaQuery.of(context).orientation == Orientation.portrait ? (MediaQuery.of(context).size.width/2) : (MediaQuery.of(context).size.width/5)),
                        child: AutoSizeText(
                          restaurant.name,
                          style: Theme.of(context).textTheme.subtitle1,
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      SizedBox(
                        width: (MediaQuery.of(context).orientation == Orientation.portrait ? (MediaQuery.of(context).size.width/2) : (MediaQuery.of(context).size.width/5)),
                        child: AutoSizeText(
                          Helper.skipHtml(restaurant.address),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),

                    ],
                  ),

                  SizedBox(width: 15,),


                  restaurant.distance > 0
                      ? Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                      color: Color(0xFFFECD00).withOpacity(0.2),),

                      child: AutoSizeText(
                        Helper.getDistance(
                            restaurant.distance,
                            Helper.of(context)
                                .trans(setting.value.distanceUnit)),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                        style: Theme.of(context).textTheme.caption.merge(TextStyle(
                          color: Color(0xFF997F13), )),
                      ))
                      : SizedBox(height: 0),

                  SizedBox(width: 5),

                  //Container(
                  //  margin: EdgeInsets.all(10),
                  //  width: 40,
                  //  height: 40,
                  //  child: FlatButton(
                  //    padding: EdgeInsets.all(0),
                  //    child: Icon(
                  //      Icons.shopping_cart,
                  //      color: Theme.of(context).primaryColor,
                  //      size: 24,
                  //    ),
                  //    color: Theme.of(context).accentColor.withOpacity(0.9),
                  //    shape: StadiumBorder(),
                  //  ),
                  //),
//
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
