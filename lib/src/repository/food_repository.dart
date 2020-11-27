import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/favorite.dart';
import '../models/filter.dart';
import '../models/food.dart';
import '../models/review.dart';
import '../models/user.dart';
import '../Bloc/shared_pref.dart';
import '../Bloc/OrderTypeProvider.dart';
import '../Bloc/Providers.dart';
import '../repository/user_repository.dart' as userRepo;

final SharedPrefs sharedPrefs = SharedPrefs();
int orderType;

getOrderType() async {
  orderType = await sharedPrefs.getIntOrderType();
  print(orderType);
}

Future<Stream<Food>> getTrendingFoods(Address address) async {
  Uri uri = Helper.getUri('api/foods');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
  filter.delivery = false;
  filter.open = false;

  orderType == 1 ? _queryParams['is_mail_order'] = 1 : null;
  orderType == 2 ? _queryParams['is_store_pickup'] = 1 : null;
  _queryParams['limit'] = '6';
  _queryParams['trending'] = 'week';
  if (!address.isUnknown()) {
    _queryParams['myLon'] = address.longitude.toString();
    _queryParams['myLat'] = address.latitude.toString();
    _queryParams['areaLon'] = address.longitude.toString();
    _queryParams['areaLat'] = address.latitude.toString();
  }
  _queryParams.addAll(filter.toQuery());
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Food.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Food.fromJSON({}));
  }
}

Future<Stream<Food>> getFood(String foodId) async {
  Uri uri = Helper.getUri('api/foods/$foodId');
  uri = uri.replace(queryParameters: {'with': 'nutrition;restaurant;category;extras;extraGroups;foodReviews;foodReviews.user'});
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).map((data) {
      return Food.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Food.fromJSON({}));
  }
}

Future<Stream<Food>> getAllProducts(Address address) async {
  Uri uri = Helper.getUri('api/foods');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
  filter.delivery = false;
  filter.open = false;

  orderType == 1 ? _queryParams['is_mail_order'] = 1 : null;
  orderType == 2 ? _queryParams['is_store_pickup'] = 1 : null;
  if (!address.isUnknown()) {
    _queryParams['myLon'] = address.longitude.toString();
    _queryParams['myLat'] = address.latitude.toString();
    _queryParams['areaLon'] = address.longitude.toString();
    _queryParams['areaLat'] = address.latitude.toString();
  }
  _queryParams.addAll(filter.toQuery());
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Food.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Food.fromJSON({}));
  }
}

Future<Stream<Food>> searchFoods(String search, Address address) async {
  Uri uri = Helper.getUri('api/foods');
  Map<String, dynamic> _queryParams = {};
  _queryParams['search'] = 'name:$search;description:$search';
  _queryParams['searchFields'] = 'name:like;description:like';
  _queryParams['limit'] = '5';
  if (!address.isUnknown()) {
    _queryParams['myLon'] = address.longitude.toString();
    _queryParams['myLat'] = address.latitude.toString();
    _queryParams['areaLon'] = address.longitude.toString();
    _queryParams['areaLat'] = address.latitude.toString();
  }
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Food.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Food.fromJSON({}));
  }
}

Future<Stream<Food>> getFoodsByCategory(categoryId) async {
  Uri uri = Helper.getUri('api/foods');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
  _queryParams['with'] = 'restaurant';
  _queryParams['search'] = 'category_id:$categoryId';
  _queryParams['searchFields'] = 'category_id:=';

  _queryParams = filter.toQuery(oldQuery: _queryParams);
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Food.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Food.fromJSON({}));
  }
}

Future<Stream<Food>> getFoodsByStoreCategory(storeId, context) async {
  String theOrderTypeD;
  String theOrderTypeS;
  final OrderTypeGenerator orderTypeGenerator = Provider.of<OrderTypeGenerator>(context);
  orderTypeGenerator.OType.toString() == "Delivery" ? theOrderTypeD = "1" : "0";
  orderTypeGenerator.OType.toString() == "Store Pick Up" ? theOrderTypeS = "1" : "0";
  Uri uri = Helper.getUri('api/foods');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
  _queryParams['is_mail_order'] = theOrderTypeD;
  _queryParams['is_store_pickup'] = theOrderTypeS;
  _queryParams['with'] = 'restaurant';
  _queryParams['search'] = 'category_id:;restaurant_id=$storeId';
  _queryParams['searchFields'] = 'category_id:=;restaurant.id:=';

  _queryParams = filter.toQuery(oldQuery: _queryParams);
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Food.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Food.fromJSON({}));
  }
}

Future<Stream<Favorite>> isFavoriteFood(String foodId) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url = '${GlobalConfiguration().getString('api_base_url')}favorites/exist?${_apiToken}food_id=$foodId&user_id=${_user.id}';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getObjectData(data)).map((data) => Favorite.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Favorite.fromJSON({}));
  }
}

Future<Stream<Favorite>> getFavorites() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}favorites?${_apiToken}with=food;user;extras&search=user_id:${_user.id}&searchFields=user_id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  try {
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => Favorite.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Favorite.fromJSON({}));
  }
}

Future<Favorite> addFavorite(Favorite favorite) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Favorite();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  favorite.userId = _user.id;
  final String url = '${GlobalConfiguration().getString('api_base_url')}favorites?$_apiToken';
  try {
    final client = new http.Client();
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(favorite.toMap()),
    );
    return Favorite.fromJSON(json.decode(response.body)['data']);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return Favorite.fromJSON({});
  }
}

Future<Favorite> removeFavorite(Favorite favorite) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Favorite();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}favorites/${favorite.id}?$_apiToken';
  try {
    final client = new http.Client();
    final response = await client.delete(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    return Favorite.fromJSON(json.decode(response.body)['data']);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return Favorite.fromJSON({});
  }
}

Future<Stream<Food>> getFoodsOfRestaurant(String restaurantId, BuildContext context) async {
  String theOrderType;
  Providers categoryProviders = Provider.of<Providers>(context, listen: false);
  String categoryId = categoryProviders.CategoryID.toString();
  OrderTypeGenerator orderTypeGenerator = Provider.of<OrderTypeGenerator>(context, listen: false);

  orderTypeGenerator.OType.toString() == "Delivery" ? theOrderType = "is_mail_order=1" :
  orderTypeGenerator.OType.toString() == "Store Pick Up" ? theOrderType = "is_store_pickup=1" : "";

  String categoryURL = categoryId == null || categoryId == "0" || categoryId == "" ? "" : "category_id:$categoryId;";

  final String url = '${GlobalConfiguration().getString('api_base_url')}foods?with=restaurant&search=$categoryURL' + 'restaurant.id:$restaurantId&searchFields=category_id:=;restaurant.id:=&searchJoin=and&';
  //final String url = '${GlobalConfiguration().getString('api_base_url')}foods?$theOrderType&with=restaurant&search=restaurant.id:$restaurantId&searchFields=restaurant.id:=';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    //print(theOrderType + ": The order type");
    //print("URl: " + url);
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Food.fromJSON(data);

    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Food.fromJSON({}));
  }
}



Future<Stream<Food>> getTrendingFoodsOfRestaurant(String restaurantId) async {
  Uri uri = Helper.getUri('api/foods');
  uri = uri.replace(queryParameters: {
    'with': 'restaurant',
    'search': 'restaurant_id:$restaurantId;featured:1',
    'searchFields': 'restaurant_id:=;featured:=',
  });
  // TODO Trending foods only
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Food.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Food.fromJSON({}));
  }
}

Future<Stream<Food>> getFeaturedFoodsOfRestaurant(String restaurantId) async {
  Uri uri = Helper.getUri('api/foods');
  uri = uri.replace(queryParameters: {
    'with': 'restaurant',
    'search': 'restaurant_id:$restaurantId;featured:1',
    'searchFields': 'restaurant_id:=;featured:=',
    'searchJoin': 'and',
  });
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Food.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Food.fromJSON({}));
  }
}

Future<Review> addFoodReview(Review review, Food food) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}food_reviews';
  final client = new http.Client();
  review.user = userRepo.currentUser.value;
  try {
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(review.ofFoodToMap(food)),
    );
    if (response.statusCode == 200) {
      return Review.fromJSON(json.decode(response.body)['data']);
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      return Review.fromJSON({});
    }
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return Review.fromJSON({});
  }
}
