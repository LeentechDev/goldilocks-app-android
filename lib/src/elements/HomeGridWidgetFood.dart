import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../elements/HomeGridItemWidgetFood.dart';
import '../models/food.dart';

class HomeGridWidgetFood extends StatelessWidget {
  final List<Food> foodList;
  final String heroTag;
  HomeGridWidgetFood({Key key, this.foodList, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return new StaggeredGridView.countBuilder(

      primary: false,
      shrinkWrap: true,
      crossAxisCount: 4,
      itemCount: foodList.length,
      itemBuilder: (BuildContext context, int index) {
        return HomeGridItemWidgetFood(food: foodList.elementAt(index), heroTag: heroTag);
      },
//                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(index % 2 == 0 ? 1 : 2),
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(MediaQuery.of(context).orientation == Orientation.portrait ? 5: 2),
      mainAxisSpacing: 15.0,
      crossAxisSpacing: 15.0,
    );
  }
}
