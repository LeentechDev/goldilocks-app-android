import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:food_delivery_app/src/models/restaurant.dart';
// import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/address.dart';
// import '../repository/settings_repository.dart' as settingRepo;
// import '../repository/user_repository.dart' as userRepo;

class DoorDashController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  InAppWebViewController webView;
  String url = "";
  double progress = 0;
  Address deliveryAddress;

  DoorDashController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
  @override
  void initState() {
    // final String _apiToken = 'api_token=${userRepo.currentUser.value.apiToken}';
    // final String _userId = 'user_id=${userRepo.currentUser.value.id}';
    // final String _deliveryAddress = 'delivery_address_id=${settingRepo.deliveryAddress.value?.id}';
    url = 'https://www.doordash.com/business/goldilocks-123027/?utm_campaign=123027&utm_medium=website&utm_source=partner-link';
    // '${GlobalConfiguration().getString('base_url')}payments/paypal/express-checkout?$_apiToken&$_userId&$_deliveryAddress';
    setState(() {});
    super.initState();
  }
}
