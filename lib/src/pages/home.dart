import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_delivery_app/src/elements/FilterBottomSheetWidget.dart';
import 'package:food_delivery_app/src/repository/order_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../controllers/home_controller.dart';
import '../elements/CardsCarouselWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DeliveryAddressBottomSheetWidget.dart';
import '../elements/FoodsCarouselWidget.dart';
import '../elements/GridWidget.dart';
import '../elements/ReviewsListWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../repository/settings_repository.dart' as settingsRepo;
import '../repository/user_repository.dart';
import '../elements/StoresGridIWidget.dart';
import '../Bloc/shared_pref.dart';
import 'package:provider/provider.dart';
import '../Bloc/OrderTypeProvider.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomeWidget extends StatefulWidget {
  static final GlobalKey<ScaffoldState> keyButton1 = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HomeWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<HomeWidget> {
  HomeController _con;
  final Key _keyButton = new GlobalKey(debugLabel: '_keyButton');
  final Key _keyButton2 = new GlobalKey(debugLabel: '_keyButton2');
  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = List();


  final SharedPrefs prefs = SharedPrefs();

  int orderType;
  String phone;
  bool _seenCoach;
  

  _HomeWidgetState() : super(HomeController()) {
    _con = controller;
  }


  getOrderType() async {
    orderType = await prefs.getIntOrderType();
    print(orderType);
  }

  getPhoneOrder() async {
    phone = await prefs.getStringPhone();
    print(phone);
  }


  Future checkCoachMark() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _seenCoach = (prefs.getBool('seenCoach') ?? false);

    if (_seenCoach){
      print(_seenCoach);
    }
    else{
      await prefs.setBool('seenCoach', true);
      initTargets();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    }
  }
  
  @override
  void initState() {
    getOrderType();
    getPhoneOrder();
    checkCoachMark();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String order = Provider.of<OrderTypeGenerator>(context).OType.toString();
    return Scaffold(
      appBar: AppBar(
        //leading: new IconButton(
        //  icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
        //  onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        //),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        //centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
              
              onPressed: () {
                if (currentUser.value.apiToken == null) {
                  _con.requestForCurrentLocation(context);
                } else {
                  var bottomSheetController = widget
                      .parentScaffoldKey.currentState
                      .showBottomSheet(
                        (context) => DeliveryAddressBottomSheetWidget(
                        scaffoldKey: widget.parentScaffoldKey),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                  );
                  bottomSheetController.closed.then((value) {
                    _con.refreshHome();
                  });
                }
              },
              icon: Icon(
                Icons.my_location,
                color: Theme.of(context).focusColor,
                key: _keyButton,
              ),
            ),

           Container(
             width: MediaQuery.of(context).size.width - 180,
             child:  ValueListenableBuilder(
               valueListenable: settingsRepo.setting,
               builder: (context, value, child) {
                 return AutoSizeText((settingsRepo.deliveryAddress.value?.address ??
                     S.of(context).unknown),
                   style: Theme.of(context).textTheme.subtitle2,
                   maxLines: 1,
                   overflow: TextOverflow.ellipsis,
                 );
               },
             ),
           ),
          ],
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

              SizedBox(height: 10.0,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SearchBarWidget(
                  onClickFilter: (event) {
                    widget.parentScaffoldKey.currentState.openEndDrawer();
                  },
                ),
                
              ),

             SizedBox(height: 10.0,),

             //Padding(
             //  padding: const EdgeInsets.symmetric(
             //      vertical: 20.0, horizontal: 20.0),
             //  child: Row(
             //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
             //    crossAxisAlignment: CrossAxisAlignment.center,
             //    children: <Widget>[
             //      orderType == 1
             //          ? Container(
             //              padding: EdgeInsets.symmetric(
             //                  horizontal: 30, vertical: 10),
             //              decoration: BoxDecoration(
             //                  color: Color(0xFFFECD00),
             //                  borderRadius: BorderRadius.circular(24)),
             //              child: AutoSizeText(
             //                S.of(context).mail_order,
             //                style: Theme.of(context).textTheme.caption.merge(
             //                    TextStyle(
             //                        color: Theme.of(context).primaryColor)),
             //              ),
             //            )
             //          : orderType == 2
             //              ? Container(
             //                  padding: EdgeInsets.symmetric(
             //                      horizontal: 30, vertical: 10),
             //                  decoration: BoxDecoration(
             //                      color: Color(0xFFFECD00),
             //                      borderRadius: BorderRadius.circular(24)),
             //                  child: AutoSizeText(
             //                    S.of(context).store_pick_up,
             //                    style: Theme.of(context)
             //                        .textTheme
             //                        .caption
             //                        .merge(TextStyle(
             //                            color:
             //                                Theme.of(context).primaryColor)),
             //                  ),
             //                )
             //              : Container(
             //                  padding: EdgeInsets.symmetric(
             //                      horizontal: 30, vertical: 10),
             //                  decoration: BoxDecoration(
             //                      color: Color(0xFFFECD00),
             //                      borderRadius: BorderRadius.circular(24)),
             //                  child: SizedBox(width: 62, height: 15),
             //                ),
             //      FlatButton(
             //        onPressed: () {
             //          Navigator.of(context)
             //              .pushReplacementNamed('/OrderType');
             //        },
             //        textColor:
             //            Colors.grey, //Theme.of(context).textTheme.caption,
             //        child: AutoSizeText(S.of(context).change_order_type),
             //      ),
             //    ],
             //  ),
             //),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  //leading: Icon(
                  //  Icons.stars,
                  //  color: Theme.of(context).hintColor,
                  //),
                  title: AutoSizeText(
                    S.of(context).stores_near_you,
                    style: Theme.of(context).textTheme.headline4.merge(TextStyle(fontSize: 25)),
                  ),
                  subtitle: AutoSizeText(
                    S.of(context).tap_the_store ,
                                maxLines: 1,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),



              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  width: 270,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    border: Border.all(
                      color: Theme.of(context).accentColor,
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          key: _keyButton2,
                          onPressed: () {
                            if (currentUser.value.apiToken == null) {
                              _con.requestForCurrentLocation(context);
                            } else {
                              var bottomSheetController = widget
                                  .parentScaffoldKey.currentState
                                  .showBottomSheet(
                                    (context) => FilterBottomSheetWidget(
                                    scaffoldKey: widget.parentScaffoldKey),
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                ),
                              );
                              bottomSheetController.closed.then((value) {
                                _con.refreshHome();
                              });
                            }
                          },
                          icon: Icon(Icons.filter_list, color: Theme.of(context).accentColor),
                        ),



                        AutoSizeText(
                          S.of(context).order_type+ ": ",
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 15.0, color: Colors.grey),
                        ),

                        AutoSizeText(
                          order == '1' ? S.of(context).mail_order : order == '2' ? S.of(context).delivery
                          : S.of(context).store_pick_up,
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),
                        )


                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20,),
              //CardsCarouselWidget(
              //    restaurantsList: _con.topRestaurants,
              //    heroTag: 'home_top_restaurants'),
              //ListTile(
              //  dense: true,
              //  contentPadding: EdgeInsets.symmetric(horizontal: 20),
              //  leading: Icon(
              //    Icons.trending_up,
              //    color: Theme.of(context).hintColor,
              //  ),
              //  title: AutoSizeText(
              //    S.of(context).trending_this_week,
              //    style: Theme.of(context).textTheme.headline4,
              //  ),
              //  subtitle: AutoSizeText(
              //    S.of(context).clickOnTheFoodToGetMoreDetailsAboutIt,
              //    style: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 11)),
              //  ),
              //),
              //FoodsCarouselWidget(foodsList: _con.trendingFoods, heroTag: 'home_food_carousel'),

             // Padding(
             //   padding: const EdgeInsets.symmetric(horizontal: 20),
             //   child: ListTile(
             //     dense: true,
             //     contentPadding: EdgeInsets.symmetric(vertical: 0),
             //     leading: Icon(
             //       Icons.category,
             //       color: Theme.of(context).hintColor,
             //     ),
             //     title: AutoSizeText(
             //       S.of(context).food_categories,
             //       style: Theme.of(context).textTheme.headline4,
             //     ),
             //   ),
             // ),
             // CategoriesCarouselWidget(
             //   categories: _con.categories,
             // ),
             // Padding(
             //   padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
             //   child: ListTile(
             //     dense: true,
             //     contentPadding: EdgeInsets.symmetric(vertical: 0),
             //     leading: Icon(
             //       Icons.local_mall,
             //       color: Theme.of(context).hintColor,
             //     ),
             //     title: AutoSizeText(
             //       S.of(context).featured_products,
             //       style: Theme.of(context).textTheme.headline4,
             //     ),
             //     trailing: FlatButton(
             //       child: AutoSizeText(
             //         S.of(context).more,
             //         style: Theme.of(context).textTheme.headline4,
             //       ),
             //       onPressed: () =>
             //           {Navigator.of(context).pushNamed('/Products')},
             //     ),
             //   ),
             // ),

              ///Restaurant List View

              _con.topRestaurants.isEmpty
                  ? CircularLoadingWidget(height: 250)
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: StoresGridWidget(
                  restaurant: _con.topRestaurants,
                  heroTag: 'top_restaurants',
                ),
              ),


              /*

              _con.restaurants.length > 0 ?
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: _con.restaurants.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/Details',
                                  arguments: RouteArgument(
                                    id: _con.restaurants.elementAt(index).id,
                                    heroTag: widget.heroTag,
                                  ));
                            },
                            child: CardWidget(restaurant: _con.restaurants.elementAt(index), heroTag: widget.heroTag),
                          );
                        },
                      ) :

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Opacity(
                            opacity: 0.4,
                            child: AutoSizeText(
                              S.of(context).no_matching_results_for_stores,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w300)),
                            ),
                          ),
                        ),
                      ),


               */


              //Padding(
              //  padding: const EdgeInsets.symmetric(horizontal: 20),
              //  child: ListTile(
              //    dense: true,
              //    contentPadding: EdgeInsets.symmetric(vertical: 20),
              //    leading: Icon(
              //      Icons.recent_actors,
              //      color: Theme.of(context).hintColor,
              //    ),
              //    title: AutoSizeText(
              //      S.of(context).recent_reviews,
              //      style: Theme.of(context).textTheme.headline4,
              //    ),
              //  ),
              //),
              //Padding(
              //  padding: const EdgeInsets.symmetric(horizontal: 20),
              //  child: ReviewsListWidget(reviewsList: _con.recentReviews),
              //),
            ],
          ),
        ),
      ),
    );
    
    //CoachMark 
  }
  void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(context,
        targets: targets,
        colorShadow: Theme.of(context).hintColor,
        textSkip: "SKIP",
        paddingFocus: 10,
        opacityShadow: 0.8, onFinish: () {
      print("finish");
    }, onClickTarget: (target) {
      print(target);
    }, onClickSkip: () {
      print("skip");
    })
      ..show();
  }

  void _afterLayout(_) {
    Future.delayed(Duration(milliseconds: 100), () {
      showTutorial();
    });
  }

  void initTargets() {
    
    targets.add(
      TargetFocus(
        enableOverlayTab: true,
        identify: "Target 0",
        keyTarget: _keyButton,
        contents: [
          ContentTarget(
              align: AlignContent.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: AutoSizeText(
                        "Here's where you can \nchange your location",
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ],
                ),
              ),),
              ContentTarget(
                align: AlignContent.bottom,
                              child: Column(
                        mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 400),
                            child: SvgPicture.asset('assets/custom_img/tap_icon.svg')
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child:AutoSizeText('Tap to Continue',
                            style: TextStyle(color: Colors.white),
                            ),
                            ),
                        ],
                      ),
              ),
        ],
        shape: ShapeLightFocus.Circle,
      ),
    );
    targets.add(
      TargetFocus(
        enableOverlayTab: true,
        identify: "Target 1",
        keyTarget: HomeWidget.keyButton1,
        contents: [
          ContentTarget(
              align: AlignContent.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: AutoSizeText(
                        "Here's your cart where you \ncan see all of the items \nyou want to order.",
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.white),

                      ),
                    )
                  ],
                ),
              ),),
              ContentTarget(
                align: AlignContent.bottom,
                              child: Column(
                        mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 400),
                            child: SvgPicture.asset('assets/custom_img/tap_icon.svg')
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child:AutoSizeText('Tap to Continue',
                            style: TextStyle(color: Colors.white),
                            ),
                            ),
                        ],
                      ),
              ),
        ],
        shape: ShapeLightFocus.Circle,
        
      ),
    );
    targets.add(
      TargetFocus(
        enableOverlayTab: true,
        identify: "Target 2",
        keyTarget: _keyButton2,
        contents: [
          ContentTarget(
              align: AlignContent.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: AutoSizeText(
                        "Tap this to change the \norder type",
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.white),

                      ),
                    )
                  ],
                ),
              ),),
              ContentTarget(
                align: AlignContent.bottom,
                              child: Column(
                        mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 190),
                            child: SvgPicture.asset('assets/custom_img/tap_icon.svg')
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child:AutoSizeText('Tap to Continue',
                            style: TextStyle(color: Colors.white),
                            ),
                            ),
                        ],
                      ),
              ),
        ],
        shape: ShapeLightFocus.Circle,
      ),
    );
  }
  //coachmark ^
}
