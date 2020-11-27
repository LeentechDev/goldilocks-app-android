import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:food_delivery_app/src/repository/food_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../generated/l10n.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/FoodItemWidget.dart';
import '../elements/StoreShoppingCartFloatButtonWidget.dart';
import '../elements/GalleryCarouselWidget.dart';
import '../elements/EmptyAllMenuWidget.dart';
import '../elements/EmptyFeaturedFoodsWidget.dart';
import '../elements/CaregoriesCarouselWidget.dart';

import '../helpers/helper.dart';
import '../Bloc/shared_pref.dart';
import '../Bloc/Providers.dart';
import '../Bloc/OrderTypeProvider.dart';
import '../models/route_argument.dart';
import '../models/food.dart';
import '../repository/settings_repository.dart';
import '../repository/food_repository.dart';

class DetailsWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  DetailsWidget({Key key, this.routeArgument}) : super(key: key);

  final SharedPrefs sharedPrefs = SharedPrefs();
  int orderType;

  getOrderType() async {
    orderType = await sharedPrefs.getIntOrderType();
    print(orderType);
  }

  @override
  _DetailsWidgetState createState() {
    return _DetailsWidgetState();
  }
}

class _DetailsWidgetState extends StateMVC<DetailsWidget> {
  RestaurantController _con;
  bool isListening = false;

  _DetailsWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

  @override
  void initState() {
    getOrderType();
    _con.listenForRestaurant(id: widget.routeArgument.id);
    _con.listenForGalleries(widget.routeArgument.id);
    _con.listenForFeaturedFoods(widget.routeArgument.id);
    _con.listenForRestaurantReviews(id: widget.routeArgument.id);

    _con.listenForCart();
    _con.listenForCartsCount();
    super.initState();
  }

  List<String> categories = [
    "All",
    "Greeting Cakes",
    "Premium Cakes",
    "Filipino Sweets",
    "Pasties Snack",
    "Cake Rolls",
    "Bread"
  ];
  int selectedIndex = 0;

  Future<Stream<Food>> foods;

  @override
  Widget build(BuildContext context) {
    if (!isListening) {
      _con.listenForFoods(widget.routeArgument.id, context);
      isListening = true;
    }
    String order = Provider.of<OrderTypeGenerator>(context).OType.toString();
    return Scaffold(
        key: _con.scaffoldKey,
        //floatingActionButton: FloatingActionButton.extended(
        //  onPressed: () {
        //    Navigator.of(context).pushNamed('/Menu',
        //        arguments: new RouteArgument(id: widget.routeArgument.id));
        //  },
        //  isExtended: true,
        //  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        //  icon: Icon(
        //    Icons.restaurant,
        //    color: Theme.of(context).primaryColor,
        //  ),
        //  label: Text(
        //    S.of(context).Menu,
        //    style: TextStyle(color: Theme.of(context).primaryColor),
        //  ),
        //),
        //floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: RefreshIndicator(
          onRefresh: _con.refreshRestaurant,
          child: _con.restaurant == null
              ? CircularLoadingWidget(height: 500)
              : Stack(
            fit: StackFit.expand,
            children: <Widget>[
              CustomScrollView(
                primary: true,
                shrinkWrap: false,
                slivers: <Widget>[
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: false,
                    title: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.5),
                                borderRadius: BorderRadius.circular(50)),
                            child: Icon(Icons.arrow_back)),
                      ),
                    ),
                    backgroundColor:
                    Theme.of(context).accentColor.withOpacity(0.9),
                    expandedHeight: 300,
                    elevation: 0,
                    iconTheme: IconThemeData(
                        color: Theme.of(context).primaryColor),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Hero(
                        tag: widget.routeArgument.heroTag +
                            _con.restaurant.id,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: _con.restaurant.image.url,
                          placeholder: (context, url) => Image.asset(
                            'assets/img/loading.gif',
                            fit: BoxFit.cover,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 20, left: 20, bottom: 10, top: 25),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: AutoSizeText(
                                  _con.restaurant?.name ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3,
                                ),
                              ),
                              /*SizedBox(
                                      height: 32,
                                      child: Chip(
                                        padding: EdgeInsets.all(0),
                                        label: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(_con.restaurant.rate,
                                                style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Theme.of(context).primaryColor))),
                                            Icon(
                                              Icons.star_border,
                                              color: Theme.of(context).primaryColor,
                                              size: 16,
                                            ),
                                          ],
                                        ),
                                        backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
                                        shape: StadiumBorder(),
                                      ),
                                    ),*/
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 20),
                            //Container(
                            //  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                            //  decoration:
                            //  BoxDecoration(color: _con.restaurant.closed ? Colors.grey : Colors.green, borderRadius: BorderRadius.circular(24)),
                            //  child: _con.restaurant.closed
                            //      ? Text(
                            //    S.of(context).closed,
                            //    style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                            //  )
                            //      : Text(
                            //    S.of(context).open,
                            //    style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                            //  ),
                            //),
                            //SizedBox(width: 10),

                            //Container(
                            //  padding: EdgeInsets.symmetric(
                            //      horizontal: 12, vertical: 3),
                            //  decoration: BoxDecoration(
                            //      color:
                            //      Helper.canDelivery(_con.restaurant)
                            //          ? Colors.green
                            //          : Colors.orange,
                            //      borderRadius:
                            //      BorderRadius.circular(24)),
                            //  child: Helper.canDelivery(_con.restaurant)
                            //      ? Text(
                            //    S.of(context).mail_order,
                            //    style: Theme.of(context)
                            //        .textTheme
                            //        .caption
                            //        .merge(TextStyle(
                            //        color: Theme.of(context)
                            //            .primaryColor)),
                            //  )
                            //      : Text(
                            //    S.of(context).store_pick_up,
                            //    style: Theme.of(context)
                            //        .textTheme
                            //        .caption
                            //        .merge(TextStyle(
                            //        color: Theme.of(context)
                            //            .primaryColor)),
                            //  ),
                            //),
                            //Expanded(child: SizedBox(height: 0)),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: order == '1'
                                        ? Colors.green
                                        : order == '2'
                                        ? Colors.blue
                                        : Colors.orange,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: AutoSizeText(
                                    order == '1'
                                        ? S.of(context).mail_order
                                        : order == '2'
                                        ? S.of(context).delivery
                                        : S.of(context).store_pick_up,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .merge(TextStyle(
                                      color: order == '1'
                                          ? Colors.green
                                          : order == '2'
                                          ? Colors.blue
                                          : Colors.orange,
                                    )))
                              //Provider.of<OrderTypeGenerator>(context)
                              //            .OType
                              //            .toString() ==
                              //        "Delivery"
                              //    ? AutoSizeText(
                              //        S.of(context).mail_order,
                              //        style: Theme.of(context)
                              //            .textTheme
                              //            .caption
                              //            .merge(TextStyle(
                              //                color: Colors.green)),
                              //      )
                              //    : AutoSizeText(
                              //        S.of(context).store_pick_up,
                              //        style: Theme.of(context)
                              //            .textTheme
                              //            .caption
                              //            .merge(TextStyle(
                              //                color: Colors.orange)),
                              //      ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                  color:
                                  Helper.canDelivery(_con.restaurant)
                                      ? Colors.green
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(5)),
                              child: AutoSizeText(
                                Helper.getDistance(
                                    _con.restaurant.distance,
                                    Helper.of(context).trans(
                                        setting.value.distanceUnit)),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .merge(TextStyle(
                                    color:
                                    Theme.of(context).hintColor)),
                              ),
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Helper.applyHtml(
                              context, _con.restaurant.description),
                        ),
                        ImageThumbCarouselWidget(
                            galleriesList: _con.galleries),

                        //Padding(
                        //  padding: const EdgeInsets.symmetric(horizontal: 20),
                        //  child: ListTile(
                        //    dense: true,
                        //    contentPadding: EdgeInsets.symmetric(vertical: 0),
                        //    leading: Icon(
                        //      Icons.stars,
                        //      color: Theme.of(context).hintColor,
                        //    ),
                        //    title: Text(
                        //      S.of(context).information,
                        //      style: Theme.of(context).textTheme.headline4,
                        //    ),
                        //  ),
                        //),
                        //Padding(
                        //  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        //  child: Helper.applyHtml(context, _con.restaurant.information),
                        //),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: ListTile(
                            dense: true,
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 0),
                            leading: SvgPicture.asset(
                                'assets/custom_img/information_icon.svg',
                                width: 30),
                            title: AutoSizeText(
                              S.of(context).information,
                              style:
                              Theme.of(context).textTheme.headline4,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 15),
                          child: Container(
                            height: 0.5,
                            color: Colors.grey.withOpacity(0.8),
                          ),
                        ),

                        _con.restaurant.information == null
                            ? SizedBox()
                            : Padding(
                          padding: const EdgeInsets.only(
                              left: 35,
                              right: 20,
                              top: 12,
                              bottom: 12),
                          child: Helper.applyHtml(
                              context, _con.restaurant.information),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          color: Theme.of(context).primaryColor,
                          child: ListTile(
                            title: AutoSizeText(
                              _con.restaurant.address ?? '',
                              overflow: TextOverflow.ellipsis,
                              style:
                              Theme.of(context).textTheme.bodyText1,
                            ),
                            trailing: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFFECD00),
                                ),
                                child: SvgPicture.asset(
                                    'assets/custom_img/leftarrow_icon.svg')),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          color: Theme.of(context).primaryColor,
                          child: ListTile(
                            title: AutoSizeText(
                              _con.restaurant.phone == null &&
                                  _con.restaurant.mobile == null
                                  ? 'No available contacts for now'
                                  : '${_con.restaurant.phone} \n${_con.restaurant.mobile}',
                              overflow: TextOverflow.ellipsis,
                              style:
                              Theme.of(context).textTheme.bodyText1,
                            ),
                            trailing: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFFECD00),
                                ),
                                child: SvgPicture.asset(
                                    'assets/custom_img/localphone_icon.svg')),
                          ),
                        ),
                        ((_con.restaurant.doordash == "null") &&
                            (_con.restaurant.grubhub == "null") &&
                            (_con.restaurant.ubereats == "null") &&
                            (_con.restaurant.postmates == "null"))
                            ? SizedBox(
                          height: 0,
                        )
                            : SizedBox(height: 100),
                        (_con.restaurant.doordash != "null")
                            ? ListTile(
                          dense: true,
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 20),
                          leading: SvgPicture.asset(
                              'assets/custom_img/delivery_icon_option.svg',
                              width: 35),
                          title: AutoSizeText(
                            S.of(context).delivery_option,
                            style: Theme.of(context)
                                .textTheme
                                .headline4,
                          ),
                        )
                            : SizedBox(height: 0),
                        (_con.restaurant.doordash != "null")
                            ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20),
                          child: Divider(
                            height: 16,
                            thickness: 1,
                          ),
                        )
                            : SizedBox(height: 0),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 25),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                            children: <Widget>[
                              (_con.restaurant.doordash != "null")
                                  ? Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .accentColor,
                                      width: 2,
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                  height: 100,
                                  width: MediaQuery.of(context)
                                      .size
                                      .width /
                                      2.2,
                                  child: ConstrainedBox(
                                    constraints:
                                    BoxConstraints.expand(),
                                    child: FlatButton(
                                        onPressed: () {
                                          Provider.of<Providers>(
                                              context,
                                              listen: false)
                                              .setUrlValue(_con
                                              .restaurant
                                              .doordash);
                                          Navigator.of(context)
                                              .pushNamed(
                                              '/DoorDash');
                                        },
                                        child: Image.asset(
                                            'assets/custom_img/doordash_logo.png')),
                                  ),
                                ),
                              )
                                  : SizedBox(),
                              (_con.restaurant.grubhub != "null")
                                  ? Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .accentColor,
                                          width: 2,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      height: 100,
                                      width: MediaQuery.of(context)
                                          .size
                                          .width /
                                          2.2,
                                      child: ConstrainedBox(
                                        constraints:
                                        BoxConstraints.expand(),
                                        child: FlatButton(
                                            onPressed: () {
                                              Provider.of<Providers>(
                                                  context,
                                                  listen: false)
                                                  .setUrlValue(_con
                                                  .restaurant
                                                  .grubhub);
                                              Navigator.of(context)
                                                  .pushNamed(
                                                  '/Grubhub');
                                            },
                                            child: Image.asset(
                                                'assets/custom_img/grubhub_logo.png')),
                                      )))
                                  : SizedBox(height: 0),
                              (_con.restaurant.ubereats != "null")
                                  ? Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .accentColor,
                                          width: 2,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      height: 100,
                                      width: MediaQuery.of(context)
                                          .size
                                          .width /
                                          2.2,
                                      child: ConstrainedBox(
                                        constraints:
                                        BoxConstraints.expand(),
                                        child: FlatButton(
                                            onPressed: () {
                                              Provider.of<Providers>(
                                                  context,
                                                  listen: false)
                                                  .setUrlValue(_con
                                                  .restaurant
                                                  .ubereats);
                                              Navigator.of(context)
                                                  .pushNamed(
                                                  '/UberEats');
                                            },
                                            child: Image.asset(
                                                'assets/custom_img/ubereats_logo.png')),
                                      )))
                                  : SizedBox(height: 0),
                              (_con.restaurant.postmates != "null")
                                  ? Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .accentColor,
                                        width: 2,
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    height: 100,
                                    width: MediaQuery.of(context)
                                        .size
                                        .width /
                                        2.2,
                                    child: FlatButton(
                                        onPressed: () {
                                          Provider.of<Providers>(
                                              context,
                                              listen: false)
                                              .setUrlValue(_con
                                              .restaurant
                                              .postmates);
                                          Navigator.of(context)
                                              .pushNamed(
                                              '/Postmates');
                                        },
                                        child: Image.asset(
                                            'assets/custom_img/postmates_logo.png')),
                                  ))
                                  : SizedBox(height: 0),
                            ],
                          ),
                        ),

                        ((_con.restaurant.doordash == "null") &&
                            (_con.restaurant.grubhub == "null") &&
                            (_con.restaurant.ubereats == "null") &&
                            (_con.restaurant.postmates == "null"))
                            ? SizedBox(
                          height: 0,
                        )
                            : SizedBox(height: 150),

                        //Products
                        order == '1'
                            ? Column(
                          children: [
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20),
                              leading: SvgPicture.asset(
                                  'assets/custom_img/utensils_icon.svg',
                                  width: 25),
                              title: AutoSizeText(
                                S.of(context).featured_foods,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 15),
                              child: Container(
                                height: 0.5,
                                color: Colors.grey.withOpacity(0.8),
                              ),
                            ),
                            _con.featuredFoods.isEmpty
                                ? SizedBox()
                                : ListView.separated(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: false,
                              itemCount:
                              _con.featuredFoods.length,
                              separatorBuilder:
                                  (context, index) {
                                return SizedBox(height: 10);
                              },
                              itemBuilder: (context, index) {
                                return FoodItemWidget(
                                  heroTag:
                                  'details_featured_food',
                                  food: _con.featuredFoods
                                      .elementAt(index),
                                );
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20),
                              leading: SvgPicture.asset(
                                  'assets/custom_img/allmenu_icon.svg',
                                  width: 25),
                              title: AutoSizeText(
                                S.of(context).all_menu,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              child: Container(
                                height: 0.5,
                                color: Colors.grey.withOpacity(0.8),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 5, right: 5, bottom: 20),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    customRadio('All', 0),
                                    for (var x = 0;
                                    x < _con.categories.length;
                                    x++)
                                      customRadio(
                                          _con.categories[x].name,
                                          x + 1),
                                  ],
                                ),
                              ),
                            ),
                            _con.restaurant == null
                                ? EmptyAllMenuWidget()
                                : FutureBuilder(
                              future: getFoodsOfRestaurant(
                                  _con.restaurant.id,
                                  context),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.data == null) {
                                  return EmptyAllMenuWidget();
                                } else if (snapshot
                                    .connectionState ==
                                    ConnectionState.done) {
                                  return _con.foods.isEmpty
                                      ? EmptyAllMenuWidget()
                                      : ListView.separated(
                                    padding:
                                    const EdgeInsets
                                        .only(
                                        bottom: 50),
                                    scrollDirection:
                                    Axis.vertical,
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: _con
                                        .foods.length,
                                    separatorBuilder:
                                        (context,
                                        index) {
                                      return SizedBox(
                                          height: 10);
                                    },
                                    itemBuilder:
                                        (context,
                                        index) {
                                      return FoodItemWidget(
                                        heroTag:
                                        'menu_list',
                                        food: _con.foods
                                            .elementAt(
                                            index),
                                      );
                                    },
                                  );
                                } else if (snapshot
                                    .connectionState ==
                                    ConnectionState.waiting) {
                                  return EmptyAllMenuWidget();
                                } else {
                                  return EmptyAllMenuWidget();
                                }
                              },
                            ),
                          ],
                        )
                            : SizedBox(),

                        /*ListView.separated(
                                     padding: const EdgeInsets.only(bottom: 50),
                                     scrollDirection: Axis.vertical,
                                     shrinkWrap: true,
                                     primary: false,
                                     itemCount: _con.foods.length,
                                     separatorBuilder: (context, index) {
                                       return SizedBox(height: 10);
                                     },
                                     itemBuilder: (context, index) {
                                       return FoodItemWidget(
                                         heroTag: 'menu_list',
                                         food: _con.foods.elementAt(index),
                                       );
                                     },
                                   ),
                              _con.reviews.isEmpty
                                  ? SizedBox(height: 5)
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                      child: ListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                                        leading: Icon(
                                          Icons.recent_actors,
                                          color: Theme.of(context).hintColor,
                                        ),
                                        title: Text(
                                          S.of(context).what_they_say,
                                          style: Theme.of(context).textTheme.headline4,
                                        ),
                                      ),
                                    ),
                              _con.reviews.isEmpty
                                  ? SizedBox(height: 5)
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: ReviewsListWidget(reviewsList: _con.reviews),
                                    ),*/
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 30,
                right: 20,
                child: _con.loadCart
                    ? SizedBox(
                  width: 60,
                  height: 60,
                  child: RefreshProgressIndicator(),
                )
                    : StoreShoppingCartFloatButtonWidget(
                  iconColor: Theme.of(context).primaryColor,
                  labelColor: Theme.of(context).hintColor,
                  restaurant: _con.restaurant,
                ),
              ),
            ],
          ),
        ));
  }

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
      foods = getFoodsOfRestaurant(_con.restaurant.id, context);
    });
  }

  Widget customRadio(String text, int index) {
    return GestureDetector(
      onTap: () async {
        Providers categoryProviders =
        Provider.of<Providers>(context, listen: false);
        changeIndex(index);
        categoryProviders.setCategoryIDValue(index.toString());
        _con.refreshFoods();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          decoration: BoxDecoration(
            color: selectedIndex == index
                ? Theme.of(context).accentColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(50.0),
            border: Border.all(
              color: Theme.of(context).accentColor,
            ),
          ),
          child: AutoSizeText(text,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .merge(TextStyle(color: Theme.of(context).hintColor))),
        ),
      ),
    );
  }
}

/*
OutlineButton(
      onPressed: () => changeIndex(index),
      color: selectedIndex == index ? Colors.deepOrangeAccent[700] : Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      borderSide: BorderSide(color: selectedIndex == index ? Colors.deepOrangeAccent[700] : Colors.grey),
      child: Icon(icon,color:  selectedIndex == index ? Colors.deepOrangeAccent : Colors.grey,),
    );
Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        _con.restaurant.address ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    //SizedBox(
                                    //  width: 42,
                                    //  height: 42,
                                    //  child: FlatButton(
                                    //    padding: EdgeInsets.all(0),
                                    //    onPressed: () {
                                    //      Navigator.of(context).pushNamed(
                                    //          '/Pages',
                                    //          arguments: new RouteArgument(
                                    //              id: '1',
                                    //              param: _con.restaurant));
                                    //    },
                                    //    child: Icon(
                                    //      Icons.directions,
                                    //      color: Theme.of(context).primaryColor,
                                    //      size: 24,
                                    //    ),
                                    //    color: Theme.of(context)
                                    //        .accentColor
                                    //        .withOpacity(0.9),
                                    //    shape: StadiumBorder(),
                                    //  ),
                                    //),
                                  ],
                                ),
Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        '${_con.restaurant.phone} \n${_con.restaurant.mobile}',
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    //SizedBox(
                                    //  width: 42,
                                    //  height: 42,
                                    //  child: FlatButton(
                                    //    padding: EdgeInsets.all(0),
                                    //    onPressed: () {
                                    //      launch(
                                    //          "tel:${_con.restaurant.mobile}");
                                    //    },
                                    //    child: Icon(
                                    //      Icons.call,
                                    //      color: Theme.of(context).primaryColor,
                                    //      size: 24,
                                    //    ),
                                    //    color: Theme.of(context)
                                    //        .accentColor
                                    //        .withOpacity(0.9),
                                    //    shape: StadiumBorder(),
                                    //  ),
                                    //),
                                  ],
                                ),
 */