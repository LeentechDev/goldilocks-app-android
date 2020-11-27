import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/food.dart';
import '../models/gallery.dart';
import '../models/category.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import '../models/cart.dart';
import '../repository/food_repository.dart';
import '../repository/gallery_repository.dart';
import '../repository/restaurant_repository.dart';
import '../repository/settings_repository.dart';
import '../repository/cart_repository.dart';
import '../repository/category_repository.dart';

class RestaurantController extends ControllerMVC {
  Restaurant restaurant;
  List<Gallery> galleries = <Gallery>[];
  List<Food> foods = <Food>[];
  List<Food> trendingFoods = <Food>[];
  List<Food> featuredFoods = <Food>[];
  List<Review> reviews = <Review>[];
  List<Category> categories = <Category>[];
  List<String> category_name = <String>[];
  List<Cart> carts = [];
  GlobalKey<ScaffoldState> scaffoldKey;
  bool loadCart = false;
  int cartCount = 0;

  RestaurantController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForCategories();
  }

  Future<void> listenForCategories() async {
    final Stream<Category> stream = await getCategories();
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForRestaurant({String id, String message}) async {
    final Stream<Restaurant> stream =
        await getRestaurant(id, deliveryAddress.value);
    stream.listen((Restaurant _restaurant) {
      setState(() => restaurant = _restaurant);
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: AutoSizeText(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: AutoSizeText("Store has been refreshed successfully"),
        ));
      }
    });
  }

  void listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      carts.add(_cart);
    });
  }

  void listenForCartsCount({String message}) async {
    final Stream<int> stream = await getCartCount();
    stream.listen((int _count) {
      setState(() {
        this.cartCount = _count;
      });
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: AutoSizeText(S.of(context).verify_your_internet_connection),
      ));
    });
  }

  void listenForGalleries(String idRestaurant) async {
    final Stream<Gallery> stream = await getGalleries(idRestaurant);
    stream.listen((Gallery _gallery) {
      setState(() => galleries.add(_gallery));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForRestaurantReviews({String id, String message}) async {
    final Stream<Review> stream = await getRestaurantReviews(id);
    stream.listen((Review _review) {
      setState(() => reviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForFoods(String idRestaurant, BuildContext context) async {
    final Stream<Food> stream =
        await getFoodsOfRestaurant(idRestaurant, context);
    stream.listen((Food _food) {
      setState(() {
        foods.add(_food);
      });
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForCategoryFoods(String idRestaurant, BuildContext context) async {
    final Stream<Food> stream =
        await getFoodsByStoreCategory(idRestaurant, context);
    stream.listen((Food _food) {
      setState(() => foods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForTrendingFoods(String idRestaurant) async {
    final Stream<Food> stream =
        await getTrendingFoodsOfRestaurant(idRestaurant);
    stream.listen((Food _food) {
      setState(() => trendingFoods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForFeaturedFoods(String idRestaurant) async {
    final Stream<Food> stream =
        await getFeaturedFoodsOfRestaurant(idRestaurant);
    stream.listen((Food _food) {
      setState(() => featuredFoods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> refreshRestaurant() async {
    var _id = restaurant.id;
    restaurant = new Restaurant();
    galleries.clear();
    reviews.clear();
    featuredFoods.clear();
    foods.clear();
    listenForRestaurant(
        id: _id, message: S.of(context).store_refreshed_successfuly);
    listenForRestaurantReviews(id: _id);
    listenForFoods(_id, context);
    listenForGalleries(_id);
    listenForFeaturedFoods(_id);
    categories = <Category>[];
    await listenForCategories();
    Future.delayed(Duration(seconds: 2));
  }

  Future<void> refreshFoods() async {
    var _id = restaurant.id;
    foods.clear();
    listenForFoods(_id, context);
    categories = <Category>[];
    await listenForCategories();
  }
}