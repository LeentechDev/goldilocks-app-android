import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/search_controller.dart';
import '../elements/CardWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/FoodItemWidget.dart';
import '../models/route_argument.dart';

class SearchResultWidget extends StatefulWidget {
  final String heroTag;

  SearchResultWidget({Key key, this.heroTag}) : super(key: key);

  @override
  _SearchResultWidgetState createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends StateMVC<SearchResultWidget> {
  SearchController _con;
  TextEditingController _search = new TextEditingController();

  _SearchResultWidgetState() : super(SearchController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              trailing: IconButton(
                icon: Icon(Icons.close),
                color: Theme.of(context).hintColor,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: AutoSizeText(
                S.of(context).search,
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: AutoSizeText(
                S.of(context).ordered_nearby,
                style: Theme.of(context).textTheme.subtitle2.merge(
                  TextStyle(color: Theme.of(context).hintColor)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: TextField(
                    controller: _search,
                    onSubmitted: (text) async {
                      await _con.refreshSearch(text);
                      _con.saveSearch(text);
                    },
                    autofocus: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      hintText: S.of(context).search_for_stores_or_foods,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .caption
                          .merge(TextStyle(fontSize: 14)),
                      prefixIcon: Icon(Icons.search,
                          color: Theme.of(context).dividerColor),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .hintColor
                                  .withOpacity(0.1))),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .hintColor
                                  .withOpacity(0.3))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .hintColor
                                  .withOpacity(0.1))),
                    ),
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                      color: Theme.of(context).accentColor,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).hintColor,
                      ),
                      onPressed: () async {
                        await _con.refreshSearch(_search.text);
                        _con.saveSearch(_search.text);
                      },
                    )),
              ],
            ),
          ),
          _con.restaurants.isEmpty && _con.foods.isEmpty
              ? CircularLoadingWidget(height: 288)
              : Expanded(
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          title: AutoSizeText(
                            S.of(context).food_results + ' (${_con.foods.length})',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                      ),
                      _con.foods.length > 0
                          ? ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: false,
                              itemCount: _con.foods.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 10);
                              },
                              itemBuilder: (context, index) {
                                return FoodItemWidget(
                                  heroTag: 'search_list',
                                  food: _con.foods.elementAt(index),
                                );
                              },
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: Center(
                                child: Opacity(
                                  opacity: 0.4,
                                  child: AutoSizeText(
                                    S.of(context).no_matching_results_for_foods,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .merge(TextStyle(
                                            fontWeight: FontWeight.w300)),
                                  ),
                                ),
                              ),
                            ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          title: AutoSizeText(
                            S.of(context).store_results +
                                ' (${_con.restaurants.length})',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                      ),
                      _con.restaurants.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: _con.restaurants.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed('/Details',
                                        arguments: RouteArgument(
                                          id: _con.restaurants
                                              .elementAt(index)
                                              .id,
                                          heroTag: widget.heroTag,
                                        ));
                                  },
                                  child: CardWidget(
                                      restaurant:
                                          _con.restaurants.elementAt(index),
                                      heroTag: widget.heroTag),
                                );
                              },
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: Center(
                                child: Opacity(
                                  opacity: 0.4,
                                  child: AutoSizeText(
                                    S
                                        .of(context)
                                        .no_matching_results_for_stores,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .merge(TextStyle(
                                            fontWeight: FontWeight.w300)),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
