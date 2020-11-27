import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Logout extends StatefulWidget {
  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  String uid = '';
  @override
  void initState() {
    uid ='';
    FirebaseAuth.instance.currentUser().then((val){
      setState(() {

        this.uid = val.uid;
      });
    }).catchError((e){
      print(e);
    });
    super.initState();
  }

  Future<void> _logout() async{
    try{
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed('/OtpTest');
    } catch(e){
      print(e.toString());
    }
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText("user"),
        centerTitle: true,

      ),
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              AutoSizeText("Welcome"),
              SizedBox(
                height: 10,

              ),
              OutlineButton(
                borderSide: BorderSide(
                  color: Colors.blue,
                  style: BorderStyle.solid,
                  width: 3,
                ),
                child: AutoSizeText("Log out", style: TextStyle(
                  color: Colors.blue,),



                ),
                onPressed: (){

                  _logout();
                },


              ),
            ],
          ),
        ),
      ),

    );
  }
}