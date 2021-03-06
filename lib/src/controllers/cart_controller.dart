import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:collection/collection.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/cart.dart';
import '../repository/cart_repository.dart';
import '../repository/user_repository.dart';

class CartController extends ControllerMVC {
  List<Cart> carts = <Cart>[];
  double taxAmount = 0.0;
  double deliveryFee = 0.0;
  int cartCount = 0;
  double subTotal = 0.0;
  double total = 0.0;
  double subTotalPerstore = 0.0;
  GlobalKey<ScaffoldState> scaffoldKey;

  CartController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForCarts({String message}) async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      if (!carts.contains(_cart)) {
        setState(() {
          carts.add(_cart);
        });
      }
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: AutoSizeText(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (carts.isNotEmpty) {
        calculateSubtotal();
      }
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: AutoSizeText(message),
        ));
      }
      onLoadingCartDone();
    });
  }



  void onLoadingCartDone() {}

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

  Future<void> refreshCarts() async {
    setState(() {
      carts = [];
    });
    listenForCarts(message: S.of(context).carts_refreshed_successfuly);
  }

  void removeFromCart(Cart _cart) async {
    setState(() {
      this.carts.remove(_cart);
    });
    removeCart(_cart).then((value) {
      calculateSubtotal();
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: AutoSizeText(S.of(context).the_food_was_removed_from_your_cart(_cart.food.name)),
      ));
    });
  }

  void calculateSubtotal() async {
    subTotal = 0;
    carts.forEach((cart) {
      subTotal += (cart.food.price * cart.quantity);
      // cart.extras.forEach((element) {
      //   subTotal += element.price;
      // });
      // subTotal *= cart.quantity;
    });
    if (Helper.canDelivery(carts[0].food.restaurant, carts: carts)) {
      deliveryFee = carts[0].food.restaurant.deliveryFee;
    }
    //taxAmount = (subTotal + deliveryFee) * carts[0].food.restaurant.defaultTax / 100;
    total = subTotal; //+ taxAmount + deliveryFee;
    setState(() {});
  }


  void calculateSubtotal2() async {
    
    subTotal = 0;
    carts.forEach((cart) {
      var group = groupBy(carts, (obj) => obj.food.restaurant.name);
      subTotal += (cart.food.price * cart.quantity);
      group.forEach((key, value) {
        print('food ' + group[key].toString());
      });
      // cart.extras.forEach((element) {
      //   subTotal += element.price;
      // });
      // subTotal *= cart.quantity;
    });
    if (Helper.canDelivery(carts[0].food.restaurant, carts: carts)) {
      deliveryFee = carts[0].food.restaurant.deliveryFee;
    }
    //taxAmount = (subTotal + deliveryFee) * carts[0].food.restaurant.defaultTax / 100;
    total = subTotal; //+ taxAmount + deliveryFee;
    setState(() {});
  }


  incrementQuantity(Cart cart) {
    if (cart.quantity <= 99) {
      ++cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }

  decrementQuantity(Cart cart) {
    if (cart.quantity > 1) {
      --cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }

  void goCheckout(BuildContext context) {
    if (!currentUser.value.profileCompleted()) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: AutoSizeText(S.of(context).completeYourProfileDetailsToContinue),
        action: SnackBarAction(
          label: S.of(context).settings,
          textColor: Theme.of(context).accentColor,
          onPressed: () {
            Navigator.of(context).pushNamed('/Settings');
          },
        ),
      ));
    } else {
      if (carts[0].food.restaurant.closed) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: AutoSizeText(S.of(context).this_store_is_closed_),
        ));
      } else {
        Navigator.of(context).pushNamed('/DeliveryPickup');
      }
    }
  }
}
