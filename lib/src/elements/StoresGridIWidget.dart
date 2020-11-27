import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../elements/StoresGridItemWidget.dart';
import '../models/restaurant.dart';

class StoresGridWidget extends StatelessWidget {
  final List<Restaurant> restaurant;
  final String heroTag;
  StoresGridWidget({Key key, this.restaurant, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return new 
    StaggeredGridView.countBuilder(

      primary: false,
      shrinkWrap: true,
      crossAxisCount: 4,
      itemCount: restaurant.length,
      itemBuilder: (BuildContext context, int index) {
        return StoresGridItemWidget(restaurant: restaurant.elementAt(index), heroTag: heroTag);
      },
//                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(index % 2 == 0 ? 1 : 2),
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(MediaQuery.of(context).orientation == Orientation.portrait ? 5 : 2),
      mainAxisSpacing: 15.0,
      crossAxisSpacing: 15.0,
    );

  }
}




