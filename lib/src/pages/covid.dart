import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/covid19Controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/covidItemWidget.dart';


class CovidWidget extends StatefulWidget {
  @override
  _CovidWidgetState createState() =>
      _CovidWidgetState();
}

class _CovidWidgetState extends StateMVC<CovidWidget> {
  CovidController _con;

  _CovidWidgetState() : super(CovidController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return _con.covidV.isEmpty
        ? CircularLoadingWidget(height: 500)
        : DefaultTabController(
      length: _con.covidV.length,
      child: Scaffold(
        key: _con.scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          //centerTitle: true,
          iconTheme: IconThemeData(color: Theme.of(context).hintColor),
          // bottom: TabBar(
          //   tabs: List.generate(_con.policies.length, (index) {
          //     return Tab(text: _con.policies.elementAt(index).name ?? '');
          //   }),
          //   labelColor: Theme.of(context).accentColor,
          //   unselectedLabelColor: Theme.of(context).dividerColor,
          // ),
          title: AutoSizeText(
              S.of(context).covid_19,
              style: Theme.of(context).textTheme.headline4
          ),
          //actions: <Widget>[
          //  new ShoppingCartButtonWidget(
          //      iconColor: Theme.of(context).primaryColor,
          //      labelColor: Theme.of(context).accentColor),
          //],
        ),
        body: RefreshIndicator(
          onRefresh: _con.refreshTermsAndCondition,
          child: TabBarView(
            children: List.generate(_con.covidV.length, (index) {
              return SingleChildScrollView(
                padding:
                EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _con.covidV.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 15);
                      },
                      itemBuilder: (context, indexFaq) {
                        return CovidItemWidget(
                            covid19 : _con.covidV
                                .elementAt(indexFaq));
                      },
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
