import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../generated/l10n.dart';
import '../controllers/tracking_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/FoodOrderItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../helpers/helper.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../Bloc/OrderTypeProvider.dart';
import '../models/route_argument.dart';
import '../elements/DetailsCancelWidget.dart';
import '../repository/settings_repository.dart';

class TrackingWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  TrackingWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _TrackingWidgetState createState() => _TrackingWidgetState();
}

class _TrackingWidgetState extends StateMVC<TrackingWidget>
    with SingleTickerProviderStateMixin {
  TrackingController _con;
  TabController _tabController;
  int _tabIndex = 0;
  int _currentStep0 = 0;
  int _currentStep1 = 1;
  int _currentStep2 = 2;
  int _currentStep3 = 3;
  int _currentStep4 = 4;
  Order order;
  bool trackLoader = true;

  Future<List<Order>> _getOrder() async {
    await _con.listenForOrder(orderId: widget.routeArgument.id);
  }

  _TrackingWidgetState() : super(TrackingController()) {
    _con = controller;
  }
  

  @override
  void initState() { if(_con.order != null){
_con?.order?.foodOrders == null ? CircularLoadingWidget(height: 50,) : SizedBox();
  }
    _getOrder().then((value){
      setState(() {
        _con.listenForOrder(orderId: widget.routeArgument.id);
        trackLoader = false;
      });
    });

    _tabController =
        TabController(length: 2, initialIndex: _tabIndex, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }

  //currentStep(){
  //  if(_con.order.orderStatus.status == "Order Received" || _con.order.orderStatus.status == "Canceled" || _con.order.orderStatus.status == "Declined"){
  //    setState(() {
  //      _currentStep = 0;
  //    });
  //  }
  //  else if(_con.order.orderStatus.status == "Preparing" || _con.order.orderStatus.status == "Processing Payment Return"){
  //    setState(() {
  //      _currentStep = 1;
  //    });
  //  }
  //  else if(_con.order.orderStatus.status == "Ready For Pickup" || _con.order.orderStatus.status == "Ready To Deliver" || _con.order.orderStatus.status == "Payment Returned"){
  //    setState(() {
  //      _currentStep = 2;
  //    });
  //  }
  //  else if(_con.order.orderStatus.status == "Completed" || _con.order.orderStatus.status == "On the Way"){
  //    setState(() {
  //      _currentStep = 3;
  //    });
  //  }
  //  else if(_con.order.orderStatus.status == "Delivered"){
  //    setState(() {
  //      _currentStep = 4;
  //    });
  //  }
  //  else if(_con.order.orderStatus.status == "Completed" || _con.order.orderStatus.status == "On the Way"){
  //    setState(() {
  //      _currentStep = 3;
  //    });
  //  }
//
  //  return _currentStep;
//
  //}


  @override
  Widget build(BuildContext context) {
    var group;
    var groupIMG;
    var groupRoute;

    //final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent, accentColor: Theme.of(context).accentColor);
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
if(_con.order != null){
    group = groupBy(_con?.order?.foodOrders, (obj) => obj.food.restaurant.name);
    groupIMG = groupBy(_con?.order?.foodOrders, (obj) => obj.food.restaurant.image.url);
    groupRoute = groupBy(_con?.order?.foodOrders, (obj) => obj.food.restaurant.id);
}

    return Scaffold(
        key: _con.scaffoldKey,
        /*bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          height: 135,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), offset: Offset(0, -2), blurRadius: 5.0)]),
          child: _con.order == null || _con.orderStatus.isEmpty
              ? CircularLoadingWidget(height: 120)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    AutoSizeText(S.of(context).how_would_you_rate_this_restaurant, style: Theme.of(context).textTheme.subtitle1),
                    AutoSizeText(S.of(context).click_on_the_stars_below_to_leave_comments, style: Theme.of(context).textTheme.caption),
                    SizedBox(height: 5),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/Reviews', arguments: RouteArgument(id: _con.order.id, heroTag: "restaurant_reviews"));
                      },
                      padding: EdgeInsets.symmetric(vertical: 5),
                      shape: StadiumBorder(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: Helper.getStarsList(double.parse(_con.order.foodOrders[0].food.restaurant.rate), size: 35),
                      ),
                    ),
                  ],
                ),
        ),*/
        body: _con.order == null || _con.orderStatus.isEmpty || trackLoader == true
            ? CircularLoadingWidget(height: 400)
            : CustomScrollView(slivers: <Widget>[
                SliverAppBar(
                  snap: true,
                  floating: true,
                  //centerTitle: true,
                  title: AutoSizeText(
                    S.of(context).orderDetails,
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .merge(TextStyle(letterSpacing: 1.3)),
                  ),
                  actions: <Widget>[
                    new ShoppingCartButtonWidget(
                        iconColor: Theme.of(context).hintColor,
                        labelColor: Theme.of(context).accentColor),
                  ],
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  bottom: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelPadding: EdgeInsets.symmetric(horizontal: 15),
                    unselectedLabelColor: Theme.of(context).dividerColor,
                    labelColor: Theme.of(context).accentColor,
                    tabs: [
                      Tab(
                        child: AutoSizeText(
                          S.of(context).details,
                        ),
                      ),
                      Tab(
                        child: AutoSizeText(S.of(context).track_order),
                      ),
                    ],
                  ),

                  /*


                TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelPadding: EdgeInsets.symmetric(horizontal: 15),
                      unselectedLabelColor: Theme.of(context).accentColor,
                      labelColor: Theme.of(context).primaryColor,
                      indicator: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Theme.of(context).accentColor),
                      tabs: [
                        Tab(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50), border: Border.all(color: Theme.of(context).accentColor.withOpacity(0.2), width: 1)),
                            child: Align(
                              alignment: Alignment.center,
                              child: AutoSizeText(S.of(context).details),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50), border: Border.all(color: Theme.of(context).accentColor.withOpacity(0.2), width: 1)),
                            child: Align(
                              alignment: Alignment.center,
                              child: AutoSizeText(S.of(context).track_order),
                            ),
                          ),
                        ),
                      ]),
                   */
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Offstage(
                      offstage: 0 != _tabIndex,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: <Widget>[
                            Opacity(
                              opacity: _con.order.active ? 1 : 0.4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top: 14),
                                    padding:
                                        EdgeInsets.only(top: 20, bottom: 5),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.9),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.1),
                                            blurRadius: 5,
                                            offset: Offset(0, 2)),
                                      ],
                                    ),
                                    child: Theme(
                                      data: theme,
                                      child: ExpansionTile(
                                        initiallyExpanded: true,
                                        title: Column(
                                          children: <Widget>[
                                            AutoSizeText(
                                              '${S.of(context).order_ID}: #${_con.order.id}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4
                                                  .merge(TextStyle(
                                                      color: Colors.black)),
                                            ),
                                            AutoSizeText(
                                              DateFormat('dd-MM-yyyy | HH:mm')
                                                  .format(_con.order.dateTime),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),
                                          ],
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                        ),
                                        trailing: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              height: 30,
                                              width: 130,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: _con.order.orderStatus.status ==
                                                      'Delivered (MO)' ||
                                                      _con.order.orderStatus.status ==
                                                          'Delivered (SP)' ||
                                                      _con.order.orderStatus.status ==
                                                          'Completed (MO)' ||
                                                      _con.order.orderStatus.status ==
                                                          'Completed (SP)'
                                                      ? Colors.green
                                                      : _con.order.orderStatus.status ==
                                                      'Declined (MO)' ||
                                                      _con.order.orderStatus.status ==
                                                          'Declined (SP)' ||
                                                      _con.order.orderStatus.status ==
                                                          'Canceled (MO)' ||
                                                      _con.order.orderStatus.status ==
                                                          'Declined (SP)'
                                                      ? Colors.red
                                                      : _con.order.active
                                                      ? Theme.of(context).accentColor
                                                      : Colors.red,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                              ),
                                              alignment:
                                                  AlignmentDirectional.center,
                                              child: AutoSizeText(
                                                _con.order.active
                                                    ? '${_con.order.orderStatus.status}'
                                                    : S.of(context).canceled,
                                                maxLines: 1,
                                                overflow: TextOverflow.fade,
                                                softWrap: false,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .merge(TextStyle(
                                                      height: 1,
                                                      color: _con.order.orderStatus.status ==
                                                          'Delivered (MO)' ||
                                                          _con.order.orderStatus.status ==
                                                              'Delivered (SP)' ||
                                                          _con.order.orderStatus.status ==
                                                              'Completed (MO)' ||
                                                          _con.order.orderStatus.status ==
                                                              'Completed (SP)'
                                                          ? Colors.green
                                                          : _con.order.orderStatus.status ==
                                                          'Declined (MO)' ||
                                                          _con.order.orderStatus.status ==
                                                              'Declined (SP)' ||
                                                          _con.order.orderStatus.status ==
                                                              'Canceled (MO)' ||
                                                          _con.order.orderStatus.status ==
                                                              'Declined (SP)'
                                                          ? Colors.red
                                                          : _con.order.active
                                                          ? Theme.of(context).accentColor
                                                          : Colors.red,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                        children: <Widget>[
                                          _con?.order?.foodOrders == null ? CircularLoadingWidget(height: 50,) :
                                          ListView.builder(
                                            itemCount: group.length,
                                            padding: EdgeInsets.symmetric(vertical: 15),
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            primary: false,
                                            itemBuilder: (BuildContext context, int index) {
                                              String key = group.keys.elementAt(index);
                                              String keyIMG = groupIMG.keys.elementAt(index);
                                              String keyRoute = groupRoute.keys.elementAt(index);


                                              return new  Column(
                                                children: <Widget>[
                                                  ListTile(
                                                    contentPadding: EdgeInsets.all(10),
                                                    leading: ClipRRect(
                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                      child: keyIMG.toString() == "https://goldilocks.ml/images/image_default.png" ?  Image.asset(
                                                        'assets/custom_img/place_holder_g.png',
                                                        fit: BoxFit.cover,
                                                        width: 60,
                                                        height: 60,
                                                      ) : CachedNetworkImage(
                                                        width: 60,
                                                        height: 60,
                                                        fit: BoxFit.cover,
                                                        imageUrl: keyIMG,
                                                        placeholder: (context, url) => Image.asset(
                                                          'assets/img/loading.gif',
                                                          fit: BoxFit.cover,
                                                          width: 60,
                                                          height: 60,
                                                        ),
                                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                                      ),
                                                    ),
                                                    title: AutoSizeText(
                                                      key,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1,
                                                    ),


                                                    trailing: IconButton(icon:Icon(Icons.arrow_forward_ios),iconSize: 15,),
                                                    onTap: (){
                                                      Navigator.of(context).pushNamed('/Details', arguments: RouteArgument(id: keyRoute, heroTag: 'tracking_restaurant'));
                                                    },

                                                  ),
                                                  ListView.separated(
                                                    padding:
                                                    EdgeInsets.symmetric(vertical: 15),
                                                    scrollDirection: Axis.vertical,
                                                    shrinkWrap: true,
                                                    primary: false,
                                                    itemCount: group[key].length,
                                                    separatorBuilder: (context, index) {
                                                      return SizedBox(height: 0);
                                                    },
                                                    itemBuilder: (context, index){
                                                      var theOrders = group[key];
                                                      return FoodOrderItemWidget(
                                                        heroTag: 'my_order',
                                                        order: _con.order,
                                                        foodOrder: theOrders.elementAt(index),
                                                      );
                                                    },
                                                  )
                                                ],
                                              );
                                            },
                                          ),

                                          /*
                                          List.generate(
                                                    group[key].length,
                                                        (indexFood) {
                                                      return FoodOrderItemWidget(
                                                          heroTag: 'my_order',
                                                          order: _con.order,
                                                          foodOrder: _con
                                                              .order.foodOrders
                                                              .elementAt(indexFood));
                                                    },
                                                  )
                                           */

                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: Column(
                                              children: <Widget>[
                                                // Row(
                                                //   children: <Widget>[
                                                //     Expanded(
                                                //       child: AutoSizeText(
                                                //         S
                                                //             .of(context)
                                                //             .delivery_fee,
                                                //         style: Theme.of(context)
                                                //             .textTheme
                                                //             .bodyText1,
                                                //       ),
                                                //     ),
                                                //     Helper.getPrice(
                                                //         _con.order.deliveryFee,
                                                //         context,
                                                //         style: Theme.of(context)
                                                //             .textTheme
                                                //             .subtitle1)
                                                //   ],
                                                // ),
                                                // Row(
                                                //   children: <Widget>[
                                                //     Expanded(
                                                //       child: AutoSizeText(
                                                //         '${S.of(context).tax} (${_con.order.tax}%)',
                                                //         style: Theme.of(context)
                                                //             .textTheme
                                                //             .bodyText1,
                                                //       ),
                                                //     ),
                                                //     Helper.getPrice(
                                                //         Helper.getTaxOrder(
                                                //             _con.order),
                                                //         context,
                                                //         style: Theme.of(context)
                                                //             .textTheme
                                                //             .subtitle1)
                                                //   ],
                                                // ),
                                                Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: AutoSizeText(
                                                        S.of(context).total,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1,
                                                      ),
                                                    ),
                                                    Helper.getPrice(
                                                        Helper
                                                            .getTotalOrdersPrice(
                                                                _con.order),
                                                        context,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline4)
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top:20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          if (_con.order.canCancelOrder())
                                            CancelDetailsWidget(
                                              onPressed: () {
                                                showGeneralDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    barrierLabel:
                                                        MaterialLocalizations.of(
                                                                context)
                                                            .modalBarrierDismissLabel,
                                                    barrierColor: Colors.black45,
                                                    transitionDuration:
                                                        const Duration(
                                                            milliseconds: 200),
                                                    pageBuilder: (BuildContext
                                                            buildContext,
                                                        Animation animation,
                                                        Animation
                                                            secondaryAnimation) {
                                                      return Center(
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              60,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height -
                                                              450,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(20),
                                                            color: Colors.white,
                                                          ),
                                                          padding:
                                                              EdgeInsets.all(20),
                                                          child: Material(
                                                            color: Colors.white,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SvgPicture.asset(
                                                                  'assets/custom_img/confirmation_icon.svg',
                                                                  width: 80,
                                                                ),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                                AutoSizeText(
                                                                  S
                                                                      .of(context)
                                                                      .are_you_sure,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: 20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                AutoSizeText(
                                                                    S
                                                                        .of(
                                                                            context)
                                                                        .areYouSureYouWantToCancelThisOrder,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .hintColor
                                                                          .withOpacity(
                                                                              0.5),
                                                                      fontSize:
                                                                          20,
                                                                    )),
                                                                SizedBox(
                                                                  height: 30,
                                                                ),
                                                                FlatButton(
                                                                  onPressed: () {
                                                                    _con.doCancelOrder();
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              14,
                                                                          horizontal:
                                                                              100),
                                                                  color: Theme.of(
                                                                          context)
                                                                      .accentColor,
                                                                  shape:
                                                                      StadiumBorder(),
                                                                  child: AutoSizeText(
                                                                    S
                                                                        .of(context)
                                                                        .yes_im_sure,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: TextStyle(
                                                                        color: Theme.of(
                                                                                context)
                                                                            .hintColor),
                                                                  ),
                                                                ),
                                                                FlatButton(
                                                                  child: new AutoSizeText(
                                                                    S
                                                                        .of(context)
                                                                        .cancel,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey),
                                                                  ),
                                                                  onPressed: () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });

                                                //showDialog(
                                                //  context: context,
                                                //  builder:
                                                //      (BuildContext context) {
                                                //    // return object of type Dialog
                                                //    return AlertDialog(
                                                //      title: Wrap(
                                                //        spacing: 10,
                                                //        children: <Widget>[
                                                //          Icon(Icons.report,
                                                //              color:
                                                //              Colors.orange),
                                                //          AutoSizeText(
                                                //            S
                                                //                .of(context)
                                                //                .confirmation,
                                                //            style: TextStyle(
                                                //                color: Colors
                                                //                    .orange),
                                                //          ),
                                                //        ],
                                                //      ),
                                                //      content: SizedBox(                                  //          .of(context)
                                                //          .areYouSureYouWantToCancelThisOrder),
                                                //      content: SizedBox(                                  //      EdgeInsets.symmetric(
                                                //          horizontal: 30,
                                                //          vertical: 25),
                                                //      actions: <Widget>[
                                                //        FlatButton(
                                                //          child: new AutoSizeText(
                                                //            S.of(context).yes,
                                                //            style: TextStyle(
                                                //                color: Theme.of(
                                                //                    context)
                                                //                    .hintColor),
                                                //          ),
                                                //          onPressed: () {
                                                //            _con.doCancelOrder();
                                                //            Navigator.of(context)
                                                //                .pop();
                                                //          },
                                                //        ),
                                                //        FlatButton(
                                                //          child: new AutoSizeText(
                                                //            S.of(context).close,
                                                //            style: TextStyle(
                                                //                color: Colors
                                                //                    .orange),
                                                //          ),
                                                //          onPressed: () {
                                                //            Navigator.of(context)
                                                //                .pop();
                                                //          },
                                                //        ),
                                                //      ],
                                                //    );
                                                //  },
                                                //);
                                              },
                                              color: Colors.red.withOpacity(0.15),
                                              text: Text(
                                                  S.of(context).cancelOrder,
                                                  style: TextStyle(
                                                      height: 1.3,
                                                      color: Colors.red)),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: 1 != _tabIndex,
                      child: Column(
                        children: <Widget>[
                          Theme(
                            data: ThemeData(
                                primaryColor: (_con.order.orderStatus.status ==
                                            "Declined (SP)" || _con.order.orderStatus.status ==
                                            "Declined (MO)") ||
                                        (_con.order.orderStatus.status ==
                                            "Canceled (SP)" ||
                                             _con.order.orderStatus.status ==
                                            "Canceled (MO)") || (_con.order.orderStatus.status ==
                                    "Order Received" && !_con.order.active)
                                    ? Colors.red
                                    : (
                                      _con.order.orderStatus.status ==
                                                "Delivered (MO)" ||
                                            _con.order.orderStatus.status ==
                                                "Completed (SP)")
                                        ? Colors.green
                                        : Theme.of(context).accentColor),
                            child: _con.order.orderStatus.status ==
                                    "Order Received" && _con.order.active
                                ? Stepper(
                                    steps: _myStepsOrderReceived(),
                                    currentStep: this._currentStep1,
                                    controlsBuilder: (BuildContext context,
                                            {VoidCallback onStepContinue,
                                            VoidCallback onStepCancel}) =>
                                        Container(),
                                  )
                                  :_con.order.orderStatus.status ==
                                    "Order Received"
                                ? Stepper(
                                    steps: _myStepsCanceledMO(),
                                    currentStep: this._currentStep1,
                                    controlsBuilder: (BuildContext context,
                                            {VoidCallback onStepContinue,
                                            VoidCallback onStepCancel}) =>
                                        Container(),
                                  )
                                : _con.order.orderStatus.status == "Preparing (SP)"
                                    ? Stepper(
                                        steps: _myStepsSPPreparing(),
                                        currentStep: this._currentStep1,
                                        controlsBuilder: (BuildContext context,
                                                {VoidCallback onStepContinue,
                                                VoidCallback onStepCancel}) =>
                                            Container(),
                                      )
                                      : _con.order.orderStatus.status == "Preparing (MO)"
                                    ? Stepper(
                                        steps: _myStepsSPPreparingMO(),
                                        currentStep: this._currentStep1,
                                        controlsBuilder: (BuildContext context,
                                                {VoidCallback onStepContinue,
                                                VoidCallback onStepCancel}) =>
                                            Container(),
                                      )
                                    : _con.order.orderStatus.status ==
                                            "Ready to Pickup (SP)"
                                        ? Stepper(
                                            steps: _myStepsReadyForPickup(),
                                            currentStep: this._currentStep2,
                                            controlsBuilder:
                                                (BuildContext context,
                                                        {VoidCallback
                                                            onStepContinue,
                                                        VoidCallback
                                                            onStepCancel}) =>
                                                    Container(),
                                          )
                                        : _con.order.orderStatus.status ==
                                                "Completed (SP)"
                                            ? Stepper(
                                                steps: _myStepsCompleted(),
                                                currentStep: this._currentStep3,
                                                controlsBuilder: (BuildContext
                                                            context,
                                                        {VoidCallback
                                                            onStepContinue,
                                                        VoidCallback
                                                            onStepCancel}) =>
                                                    Container(),
                                              )
                                            : _con.order.orderStatus.status ==
                                                    "Ready To Deliver (SP)"
                                                ? Stepper(
                                                    steps:
                                                        _myStepsReadytoDeliver(),
                                                    currentStep:
                                                        this._currentStep2,
                                                    controlsBuilder: (BuildContext
                                                                context,
                                                            {VoidCallback
                                                                onStepContinue,
                                                            VoidCallback
                                                                onStepCancel}) =>
                                                        Container(),
                                                  )
                                                : _con.order.orderStatus.status ==
                                                        "On the Way (MO)"
                                                    ? Stepper(
                                                        steps:
                                                            _myStepsOnTheWay(),
                                                        currentStep:
                                                            this._currentStep2,
                                                        controlsBuilder: (BuildContext
                                                                    context,
                                                                {VoidCallback
                                                                    onStepContinue,
                                                                VoidCallback
                                                                    onStepCancel}) =>
                                                            Container(),
                                                      )
                                                    : _con.order.orderStatus
                                                                .status ==
                                                            "Delivered (MO)"
                                                        ? Stepper(
                                                            steps:
                                                                _myStepsDelivered(),
                                                            currentStep: this
                                                                ._currentStep3,
                                                            controlsBuilder: (BuildContext
                                                                        context,
                                                                    {VoidCallback
                                                                        onStepContinue,
                                                                    VoidCallback
                                                                        onStepCancel}) =>
                                                                Container(),
                                                          )
                                                        : _con.order.orderStatus
                                                                    .status ==
                                                                "Canceled"
                                                            ? Stepper(
                                                                steps:
                                                                    _myStepsCanceledMO(),
                                                                currentStep: this
                                                                    ._currentStep0,
                                                                controlsBuilder: (BuildContext
                                                                            context,
                                                                        {VoidCallback
                                                                            onStepContinue,
                                                                        VoidCallback
                                                                            onStepCancel}) =>
                                                                    Container(),
                                                              )
                                                            : _con.order.orderStatus
                                                                            .status ==
                                                                        "Processing Payment Return (MO)" &&
                                                                    _con.order
                                                                        .active
                                                                ? Stepper(
                                                                    steps:
                                                                        _myStepsCProcessingMO(),
                                                                    currentStep:
                                                                        this._currentStep1,
                                                                    controlsBuilder: (BuildContext
                                                                                context,
                                                                            {VoidCallback
                                                                                onStepContinue,
                                                                            VoidCallback
                                                                                onStepCancel}) =>
                                                                        Container(),
                                                                  )
                                                                : _con.order.orderStatus.status ==
                                                                            "Payment Returned (MO)" &&
                                                                        _con.order
                                                                            .active
                                                                    ? Stepper(
                                                                        steps:
                                                                            _myStepsCReturnedMO(),
                                                                        currentStep:
                                                                            this._currentStep2,
                                                                        controlsBuilder: (BuildContext context,
                                                                                {VoidCallback onStepContinue,
                                                                                VoidCallback onStepCancel}) =>
                                                                            Container(),
                                                                      )
                                                                    : _con.order.orderStatus.status ==
                                                                            "Declined (MO)"
                                                                        ? Stepper(
                                                                            steps:
                                                                                _myStepsDeclinedMO(),
                                                                            currentStep:
                                                                                this._currentStep0,
                                                                            controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
                                                                                Container(),
                                                                          )
                                                                          : _con.order.orderStatus.status ==
                                                                            "Declined (SP)"
                                                                        ? Stepper(
                                                                            steps:
                                                                                _myStepsDeclinedMO(),
                                                                            currentStep:
                                                                                this._currentStep0,
                                                                            controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
                                                                                Container(),
                                                                          )
                                                                        : _con.order.orderStatus.status == "Processing Payment Return (MO)"
                                                                            ? Stepper(
                                                                                steps: _myStepsDProcessingMO(),
                                                                                currentStep: this._currentStep1,
                                                                                controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) => Container(),
                                                                              )
                                                                              : _con.order.orderStatus.status == "Processing Payment Return (SP)"
                                                                            ? Stepper(
                                                                                steps: _myStepsDProcessingMO(),
                                                                                currentStep: this._currentStep1,
                                                                                controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) => Container(),
                                                                              )
                                                                            : _con.order.orderStatus.status == "Payment Returned (MO)"
                                                                                ? Stepper(
                                                                                    steps: _myStepsDReturnedMO(),
                                                                                    currentStep: this._currentStep2,
                                                                                    controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) => Container(),
                                                                                  )
                                                                                  : _con.order.orderStatus.status == "Payment Returned (SP)"
                                                                                ? Stepper(
                                                                                    steps: _myStepsDReturnedMO(),
                                                                                    currentStep: this._currentStep2,
                                                                                    controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) => Container(),
                                                                                  )
                                                                                :_con.order.orderStatus.status ==
                                    "Canceled (MO)" || _con.order.orderStatus.status == "Canceled (SP)"
                                                                                ? Stepper(
                                    steps: _myStepsCanceledMO(),
                                    currentStep: this._currentStep0,
                                    controlsBuilder: (BuildContext context,
                                            {VoidCallback onStepContinue,
                                            VoidCallback onStepCancel}) =>
                                        Container(),
                                  )
                                  : Container(),
                          ),
                        ],
                      ),
                    ),
                  ]),
                )
              ]));
  }

  List<Step> _myStepsOrderReceived() {
    List<Step> _steps = [
      Step(
          title: AutoSizeText(
            "Order Received",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep0 >= 0,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Preparing",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep0 >= 1,
          state: StepState.complete),
      
    ];
    return _steps;
  }

  List<Step> _myStepsSPPreparing() {
    List<Step> _steps = [
      Step(
          title: AutoSizeText(
            "Order Received",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep1 >= 0,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Preparing",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep1 >= 1,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Ready for Pickup",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep1 >= 2,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Completed",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep1 >= 3,
          state: StepState.complete),
    ];
    return _steps;
  }

  List<Step> _myStepsSPPreparingMO() {
    List<Step> _steps = [
      Step(
          title: AutoSizeText(
            "Order Received",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep1 >= 0,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Preparing",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep1 >= 1,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "On the Way",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep1 >= 2,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Delivered",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep1 >= 3,
          state: StepState.complete),
    ];
    return _steps;
  }

  List<Step> _myStepsReadyForPickup() {
    List<Step> _steps = [
      Step(
          title: AutoSizeText(
            "Order Received",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep2 >= 0,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Preparing",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep2 >= 1,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Ready to Pickup",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep2 >= 2,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Completed",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep2 >= 3,
          state: StepState.complete),
    ];
    return _steps;
  }

  List<Step> _myStepsCompleted() {
    List<Step> _steps = [
      Step(
          title: AutoSizeText(
            "Order Received",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep3 >= 0,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Preparing",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep3 >= 1,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Ready to Pickup",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep3 >= 2,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Completed",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep3 >= 3,
          state: StepState.complete),
    ];
    return _steps;
  }

  List<Step> _myStepsReadytoDeliver() {
    List<Step> _steps = [
      Step(
          title: AutoSizeText(
            "Order Received",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep2 >= 0,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Preparing",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep2 >= 1,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Ready to Deliver",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep2 >= 2,
          state: StepState.complete),
    ];
    return _steps;
  }

  List<Step> _myStepsOnTheWay() {
    List<Step> _steps = [
      Step(
          title: AutoSizeText(
            "Order Received",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep2 >= 0,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Preparing",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep2 >= 1,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "On The Way",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep2 >= 2,
          state: StepState.complete),
        Step(
          title: AutoSizeText(
            "Delivered",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep2 >= 3,
          state: StepState.complete),
    ];
    return _steps;
  }

  List<Step> _myStepsDelivered() {
    List<Step> _steps = [
      Step(
          title: AutoSizeText(
            "Order Received",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep3 >= 0,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Preparing",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep3 >= 1,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "On The Way",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep3 >= 2,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Delivered",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep3 >= 3,
          state: StepState.complete),
    ];
    return _steps;
  }

  List<Step> _myStepsCanceledMO() {
    List<Step> _steps = [
      Step(
          title: AutoSizeText(
            "Order Received",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep1 >= 0,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Canceled",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep1 >= 1,
          state: StepState.complete),
          Step(
          title: AutoSizeText(
            "Processing Payment Return",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep1 >= 2,
          state: StepState.complete),
          Step(
          title: AutoSizeText(
            "Payment Returned",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep1 >= 3,
          state: StepState.complete),
    ];
    return _steps;
  }

  List<Step> _myStepsCProcessingMO() {
    List<Step> _steps = [
      Step(
          title: AutoSizeText(
            "Order Received",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep2 >= 0,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Canceled",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep2 >= 1,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Processing Payment Return",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep2 >= 2,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Payment Returned",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep3 >= 3,
          state: StepState.complete),
    ];
    return _steps;
  }

  List<Step> _myStepsCReturnedMO() {
    List<Step> _steps = [
      Step(
          title: AutoSizeText(
            "Order Received",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep3 >= 0,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Canceled",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep3 >= 1,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Processing Payment Return",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep3 >= 2,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Payment Returned",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep3 >= 3,
          state: StepState.complete),
    ];
    return _steps;
  }

  List<Step> _myStepsDeclinedMO() {
    List<Step> _steps = [
      Step(
          title: AutoSizeText(
            "Order Received",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep1 >= 0,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Declined",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep1 >= 1,
          state: StepState.complete),
          Step(
          title: AutoSizeText(
            "Processing Payment Return",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep1 >= 2,
          state: StepState.complete),
          Step(
          title: AutoSizeText(
            "Payment Returned",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep1 >= 3,
          state: StepState.complete),
    ];
    return _steps;
  }

  List<Step> _myStepsDProcessingMO() {
    List<Step> _steps = [
      Step(
          title: AutoSizeText(
            "Order Received",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep2 >= 0,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Declined",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep2 >= 1,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Processing Payment Return",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep2 >= 2,
          state: StepState.complete),
          Step(
          title: AutoSizeText(
            "Payment Returned",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep2 >= 3,
          state: StepState.complete),
    ];
    return _steps;
  }

  List<Step> _myStepsDReturnedMO() {
    List<Step> _steps = [
      Step(
          title: AutoSizeText(
            "Order Received",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep3 >= 0,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Declined",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep3 >= 1,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Processing Payment Return",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep3 >= 2,
          state: StepState.complete),
      Step(
          title: AutoSizeText(
            "Payment Returned",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(),
          isActive: _currentStep3 >= 3,
          state: StepState.complete),
    ];
    return _steps;
  }
}

/*
 Padding(
                            padding: const EdgeInsets.all(12),
                            child: Theme(
                              data: ThemeData(
                                primaryColor:
                                    _con.order.orderStatus.status == "Canceled"
                                        ? Colors.red
                                        : Theme.of(context).accentColor,
                              ),
                              child: Stepper(
                                physics: ClampingScrollPhysics(),
                                controlsBuilder: (BuildContext context,
                                    {VoidCallback onStepContinue,
                                    VoidCallback onStepCancel}) {
                                  return SizedBox(height: 0);
                                },
                                steps: _con.getTrackingSteps(context),
                                currentStep: int.tryParse(
                                        this._con.order.orderStatus.id) -
                                    1,
                              ),
                            ),
                          ),
                          _con.order.deliveryAddress?.address != null
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 55,
                                        width: 55,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
                                                    ? Colors.black38
                                                    : Theme.of(context)
                                                        .backgroundColor),
                                        child: Icon(
                                          Icons.place,
                                          color: Theme.of(context).primaryColor,
                                          size: 38,
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            AutoSizeText(
                                              _con.order.deliveryAddress
                                                      ?.description ??
                                                  "",
                                              overflow: TextOverflow.fade,
                                              softWrap: false,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                            ),
                                            AutoSizeText(
                                              _con.order.deliveryAddress
                                                      ?.address ??
                                                  S.of(context).unknown,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : SizedBox(height: 0),
                          SizedBox(height: 30)
 */
