import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/home_controller.dart';
import '../elements/SearchBarWidget2.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../repository/settings_repository.dart' as settingsRepo;
import '../elements/ProductGridWidget.dart';

class ProductList extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  String value;
  ProductList({Key key, this.value, this.parentScaffoldKey}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends StateMVC<ProductList> {
  HomeController _con;
  String value;

  _ProductListState({this.value}) : super(HomeController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: PreferredSize(
              child: Container(
                color: Colors.grey,
                height: 2.0,
              ),
              preferredSize: Size.fromHeight(0.1)),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: ValueListenableBuilder(
            valueListenable: settingsRepo.setting,
            builder: (context, value, child) {
              return AutoSizeText(
                "Products", //value.appName ?? S.of(context).home,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .merge(TextStyle(letterSpacing: 1.3)),
              );
            },
          ),
//        title: AutoSizeText(
//          settingsRepo.setting?.value.appName ?? S.of(context).home,
//          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
//        ),
          actions: <Widget>[
            new ShoppingCartButtonWidget(
                iconColor: Theme.of(context).hintColor,
                labelColor: Theme.of(context).accentColor),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _con.refreshHome,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SearchBarWidget2(
                    onClickFilter: (event) {
                      widget.parentScaffoldKey.currentState.openEndDrawer();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    leading: Icon(
                      Icons.store,
                      color: Theme.of(context).hintColor,
                    ),
                    title: AutoSizeText(
                      "Products",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    /*subtitle: AutoSizeText(
                    S.of(context).near_to + " " + (settingsRepo.deliveryAddress.value?.address ?? S.of(context).unknown),
                    style: Theme.of(context).textTheme.caption,
                  ),*/
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ProductGridWidget(
                    foodList: _con.allProducts,
                    heroTag: 'list_products',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SearchBarWidget(
                  onClickFilter: (event) {
                    widget.parentScaffoldKey.currentState.openEndDrawer();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.stars,
                    color: Theme.of(context).hintColor,
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      if (currentUser.value.apiToken == null) {
                        _con.requestForCurrentLocation(context);
                      } else {
                        var bottomSheetController = widget.parentScaffoldKey.currentState.showBottomSheet(
                          (context) => DeliveryAddressBottomSheetWidget(scaffoldKey: widget.parentScaffoldKey),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                          ),
                        );
                        bottomSheetController.closed.then((value) {
                          _con.refreshHome();
                        });
                      }
                    },
                    icon: Icon(
                      Icons.my_location,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  title: AutoSizeText(
                    S.of(context).top_restaurants,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  subtitle: AutoSizeText(
                    S.of(context).near_to + " " + (settingsRepo.deliveryAddress.value?.address ?? S.of(context).unknown),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ),
              CardsCarouselWidget(restaurantsList: _con.topRestaurants, heroTag: 'home_top_restaurants'),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                leading: Icon(
                  Icons.trending_up,
                  color: Theme.of(context).hintColor,
                ),
                title: AutoSizeText(
                  S.of(context).trending_this_week,
                  style: Theme.of(context).textTheme.headline4,
                ),
                subtitle: AutoSizeText(
                  S.of(context).clickOnTheFoodToGetMoreDetailsAboutIt,
                  style: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 11)),
                ),
              ),
              FoodsCarouselWidget(foodsList: _con.trendingFoods, heroTag: 'home_food_carousel'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.category,
                    color: Theme.of(context).hintColor,
                  ),
                  title: AutoSizeText(
                    S.of(context).food_categories,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
              CategoriesCarouselWidget(
                categories: _con.categories,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.trending_up,
                    color: Theme.of(context).hintColor,
                  ),
                  title: AutoSizeText(
                    S.of(context).most_popular,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridWidget(
                  restaurantsList: _con.popularRestaurants,
                  heroTag: 'home_restaurants',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  leading: Icon(
                    Icons.recent_actors,
                    color: Theme.of(context).hintColor,
                  ),
                  title: AutoSizeText(
                    S.of(context).recent_reviews,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ReviewsListWidget(reviewsList: _con.recentReviews),
              ),*/
