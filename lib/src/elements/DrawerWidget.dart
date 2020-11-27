// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:mvc_pattern/mvc_pattern.dart';

// import '../../generated/l10n.dart';
// import '../controllers/profile_controller.dart';
// import '../repository/settings_repository.dart';
// import '../repository/user_repository.dart';

// class DrawerWidget extends StatefulWidget {
//   @override
//   _DrawerWidgetState createState() => _DrawerWidgetState();
// }

// class _DrawerWidgetState extends StateMVC<DrawerWidget> {
//   //ProfileController _con;

//   _DrawerWidgetState() : super(ProfileController()) {
//     //_con = controller;
//   }
//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         children: <Widget>[
//           GestureDetector(
//             onTap: () {
//               currentUser.value.apiToken != null ? Navigator.of(context).pushNamed('/Profile') : Navigator.of(context).pushNamed('/Login');
//             },
//             child: currentUser.value.apiToken != null
//                 ? UserAccountsDrawerHeader(
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).hintColor.withOpacity(0.1),
//                     ),
//                     accountName: AutoSizeText(
//                       currentUser.value.name,
//                       style: Theme.of(context).textTheme.headline6,
//                     ),
//                     accountEmail: AutoSizeText(
//                       currentUser.value.email,
//                       style: Theme.of(context).textTheme.caption,
//                     ),
//                     currentAccountPicture: CircleAvatar(
//                       backgroundColor: Theme.of(context).accentColor,
//                       backgroundImage: NetworkImage(currentUser.value.image.thumb),
//                     ),
//                   )
//                 : Container(
//                     padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).hintColor.withOpacity(0.1),
//                     ),
//                     child: Row(
//                       children: <Widget>[
//                         Icon(
//                           Icons.person,
//                           size: 32,
//                           color: Theme.of(context).accentColor.withOpacity(1),
//                         ),
//                         SizedBox(width: 30),
//                         AutoSizeText(
//                           S.of(context).guest,
//                           style: Theme.of(context).textTheme.headline6,
//                         ),
//                       ],
//                     ),
//                   ),
//           ),
//           ListTile(
//             onTap: () {
//               Navigator.of(context).pushNamed('/Pages', arguments: 0);
//             },
//             leading: Icon(
//               Icons.home,
//               color: Theme.of(context).focusColor.withOpacity(1),
//             ),
//             title: AutoSizeText(
//               S.of(context).home,
//               style: Theme.of(context).textTheme.subtitle1,
//             ),
//           ),

//           ListTile(
//             onTap: () {
//               Navigator.of(context).pushNamed('/Pages', arguments: 1);
//             },
//             leading: Icon(
//               Icons.local_mall,
//               color: Theme.of(context).focusColor.withOpacity(1),
//             ),
//             title: AutoSizeText(
//               S.of(context).my_orders,
//               style: Theme.of(context).textTheme.subtitle1,
//             ),
//           ),
//           ListTile(
//             onTap: () {
//               Navigator.of(context).pushNamed('/Pages', arguments: 2);
//             },
//             leading: Icon(
//               Icons.notifications,
//               color: Theme.of(context).focusColor.withOpacity(1),
//             ),
//             title: AutoSizeText(
//               S.of(context).notifications,
//               style: Theme.of(context).textTheme.subtitle1,
//             ),
//           ),
//           ListTile(
//             onTap: () {
//               Navigator.of(context).pushNamed('/Stores');
//             },
//             leading: Icon(
//               Icons.store,
//               color: Theme.of(context).focusColor.withOpacity(1),
//             ),
//             title: AutoSizeText(
//               S.of(context).stores,
//               style: Theme.of(context).textTheme.subtitle1,
//             ),
//           ),
//           ListTile(
//             onTap: () {
//               Navigator.of(context).pushNamed('/Products');
//             },
//             leading: Icon(
//               Icons.local_mall,
//               color: Theme.of(context).focusColor.withOpacity(1),
//             ),
//             title: AutoSizeText(
//               S.of(context).products,
//               style: Theme.of(context).textTheme.subtitle1,
//             ),
//           ),
//           ListTile(
//             dense: true,
//             title: AutoSizeText(
//               S.of(context).application_preferences,
//               style: Theme.of(context).textTheme.bodyText2,
//             ),
//             trailing: Icon(
//               Icons.remove,
//               color: Theme.of(context).focusColor.withOpacity(0.3),
//             ),
//           ),
//           ListTile(
//             onTap: () {
//               Navigator.of(context).pushNamed('/Help');
//             },
//             leading: Icon(
//               Icons.help,
//               color: Theme.of(context).focusColor.withOpacity(1),
//             ),
//             title: AutoSizeText(
//               S.of(context).help__support,
//               style: Theme.of(context).textTheme.subtitle1,
//             ),
//           ),
//           //ListTile(
//           //  onTap: () {
//           //    if (currentUser.value.apiToken != null) {
//           //      Navigator.of(context).pushNamed('/Settings');
//           //    } else {
//           //      Navigator.of(context).pushReplacementNamed('/Login');
//           //    }
//           //  },
//           //  leading: Icon(
//           //    Icons.settings,
//           //    color: Theme.of(context).focusColor.withOpacity(1),
//           //  ),
//           //  title: AutoSizeText(
//           //    S.of(context).settings,
//           //    style: Theme.of(context).textTheme.subtitle1,
//           //  ),
//           //),
//           //ListTile(
//           //  onTap: () {
//           //    Navigator.of(context).pushNamed('/Languages');
//           //  },
//           //  leading: Icon(
//           //    Icons.translate,
//           //    color: Theme.of(context).focusColor.withOpacity(1),
//           //  ),
//           //  title: AutoSizeText(
//           //    S.of(context).languages,
//           //    style: Theme.of(context).textTheme.subtitle1,
//           //  ),
//           //),
//           //ListTile(
//           //  onTap: () {
//           //    if (Theme.of(context).brightness == Brightness.dark) {
//           //      setBrightness(Brightness.light);
//           //      setting.value.brightness.value = Brightness.light;
//           //    } else {
//           //      setting.value.brightness.value = Brightness.dark;
//           //      setBrightness(Brightness.dark);
//           //    }
//           //    setting.notifyListeners();
//           //  },
//           //  leading: Icon(
//           //    Icons.brightness_6,
//           //    color: Theme.of(context).focusColor.withOpacity(1),
//           //  ),
//           //  title: AutoSizeText(
//           //    Theme.of(context).brightness == Brightness.dark ? S.of(context).light_mode : S.of(context).dark_mode,
//           //    style: Theme.of(context).textTheme.subtitle1,
//           //  ),
//           //),
//           ListTile(
//             onTap: () {
//               if (currentUser.value.apiToken != null) {
//                 logout().then((value) {
//                   Navigator.of(context).pushNamed('/Login');
//                 });
//               } else {
//                 Navigator.of(context).pushNamed('/Login');
//               }
//             },
//             leading: Icon(
//               Icons.exit_to_app,
//               color: Theme.of(context).focusColor.withOpacity(1),
//             ),
//             title: AutoSizeText(
//               currentUser.value.apiToken != null ? S.of(context).log_out : S.of(context).login,
//               style: Theme.of(context).textTheme.subtitle1,
//             ),
//           ),
//           currentUser.value.apiToken == null
//               ? ListTile(
//                   onTap: () {
//                     Navigator.of(context).pushNamed('/SignUp');
//                   },
//                   leading: Icon(
//                     Icons.person_add,
//                     color: Theme.of(context).focusColor.withOpacity(1),
//                   ),
//                   title: AutoSizeText(
//                     S.of(context).register,
//                     style: Theme.of(context).textTheme.subtitle1,
//                   ),
//                 )
//               : SizedBox(height: 0),
//           //setting.value.enableVersion
//           //    ? ListTile(
//           //        dense: true,
//           //        title: AutoSizeText(
//           //          S.of(context).version + " " + setting.value.appVersion,
//           //          style: Theme.of(context).textTheme.bodyText2,
//           //        ),
//           //        trailing: Icon(
//           //          Icons.remove,
//           //          color: Theme.of(context).focusColor.withOpacity(0.3),
//           //        ),
//           //      )
//           //    : SizedBox(),
//         ],
//       ),
//     );
//   }
// }
