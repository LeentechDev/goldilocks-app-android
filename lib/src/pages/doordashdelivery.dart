import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:food_delivery_app/src/Bloc/Providers.dart';
import 'package:food_delivery_app/src/controllers/doordash_controller.dart';
import 'package:food_delivery_app/src/controllers/paypal_controller.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../models/route_argument.dart';

// ignore: must_be_immutable
class DoorDashWidget extends StatefulWidget {
  RouteArgument routeArgument;
  DoorDashWidget({Key key, this.routeArgument}) : super(key: key);
  @override
  _DoorDashWidgetState createState() => _DoorDashWidgetState();
}

class _DoorDashWidgetState extends StateMVC<DoorDashWidget> {
  DoorDashController _con;
  _DoorDashWidgetState() : super(DoorDashController()) {
    _con = controller;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        //centerTitle: true,
        title: AutoSizeText(
          S.of(context).door_dash,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      body: Stack(
        children: <Widget>[
          InAppWebView(
            initialUrl: Provider.of<Providers>(context).Url.toString(),
            initialHeaders: {},
            initialOptions: new InAppWebViewWidgetOptions(),
            onWebViewCreated: (InAppWebViewController controller) {
               
              _con.webView = controller;
            },
            onLoadStart: (InAppWebViewController controller, String url) {
             
              setState(() {
                _con.url = url;
              });
              if (url == '') {
                Navigator.of(context).pushReplacementNamed('/settings');
              }
            },
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              setState(() {
                _con.progress = progress / 100;
              });
            },
            onLoadError: (InAppWebViewController controller, String url,
                int code, String message) async {
              print("error $url: $code, $message");

              var tRexHtml = await controller.getTRexRunnerHtml();
              var tRexCss = await controller.getTRexRunnerCss();

              controller.loadData(data: """
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1.0, user-scalable=no">
    <style>$tRexCss</style>
  </head>
  <body>
    $tRexHtml
    <p>
      URL $url failed to load.
    </p>
    <p>
      Error: $code, $message
    </p>
  </body>
</html>
                  """);
            },
            onLoadHttpError: (InAppWebViewController controller, String url,
                int statusCode, String description) async {
              if("$statusCode" == "500"){
                Navigator.of(context).pushReplacementNamed('/Pages', arguments: 0);
              }
              print("HTTP error $url: $statusCode, $description");
            },
          ),
          _con.progress < 1
              ? SizedBox(
                  height: 3,
                  child: LinearProgressIndicator(
                    value: _con.progress,
                    backgroundColor:
                        Theme.of(context).accentColor.withOpacity(0.2),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}