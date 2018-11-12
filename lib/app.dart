
import 'package:flutter/material.dart';

import 'backdrop.dart';
import 'colors.dart';
import 'home.dart';


import 'categorymenupage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'supplemental/cut_corners_border.dart';

import 'withoutsignin.dart';
import 'package:shared_preferences/shared_preferences.dart';

String gg;
class RaveMag extends StatefulWidget {
  @override
  RaveMagState createState() {
    return new RaveMagState();
  }
}

class RaveMagState extends State<RaveMag> {
  static SharedPreferences prefs;
  Category _currentCategory = Category.News;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
 static bool loggedin;

  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
      print(category);
    });
  }


  @override
  void initState() {
   getdata();
    super.initState();

    SharedPreferences.getInstance().then((string)
    {

    loggedin=  (string.getBool('login'))?? false;
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },

    );


  }

 static getdata() async
  {
    prefs= await SharedPreferences.getInstance();
    //  prefs.clear();
    loggedin=(prefs.getBool('login'))?? false;
    print(loggedin);
  }
  Widget build(BuildContext context) {



    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RAVEMAG',
      home: Backdrop(
        currentcategory: _currentCategory,
        frontLayer: HomePage(
          category: _currentCategory,
        ),
        backLayer: CategoryMenuPage(
          currentCategory: _currentCategory,
          onCategoryTap: _onCategoryTap,
        ),
        frontTitle: Text('RAVEMAG'),
        backTitle: Text('MENU'),
      ),
      initialRoute: '/withoutsignin',
      routes: <String, WidgetBuilder>{
        //5
        '/home': (BuildContext context) => HomePage(), //6

        '/withoutsignin' : (BuildContext context) => without() //7
      },
      theme: _kShrineTheme,
    );
  }
}

final ThemeData _kShrineTheme = _buildShrineTheme();

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: kShrinePink50,
    primaryColor: kShrinePink50,
    buttonColor: kShrinePink50,
    scaffoldBackgroundColor: kShrineBackgroundWhite,
    cardColor: kShrineBackgroundWhite,
    textSelectionColor: kShrinePink100,
    errorColor: kShrineErrorRed,
    textTheme: _buildShrineTextTheme(base.textTheme),
    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
    primaryIconTheme: base.iconTheme.copyWith(color: kShrineBrown900),
    inputDecorationTheme: InputDecorationTheme(
      border: CutCornersBorder(),
    ),
  );
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline: base.headline.copyWith(
          fontWeight: FontWeight.w500,
        ),
        title: base.title.copyWith(fontSize: 20.0),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
        ),
      )
      .apply(
        fontFamily: 'Rubik',
        displayColor: kShrineBrown900,
        bodyColor: kShrineBrown900,
      );
}
