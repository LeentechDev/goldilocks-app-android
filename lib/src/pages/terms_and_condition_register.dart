import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/terms_and_condition_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/TermsAndConditionItemWidget.dart';


class TermsAndConditionRegisterWidget extends StatefulWidget {
  @override
  _TermsAndConditionRegisterWidgetState createState() =>
      _TermsAndConditionRegisterWidgetState();
}

class _TermsAndConditionRegisterWidgetState extends StateMVC<TermsAndConditionRegisterWidget> {
  TermsAndConditionController _con;

  _TermsAndConditionRegisterWidgetState() : super(TermsAndConditionController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return _con.terms.isEmpty
        ? CircularLoadingWidget(height: 500)
        : DefaultTabController(
      length: _con.terms.length,
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
              S.of(context).terms_and_conditions,
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
            children: List.generate(_con.terms.length, (index) {
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
                      itemCount: _con.terms.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 15);
                      },
                      itemBuilder: (context, indexFaq) {
                        return TermsAndConditionItemWidget(
                            termsAndCondition : _con.terms
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

/*
ConfigurableExpansionTile(
            header: Container(
              width: MediaQuery.of(context).size.width - 50,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5))),
              child: ListTile(
                title: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: AutoSizeText(
                    Helper.skipHtml(this.termsAndCondition.titleterms),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .merge(TextStyle(color: Theme.of(context).hintColor)),
                    maxLines: 3,
                  ),
                ),
                subtitle: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AutoSizeText(
                        "Created at: " + Helper.skipHtml(this.termsAndCondition.created_at),
                        style: Theme.of(context)
                            .textTheme
                            .caption,
                        maxLines: 3,
                      ),
                      AutoSizeText(
                        "Updated at: " + Helper.skipHtml(this.termsAndCondition.created_at),
                        style: Theme.of(context)
                            .textTheme
                            .caption,
                        maxLines: 3,
                      ),
                    ],
                  )
                ),
                trailing: Icon(
                  Icons.add,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            headerExpanded: Container(
              width: MediaQuery.of(context).size.width - 50,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5))),
              child: ListTile(
                title: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: AutoSizeText(
                    Helper.skipHtml(this.termsAndCondition.titleterms),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .merge(TextStyle(color: Theme.of(context).hintColor)),
                    maxLines: 3,
                  ),
                ),
                subtitle: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AutoSizeText(
                        "Created at: " + Helper.skipHtml(this.termsAndCondition.created_at),
                        style: Theme.of(context)
                            .textTheme
                            .caption,
                        maxLines: 3,
                      ),
                      AutoSizeText(
                        "Updated at: " + Helper.skipHtml(this.termsAndCondition.created_at),
                        style: Theme.of(context)
                            .textTheme
                            .caption,
                        maxLines: 3,
                      ),
                    ],
                  )
                ),
                trailing: Icon(
                  Icons.remove,
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width - 50,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(5),
                        bottomLeft: Radius.circular(5))),
                child: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  padding: EdgeInsets.only(left: 18, bottom: 20),
                  child: AutoSizeText(
                    Helper.skipHtml(this.termsAndCondition.termsandcondition),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .merge(TextStyle(color: Theme.of(context).hintColor)),
                  ),
                ),
              ),
            ],
          ),
 */