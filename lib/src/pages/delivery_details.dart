import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../models/route_argument.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart';

class DeliveryDetails extends StatefulWidget {
  final RouteArgument routeArgument;
  DeliveryDetails({Key key, this.routeArgument}) : super(key: key);

  @override
  _DeliveryDetailsState createState() => _DeliveryDetailsState();
}

class _DeliveryDetailsState extends State<DeliveryDetails> {
  
  @override
  Widget build(BuildContext context) {
    var name = currentUser.value.name;
    var trimedleft = name.lastIndexOf(' ');
    var resultleft = (trimedleft != -1) ? name.substring(0, trimedleft) : name;
    var trimedright = name.lastIndexOf(' ');
    var resultright = (trimedright != -1) ? name.substring(trimedright) : name;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
          elevation: 0,
        title: AutoSizeText(
          S.of(context).delivery_details,
          style: Theme.of(context).textTheme.headline4.merge(
            TextStyle(fontSize: 18)
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Material(
                    child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Form(
                          child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      AutoSizeText(S.of(context).personal_infomation,
                      style: Theme.of(context).textTheme.headline4.merge(
                        TextStyle(fontSize: 16, color: Theme.of(context).hintColor)),
                      ),
                      SizedBox(height: 20),

                      new TextFormField(
                        style: TextStyle(
                          color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                            hintText: 'John',
                            labelText: S.of(context).first_name),
                            initialValue: currentUser.value.name != null ? resultleft : "",
                      ),
                      SizedBox(height: 20,),

                      new TextFormField(
                              style: TextStyle(
                          color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                            hintText: 'Doe',
                            labelText: S.of(context).last_name),
                            initialValue: currentUser.value.name != null ? resultright : "",
                      ),
                      SizedBox(height: 20,),

                      new TextFormField(
                              style: TextStyle(
                          color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                            hintText: 'Phone number',
                            labelText: S.of(context).phone_number),
                            initialValue: currentUser.value.phone,
                      ),
                      SizedBox(height: 20),

                      new TextFormField(
                              style: TextStyle(
                          color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                            hintText: 'johndoe@sample.com',
                            labelText: S.of(context).email),
                            initialValue: currentUser.value.email,
                      ),
                      SizedBox(height: 50),

                      AutoSizeText(S.of(context).billing_address,
                      style: Theme.of(context).textTheme.headline4.merge(
                        TextStyle(fontSize: 16 ,color: Theme.of(context).hintColor)),
                      ),
                      SizedBox(height: 20),

                      new TextFormField(
                              style: TextStyle(
                          color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                            hintText: 'State',
                            labelText: S.of(context).address),
                            initialValue: currentUser.value.address,
                      ),
                      SizedBox(height: 20),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),






    );
  }
  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
      border: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).dividerColor.withOpacity(0.2))),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).accentColor.withOpacity(0.5))),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).dividerColor.withOpacity(0.2))),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
}
}