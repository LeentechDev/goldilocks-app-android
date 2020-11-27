import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter_svg/flutter_svg.dart';

import '../helpers/helper.dart';
import '../models/notification.dart' as model;

class NotificationItemWidget extends StatelessWidget {
  final model.Notification notification;

  NotificationItemWidget({Key key, this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // String newYData = notification.data.replaceRange(13, notification.data.length, '');
    
    // String newYData = newXData.replaceRange(2, newXData.length, '');
    var newData = notification.data.lastIndexOf(',');
    var newXData = (newData != -1) ? notification.data.substring(0, newData) : notification.data;
    String newZData = newXData.replaceAll(new RegExp(r'[^\w\s]+'), '');
    String newYData = newZData.replaceAll(new RegExp('order_id'), '');

    String description;

    if (notification.status == "Preparing (SP)" ||
        notification.status == "Preparing (MO)") {
      description = "is now Preparing.";
    } else if (notification.status == "Ready to Pickup (SP)") {
      description = "is ready for pickup";
    } else if (notification.status == "Completed (SP)") {
      description = "is completed, Enjoy!";
    } else if (notification.status == "On the Way (MO)") {
      description = "is out for Delivery";
    } else if (notification.status == "Delivered (MO)") {
      description = "has been delivered, Enjoy!";
    } else if (notification.status == "Declined (SP)" ||
        notification.status == "Declined (MO)") {
      description = "has been declined";
    } else if (notification.status == "Processing Payment Return (MO)" ||
        notification.status == "Processing Payment Return (SP)") {
      description = "payment is processing for return.";
    } else if (notification.status == "Payment Returned (SP)" ||
        notification.status == "Payment Returned (MO)") {
      description = "payment has been returned.";
    } else {
      description = "has been received";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFDCDCDC).withOpacity(0.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SvgPicture.asset(
                  'assets/custom_img/notif_icon.svg',
                  width: 5,
                ),
              ),
            ),
            //Positioned(
            //  right: -30,
            //  bottom: -50,
            //  child: Container(
            //    width: 100,
            //    height: 100,
            //    decoration: BoxDecoration(
            //      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
            //      borderRadius: BorderRadius.circular(150),
            //    ),
            //  ),
            //),
            //Positioned(
            //  left: -20,
            //  top: -50,
            //  child: Container(
            //    width: 120,
            //    height: 120,
            //    decoration: BoxDecoration(
            //      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
            //      borderRadius: BorderRadius.circular(150),
            //    ),
            //  ),
            //)
          ],
        ),
        SizedBox(width: 15),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                child: RichText(
                  text: TextSpan(
                    text: 'Your ',
                    style: Theme.of(context).textTheme.subtitle1,
                    children: <TextSpan>[
                      TextSpan(text: 'Order ID #${newYData} ', style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).accentColor))),
                      TextSpan(text: description, style: Theme.of(context).textTheme.subtitle1),
                    ],
                  ),
                ),
              ),

              AutoSizeText(
                DateFormat('yyyy-MM-dd | HH:mm').format(notification.createdAt),
                style: Theme.of(context).textTheme.caption,
              )
            ],
          ),
        )
      ],
    );
  }
}
