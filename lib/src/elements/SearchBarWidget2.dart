import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../elements/SearchWidget.dart';

class SearchBarWidget2 extends StatelessWidget {
  final ValueChanged onClickFilter;

  const SearchBarWidget2({Key key, this.onClickFilter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(SearchModal());
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Theme.of(context).focusColor.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12, left: 0),
              child: Icon(Icons.search, color: Theme.of(context).hintColor),
            ),
            Expanded(
              child: AutoSizeText(
                "Search",//S.of(context).search_for_restaurants_or_foods,
                maxLines: 1,
                style: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
