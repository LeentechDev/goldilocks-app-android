import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Bloc/OrderTypeProvider.dart';

class StorePickUpType extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final OrderTypeGenerator orderTypeGenerator = Provider.of<OrderTypeGenerator>(context);
    return new FlatButton(onPressed: () {
      orderTypeGenerator.setOrderTypeValue(1);
    }, child: AutoSizeText('Store pick up'));
  }
}
