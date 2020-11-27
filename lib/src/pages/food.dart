import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/food_controller.dart';
import '../elements/AddToCartAlertDialog.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/ExtraItemWidget.dart';
import '../elements/ReviewsListWidget.dart';
import '../elements/ShoppingCartFloatButtonWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart';

// ignore: must_be_immutable
class FoodWidget extends StatefulWidget {
  RouteArgument routeArgument;

  FoodWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _FoodWidgetState createState() {
    return _FoodWidgetState();
  }
}

class _FoodWidgetState extends StateMVC<FoodWidget> {
  FoodController _con;
  int currentCount = 0;

  _FoodWidgetState() : super(FoodController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForFood(foodId: widget.routeArgument.id);
    _con.listenForCart();
    _con.listenForFavorite(foodId: widget.routeArgument.id);
    //getQuantity();
    super.initState();

    //print(currentCount);
  }

  getQuantity() async {
    currentCount = await int.parse(_con.food.packageItemsCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: _con.food == null || _con.food?.image == null
          ? CircularLoadingWidget(height: 500)
          : RefreshIndicator(
              onRefresh: _con.refreshFood,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 125),
                    padding: EdgeInsets.only(bottom: 15),
                    child: CustomScrollView(
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
                              tag: widget.routeArgument.heroTag ??
                                  '' + _con.food.id,
                              child: _con.food.image.url.toString() ==
                                      "https://goldilocks.ml/images/image_default.png"
                                  ? Image.asset(
                                      'assets/custom_img/place_holder_g.png',
                                      fit: BoxFit.cover,
                                    )
                                  : CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: _con.food.image.url,
                                      placeholder: (context, url) =>
                                          Image.asset(
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: Wrap(
                              runSpacing: 8,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          AutoSizeText(
                                            _con.food?.name ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3,
                                          ),
                                          AutoSizeText(
                                            _con.food?.restaurant?.name ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .merge(TextStyle(
                                                    color: Theme.of(context)
                                                        .hintColor)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                0.5,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Helper.getPrice(
                                              _con.food.price,
                                              context,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline2
                                                  .merge(TextStyle(
                                                      color:
                                                          Color(0xFFFea300))),
                                            ),
                                            _con.food.discountPrice > 0
                                                ? Helper.getPrice(
                                                    _con.food.discountPrice,
                                                    context,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        .merge(TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough)))
                                                : SizedBox(height: 0),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    //Container(
                                    //  padding: EdgeInsets.symmetric(
                                    //      horizontal: 8, vertical: 10),
                                    //  decoration: BoxDecoration(
                                    //      border: Border.all(
                                    //        color: Helper.canDelivery(
                                    //            _con.food.restaurant) &&
                                    //            _con.food.deliverable
                                    //            ? Colors.green
                                    //            : Colors.orange,
                                    //        width: 1.0,
                                    //      ),
                                    //      borderRadius:
                                    //          BorderRadius.circular(5)),
                                    //  child: Helper.canDelivery(
                                    //              _con.food.restaurant) &&
                                    //          _con.food.deliverable
                                    //      ? AutoSizeText(
                                    //          S.of(context).deliverable,
                                    //          style: Theme.of(context)
                                    //              .textTheme
                                    //              .caption
                                    //              .merge(TextStyle(
                                    //                  color: Colors.green)),
                                    //        )
                                    //      : AutoSizeText(
                                    //          S.of(context).store_pick_up,
                                    //          style: Theme.of(context)
                                    //              .textTheme
                                    //              .caption
                                    //              .merge(TextStyle(
                                    //                  color: Colors.orange)),
                                    //        ),

//                                    //),

                                    //SizedBox(width: 10,),
                                    // Container(
                                    //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                    //     decoration: BoxDecoration(color: Theme.of(context).focusColor, borderRadius: BorderRadius.circular(24)),
                                    //     child: AutoSizeText(
                                    //       _con.food.weight + " " + _con.food.unit,
                                    //       style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                                    //     )),
                                    // SizedBox(width: 5),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  _con.food.packageItemsCount !=
                                                          "0"
                                                      ? Colors.green
                                                      : Theme.of(context)
                                                          .dividerColor,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: AutoSizeText(
                                          _con.food.packageItemsCount +
                                              " " +
                                              S.of(context).items,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .merge(TextStyle(
                                                  color: _con.food
                                                              .packageItemsCount !=
                                                          "0"
                                                      ? Colors.green
                                                      : Theme.of(context)
                                                          .dividerColor)),
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),

                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .dividerColor,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: AutoSizeText(
                                          _con.food.category.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .merge(TextStyle(
                                                  color: Theme.of(context)
                                                      .dividerColor)),
                                        )),

                                    //Container(
                                    //    padding: EdgeInsets.symmetric(
                                    //        horizontal: 12, vertical: 3),
                                    //    decoration: BoxDecoration(
                                    //        color: Theme.of(context).focusColor,
                                    //        borderRadius:
                                    //            BorderRadius.circular(24)),
                                    //    child: _con.food.packageItemsCount == '0'
                                    //        ? AutoSizeText(
                                    //      S.of(context).out_of_stock,
                                    //      style: Theme.of(context)
                                    //          .textTheme
                                    //          .caption
                                    //          .merge(TextStyle(
                                    //          color: Theme.of(context)
                                    //              .primaryColor)),
                                    //    ) :
                                    //    AutoSizeText(
                                    //      _con.food.packageItemsCount +
                                    //          " " +
                                    //          S.of(context).items,
                                    //      style: Theme.of(context)
                                    //          .textTheme
                                    //          .caption
                                    //          .merge(TextStyle(
                                    //          color: Theme.of(context)
                                    //              .primaryColor)),
                                    //    ),),
                                  ],
                                ),
                                Helper.applyHtml(context, _con.food.description,
                                    style: TextStyle(fontSize: 12)),
                                //ListTile(
                                //  dense: true,
                                //  contentPadding: EdgeInsets.symmetric(vertical: 10),
                                //  leading: Icon(
                                //    Icons.add_circle,
                                //    color: Theme.of(context).hintColor,
                                //  ),
                                //  title: AutoSizeText(
                                //    S.of(context).extras,
                                //    style: Theme.of(context).textTheme.subtitle1,
                                //  ),
                                //  subtitle: AutoSizeText(
                                //    S.of(context).select_extras_to_add_them_on_the_food,
                                //    style: Theme.of(context).textTheme.caption,
                                //  ),
                                //),
                                //_con.food.extraGroups == null
                                //    ? CircularLoadingWidget(height: 100)
                                //    : ListView.separated(
                                //        padding: EdgeInsets.all(0),
                                //        itemBuilder: (context, extraGroupIndex) {
                                //          var extraGroup = _con.food.extraGroups.elementAt(extraGroupIndex);
                                //          return Wrap(
                                //            children: <Widget>[
                                //              ListTile(
                                //                dense: true,
                                //                contentPadding: EdgeInsets.symmetric(vertical: 0),
                                //                leading: Icon(
                                //                  Icons.add_circle_outline,
                                //                  color: Theme.of(context).hintColor,
                                //                ),
                                //                title: AutoSizeText(
                                //                  extraGroup.name,
                                //                  style: Theme.of(context).textTheme.subtitle1,
                                //                ),
                                //              ),
                                //              ListView.separated(
                                //                padding: EdgeInsets.all(0),
                                //                itemBuilder: (context, extraIndex) {
                                //                  return ExtraItemWidget(
                                //                    extra: _con.food.extras.where((extra) => extra.extraGroupId == extraGroup.id).elementAt(extraIndex),
                                //                    onChanged: _con.calculateTotal,
                                //                  );
                                //                },
                                //                separatorBuilder: (context, index) {
                                //                  return SizedBox(height: 20);
                                //                },
                                //                itemCount: _con.food.extras.where((extra) => extra.extraGroupId == extraGroup.id).length,
                                //                primary: false,
                                //                shrinkWrap: true,
                                //              ),
                                //            ],
                                //          );
                                //        },
                                //        separatorBuilder: (context, index) {
                                //          return SizedBox(height: 20);
                                //        },
                                //        itemCount: _con.food.extraGroups.length,
                                //        primary: false,
                                //        shrinkWrap: true,
                                //      ),
                                //ListTile(
                                //  dense: true,
                                //  contentPadding: EdgeInsets.symmetric(vertical: 10),
                                //  leading: Icon(
                                //    Icons.donut_small,
                                //    color: Theme.of(context).hintColor,
                                //  ),
                                //  title: AutoSizeText(
                                //    S.of(context).ingredients,
                                //    style: Theme.of(context).textTheme.subtitle1,
                                //  ),
                                //),
                                //Helper.applyHtml(context, _con.food.ingredients, style: TextStyle(fontSize: 12)),
                                //ListTile(
                                //  dense: true,
                                //  contentPadding: EdgeInsets.symmetric(vertical: 10),
                                //  leading: Icon(
                                //    Icons.local_activity,
                                //    color: Theme.of(context).hintColor,
                                //  ),
                                //  title: AutoSizeText(
                                //    S.of(context).nutrition,
                                //    style: Theme.of(context).textTheme.subtitle1,
                                //  ),
                                //),
                                //Wrap(
                                //  spacing: 8,
                                //  runSpacing: 8,
                                //  children: List.generate(_con.food.nutritions.length, (index) {
                                //    return Container(
                                //      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                //      decoration: BoxDecoration(
                                //          color: Theme.of(context).primaryColor,
                                //          borderRadius: BorderRadius.all(Radius.circular(5)),
                                //          boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.2), offset: Offset(0, 2), blurRadius: 6.0)]),
                                //      child: Column(
                                //        mainAxisSize: MainAxisSize.min,
                                //        children: <Widget>[
                                //          AutoSizeText(_con.food.nutritions.elementAt(index).name,
                                //              overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.caption),
                                //          AutoSizeText(_con.food.nutritions.elementAt(index).quantity.toString(),
                                //              overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.headline5),
                                //        ],
                                //      ),
                                //    );
                                //  }),
                                //),
                                //ListTile(
                                //  dense: true,
                                //  contentPadding: EdgeInsets.symmetric(vertical: 10),
                                //  leading: Icon(
                                //    Icons.recent_actors,
                                //    color: Theme.of(context).hintColor,
                                //  ),
                                //  title: AutoSizeText(
                                //    S.of(context).reviews,
                                //    style: Theme.of(context).textTheme.subtitle1,
                                //  ),
                                //),
                                //ReviewsListWidget(
                                //  reviewsList: _con.food.foodReviews,
                                //),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
                        : ShoppingCartFloatButtonWidget(
                            iconColor: Theme.of(context).primaryColor,
                            labelColor: Theme.of(context).hintColor,
                            food: _con.food,
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 160,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.15),
                                offset: Offset(0, -2),
                                blurRadius: 5.0)
                          ]),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            _con.food.packageItemsCount == '0'
                                ? SizedBox(height: 50)
                                : Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: AutoSizeText(
                                          S.of(context).quantity,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1.merge(TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      _con.food.packageItemsCount == '0'
                                          ? SizedBox(
                                              height: 50,
                                            )
                                          : Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                IconButton(
                                                  onPressed: () {
                                                    _con.decrementQuantity();
                                                  },
                                                  iconSize: 30,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 10),
                                                  icon: Icon(Icons
                                                      .remove_circle_outline),
                                                  color: Theme.of(context)
                                                      .dividerColor,
                                                ),
                                                AutoSizeText(
                                                    _con.quantity
                                                        .round()
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1),
                                                _con.quantity <
                                                        int.parse(_con.food
                                                            .packageItemsCount)
                                                    ? IconButton(
                                                        onPressed: () {
                                                          _con.incrementQuantity();
                                                        },
                                                        iconSize: 30,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5,
                                                                vertical: 10),
                                                        icon: Icon(Icons
                                                            .add_circle_outline),
                                                        color: Theme.of(context)
                                                            .dividerColor,
                                                      )
                                                    : IconButton(
                                                        onPressed: () {},
                                                        iconSize: 30,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5,
                                                                vertical: 10),
                                                        icon: Icon(Icons
                                                            .add_circle_outline),
                                                        color: Theme.of(context)
                                                            .dividerColor,
                                                      ),
                                              ],
                                            ),
                                    ],
                                  ),
                            Divider(height: 20),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                //Expanded(
                                //  child: _con.favorite?.id != null
                                //      ? OutlineButton(
                                //          onPressed: () {
                                //            _con.removeFromFavorite(_con.favorite);
                                //          },
                                //          padding: EdgeInsets.symmetric(vertical: 14),
                                //          color: Theme.of(context).primaryColor,
                                //          shape: StadiumBorder(),
                                //          borderSide: BorderSide(color: Theme.of(context).accentColor),
                                //          child: Icon(
                                //            Icons.favorite,
                                //            color: Theme.of(context).accentColor,
                                //          ))
                                //      : FlatButton(
                                //          onPressed: () {
                                //            if (currentUser.value.apiToken == null) {
                                //              Navigator.of(context).pushNamed("/Login");
                                //            } else {
                                //              _con.addToFavorite(_con.food);
                                //            }
                                //          },
                                //          padding: EdgeInsets.symmetric(vertical: 14),
                                //          color: Theme.of(context).accentColor,
                                //          shape: StadiumBorder(),
                                //          child: Icon(
                                //            Icons.favorite,
                                //            color: Theme.of(context).primaryColor,
                                //          )),
                                //),

                                _con.food.packageItemsCount == '0'
                                    ? Stack(
                                        fit: StackFit.loose,
                                        alignment:
                                            AlignmentDirectional.centerEnd,
                                        children: <Widget>[
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                60,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Theme.of(context)
                                                          .dividerColor
                                                          .withOpacity(0.2),
                                                      blurRadius: 15,
                                                      offset: Offset(0, 15)),
                                                  BoxShadow(
                                                      color: Theme.of(context)
                                                          .dividerColor
                                                          .withOpacity(0.2),
                                                      blurRadius: 5,
                                                      offset: Offset(0, 3))
                                                ],
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100)),
                                              ),
                                              child: FlatButton(
                                                onPressed: () {},
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 14),
                                                color: Colors
                                                    .grey, //Theme.of(context).accentColor,
                                                shape: StadiumBorder(),
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20),
                                                  child: AutoSizeText(
                                                    S.of(context).out_of_stock,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                AutoSizeText(
                                                  S.of(context).subtotal,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption,
                                                ),
                                                Helper.getPrice(
                                                  _con.total,
                                                  context,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline4
                                                      .merge(TextStyle(
                                                          color: Color(
                                                              0xFFFEA300))),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Stack(
                                            fit: StackFit.loose,
                                            alignment:
                                                AlignmentDirectional.centerEnd,
                                            children: <Widget>[
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    190,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Theme.of(
                                                                  context)
                                                              .accentColor
                                                              .withOpacity(0.2),
                                                          blurRadius: 15,
                                                          offset:
                                                              Offset(0, 15)),
                                                      BoxShadow(
                                                          color: Theme.of(
                                                                  context)
                                                              .accentColor
                                                              .withOpacity(0.2),
                                                          blurRadius: 5,
                                                          offset: Offset(0, 3))
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                100)),
                                                  ),
                                                  child: FlatButton(
                                                    onPressed: () {
                                                      if (currentUser
                                                              .value.apiToken ==
                                                          null) {
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                "/Login");
                                                      } else {
                                                        _con.addToCart(
                                                            _con.food,
                                                            _con.food.restaurant
                                                                .id);
                                                        //if (_con.isSameRestaurants(
                                                        //    _con.food)) {
                                                        //  _con.addToCart(_con.food);
                                                        //} else {
                                                        //  showDialog(
                                                        //    context: context,
                                                        //    builder: (BuildContext
                                                        //    context) {
                                                        //      // return object of type Dialog
                                                        //      return AddToCartAlertDialogWidget(
                                                        //          oldFood: _con.carts
                                                        //              .elementAt(0)
                                                        //              ?.food,
                                                        //          newFood: _con.food,
                                                        //          onPressed: (food,
                                                        //              {reset: true}) {
                                                        //            return _con
                                                        //                .addToCart(
                                                        //                _con.food,
                                                        //                reset:
                                                        //                true);
                                                        //          });
                                                        //    },
                                                        //  );
                                                        //}
                                                      }
                                                    },
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 14),
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    shape: StadiumBorder(),
                                                    child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 20),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Icon(Icons
                                                                .add_shopping_cart),
                                                            SizedBox(width: 10),
                                                            AutoSizeText(
                                                              S
                                                                  .of(context)
                                                                  .add_cart,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .hintColor),
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

/*
 */
