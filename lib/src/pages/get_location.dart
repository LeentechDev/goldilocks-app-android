import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_map_location_picker/generated/i18n.dart'
    as location_picker;
import 'package:provider/provider.dart';

import '../elements/BlockButtonWidget.dart';
import '../controllers/locationpage_controller.dart';
import '../repository/settings_repository.dart' as settingsRepo;
import '../repository/user_repository.dart' as userRepo;
import '../models/address.dart';
import '../Bloc/Providers.dart';

class GetLocationWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  GetLocationWidget({Key key, this.scaffoldKey}) : super(key: key);

  @override
  _GetLocationWidgetState createState() => _GetLocationWidgetState();
}

class _GetLocationWidgetState extends StateMVC<GetLocationWidget> {
  bool _load = true;
  LocationPageController _con;

  _GetLocationWidgetState() : super(LocationPageController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          location_picker.S.delegate,
          //S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[
          Locale('en', ''),
        ],
        home: Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          onPressed: () {},
                          // Navigator.of(context).pushNamed('/OrderType'),
                          child: AutoSizeText(
                            "",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            AutoSizeText(
                              'Setup Location',
                              textAlign: TextAlign.center,
                              minFontSize: 18,
                              maxLines: 1,
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                fontSize: 30.0,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            AutoSizeText(
                              'Goldilocks app uses your location to show stores near you!',
                              minFontSize: 12,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 20.0,
                                height: 1.2,
                              ),
                            ),
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/custom_img/location_icon.png',
                                ),
                                height: 350.0,
                                width: 350.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _load
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  BlockButtonWidget(
                                    text: AutoSizeText(
                                      "Use current location",
                                      style: TextStyle(
                                          color: Theme.of(context).hintColor),
                                    ),
                                    color: Theme.of(context).accentColor,
                                    onPressed: () {
                                      setState(() {
                                        _load = false;
                                      });
                                      _con
                                          .changeDeliveryAddressToCurrentLocation()
                                          .then((value) async {
                                        Address current_address =
                                             settingsRepo
                                                .deliveryAddress.value;
                                        _con.addAddress(current_address);
                                        _con
                                            .changeDeliveryAddress(
                                            _con.addresses.first)
                                            .then((value) {
                                          String phone =
                                              currentUser.value.phone;
                                          String address = settingsRepo
                                              .deliveryAddress.value?.address;
                                          userRepo.updateUserInfo(
                                              phone, address);
                                          Navigator.of(context)
                                              .pushNamed('/OrderType');
                                        });
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  FlatButton(
                                      child: AutoSizeText(
                                        "Select another location",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      onPressed: () async {
                                        setState(() {});
                                        LocationResult result =
                                            await showLocationPicker(
                                          context,
                                          settingsRepo
                                              .setting.value.googleMapsKey,
                                          initialCenter: LatLng(
                                              settingsRepo.deliveryAddress.value
                                                      ?.latitude ??
                                                  0,
                                              settingsRepo.deliveryAddress.value
                                                      ?.longitude ??
                                                  0),
                                          //automaticallyAnimateToCurrentLocation: true,
                                          //mapStylePath: 'assets/mapStyle.json',
                                          myLocationButtonEnabled: true,
                                          //resultCardAlignment: Alignment.bottomCenter,
                                        );

                                        Address address = new Address.fromJSON({
                                          'address': result.address,
                                          'latitude': result.latLng.latitude,
                                          'longitude': result.latLng.longitude,
                                        });

                                        _con.addAddress(address);
                                        _con
                                            .changeDeliveryAddress(address)
                                            .then((value) {
                                          String phone =
                                              currentUser.value.phone;
                                          userRepo.updateUserInfo(
                                              phone, result.address);
                                          Navigator.of(context)
                                              .pushNamed('/OrderType');
                                        });
                                      }),
                                ],
                              ),
                            )
                          : Center(
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.yellow),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
