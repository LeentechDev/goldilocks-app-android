import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../helpers/app_config.dart' as config;

class EmptyAllMenuWidget extends StatefulWidget {
  EmptyAllMenuWidget({
    Key key,
  }) : super(key: key);

  @override
  _EmptyAllMenuWidgetState createState() => _EmptyAllMenuWidgetState();
}

class _EmptyAllMenuWidgetState extends State<EmptyAllMenuWidget> {
  bool loading = true;

  @override
  void initState() {
    Timer(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        loading
            ? SizedBox(
          height: 3,
          child: LinearProgressIndicator(
            backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
          ),
        )
            : SizedBox(),
        Container(
          alignment: AlignmentDirectional.center,
          padding: EdgeInsets.symmetric(horizontal: 30),
          height: config.App(context).appHeight(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              Image.asset("assets/custom_img/allmenu_empty.png", height: MediaQuery.of(context).size.height /6,),
              SizedBox(height: 15),
              Opacity(
                opacity: 0.4,
                child: AutoSizeText(
                  S.of(context).no_food_items_found,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3.merge(TextStyle(fontWeight: FontWeight.w300)),
                ),
              ),
              SizedBox(height: 50),
              //!loading
              //    ? FlatButton(
              //        onPressed: () {
              //          Navigator.of(context).pushNamed('/Pages', arguments: 0);
              //        },
              //        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
              //        color: Theme.of(context).accentColor.withOpacity(1),
              //        shape: StadiumBorder(),
              //        child: AutoSizeText(
              //          S.of(context).start_exploring,
              //          style: Theme.of(context).textTheme.headline6.merge(TextStyle(color: Theme.of(context).scaffoldBackgroundColor)),
              //        ),
              //      )
              //    : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
