import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../Bloc/OrderTypeProvider.dart';
import 'package:provider/provider.dart';
import '../Bloc/store_pick_up.dart';

class OrderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final OrderTypeGenerator orderTypeGenerator = Provider.of<OrderTypeGenerator>(context);
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: <Widget>[
             AutoSizeText(orderTypeGenerator.OType.toString()),
             StorePickUpType(),
           ],
          ),
        ),
      ),
    );
  }
}
