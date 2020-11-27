import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../elements/CartItemWidget.dart';
import '../elements/StoresGridItemWidget.dart';
import '../models/restaurant.dart';

class CartRestaurantWidget extends StatelessWidget {
  final List<Restaurant> restaurant;
  final String heroTag;
  CartRestaurantWidget({Key key, this.restaurant, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return new ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 15),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      primary: false,
      itemCount: restaurant.length,
      separatorBuilder: (context, index) {
        return SizedBox(height: 15);
      },
      itemBuilder: (BuildContext context, int index) {
        return StoresGridItemWidget(restaurant: restaurant.elementAt(index), heroTag: heroTag);
      },
    );
  }
}

/*
ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 15),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      primary: false,
      itemCount: restaurant.length,
      separatorBuilder: (context, index) {
        return SizedBox(height: 15);
      },
      itemBuilder: (BuildContext context, int index) {
        return StoresGridItemWidget(restaurant: restaurant.elementAt(index), heroTag: heroTag);
      },
    );
 */