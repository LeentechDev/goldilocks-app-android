import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/order.dart';
import 'package:food_delivery_app/src/pages/profile.dart';
import 'package:food_delivery_app/src/pages/settings.dart';

import '../elements/DrawerWidget.dart';
import '../elements/FilterWidget.dart';
import '../models/route_argument.dart';
import '../pages/favorites.dart';
import '../pages/home.dart';
import '../pages/map.dart';
import '../pages/notifications.dart';
import '../pages/orders.dart';
import '../pages/list_products.dart';
import '../pages/list_stores.dart';
import '../Bloc/shared_pref.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class PagesWidget extends StatefulWidget {
  dynamic currentTab;
  RouteArgument routeArgument;
  Widget currentPage = HomeWidget();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  PagesWidget({
    Key key,
    this.currentTab,
  }) {
    if (currentTab != null) {
      if (currentTab is RouteArgument) {
        routeArgument = currentTab;
        currentTab = int.parse(currentTab.id);
      }
    } else {
      currentTab = 2;
    }
  }

  @override
  _PagesWidgetState createState() {
    return _PagesWidgetState();
  }
}

class _PagesWidgetState extends State<PagesWidget> {

  initState() {
    super.initState();
    _selectTab(widget.currentTab);
  }

  @override
  void didUpdateWidget(PagesWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }


  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentPage = HomeWidget(
              parentScaffoldKey: widget
                  .scaffoldKey); //widget.currentPage = NotificationsWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 1:
          widget.currentPage = NotificationsWidget(
              parentScaffoldKey: widget
                  .scaffoldKey); //widget.currentPage = MapWidget(parentScaffoldKey: widget.scaffoldKey, routeArgument: widget.routeArgument);
          break;
        case 2:
          widget.currentPage = OrdersWidget(
              parentScaffoldKey: widget
                  .scaffoldKey); //widget.currentPage = HomeWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 3:
          widget.currentPage =
              SettingsWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 4:
          widget.currentPage = StoreList(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 5:
          widget.currentPage =
              ProductList(parentScaffoldKey: widget.scaffoldKey);
          break;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: widget.scaffoldKey,
        // drawer: DrawerWidget(),
        // endDrawer: FilterWidget(onFilter: (filter) {
        //   Navigator.of(context)
        //       .pushReplacementNamed('/Pages', arguments: widget.currentTab);
        // }),
        body: widget.currentPage,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).accentColor,
          //selectedFontSize: 0,
          //unselectedFontSize: 0,
          iconSize: 22,
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          //selectedIconTheme: IconThemeData(size: 28),
          unselectedItemColor: Theme.of(context).hintColor.withOpacity(1),
          currentIndex: widget.currentTab,
          onTap: (int i) {
            this._selectTab(i);
          },
          // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/custom_img/home_icon.svg',),
              activeIcon: SvgPicture.asset('assets/custom_img/colored_home_icon.svg'),
              title: new AutoSizeText(
                "Home",
                textAlign: TextAlign.center,
              ),
            ),

            /*BottomNavigationBarItem(
                title: new Container(height: 5.0),
                icon: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 40, offset: Offset(0, 15)),
                      BoxShadow(color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 13, offset: Offset(0, 3))
                    ],
                  ),
                  child: new Icon(Icons.home, color: Theme.of(context).primaryColor),
                )),*/
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/custom_img/notif_icon.svg',),
              activeIcon: SvgPicture.asset('assets/custom_img/colored_notification_icon.svg'),
              title: new AutoSizeText(
                "Notifications",
                textAlign: TextAlign.center,
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/custom_img/orders_icon.svg'),
              activeIcon: SvgPicture.asset('assets/custom_img/colored_orders_icon.svg'),
              title: new AutoSizeText(
                "My Orders",
                textAlign: TextAlign.center,
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/custom_img/account_icon.svg'),
              activeIcon: SvgPicture.asset('assets/custom_img/colored_account_icon.svg'),
              title: new AutoSizeText(
                "Account",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
