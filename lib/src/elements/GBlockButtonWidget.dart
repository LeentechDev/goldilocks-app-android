import 'package:flutter/material.dart';

class GBlockButtonWidget extends StatelessWidget {
  const GBlockButtonWidget({Key key, @required this.color, @required this.row, @required this.onPressed})
      : super(key: key);

  final Color color;
  final Row row;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/ 14,
      width: MediaQuery.of(context).size.width/ 1.3,
      decoration: BoxDecoration(
       
        boxShadow: [
          BoxShadow(color: Theme.of(context).dividerColor.withOpacity(0.2), blurRadius: 15, offset: Offset(0, 15)),
          BoxShadow(color: Theme.of(context).dividerColor.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 3))
        ],
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      child: FlatButton(
        onPressed: this.onPressed,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: this.color,
        shape: StadiumBorder(),
        child: this.row,
      ),
    );
  }
}
