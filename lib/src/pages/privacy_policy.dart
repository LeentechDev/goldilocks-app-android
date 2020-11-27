import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/privacy_policy_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/PrivacyPolicyItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';

class PrivacyPolicyWidget extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends StateMVC<PrivacyPolicyWidget> {
  PrivacyPolicyController _con;

  _PrivacyPolicyState() : super(PrivacyPolicyController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return _con.policies.isEmpty
        ? CircularLoadingWidget(height: 500)
        : DefaultTabController(
      length: _con.policies.length,
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
              S.of(context).privacy_policy,
              style: Theme.of(context).textTheme.headline4
          ),
          //actions: <Widget>[
          //  new ShoppingCartButtonWidget(
          //      iconColor: Theme.of(context).primaryColor,
          //      labelColor: Theme.of(context).accentColor),
          //],
        ),
        body: RefreshIndicator(
          onRefresh: _con.refreshPrivacyPolicy,
          child: TabBarView(
            children: List.generate(_con.policies.length, (index) {
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
                      itemCount: _con.policies.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 15);
                      },
                      itemBuilder: (context, indexFaq) {
                        return PrivacyPolicyItemWidget(
                            privacyPolicy : _con.policies
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
