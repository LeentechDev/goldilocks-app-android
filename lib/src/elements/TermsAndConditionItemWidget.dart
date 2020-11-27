import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';

import '../helpers/helper.dart';
import '../models/terms_and_condition.dart';
import '../../generated/l10n.dart';

class TermsAndConditionItemWidget extends StatelessWidget {
  final TermsAndCondition termsAndCondition;
  TermsAndConditionItemWidget({Key key, this.termsAndCondition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          // AutoSizeText(
          //   S.of(context).goldilocksdelivery,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold, fontSize: 20))
          // ),
          // AutoSizeText(''),
          // AutoSizeText(
          //   S.of(context).theseterms,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),
          // AutoSizeText(''),
          // AutoSizeText(
          //   S.of(context).allminimum,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),
          // AutoSizeText(''),
          // AutoSizeText(
          //   S.of(context).pricesandinformation,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),
          // AutoSizeText(''),
          // AutoSizeText(
          //   S.of(context).generalanduse,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).whenyouchoose,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),
          // AutoSizeText(''),
          // AutoSizeText(
          //   S.of(context).accountmaintenance,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).whenyouuse,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),
          // AutoSizeText(''),
          // AutoSizeText(
          //   S.of(context).publishedweb,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).theaccuracy,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),
          // AutoSizeText(''),
          // AutoSizeText(
          //   S.of(context).useofcookies,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).ourwebsite,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),
          // AutoSizeText(''),
          // AutoSizeText(
          //   S.of(context).securityterms,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).wehaveendeavored,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),
          // AutoSizeText(''),
          // AutoSizeText(
          //   S.of(context).linksterms,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).thissite,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),
          // AutoSizeText(''),
          // AutoSizeText(
          //   S.of(context).copyrightterms,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).unlessotherwise,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),
          // AutoSizeText(''),
          // AutoSizeText(
          //   S.of(context).trademarkterms,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).alltrademarks,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),
          // AutoSizeText(''),
          // AutoSizeText(
          //   S.of(context).limitations,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).youruseofsite,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),
          // AutoSizeText(''),
          // AutoSizeText(
          //   S.of(context).disclaimer,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).youassume,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),
          // AutoSizeText(''),
          // AutoSizeText(''),
          // AutoSizeText(
          //   S.of(context).choiceoflaw,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).thelawsofthe,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),
          // AutoSizeText(''),
          // AutoSizeText(
          //   S.of(context).indemnification,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).youshallindemnify,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),
          // AutoSizeText(''),
          // AutoSizeText(
          //   S.of(context).orderacceptance,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).thereceipt,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),
          // AutoSizeText(''),
          // AutoSizeText(
          //   S.of(context).orderavailability,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).productsandservices,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),
          // AutoSizeText(''),
          // AutoSizeText(
          //   S.of(context).qualityofdelivered,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).productspurchased,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),
          // AutoSizeText(''),
          // AutoSizeText(
          //   S.of(context).pricingterms,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).theproductprice,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),
          // AutoSizeText(''),
          // AutoSizeText(
          //   S.of(context).pricingerror,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).informationatthe,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),
          // AutoSizeText(''),
          // AutoSizeText(
          //   S.of(context).entireagreement,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          //  AutoSizeText(
          //   S.of(context).thesetermsandother,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),

          AutoSizeText(
            Helper.skipHtml(this.termsAndCondition.termsandcondition),
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .merge(TextStyle(color: Theme.of(context).hintColor)),
          ),

        ],
      ),
    );
  }
}
