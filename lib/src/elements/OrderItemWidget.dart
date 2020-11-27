import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:collection/collection.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/order.dart';
import '../models/route_argument.dart';
import 'FoodOrderItemWidget.dart';
import '../elements/BlockButtonWidget.dart';
import '../elements/CancelBlockButtonWidget.dart';

class OrderItemWidget extends StatefulWidget {
  final bool expanded;
  final Order order;
  final ValueChanged<void> onCanceled;

  OrderItemWidget({Key key, this.expanded, this.order, this.onCanceled})
      : super(key: key);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  final String paypal = 'Paypal';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

    return Stack(
      children: <Widget>[
        Opacity(
          opacity: widget.order.active ? 1 : 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 14),
                padding: EdgeInsets.only(top: 20, bottom: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).hintColor.withOpacity(0.1),
                        blurRadius: 5,
                        offset: Offset(0, 2)),
                  ],
                ),
                child: Theme(
                  data: theme,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 28,
                          width: 140,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: widget.order.orderStatus.status ==
                                          'Delivered (MO)' ||
                                      widget.order.orderStatus.status ==
                                          'Delivered (SP)' ||
                                      widget.order.orderStatus.status ==
                                          'Completed (MO)' ||
                                      widget.order.orderStatus.status ==
                                          'Completed (SP)'
                                  ? Colors.green
                                  : widget.order.orderStatus.status ==
                                              'Declined (MO)' ||
                                          widget.order.orderStatus.status ==
                                              'Declined (SP)' ||
                                          widget.order.orderStatus.status ==
                                              'Canceled (MO)' ||
                                          widget.order.orderStatus.status ==
                                              'Declined (SP)'
                                      ? Colors.red
                                      : widget.order.active
                                          ? Theme.of(context).accentColor
                                          : Colors.red,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ), //color: widget.order.active ? Theme.of(context).accentColor : Colors.redAccent),
                          alignment: AlignmentDirectional.center,
                          child: AutoSizeText(
                            widget.order.active
                                ? '${widget.order.orderStatus.status}'
                                : S.of(context).canceled,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .merge(TextStyle(
                                  height: 1,
                                  color: widget.order.orderStatus.status ==
                                              'Delivered (MO)' ||
                                          widget.order.orderStatus.status ==
                                              'Delivered (SP)' ||
                                          widget.order.orderStatus.status ==
                                              'Completed (MO)' ||
                                          widget.order.orderStatus.status ==
                                              'Completed (SP)'
                                      ? Colors.green
                                      : widget.order.orderStatus.status ==
                                                  'Declined (MO)' ||
                                              widget.order.orderStatus.status ==
                                                  'Declined (SP)' ||
                                              widget.order.orderStatus.status ==
                                                  'Canceled (MO)' ||
                                              widget.order.orderStatus.status ==
                                                  'Declined (SP)'
                                          ? Colors.red
                                          : widget.order.active
                                              ? Theme.of(context).accentColor
                                              : Colors.red,
                                )),
                          ),
                        ),
                      ),
                      ExpansionTile(
                        initiallyExpanded: widget.expanded,
                        title: Column(
                          children: <Widget>[
                            AutoSizeText(
                              '${S.of(context).order_ID}: #${widget.order.id}',
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            AutoSizeText(
                              DateFormat('dd-MM-yyyy | HH:mm')
                                  .format(widget.order.dateTime),
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        trailing: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Helper.getPrice(
                                  Helper.getTotalOrdersPrice(widget.order),
                                  context,
                                  style: Theme.of(context).textTheme.headline4),
                              AutoSizeText(
                                'Paid via ${widget.order.payment.method}',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: Theme.of(context).textTheme.caption,
                              )
                            ],
                          ),
                        ),
                        children: <Widget>[
                          Column(
                              children: List.generate(
                            widget.order.foodOrders.length,
                            (indexFood) {
                              return FoodOrderItemWidget(
                                  heroTag: 'mywidget.orders',
                                  order: widget.order,
                                  foodOrder: widget.order.foodOrders
                                      .elementAt(indexFood));
                            },
                          )),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Column(
                              children: <Widget>[
                                // Row(
                                //   children: <Widget>[
                                //     Expanded(
                                //       child: AutoSizeText(
                                //         S.of(context).delivery_fee,
                                //         style: Theme.of(context)
                                //             .textTheme
                                //             .bodyText1,
                                //       ),
                                //     ),
                                //     Helper.getPrice(
                                //         widget.order.deliveryFee, context,
                                //         style: Theme.of(context)
                                //             .textTheme
                                //             .subtitle1)
                                //   ],
                                // ),
                                // Row(
                                //   children: <Widget>[
                                //     Expanded(
                                //       child: AutoSizeText(
                                //         '${S.of(context).tax} (${widget.order.tax}%)',
                                //         style: Theme.of(context)
                                //             .textTheme
                                //             .bodyText1,
                                //       ),
                                //     ),
                                //     Helper.getPrice(
                                //         Helper.getTaxOrder(widget.order),
                                //         context,
                                //         style: Theme.of(context)
                                //             .textTheme
                                //             .subtitle1)
                                //   ],
                                // ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: AutoSizeText(
                                        S.of(context).total,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                    Helper.getPrice(
                                        Helper.getTotalOrdersPrice(
                                            widget.order),
                                        context,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4)
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    if (widget.order.canCancelOrder())
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CancelBlockButtonWidget(
                          color: Colors.red.withOpacity(0.05),
                          text: Text(
                            "Cancel Order",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: MaterialLocalizations.of(context)
                                    .modalBarrierDismissLabel,
                                barrierColor: Colors.black45,
                                transitionDuration:
                                    const Duration(milliseconds: 200),
                                pageBuilder: (BuildContext buildContext,
                                    Animation animation,
                                    Animation secondaryAnimation) {
                                  return SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 100),
                                      child: Center(
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              60,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              300,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white,
                                          ),
                                          padding: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              bottom: 20,
                                              top: 50),
                                          child: Material(
                                            color: Colors.white,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/custom_img/confirmation_icon.svg',
                                                    width: 80,
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  AutoSizeText(
                                                    S.of(context).are_you_sure,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  "${widget.order.payment.method}" ==
                                                          'PayPal'
                                                      ? AutoSizeText(
                                                          S
                                                              .of(context)
                                                              .the_default_refund,
                                                          textAlign:
                                                              TextAlign.justify,
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .hintColor
                                                                .withOpacity(
                                                                    0.5),
                                                            fontSize: 14,
                                                          ))
                                                      : AutoSizeText(
                                                          S
                                                              .of(context)
                                                              .there_are_no_fees,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .hintColor
                                                                .withOpacity(
                                                                    0.5),
                                                            fontSize: 14,
                                                          )),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  FlatButton(
                                                    onPressed: () {
                                                      widget.onCanceled(
                                                          widget.order);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 14,
                                                            horizontal: 100),
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    shape: StadiumBorder(),
                                                    child: AutoSizeText(
                                                      S.of(context).yes_im_sure,
                                                      maxLines: 1,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .hintColor),
                                                    ),
                                                  ),
                                                  FlatButton(
                                                    child: new AutoSizeText(
                                                      S.of(context).cancel,
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                            //showGeneralDialog(
                            //    context: context,
                            //    barrierDismissible: true,
                            //    barrierLabel: MaterialLocalizations.of(context)
                            //        .modalBarrierDismissLabel,
                            //    barrierColor: Colors.black45,
                            //    transitionDuration:
                            //        const Duration(milliseconds: 200),
                            //    pageBuilder: (BuildContext buildContext,
                            //        Animation animation,
                            //        Animation secondaryAnimation) {
                            //      return Center(
                            //        child: Container(
                            //          width: MediaQuery.of(context).size.width -
                            //              60,
                            //          height:
                            //              MediaQuery.of(context).size.height -
                            //                  450,
                            //          decoration: BoxDecoration(
                            //            borderRadius: BorderRadius.circular(20),
                            //            color: Colors.white,
                            //          ),
                            //          padding: EdgeInsets.all(20),
                            //          child: Material(
                            //            color: Colors.white,
                            //            child: Column(
                            //              mainAxisAlignment:
                            //                  MainAxisAlignment.start,
                            //              crossAxisAlignment:
                            //                  CrossAxisAlignment.center,
                            //              children: [
                            //                SvgPicture.asset(
                            //                  'assets/custom_img/confirmation_icon.svg',
                            //                  width: 80,
                            //                ),
                            //                SizedBox(
                            //                  height: 15,
                            //                ),
                            //                AutoSizeText(
                            //                  S.of(context).are_you_sure,
                            //                  textAlign: TextAlign.center,
                            //                  style: TextStyle(
                            //                    color: Colors.black,
                            //                    fontSize: 20,
                            //                    fontWeight: FontWeight.bold,
                            //                    fontFamily: 'Poppins',
                            //                  ),
                            //                ),
                            //                SizedBox(
                            //                  height: 10,
                            //                ),
                            //                AutoSizeText(
                            //                    S
                            //                        .of(context)
                            //                        .areYouSureYouWantToCancelThisOrder,
                            //                    textAlign: TextAlign.center,
                            //                    style: TextStyle(
                            //                      color: Theme.of(context)
                            //                          .hintColor
                            //                          .withOpacity(0.5),
                            //                      fontSize: 20,
                            //                    )),
                            //                SizedBox(
                            //                  height: 20,
                            //                ),
                            //                FlatButton(
                            //                  onPressed: () {
                            //                    widget.onCanceled(widget.order);
                            //                    Navigator.of(context).pop();
                            //                  },
                            //                  padding: EdgeInsets.symmetric(
                            //                      vertical: 14, horizontal: 100),
                            //                  color:
                            //                      Theme.of(context).accentColor,
                            //                  shape: StadiumBorder(),
                            //                  child: AutoSizeText(
                            //                    S.of(context).yes_im_sure,
                            //                    textAlign: TextAlign.start,
                            //                    style: TextStyle(
                            //                        color: Theme.of(context)
                            //                            .hintColor),
                            //                  ),
                            //                ),
                            //                FlatButton(
                            //                  child: new AutoSizeText(
                            //                    S.of(context).cancel,
                            //                    style: TextStyle(
                            //                        color: Colors.grey),
                            //                  ),
                            //                  onPressed: () {
                            //                    Navigator.of(context).pop();
                            //                  },
                            //                ),
                            //              ],
                            //            ),
                            //          ),
                            //        ),
                            //      );
                            //    });
                          },
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: BlockButtonWidget(
                        text: AutoSizeText(
                          "View Details",
                          style: TextStyle(
                              color: Colors
                                  .black), //Theme.of(context).primaryColor),
                        ),
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          Navigator.of(context).pushNamed('/Tracking',
                              arguments: RouteArgument(id: widget.order.id));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
