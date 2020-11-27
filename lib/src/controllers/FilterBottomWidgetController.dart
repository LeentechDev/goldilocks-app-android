import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/cuisine.dart';
import '../models/filter.dart';
import '../Bloc/shared_pref.dart';
import '../repository/cuisine_repository.dart';
import 'package:food_delivery_app/src/repository/food_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterBottomController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  List<Cuisine> cuisines = [];
  Filter filter;
  Cart cart;
  final SharedPrefs prefs = SharedPrefs();

  int orderType;

  getOrderType() async {
    orderType = await prefs.getIntOrderType();
    print(orderType);
  }

  FilterBottomController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForFilter().whenComplete(() {
      listenForCuisines();
    });
  }

  Future<void> listenForFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
    });
  }

  Future<void> saveFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    filter.cuisines = this.cuisines.where((_f) => _f.selected).toList();
    prefs.setString('filter', json.encode(filter.toMap()));
    setState(() {
      filter.delivery == true ?
      sharedPrefs.setIntOrderType(1) : sharedPrefs.setIntOrderType(2);
      Navigator.of(context).pop();
    });
  }

  void listenForCuisines({String message}) async {
    cuisines.add(new Cuisine.fromJSON({'id': '0', 'name': S.of(context).all, 'selected': true}));
    final Stream<Cuisine> stream = await getCuisines();
    stream.listen((Cuisine _cuisine) {
      setState(() {
        if (filter.cuisines.contains(_cuisine)) {
          _cuisine.selected = true;
          cuisines.elementAt(0).selected = false;
        }
        cuisines.add(_cuisine);
      });
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: AutoSizeText(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: AutoSizeText(message),
        ));
      }
    });
  }

  Future<void> refreshCuisines() async {
    cuisines.clear();
    listenForCuisines(message: S.of(context).addresses_refreshed_successfuly);
  }

  void clearFilter() {
    setState(() {
      filter.open = false;
      filter.delivery = false;
      resetCuisines();
    });
  }


  void resetCuisines() {
    filter.cuisines = [];
    cuisines.forEach((Cuisine _f) {
      _f.selected = false;
    });
    cuisines.elementAt(0).selected = true;
  }

  void onChangeCuisinesFilter(int index) {
    if (index == 0) {
      // all
      setState(() {
        resetCuisines();
      });
    } else {
      setState(() {
        cuisines.elementAt(index).selected = !cuisines.elementAt(index).selected;
        cuisines.elementAt(0).selected = false;
      });
    }
  }
}
