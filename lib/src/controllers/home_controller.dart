import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/src/Bloc/Providers.dart';
import 'package:food_delivery_app/src/models/order.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';

import '../helpers/helper.dart';
import '../models/category.dart';
import '../models/food.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import '../Bloc/OrderTypeProvider.dart';
import '../repository/category_repository.dart';
import '../repository/food_repository.dart';
import '../repository/restaurant_repository.dart';
import '../repository/settings_repository.dart';

class HomeController extends ControllerMVC {
  List<Category> categories = <Category>[];
  List<Restaurant> topRestaurants = <Restaurant>[];
  List<Restaurant> popularRestaurants = <Restaurant>[];
  List<Review> recentReviews = <Review>[];
  List<Food> trendingFoods = <Food>[];
  List<Food> allProducts = <Food>[];
  List<Restaurant> allRestaurants = <Restaurant>[];
  int status;


  HomeController() {
    listenForTopRestaurants();
    listenForTrendingFoods();
    listenForCategories();
    listenForPopularRestaurants();
    listenForRecentReviews();
    listenForAllRestaurants();
    listenForAllProducts();
  }

  Future<void> listenForCategories() async {
    final Stream<Category> stream = await getCategories();
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }


  Future<void> listenForTopRestaurants() async {
    Future.delayed(Duration(seconds: 1)).whenComplete(() async {
      final Stream<Restaurant> stream = await getNearRestaurants(deliveryAddress.value, deliveryAddress.value);
    stream.listen((Restaurant _restaurant) {
      setState(() => topRestaurants.add(_restaurant));
    }, onError: (a) {}, onDone: () {});
    });
    
  }

  Future<void> listenForPopularRestaurants() async {
    final Stream<Restaurant> stream = await getPopularRestaurants(deliveryAddress.value);
    stream.listen((Restaurant _restaurant) {
      setState(() => popularRestaurants.add(_restaurant));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForRecentReviews() async {
    final Stream<Review> stream = await getRecentReviews();
    stream.listen((Review _review) {
      setState(() => recentReviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForTrendingFoods() async {
    final Stream<Food> stream = await getTrendingFoods(deliveryAddress.value);
    stream.listen((Food _food) {
      setState(() => trendingFoods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForAllProducts() async {
    final Stream<Food> stream = await getAllProducts(deliveryAddress.value);
    stream.listen((Food _food) {
      setState(() => allProducts.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForAllRestaurants() async {
    final Stream<Restaurant> stream = await getAllRestaurants(deliveryAddress.value, deliveryAddress.value);
    stream.listen((Restaurant _restaurant) {
      setState(() => allRestaurants.add(_restaurant));
    }, onError: (a) {}, onDone: () {});
  }

  void requestForCurrentLocation(BuildContext context) {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    setCurrentLocation().then((_address) async {
      deliveryAddress.value = _address;
      await refreshHome();
      loader.remove();
    }).catchError((e) {
      loader.remove();
    });
  }

  Future<void> refreshHome() async {
    setState(() {
      categories = <Category>[];
      topRestaurants = <Restaurant>[];
      popularRestaurants = <Restaurant>[];
      recentReviews = <Review>[];
      trendingFoods = <Food>[];
      allRestaurants = <Restaurant>[];
      allProducts = <Food>[];
    });
    await listenForTopRestaurants();
    await listenForTrendingFoods();
    await listenForCategories();
    await listenForPopularRestaurants();
    await listenForRecentReviews();
    await listenForAllRestaurants();
    await listenForAllProducts();
  }
}