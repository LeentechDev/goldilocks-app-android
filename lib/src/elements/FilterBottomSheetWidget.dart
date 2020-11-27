import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/FilterBottomWidgetController.dart';
import '../helpers/app_config.dart' as config;
import '../models/filter.dart';
import '../Bloc/shared_pref.dart';
import '../Bloc/OrderTypeProvider.dart';


class OrderChoice{
  String choice;
  int index;
  OrderChoice({this.index, this.choice});
}

class FilterBottomSheetWidget extends StatefulWidget {

  final GlobalKey<ScaffoldState> scaffoldKey;
  final ValueChanged<Filter> onFilter;

  FilterBottomSheetWidget({Key key, this.scaffoldKey,this.onFilter}) : super(key: key);

  @override
  _FilterBottomSheetWidgetState createState() =>
      _FilterBottomSheetWidgetState();
}



class _FilterBottomSheetWidgetState extends StateMVC<FilterBottomSheetWidget> {
  FilterBottomController _con;

  _FilterBottomSheetWidgetState() : super(FilterBottomController()) {
    _con = controller;
  }

  final SharedPrefs prefs = SharedPrefs();
  
  int orderType;

  getOrderType() async {
    orderType = await prefs.getIntOrderType();
    print(orderType);
  }

  @override
  void initState() {
    getOrderType();
    super.initState();
  }

  void _handleRadioValueChange1(int value) {
    final OrderTypeGenerator orderTypeGenerator = Provider.of<OrderTypeGenerator>(context, listen: false);
    setState(() {
      orderType = value;
      switch (orderType) {
        case 1:
          orderTypeGenerator.setOrderTypeValue(1);
          prefs.setIntOrderType(1);
          break;
        case 2:
          orderTypeGenerator.setOrderTypeValue(2);
          prefs.setIntOrderType(2);
          break;
        case 3:
          orderTypeGenerator.setOrderTypeValue(3);
          prefs.setIntOrderType(3);
          break;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).hintColor.withOpacity(0.4),
              blurRadius: 30,
              offset: Offset(0, -30)),
        ],
      ),
      child: Stack(
        children: <Widget>[

          Padding(
            padding: EdgeInsets.symmetric(vertical: 30,horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                AutoSizeText(
                  S.of(context).delivery_or_pickup, style: Theme.of(context).textTheme.headline4,
                ),

                SizedBox(height: 20,),

                ListTile(
                  title: AutoSizeText(
                    S.of(context).mail_order,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1,
                  ),
                  trailing: Radio(
                          value: 1,
                          groupValue: orderType,
                          onChanged: _handleRadioValueChange1,
                        ),
                ),
                ListTile(
                  title: AutoSizeText(
                    S.of(context).delivery,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1,
                  ),
                  trailing: Radio(
                          value: 2,
                          groupValue: orderType,
                          onChanged: _handleRadioValueChange1,
                        ),
                ),
                ListTile(
                  title: AutoSizeText(
                    S.of(context).store_pick_up,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1,
                  ),
                  trailing: Radio(
                          value: 3,
                          groupValue: orderType,
                          onChanged: _handleRadioValueChange1,
                        ),
                ),
                
                
                // CheckboxListTile(
                //   controlAffinity: ListTileControlAffinity.trailing,
                //   value: _con.filter?.delivery ?? false,
                //   onChanged: (value) {
                //     Provider.of<OrderTypeGenerator>(context, listen: false).setOrderTypeDelivery();
                //     setState(() {
                //       _con.filter?.delivery = true;
                //       prefs.setIntOrderType(0);
                //     });
                //   },
                //   title: AutoSizeText(
                //     S.of(context).mail_order,
                //     overflow: TextOverflow.fade,
                //     softWrap: false,
                //     maxLines: 1,
                //   ),
                // ),
                // CheckboxListTile(
                //   controlAffinity: ListTileControlAffinity.trailing,
                //   value: _con.filter?.delivery ?? false,
                //   onChanged: (value) {
                //     Provider.of<OrderTypeGenerator>(context, listen: false).setOrderTypeDelivery();
                //     setState(() {
                //       _con.filter?.delivery = true;
                //       prefs.setIntOrderType(1);
                //     });
                //   },
                //   title: AutoSizeText(
                //     S.of(context).delivery,
                //     overflow: TextOverflow.fade,
                //     softWrap: false,
                //     maxLines: 1,
                //   ),
                // ),
                // CheckboxListTile(
                //   controlAffinity: ListTileControlAffinity.trailing,
                //   value: _con.filter?.delivery ?? false ? false : true,
                //   onChanged: (value) {
                //     Provider.of<OrderTypeGenerator>(context, listen: false).setOrderTypePickup();
                //     setState(() {
                //       _con.filter?.delivery = false;
                //       prefs.setIntOrderType(2);
                //     });
                //   },
                //   title: AutoSizeText( 
                //     S.of(context).store_pick_up,
                //     overflow: TextOverflow.fade,
                //     softWrap: false,
                //     maxLines: 1,
                //   ),
                // ),

                SizedBox(height: 15),
                FlatButton(
                  onPressed: () {
                    setState(() { 
                      orderType;
                    });
                    Navigator.pop(context);
                    // _con.saveFilter().whenComplete(() {
                    //   widget.onFilter(_con.filter);
                    // });

                  },
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  color: Theme.of(context).accentColor,
                  shape: StadiumBorder(),
                  child: AutoSizeText(
                    S.of(context).apply_filters,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                ),
              ],
            ),
          ),


          Container(
            height: 30,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                vertical: 13, horizontal: config.App(context).appWidth(42)),
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
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

/*
Expanded(
            child: ListView(
              primary: true,
              shrinkWrap: true,
              children: <Widget>[
                ExpansionTile(
                  title: AutoSizeText(S.of(context).delivery_or_pickup),
                  children: [
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.trailing,
                      value: true,//_con.filter?.delivery ?? false,
                      onChanged: (value) {
                        setState(() {
                          //_con.filter?.delivery = true;
                        });
                      },
                      title: AutoSizeText(
                        S.of(context).mail_order,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        maxLines: 1,
                      ),
                    ),
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.trailing,
                      value: true ,//_con.filter?.delivery ?? false ? false : true,
                      onChanged: (value) {
                        setState(() {
                          //_con.filter?.delivery = false;
                        });
                      },
                      title: AutoSizeText(
                        S.of(context).store_pick_up,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        maxLines: 1,
                      ),
                    ),
                  ],
                  initiallyExpanded: true,
                ),
                //ExpansionTile(
                //  title: AutoSizeText(S.of(context).opened_stores),
                //  children: [
                //    CheckboxListTile(
                //      controlAffinity: ListTileControlAffinity.trailing,
                //      value: _con.filter?.open ?? false,
                //      onChanged: (value) {
                //        setState(() {
                //          _con.filter?.open = value;
                //        });
                //      },
                //      title: AutoSizeText(
                //        S.of(context).open,
                //        overflow: TextOverflow.fade,
                //        softWrap: false,
                //        maxLines: 1,
                //      ),
                //    ),
                //  ],
                //  initiallyExpanded: true,
                //),
                //_con.cuisines.isEmpty
                //    ? CircularLoadingWidget(height: 100)
                //    : ExpansionTile(
                //        title: AutoSizeText(S.of(context).cuisines),
                //        children: List.generate(_con.cuisines.length, (index) {
                //          return CheckboxListTile(
                //            controlAffinity: ListTileControlAffinity.trailing,
                //            value: _con.cuisines.elementAt(index).selected,
                //            onChanged: (value) {
                //              _con.onChangeCuisinesFilter(index);
                //            },
                //            title: AutoSizeText(
                //              _con.cuisines.elementAt(index).name,
                //              overflow: TextOverflow.fade,
                //              softWrap: false,
                //              maxLines: 1,
                //            ),
                //          );
                //        }),
                //        initiallyExpanded: true,
                //      ),
              ],
            ),
          ),
 */
