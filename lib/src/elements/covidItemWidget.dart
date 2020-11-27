import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:food_delivery_app/src/elements/BlockButtonWidget.dart';
import 'package:html/dom.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/helper.dart';
import '../models/covid.dart';

class CovidItemWidget extends StatelessWidget {
  final Covid19 covid19;
  CovidItemWidget({Key key, this.covid19}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          AutoSizeText(
            Helper.skipHtml(this.covid19.covid),
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .merge(TextStyle(color: Theme.of(context).hintColor)),
          ),
          SizedBox(height: 30,),

          BlockButtonWidget(
            onPressed: () async {
              final url = 'https://www.goldilocks-usa.com/wp-content/themes/goldilocksusa/covid-docs/COVID19_Memo_Fnl.pdf';
              if (await canLaunch(url)){
                await launch(url, forceWebView: false);
              }
            },
            text: AutoSizeText('Covid19 Memo', style: Theme.of(context).textTheme.subtitle1,),
            color: Theme.of(context).accentColor,
          ),

          SizedBox(height: 20,),

          BlockButtonWidget(
            onPressed: () async {
              final url = 'https://www.goldilocks-usa.com/wp-content/themes/goldilocksusa/covid-docs/GOLDILOCKS_USA_Notice_of_Mandatory_Social_Distancing_Protocols.docx';
              if (await canLaunch(url)){
                await launch(url, forceWebView: false);
              }
            },
            text: AutoSizeText('Notice Mandatory Social Distancing Protocols', style: Theme.of(context).textTheme.subtitle1, textAlign: TextAlign.center,),
            color: Theme.of(context).accentColor,
          )

        ],
      ),
    );
  }
}
