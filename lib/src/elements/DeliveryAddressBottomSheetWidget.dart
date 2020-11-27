import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../generated/l10n.dart';
import '../controllers/delivery_addresses_controller.dart';
import '../helpers/app_config.dart' as config;
import '../models/address.dart';
import '../repository/settings_repository.dart' as settingsRepo;
import '../repository/user_repository.dart' as userRepo;
import '../Bloc/Providers.dart';
import '../Bloc/shared_pref.dart';


class DeliveryAddressBottomSheetWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  DeliveryAddressBottomSheetWidget({Key key, this.scaffoldKey}) : super(key: key);

  @override
  _DeliveryAddressBottomSheetWidgetState createState() => _DeliveryAddressBottomSheetWidgetState();
}

class _DeliveryAddressBottomSheetWidgetState extends StateMVC<DeliveryAddressBottomSheetWidget> {
  DeliveryAddressesController _con;

  _DeliveryAddressBottomSheetWidgetState() : super(DeliveryAddressesController()) {
    _con = controller;
  }

  final SharedPrefs prefs = SharedPrefs();

  String _phone;

  getPhoneOrder() async {
    _phone = await prefs.getStringPhone();
    print(_phone);
  }

  @override
  void initState() {
    getPhoneOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.4), blurRadius: 30, offset: Offset(0, -30)),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: ListView(
              padding: EdgeInsets.only(top: 20, bottom: 15, left: 20, right: 20),
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    LocationResult result = await showLocationPicker(
                      context,
                      settingsRepo.setting.value.googleMapsKey,
                      initialCenter: LatLng(settingsRepo.deliveryAddress.value?.latitude ?? 0, settingsRepo.deliveryAddress.value?.longitude ?? 0),
                      //automaticallyAnimateToCurrentLocation: true,
                      //mapStylePath: 'assets/mapStyle.json',
                      myLocationButtonEnabled: true,
                      //resultCardAlignment: Alignment.bottomCenter,
                    );

                    Address current_address = new Address.fromJSON({
                      'address': result.address,
                      'latitude': result.latLng.latitude,
                      'longitude': result.latLng.longitude,
                    });
                    _con.addAddress(current_address);
                    _con.changeDeliveryAddress(current_address).then((value) {
                      String phone = userRepo.currentUser.value.phone;
                      userRepo.updateUserInfo(phone, result.address);
                      Navigator.of(context).pop();
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).accentColor,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(100)), color: Theme.of(context).primaryColor),
                        child: Icon(
                          Icons.add,
                          color: Theme.of(context).hintColor,
                          size: 22,
                        ),
                      ),
                      SizedBox(width: 15),
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  AutoSizeText(
                                    S.of(context).add_new_delivery_address,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Theme.of(context).dividerColor,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 25),
                InkWell(
                  onTap: () {
                    _con.changeDeliveryAddressToCurrentLocation().then((value) async {
                      Address current_address = settingsRepo.deliveryAddress.value;
                      _con.addAddress(current_address);
                      _con.changeDeliveryAddress(_con.addresses.first).then((value){
                        String phone = userRepo.currentUser.value.phone;
                        String address = settingsRepo.deliveryAddress.value?.address;
                        userRepo.updateUserInfo(phone, address);
                        Navigator.of(widget.scaffoldKey.currentContext).pop();
                      });
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100)), color: Theme.of(context).accentColor, ),
                        child: Icon(
                          Icons.my_location,
                          color: Theme.of(context).hintColor,
                          size: 22,
                        ),
                      ),
                      SizedBox(width: 15),
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  AutoSizeText(
                                    S.of(context).current_location,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Theme.of(context).dividerColor,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _con.addresses.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 25);
                  },
                  itemBuilder: (context, index) {
//                return DeliveryAddressesItemWidget(
//                  address: _con.addresses.elementAt(index),
//                  onPressed: (Address _address) {
//                    _con.chooseDeliveryAddress(_address);
//                  },
//                  onLongPress: (Address _address) {
//                    DeliveryAddressDialog(
//                      context: context,
//                      address: _address,
//                      onChanged: (Address _address) {
//                        _con.updateAddress(_address);
//                      },
//                    );
//                  },
//                  onDismissed: (Address _address) {
//                    _con.removeDeliveryAddress(_address);
//                  },
//                );
                    return InkWell(
                      onTap: () {
                        _con.changeDeliveryAddress(_con.addresses.elementAt(index)).then((value) async {
                          String phone = userRepo.currentUser.value.phone;
                          String address = settingsRepo.deliveryAddress.value?.address;
                          userRepo.updateUserInfo(phone, address);
                          Navigator.of(widget.scaffoldKey.currentContext).pop();
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100)), color: Color(0xFFFDF2C4),),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset('assets/custom_img/pin_drop.svg',
                              ),
                            )
                          ),
                          SizedBox(width: 15),
                          Flexible(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      AutoSizeText(
                                        _con.addresses.elementAt(index).address.toString() ?? _con.addresses.elementAt(index).address,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(context).textTheme.bodyText2,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Theme.of(context).dividerColor,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            height: 30,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 13, horizontal: config.App(context).appWidth(42)),
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withOpacity(0.05),
              borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
            child: Container(
              width: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(3),
              ),
              //child: SizedBox(height: 1,),
            ),
          ),
        ],
      ),
    );
  }
}
