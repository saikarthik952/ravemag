import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'categorymenupage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

import 'package:shared_preferences/shared_preferences.dart';

var _bb;
String chart;

bool pie, question,chartdisplay;
bool checked = false;
SharedPreferences prefs;
bool mm;

class HomePage extends StatefulWidget {
  final Category category;

  const HomePage({this.category: Category.News});

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  List<Widget> _fakeBottomButtons;

  SharedPreferences prefs;

  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  final _chartSize = const Size(300.0, 300.0);
  getdata() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      pie = (prefs.getBool('answered')) ?? false;
      mm= (prefs.getBool('readq')) ?? false;
    });
  }



  @override
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 500), () => getdata());



  }
  dango() async{
    setState(() {
      mm=false;
    });
    prefs.setBool('readq', false);
  }
  mango() async {
   
    setState(() {
      pie = false;
      mm=true;
    });
    prefs.setBool('answered', false);
    prefs.setBool('readq', true);
  }

  storeName(bool visibility) async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      pie = true;
    });
    prefs.setBool('answered', visibility);
  }

  @override
  Widget build(BuildContext context) {

    _fakeBottomButtons = new List<Widget>();
    _fakeBottomButtons.add(new Container(
      height: 40.0,
    ));


    var categoryString =
        widget.category.toString().replaceAll('Category.', '').toLowerCase();
    print(categoryString);
    if (categoryString == 'news') {
      _bb= new Center(child: new CircularProgressIndicator(strokeWidth: 5.0,backgroundColor: Colors.brown,),);
      Query xs =
      Firestore.instance.collection(categoryString).orderBy('articleno',descending: true);
      _bb = StreamBuilder(
          stream: xs.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return new Center(child: new Text('Loading.....'),);
            return new ListView.builder(

                itemCount: snapshot.data.documents.length,
                padding: const EdgeInsets.only(top: 0.0, bottom: 5.0),
                itemExtent: 300.0,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.documents[index];
                  if(!snapshot.hasData) return new Center(child:  const CircularProgressIndicator(backgroundColor: Colors.cyan,),);
                  return new FlatButton(
                    padding: EdgeInsets.all(4.0),
                    child: new Container(
                      padding: EdgeInsets.all(4.0),
                      height: 300.0,
                      child: new Card(
                        elevation: 6.0,
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15.0),
                                bottomRight: Radius.circular(0.0),
                                bottomLeft: Radius.circular(0.0),
                                topLeft: Radius.circular(15.0))),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new SizedBox(
                              height: 210.0,
                              child: new Stack(
                                children: <Widget>[
                                  new Positioned.fill(
                                    child: new Image.network(
                                      ds['image'],
                                      fit: BoxFit.cover,
                                    ),
                                    bottom: 4.0,
                                  ),
                                ],
                              ),
                            ),
                            new Expanded(
                              child: new Container(
                                padding: EdgeInsets.only(
                                    top: 4.0,
                                    left: 4.0,
                                    right: 4.0,
                                    bottom: 4.0),
                                alignment: Alignment.center,
                                child: Text(
                                  ds['title'].toUpperCase(),
                                  style: Theme.of(context).textTheme.body2,
                                  textAlign: TextAlign.left,
                                  softWrap: true,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    onPressed: () {
                      print(ds.documentID);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new PostScreen(
                                    docid: ds.documentID,
                                    title: ds['title'],
                                    articleno: ds['articleno'],

                                    Description: ds['Description'],
                                    dateTime: ds['Date'],
                                    image: ds['image'],
                                  )));
                    },
                  );
                });
          });
    } else if (categoryString == 'charts') {


_bb= new Center(child: new CircularProgressIndicator(strokeWidth: 5.0,backgroundColor: Colors.brown,),);
  _bb = new StreamBuilder(
      stream: Firestore.instance.collection(categoryString).orderBy(
          'position', descending: false).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) new Text('hell0');
        return new ListView.builder(


            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.documents[index];
              if (!snapshot.hasData) return new Center(
                child: const CircularProgressIndicator(
                  backgroundColor: Colors.cyan,),);
              return new Container(
                color: Colors.white30,
                height: 200.0,
                margin: const EdgeInsets.all(12.0),
                child: new Stack(

                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.symmetric(vertical: 0.0),
                      padding: EdgeInsets.only(top: 14.0),
                      alignment: FractionalOffset.centerLeft,
                      child: new Image.network(
                        ds['image'],
                        fit: BoxFit.fill,
                        width: 120.0,
                        height: 130.0,
                      ),
                    ),
                    new Container(
                      child: new Container(
                        margin: EdgeInsets.all(10.0),
                        child: new Column(
                          children: <Widget>[
                            new SizedBox(height: 10.0),
                            new Text(
                              ds['trackname'],
                              style: Theme
                                  .of(context)
                                  .primaryTextTheme
                                  .body2
                                  .copyWith(fontSize: 16.0),
                            ),
                            new SizedBox(height: 10.0),
                            new Text(ds['artists'],
                                style: Theme
                                    .of(context)
                                    .accentTextTheme
                                    .subhead,
                                softWrap: true,
                                textAlign: TextAlign.left),
                            new SizedBox(height: 10.0),
                            new Text(
                              ds['Recordings'],
                              style:
                              Theme
                                  .of(context)
                                  .accentTextTheme
                                  .caption,
                              softWrap: true,
                            ),
                            new SizedBox(height: 12.0),
                            new Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                new Container(
                                  alignment: FractionalOffset.bottomLeft,
                                  child: new Text(
                                    'LW : #${ds['status']}',
                                    style:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .body2,
                                  ),
                                ),
                                new Container(
                                  alignment: FractionalOffset.bottomRight,
                                  child: new Text(
                                    '#${ds['position']}',
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .headline,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      height: 200.0,

                      margin: new EdgeInsets.only(left: 100.0, top: 10.0),
                      decoration: new BoxDecoration(
                        color: Colors.white,

                        shape: BoxShape.rectangle,
                        borderRadius: new BorderRadius.circular(8.0),
                        boxShadow: <BoxShadow>[
                          new BoxShadow(
                            color: Colors.black12,
                            blurRadius: 20.0,
                            offset: new Offset(0.0, 10.0),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              );
            });
      });

    } else if (categoryString == 'polls') {

      _bb = new StreamBuilder(
          stream: Firestore.instance.collection(categoryString).snapshots(),
          builder: (context, snapshot) {
            return new ListView.builder(
                itemCount: snapshot.data.documents.length,
                padding: const EdgeInsets.only(top: 10.0),
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.documents[index];
                  print(pie);
                  print(question);

                  if(!snapshot.hasData) return new Center(child:  const CircularProgressIndicator(backgroundColor: Colors.cyan,),);
                  List<CircularStackEntry> data = <CircularStackEntry>[
                    new CircularStackEntry(
                      <CircularSegmentEntry>[
                        new CircularSegmentEntry(
                            ds['votes1'].toDouble(), Colors.red[200],
                            rankKey: 'Q1'),
                        new CircularSegmentEntry(
                            ds['votes2'].toDouble(), Colors.green[200],
                            rankKey: 'Q2'),
                        new CircularSegmentEntry(
                            ds['votes3'].toDouble(), Colors.blue[200],
                            rankKey: 'Q3'),
                        new CircularSegmentEntry(
                            ds['votes4'].toDouble(), Colors.yellow[200],
                            rankKey: 'Q4'),
                      ],
                      rankKey: 'Quarterly Profits',
                    ),
                  ];
                  var kx = new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[

                      new Container(
                        child: new AnimatedCircularChart(
                          key: _chartKey,
                          size: const Size(300.0, 300.0),
                          initialChartData: data,
                          chartType: CircularChartType.Pie,
                        ),
                      ),
                      new Container(

                        child: new Text('Q. ${ds['Question']}',style: Theme.of(context).textTheme.subhead,
                        ),

                        padding: EdgeInsets.all(16.0),
                      ),

                      new Container(

                        child: new Center(
                          child: new Text('A. ${ds['option1']} votes : ${ds['votes1']}',style: Theme.of(context).textTheme.subhead,
                            textAlign: TextAlign.justify,),
                        ),
                        color: Colors.red[200],
                        padding: EdgeInsets.all(16.0),
                        margin: EdgeInsets.all(16.0),
                      ),
                      new Container(
                        margin: EdgeInsets.all(16.0),
                        child: new Center(
                          child: new Text('B. ${ds['option2']} votes: ${ds['votes2']}',style: Theme.of(context).textTheme.subhead,
                          ),
                        ),
                        color: Colors.green[200],
                        padding: EdgeInsets.all(16.0),
                      ),
                      new Container(
                        margin: EdgeInsets.all(16.0),
                        child: new Center(
                          child: new Text('C. ${ds['option3']} votes: ${ds['votes3']}',style: Theme.of(context).textTheme.subhead,
                          ),
                        ),
                        color: Colors.blue[200],
                        padding: EdgeInsets.all(16.0),
                      ),
                      new Container(
                        margin: EdgeInsets.all(16.0),
                        child: new Center(
                          child: new Text('D. ${ds['option4']} votes: ${ds['votes4']}',style: Theme.of(context).textTheme.subhead,
                          ),
                        ),
                        color: Colors.yellow[200],
                        padding: EdgeInsets.all(16.0),
                      ),
                    new Container(
                      margin: EdgeInsets.all(16.0)
                      ,
                      child: new Text(
                          "1.After Answering the Question you will be Shown Results\n"
                              "2.Generally Poll will be For 1 Week\n"
                              "3.To answer Upcoming Question you need to Come to Polls tab and should click on Im Ready\n"

                              "4. So that you are eligible for answering upcoming question!!!\n"
                              "5.Dont Worry we will notify you when you need come and click ",softWrap: true,style: Theme.of(context).textTheme.caption,),
                    ),],
                  );
                  var rr = new Container(
                    margin: EdgeInsets.all(16.0),
                    child: new Column(
                      children: <Widget>[
                        new SizedBox(
                          height: 30.0,
                        ),
                        new Text(
                          ds['Question'],
                          softWrap: true,
                          style: Theme.of(context).textTheme.title,
                          textAlign: TextAlign.center,
                        ),
                        new SizedBox(
                          height: 30.0,
                        ),
                        new Container(
                          decoration: new BoxDecoration(
                            border:
                                new Border.all(color: const Color(0x80000000)),
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          child: new FlatButton(
                              onPressed: () {
                                Firestore.instance
                                    .runTransaction((transaction) async {
                                  DocumentSnapshot freshSnap =
                                      await transaction.get(ds.reference);
                                  await transaction.update(freshSnap.reference,
                                      {'votes1': freshSnap['votes1'] + 1});
                                });

                                storeName(true);
                                // storeName(false,'question');
                              },
                              child: new Text(
                                ' A.  ${ds['option1']}',
                                style: Theme.of(context).textTheme.subhead,
                              )),
                        ),
                        new SizedBox(
                          height: 30.0,
                        ),
                        new Container(
                          decoration: new BoxDecoration(
                            border:
                                new Border.all(color: const Color(0x80000000)),
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          child: new FlatButton(
                              onPressed: () {
                                Firestore.instance
                                    .runTransaction((transaction) async {
                                  DocumentSnapshot freshSnap =
                                      await transaction.get(ds.reference);
                                  await transaction.update(freshSnap.reference,
                                      {'votes2': freshSnap['votes2'] + 1});
                                  return new Opacity(opacity: 0.0);
                                });
                                //_saveValues();

                                storeName(true);
                              },
                              child: new Text(
                                ' B.  ${ds['option2']}',
                                style: Theme.of(context).textTheme.subhead,
                              )),
                        ),
                        new SizedBox(
                          height: 30.0,
                        ),
                        new Container(
                          decoration: new BoxDecoration(
                            border:
                                new Border.all(color: const Color(0x80000000)),
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          child: new FlatButton(
                              onPressed: () {
                                Firestore.instance
                                    .runTransaction((transaction) async {
                                  DocumentSnapshot freshSnap =
                                      await transaction.get(ds.reference);
                                  await transaction.update(freshSnap.reference,
                                      {'votes3': freshSnap['votes3'] + 1});
                                });
                                // _saveValues();

                                storeName(true);
                              },
                              child: new Text(
                                ' C.  ${ds['option3']}',
                                style: Theme.of(context).textTheme.subhead,
                              )),
                        ),
                        new SizedBox(
                          height: 30.0,
                        ),
                        new Container(
                          decoration: new BoxDecoration(
                            border:
                                new Border.all(color: const Color(0x80000000)),
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          child: new FlatButton(
                              onPressed: () {
                                Firestore.instance
                                    .runTransaction((transaction) async {
                                  DocumentSnapshot freshSnap =
                                      await transaction.get(ds.reference);
                                  await transaction.update(freshSnap.reference,
                                      {'votes4': freshSnap['votes4'] + 1});
                                });
                                //_saveValues();

                                storeName(true);
                              },
                              child: new Text(
                                ' D.  ${ds['option4']}',
                                style: Theme.of(context).textTheme.subhead,
                              )),
                        ),
new SizedBox(height: 30.0,),
                        new Container(
                          margin: EdgeInsets.all(16.0)
                          ,
                          child: new Text(
                            "1.After Answering the Question you will be Shown Results\n"
                                "2.Generally Poll will be For 1 Week\n"
                                "3.To answer Upcoming Question you need to Come to Polls tab and should click on Im Ready\n"
                                "4. So that you are eligible for answering upcoming question!!!\n"
                                "5.Dont Worry we will notify you when you need come and click  ",softWrap: true,style: Theme.of(context).textTheme.caption,),
                        )
                      ],
                    ),
                  );





                  if (pie == false && ds['pie'] && ds['question']) {
                    dango();
                    return rr;
                  } else if (ds['pie'] && pie == true) {
                    dango();
                    return kx;
                  }else if(ds['question']==false&&pie==true)
                    {

                      return kx;
                    }
                  else if (mm==true) {
                    if (pie == true) mango();

                    return new Center(
                      child: new Container(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new SizedBox(height: 200.0,),
                            new Column(
                              children: <Widget>[
                                new Center(
                                  child: new Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: new Text("You are Ready To Take Question.It will be Live in  ${ds['readyq']} Hrs.",softWrap: true,textAlign: TextAlign.center,),
                                  ),
                                ),
                                new SizedBox(height: 40.0,),
                                new Container(
                                  margin: EdgeInsets.all(16.0)
                                  ,
                                  child: new Text(
                                    "1.After Answering the Question you will be Shown Results\n"
                                        "2.Generally Poll will be For 1 Week\n"
                                        "3.To answer Upcoming Question you need to Come to Polls tab and should click on Im Ready\n"
                                        "4. So that you are eligible for answering upcoming question!!! \n"
                                        "5.Dont Worry we will notify you when you need come and click ",softWrap: true,style: Theme.of(context).textTheme.caption,),
                                )
                              ],
                            )

                          ],
                        ),
                      ),
                    );
                  }
                    else if(ds['remark']==true)
                      {
                        return new Center(
                          child: new Container(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new SizedBox(height: 100.0,),

                                  new Column(
                                    children: <Widget>[
                                      new Center(
                                        child: new Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: new Column(children: <Widget>[
                                            new Text('New Question will be Soon Are you Ready !?'),
                                            new SizedBox(height: 40.0,),

                                            new Container(
                                              child: new RaisedButton(onPressed:()
                                              {

                                                mango();
                                              },child: new Text('Ready'),color: Colors.cyan,),
                                            ),
                                            new SizedBox(height: 30.0,),
                                            new Container(
                                              margin: EdgeInsets.all(16.0)
                                              ,
                                              child: new Text(
                                                "1.After Answering the Question you will be Shown Results\n"
                                                    "2.Generally Poll will be For 1 Week\n"
                                                    "3.To answer Upcoming Question you need to Come to Polls tab and should click on Im Ready\n"
                                                    "4. So that you are eligible for answering upcoming question!!! ",softWrap: true,style: Theme.of(context).textTheme.caption,),
                                            )
                                          ],),
                                        ),
                                      ),
                                    ],
                                  ),


                              ],
                            ),
                          ),
                        );
                      }

                });
          });
    } else if (categoryString == 'aboutus') {
      _bb = new Scaffold(body:
        new    ListView(
          padding: EdgeInsets.all(20.0),
          scrollDirection: Axis.vertical,
            children: <Widget>[
              new Text('RaveMag is an Application which provides you Trending and Buzzing stuff going in and around Electronic Dance Music (EDM). We provide rich articles, music charts based on quality and hype and we have polls on EDM stuff where we listen to your vote and know general Buzz of every EDM fan.',style: Theme.of(context).textTheme.caption.copyWith(fontSize: 15.0),textAlign: TextAlign.center,)
            ,
            new SizedBox(height: 60.0,),
            new Center(child: new Text('Developer',style: Theme.of(context).textTheme.headline,)),
              new SizedBox(height: 30.0,),
            new Center(child: new Text('Sai Karthik',style: Theme.of(context).textTheme.title,)),
              new SizedBox(height: 30.0,),
              new Center(child: new Text('For any issues in content or service\n write us to',style: Theme.of(context).textTheme.caption,textAlign: TextAlign.center,)),
              new SizedBox(height: 20.0,),
              new Center(child: new Text('ravemagofficial@gmail.com',style: Theme.of(context).textTheme.subhead,))],
          ),

        );
    }

    return Scaffold(
      body: _bb,
      backgroundColor: Colors.white30,

    );
  }
}

class PostScreen extends StatelessWidget {
  final String docid;
  final String title, Description, image;
  final int articleno;
  final String dateTime;

  PostScreen(
      {Key key,
      this.docid,
      this.title,
      this.Description,
      this.image,
      this.articleno,

      this.dateTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
   List<Widget> _fakeBottomButtons = new List<Widget>();
    _fakeBottomButtons.add(new Container(
      height: 40.0,
    ));
    return new Scaffold(
        body: new CustomScrollView(
      slivers: <Widget>[
        new SliverAppBar(
          floating: false,
          pinned: true,
          expandedHeight: 240.0,
          flexibleSpace: new FlexibleSpaceBar(
            background: new Image.network(
              image,
              fit: BoxFit.fill,
            ),
          ),
        ),
        new SliverPadding(
          padding: new EdgeInsets.all(16.0),
          sliver: new SliverList(
            delegate: new SliverChildListDelegate([
              new Text(
                title,
                softWrap: true,
                style: Theme.of(context).primaryTextTheme.headline,
                textAlign: TextAlign.start,
              ),
              new SizedBox(
                height: 10.0,
              ),
              new Text(dateTime),
              new SizedBox(
                height: 10.0,
              ),
              new Text(
                Description,
                softWrap: true,
                style: Theme.of(context).primaryTextTheme.subhead.copyWith(color: Colors.black87,fontSize: 16.0,letterSpacing: 0.8,wordSpacing: 1.0),textAlign: TextAlign.justify,

              ),
            ]),
          ),
        ),
      ],
    ),
     );
  }

}
