import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';

import '../helpers/helper.dart';
import '../models/faq.dart';

class FaqItemWidget extends StatelessWidget {
  final Faq faq;
  FaqItemWidget({Key key, this.faq}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ConfigurableExpansionTile(
            header: Container(
              width: MediaQuery.of(context).size.width - 50,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 100,
                    child: AutoSizeText(
                      Helper.skipHtml(this.faq.question),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .merge(TextStyle(color: Theme.of(context).hintColor)),
                      maxLines: 3,
                    ),
                  ),
                  Icon(
                    Icons.add,
                    color: Theme.of(context).accentColor,
                  ),
                ],
              ),
            ),
            headerExpanded: Container(
              width: MediaQuery.of(context).size.width - 50,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 100,
                    child: AutoSizeText(
                      Helper.skipHtml(this.faq.question),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .merge(TextStyle(color: Theme.of(context).hintColor)),
                      maxLines: 3,
                    ),
                  ),
                  Icon(
                    Icons.remove,
                    color: Theme.of(context).dividerColor,
                  ),
                ],
              ),
            ),
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width - 50,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(5),
                        bottomLeft: Radius.circular(5))),
                child: AutoSizeText(
                  Helper.skipHtml(this.faq.answer),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .merge(TextStyle(color: Theme.of(context).hintColor)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
