import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/elements/BlockButtonWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/home_controller.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../repository/settings_repository.dart' as settingsRepo;
import '../repository/user_repository.dart';
import '../elements/StoresGridIWidget.dart';
import '../elements/SearchBarWidget2.dart';
import '';

class StoreList extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  String value;
  StoreList({Key key, this.value, this.parentScaffoldKey}) : super(key: key);

  @override
  _StoreListState createState() => _StoreListState();
}

class _StoreListState extends StateMVC<StoreList> {
  HomeController _con;
  String value;

  _StoreListState({this.value}) : super(HomeController()) {
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
                "STORES", //value.appName ?? S.of(context).home,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: SearchBarWidget2(
                    onClickFilter: (event) {
                      widget.parentScaffoldKey.currentState.openEndDrawer();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    leading: Icon(
                      Icons.store,
                      color: Theme.of(context).hintColor,
                    ),
                    title: AutoSizeText(
                      S.of(context).stores,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: StoresGridWidget(
                    restaurant: _con.allRestaurants,
                    heroTag: 'list_stores',
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
