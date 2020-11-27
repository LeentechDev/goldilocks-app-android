import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/Bloc/auth.dart';
import 'package:food_delivery_app/src/models/media.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../controllers/settings_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/PaymentSettingsDialog.dart';
import '../elements/ProfileSettingsDialog.dart';
import '../elements/ChangePasswordDialog.dart';
import '../elements/SearchBarWidget.dart';
import '../helpers/helper.dart';
import '../Bloc/shared_pref.dart';
import '../repository/user_repository.dart';
import '../repository/settings_repository.dart' as settingsRepo;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../Bloc/Providers.dart';

class SettingsWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  SettingsWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends StateMVC<SettingsWidget> {
  SettingsController _con;

  final SharedPrefs prefs = SharedPrefs();
  bool _LoginType;

  _SettingsWidgetState() : super(SettingsController()) {
    _con = controller;
  }

  Future<bool>getLoginType() async {
    bool LoginType = await prefs.getIntLoginType();
    setState(() {
      _LoginType = LoginType;
    });
    print(LoginType);
    return LoginType;
  }

  @override
  void initState() {
    getLoginType(); 

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    print("asdasddas" + currentUser.value.toString());
    var name = currentUser.value.name;
    var trimedleft = name.lastIndexOf(' ');
    var firstletter = ('${name[0]}');
    var resultleft = (trimedleft != -1) ? name.substring(0, trimedleft) : name;
    var trimedright = name.lastIndexOf(' ');
    var resultright = (trimedright != -1) ? name.substring(trimedright) : name;
    var lastletter = ('${resultright[1]}');
    return currentUser.value == null ? 
    CircularLoadingWidget(height: 50) :
    Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        //centerTitle: true,

        title: AutoSizeText(
          S.of(context).account,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      body: currentUser.value.id == null
          ? CircularLoadingWidget(height: 500)
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 7),
              child: Column(
                children: <Widget>[
                  //Padding(
                  //  padding: const EdgeInsets.symmetric(horizontal: 20),
                  //  child: SearchBarWidget(),
                  //),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              AutoSizeText(
                                currentUser.value.name,
                                textAlign: TextAlign.left,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .merge(TextStyle(fontSize: 25)),
                              ),
                              AutoSizeText(
                                currentUser.value.email,
                                style:
                                    Theme.of(context).textTheme.caption.merge(
                                          TextStyle(color: Colors.black),
                                        ),
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                        SizedBox(
                            width: 55,
                            height: 55,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(300),
                              onTap: () {
                                //Navigator.of(context).pushNamed('/Profile');
                              },
                              child: currentUser.value.image.thumb == 'https://goldilocks.ml/images/image_default.png'
                                  ? CircleAvatar(
                                    backgroundColor: Theme.of(context).accentColor.withOpacity(0.3),
                                      child: AutoSizeText(firstletter + lastletter,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF997F13),
                                      ),),
                                    )
                                  : 
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                          currentUser.value.image.thumb),
                            )),
                         ) ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      //borderRadius: BorderRadius.circular(6),
                      //boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      primary: false,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      children: <Widget>[
                        ListTile(
                          leading: Opacity (
                            opacity: 0.7,
                            child: Icon(Icons.person, color: Theme.of(context).dividerColor)),
                          title: AutoSizeText(
                            S.of(context).profile_settings,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          trailing: ButtonTheme(
                            padding: EdgeInsets.all(0),
                            minWidth: 50.0,
                            height: 25.0,
                            child: ProfileSettingsDialog(
                              user: currentUser.value == null ? '' : currentUser.value,
                              onChanged: () {
                                _con.update(currentUser.value);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 15),
                          child: Container(
                            height: 0.5,
                            color: Colors.grey.withOpacity(0.8),
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          dense: true,
                          title: AutoSizeText(
                            S.of(context).first_name,
                            style: Theme.of(context).textTheme.bodyText2.merge(
                                TextStyle(color: Theme.of(context).hintColor)),
                          ),
                          trailing: AutoSizeText(
                            currentUser.value.name != null ? resultleft : "",
                            style: TextStyle(
                                color: Theme.of(context).hintColor.withOpacity(0.7)),
                          ),
                        ),

                        ListTile(
                          onTap: () {},
                          dense: true,
                          title: AutoSizeText(
                            S.of(context).last_name,
                            style: Theme.of(context).textTheme.bodyText2.merge(
                                TextStyle(color: Theme.of(context).hintColor)),
                          ),
                          trailing: AutoSizeText(
                            currentUser.value.name != null ? resultright : "",
                            style: TextStyle(
                                color: Theme.of(context).hintColor.withOpacity(0.7)),
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          dense: true,
                          title: AutoSizeText(
                            S.of(context).phone_number,
                            style: Theme.of(context).textTheme.bodyText2.merge(
                                TextStyle(color: Theme.of(context).hintColor)),
                          ),
                          trailing: AutoSizeText(
                            currentUser.value.phone != null
                                ? currentUser.value.phone
                                : "",
                            style: TextStyle(
                                color: Theme.of(context).hintColor.withOpacity(0.7)),
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          dense: true,
                          title: AutoSizeText(
                            S.of(context).email,
                            style: Theme.of(context).textTheme.bodyText2.merge(
                                TextStyle(color: Theme.of(context).hintColor)),
                          ),
                          trailing: AutoSizeText(
                            currentUser.value.email != null
                                ? currentUser.value.email
                                : "",
                            style: TextStyle(
                                color: Theme.of(context).hintColor.withOpacity(0.7)),
                          ),
                        ),

                        ListTile(
                          onTap: () {},
                          dense: true,
                          title: AutoSizeText(
                            S.of(context).address,
                            overflow: TextOverflow.visible,
                            style: Theme.of(context).textTheme.bodyText2.merge(
                                TextStyle(color: Theme.of(context).hintColor)),
                          ),
                          trailing: Container(
                            width: MediaQuery.of(context).size.width - 200,
                            child: AutoSizeText( 
                              settingsRepo.deliveryAddress.value.address != null ? settingsRepo.deliveryAddress.value?.address : "",
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: TextStyle(
                                  color: Theme.of(context).hintColor.withOpacity(0.7)),
                            ),
                          ),
                        ),
                        //ListTile(
                        //  onTap: () {},
                        //  dense: true,
                        //  title: AutoSizeText(
                        //    S.of(context).about,
                        //    style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Theme.of(context).hintColor,
                        //  ),
                        //  trailing: AutoSizeText(
                        //    Helper.limitString(currentUser.value.bio),
                        //    overflow: TextOverflow.fade,
                        //    softWrap: false,
                        //    style:
                        //        TextStyle(color: Theme.of(context).dividerColor),
                        //  ),
                        //),
                      ],
                    ),
                  ),

                  _LoginType == true ? SizedBox() :
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    margin: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      //borderRadius: BorderRadius.circular(6),
                      //boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      primary: false,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      children: <Widget>[
                        ListTile(
                          leading: Opacity(
                            opacity: 0.7,
                            child: Icon(Icons.vpn_key)),
                          title: AutoSizeText(
                            S.of(context).change_password,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          trailing: ButtonTheme(
                            padding: EdgeInsets.all(0),
                            minWidth: 50.0,
                            height: 25.0,
                            child: ChangePasswordDialog(
                              user: currentUser.value,
                              onChanged: () {
                                _con.changepassword(currentUser.value);
//                                  setState(() {});
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 15),
                          child: Container(
                            height: 0.5,
                            color: Colors.grey.withOpacity(0.8),
                          ),
                        ),
                        ListTile(
                          dense: true,
                          title: AutoSizeText(
                            S.of(context).its_a_good_idea_too_use_its,
                            style: Theme.of(context).textTheme.bodyText2.merge(
                                TextStyle(color: Theme.of(context).hintColor)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      //borderRadius: BorderRadius.circular(6),
                      //boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      primary: false,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      children: <Widget>[
                        ListTile(
                          leading: SvgPicture.asset(
                            "assets/custom_img/credit_card_icon.svg",
                          ),
                          title: AutoSizeText(
                            S.of(context).payments_settings,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          trailing: ButtonTheme(
                            padding: EdgeInsets.all(0),
                            minWidth: 50.0,
                            height: 25.0,
                            child: PaymentSettingsDialog(
                              creditCard: _con.creditCard,
                              onChanged: () {
                                _con.updateCreditCard(_con.creditCard);
                                //setState(() {});
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 15),
                          child: Container(
                            height: 0.5,
                            color: Colors.grey.withOpacity(0.8),
                          ),
                        ),
                        ListTile(
                          dense: true,
                          title: AutoSizeText(
                            S.of(context).default_credit_card,
                            style: Theme.of(context).textTheme.bodyText2.merge(
                                TextStyle(color: Theme.of(context).hintColor)),
                          ),
                          trailing: AutoSizeText(
                            _con.creditCard.number.isNotEmpty
                                ? ''
                                // _con.creditCard.number.replaceRange(
                                //     0, _con.creditCard.number.length - 4, '...')
                                : '',
                            style:
                                TextStyle(color: Theme.of(context).hintColor),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      //borderRadius: BorderRadius.circular(6),
                      //boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      primary: false,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      children: <Widget>[
                        ListTile(
                          leading: Opacity(
                            opacity: 0.7,
                            child: Icon(Icons.settings)),
                          title: AutoSizeText(
                            S.of(context).app_settings,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 15),
                          child: Container(
                            height: 0.5,
                            color: Colors.grey.withOpacity(0.8),
                          ),
                        ),
                        //ListTile(
                        //  onTap: () {
                        //    Navigator.of(context).pushNamed('/Languages');
                        //  },
                        //  dense: true,
                        //  title: Row(
                        //    children: <Widget>[
                        //     // Icon(
                        //     //   Icons.translate,
                        //     //   size: 22,
                        //     //   color: Theme.of(context).hintColor,
                        //     // ),
                        //     // SizedBox(width: 10),
                        //      AutoSizeText(
                        //        S.of(context).languages,
                        //        style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Theme.of(context).hintColor,
                        //      ),
                        //    ],
                        //  ),
                        //  trailing: AutoSizeText(
                        //    S.of(context).english,
                        //    style: TextStyle(color: Theme.of(context).hintColor),
                        //  ),
                        //),

                        
                        // ListTile(
                        //   onTap: () {
                        //     Navigator.of(context)
                        //         .pushNamed('/DeliveryAddresses');
                        //   },
                        //   dense: true,
                        //   title: Row(
                        //     children: <Widget>[
                        //       // Icon(
                        //       //   Icons.place,
                        //       //   size: 22,
                        //       //   color: Theme.of(context).hintColor,
                        //       // ),
                        //       // SizedBox(width: 10),
                        //       AutoSizeText(
                        //         S.of(context).delivery_addresses,
                        //         style: Theme.of(context)
                        //             .textTheme
                        //             .bodyText2
                        //             .merge(TextStyle(
                        //                 color: Theme.of(context).hintColor)),
                        //       ),
                        //     ],
                        //   ),
                        //   trailing: Icon(Icons.arrow_forward_ios,
                        //       color: Colors.grey, size: 20),
                        // ),
                        ListTile(
                          onTap: () {
                            Navigator.of(context).pushNamed('/Help');
                          },
                          dense: true,
                          title: Row(
                            children: <Widget>[
                              //Icon(
                              //  Icons.help,
                              //  size: 22,
                              //  color: Theme.of(context).hintColor,
                              //),
                              //SizedBox(width: 10),
                              AutoSizeText(
                                S.of(context).faqs,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .merge(TextStyle(
                                        color: Theme.of(context).hintColor)),
                              ),
                            ],
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: Colors.grey, size: 20),
                        ),

                        ListTile(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/ContactGoldilocks');
                          },
                          dense: true,
                          title: Row(
                            children: <Widget>[
                              //Icon(
                              //  Icons.help,
                              //  size: 22,
                              //  color: Theme.of(context).hintColor,
                              //),
                              //SizedBox(width: 10),
                              AutoSizeText(
                                S.of(context).contact_details,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .merge(TextStyle(
                                        color: Theme.of(context).hintColor)),
                              ),
                            ],
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: Colors.grey, size: 20),
                        ),

                        ListTile(
                          onTap: () {
                            Navigator.of(context).pushNamed('/PrivacyPolicy');
                          },
                          dense: true,
                          title: Row(
                            children: <Widget>[
                              //Icon(
                              //  Icons.help,
                              //  size: 22,
                              //  color: Theme.of(context).hintColor,
                              //),
                              //SizedBox(width: 10),
                              AutoSizeText(
                                S.of(context).privacy_policy,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .merge(TextStyle(
                                        color: Theme.of(context).hintColor)),
                              ),
                            ],
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: Colors.grey, size: 20),
                        ),

                        ListTile(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/TermsAndConditions');
                          },
                          dense: true,
                          title: Row(
                            children: <Widget>[
                              //Icon(
                              //  Icons.help,
                              //  size: 22,
                              //  color: Theme.of(context).hintColor,
                              //),
                              //SizedBox(width: 10),
                              AutoSizeText(
                                S.of(context).terms_and_conditions,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .merge(TextStyle(
                                        color: Theme.of(context).hintColor)),
                              ),
                            ],
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: Colors.grey, size: 20),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.of(context).pushNamed('/Covid');
                          },
                          dense: true,
                          title: Row(
                            children: <Widget>[
                              //Icon(
                              //  Icons.help,
                              //  size: 22,
                              //  color: Theme.of(context).hintColor,
                              //),
                              //SizedBox(width: 10),
                              AutoSizeText(
                                S.of(context).covid_19,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .merge(TextStyle(
                                        color: Theme.of(context).hintColor)),
                              ),
                            ],
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              color: Colors.grey, size: 20),
                        ),
                      ],
                    ),
                  ),

                  Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        //borderRadius: BorderRadius.circular(6),
                        //boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
                      ),
                      child: FlatButton(
                        onPressed: () {
                          if (currentUser.value.apiToken != null) {
                            prefs.setIntLoginType(false);
                            logout().then((value) {
                              signOutGoogle();
                              signOutFacebook();
                              Navigator.of(context).pushNamed('/Login');
                            });
                          } else {
                            Navigator.of(context).pushNamed('/Login');
                          }
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.exit_to_app,
                              color: Colors.red,
                              size: 30,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            AutoSizeText(S.of(context).logout,
                                style:
                                    Theme.of(context).textTheme.headline4.merge(
                                          TextStyle(
                                            color: Colors.red,
                                          ),
                                        )),
                          ],
                        ),
                      )),

                  //ListTile(
                  //  onTap: () {},
                  //  dense: true,
                  //  title: AutoSizeText(
                  //    S.of(context).about,
                  //    style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Theme.of(context).hintColor,
                  //  ),
                  //  trailing: AutoSizeText(
                  //    Helper.limitString(currentUser.value.bio),
                  //    overflow: TextOverflow.fade,
                  //    softWrap: false,
                  //    style:
                  //        TextStyle(color: Theme.of(context).dividerColor),
                  //  ),
                  //),
                ],
              ),
            ),
    );
  }
}