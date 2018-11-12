

import 'package:flutter/material.dart';
import 'Colors.dart';
import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';


class without extends StatefulWidget {
  @override
  withoutstate createState() => withoutstate();
}

class PrimaryColorOverride extends StatelessWidget {
  const PrimaryColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(primaryColor: color),
    );
  }
}

class withoutstate extends State<without> {
  SharedPreferences prefs;
  PageController _controller = new PageController();
  bool loggedIn = false;  // this will check status


  @override
  void initState() {
    super.initState();
//_starttime();

  }
_starttime() async
{ new Timer(new Duration(seconds: 3), ()
  {
    Navigator.pop(context);
  });
}

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset(
                  'assets/diamond.png',height: 100.0,
                ),
                SizedBox(height: 16.0),
                Text('RAVEMAG'),
              ],
            ),
            SizedBox(height: 80.0),

            new Column(
              children: <Widget>[
                new Text('RaveMag is an Application which provides you Trending and Buzzing stuff going in and around Electronic Dance Music (EDM). We provide rich articles, music charts based on quality and hype and we have polls on EDM stuff where we listen to your vote and know general Buzz of every EDM fan.',style: Theme.of(context).textTheme.caption.copyWith(fontSize: 15.0),textAlign: TextAlign.center,)
              ],
            ),


            SizedBox(height: 50.0),
            RaisedButton(

              color: Colors.cyan,
              child: new Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text('Let''s Rave',style: Theme.of(context).textTheme.caption.copyWith(color: Colors.white),),
              ),
              elevation: 8.0,

              onPressed: ()
              {
                Navigator.pop(context);
              },
            ),
          ],


        ),
      ),
    );
  }


  }
