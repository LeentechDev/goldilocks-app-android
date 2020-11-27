import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';

import '../helpers/helper.dart';
import '../models/privacy_policy.dart';
import '../../generated/l10n.dart';

class PrivacyPolicyItemWidget extends StatelessWidget {
  final PrivacyPolicy privacyPolicy;
  PrivacyPolicyItemWidget({Key key, this.privacyPolicy}) : super(key: key);

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
          //   S.of(context).privacy_policy,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).thankyouforvisiting,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),

          // AutoSizeText(""),

          // AutoSizeText(
          //   S.of(context).typeofinformation,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).wemaycollect,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),

          // AutoSizeText(""),

          // AutoSizeText(
          //   S.of(context).informationwecollect,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).wecollectinformation,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),

          // AutoSizeText(""),

          // AutoSizeText(
          //   S.of(context).whywecollect,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).weusetheinformation,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),

          // AutoSizeText(""),

          // AutoSizeText(
          //   S.of(context).howweshare,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).somepages,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),

          // AutoSizeText(""),

          // AutoSizeText(
          //   S.of(context).trackingtool,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).cookiesaresmall,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),

          // AutoSizeText(""),

          // AutoSizeText(
          //   S.of(context).donottrack,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).thewebsite,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),

          // AutoSizeText(""),

          // AutoSizeText(
          //   S.of(context).howtoopt,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).inorderto,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),

          // AutoSizeText(""),

          // AutoSizeText(
          //   S.of(context).childrenprivacy,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).withyourchildren,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),

          // AutoSizeText(""),

          // AutoSizeText(
          //   S.of(context).adapolicy,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).incompliance,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),

          // AutoSizeText(""),

          // AutoSizeText(
          //   S.of(context).security,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).pleasenote,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),

          // AutoSizeText(""),

          // AutoSizeText(
          //   S.of(context).refundpolicy,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold))
          // ),
          // AutoSizeText(
          //   S.of(context).wearecommited,
          //   style: Theme.of(context).textTheme.bodyText2.merge(
          //     TextStyle(color: Theme.of(context).hintColor))
          // ),




          AutoSizeText(
            Helper.skipHtml(this.privacyPolicy.titlename),
            strutStyle: StrutStyle.disabled,
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

/*
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
                      Helper.skipHtml(this.privacyPolicy.titlename),
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
                      Helper.skipHtml(this.privacyPolicy.titlename),
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
                  Helper.skipHtml(this.privacyPolicy.name),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .merge(TextStyle(color: Theme.of(context).hintColor)),
                ),
              ),
            ],
          ),
 */
