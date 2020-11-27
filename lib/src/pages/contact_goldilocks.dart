import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/settings_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/PaymentSettingsDialog.dart';
import '../elements/ProfileSettingsDialog.dart';
import '../elements/SearchBarWidget.dart';
import '../helpers/helper.dart';
import '../repository/user_repository.dart';

class ContactGoldilocksWidget extends StatefulWidget {
  @override
  _ContactGoldilocksWidgetState createState() =>
      _ContactGoldilocksWidgetState();
}

class _ContactGoldilocksWidgetState extends StateMVC<ContactGoldilocksWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: AutoSizeText(
            S.of(context).contact_details,
            style: Theme.of(context).textTheme.headline4.merge(
                  TextStyle(
                      color: Theme.of(context).hintColor),
                ),
          ),
        ),
        body: Center(
          child: Column(children: <Widget>[
            SizedBox(
              height: 70,
            ),
            Image.asset(
              'assets/custom_img/goldilocks_logo_yellow.png',
              width: 250,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 50,
            ),
            ListView(shrinkWrap: true, primary: false, children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).hintColor.withOpacity(0.15),
                        offset: Offset(0, 3),
                        blurRadius: 10)
                  ],
                ),
                child: ListTile(
                  title: AutoSizeText(
                    S.of(context).email,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  subtitle: AutoSizeText(
                    "goldilocks@gmail.com", //S.of(context).email,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .merge(TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.w300)),
                  ),
                  trailing: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        boxShadow: [
          BoxShadow(color: Theme.of(context).accentColor.withOpacity(0.2), blurRadius: 15, offset: Offset(0, 15)),
          BoxShadow(color: Theme.of(context).accentColor.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 3))
        ],
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30))),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        "assets/custom_img/mail_icon.svg",
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).hintColor.withOpacity(0.15),
                        offset: Offset(0, 3),
                        blurRadius: 10)
                  ],
                ),
                child: ListTile(
                  title: AutoSizeText(
                    S.of(context).phone,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  subtitle: AutoSizeText(
                    "310 - 341 - 3706", //S.of(context).email,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .merge(TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.w300)),
                  ),
                  trailing: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      boxShadow: [
          BoxShadow(color: Theme.of(context).accentColor.withOpacity(0.2), blurRadius: 15, offset: Offset(0, 15)),
          BoxShadow(color: Theme.of(context).accentColor.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 3))
        ],
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30))),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        "assets/custom_img/localphone_icon.svg",
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).hintColor.withOpacity(0.15),
                        offset: Offset(0, 3),
                        blurRadius: 10)
                  ],
                ),
                child: Container(
                  height: 80,
                  width: 50,
                  child: Center(
                    child: ListTile(
                      title: AutoSizeText(
                        S.of(context).address,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      subtitle: AutoSizeText(
                        "3133 Doctors Drive, Los Angeles, California, 90017",
                        style: Theme.of(context).textTheme.subtitle2.merge(
                            TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.w300)),
                      ),
                      trailing: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          boxShadow: [
          BoxShadow(color: Theme.of(context).accentColor.withOpacity(0.2), blurRadius: 15, offset: Offset(0, 15)),
          BoxShadow(color: Theme.of(context).accentColor.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 3))
        ],
                            color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30))),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            "assets/custom_img/leftarrow_icon.svg",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ]),
        ));
  }
}
