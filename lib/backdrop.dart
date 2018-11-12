import 'package:flutter/material.dart';
import 'package:meta/meta.dart';


import 'Colors.dart';
import 'categorymenupage.dart';

const double _kFlingVelocity = 2.0;

class Backdrop extends StatefulWidget {
  final Category currentcategory;
  final Widget frontLayer;
  final Widget backLayer;
  final Widget frontTitle;
  final Widget backTitle;

  const Backdrop({
    @required this.currentcategory,
    @required this.frontLayer,
    @required this.backLayer,
    @required this.frontTitle,
    @required this.backTitle,
  })  : assert(currentcategory != null),
        assert(frontLayer != null),
        assert(backLayer != null),
        assert(frontTitle != null),
        assert(backTitle != null);

  @override
  _BackdropState createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  AnimationController _controller;
  @override
  void didUpdateWidget(Backdrop old) {
    super.didUpdateWidget(old);

    if (widget.currentcategory != old.currentcategory) {
      _toggleBackdropLayerVisibility();
    } else if (!_frontLayerVisible) {
      _controller.fling(velocity: _kFlingVelocity);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
  }

  bool get _frontLayerVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropLayerVisibility() {
    _controller.fling(
        velocity: _frontLayerVisible ? -_kFlingVelocity : _kFlingVelocity);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double layerTitleHeight = 30.0;
    final Size layerSize = constraints.constrainDimensions(0.0, 300.0);
    final double layerTop = layerSize.height - layerTitleHeight;

    Animation<RelativeRect> layerAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          0.0, layerTop, 0.0, layerTop - layerSize.height),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(_controller.view);

    return Stack(
      key: _backdropKey,
      children: <Widget>[
        widget.backLayer,
        PositionedTransition(
          rect: layerAnimation,
          child: _FrontLayer(
            onTap: _toggleBackdropLayerVisibility,
            child: widget.frontLayer,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var brandedIcon = Row(children: <Widget>[
      ImageIcon(AssetImage('assets/diamond.png')),
    ]);
    var appBar = AppBar(
      brightness: Brightness.light,
      elevation: 0.0,
      title: _BackdropTitle(
        listenable: _controller.view,
        frontTitle: Row(
          children: <Widget>[
            SizedBox(
              width: 60.0,
              child: IconButton(
                padding: EdgeInsets.only(left: 0.0),
                onPressed: _toggleBackdropLayerVisibility,
                icon: Icon(Icons.menu),
              ),
            ),
            new Center(child:  widget.frontTitle,)

          ],
        ),
        backTitle: IconButton(
          onPressed: _toggleBackdropLayerVisibility,
          icon: Icon(Icons.close),
        ),
      ),

    );
    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(builder: _buildStack),
    );
  }
}

class _FrontLayer extends StatelessWidget {
  const _FrontLayer({
    Key key,
    this.onTap,
    this.child,
  }) : super(key: key);

  final Widget child;

  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              color: Colors.white30,
              height: 40.0,
              alignment: AlignmentDirectional.center,
              child: new Text('Touch to Pull Down Menu',style: Theme.of(context).textTheme.caption,textAlign: TextAlign.center,),
            ),
          ),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

class _BackdropTitle extends AnimatedWidget {
  final Widget frontTitle;
  final Widget backTitle;

  const _BackdropTitle({
    Key key,
    Listenable listenable,
    this.frontTitle,
    this.backTitle,
  }) : super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = this.listenable;
    return DefaultTextStyle(
      style: Theme.of(context).primaryTextTheme.title,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      // Here, we do a custom cross fade between backTitle and frontTitle.
      // This makes a smooth animation between the two texts.
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: CurvedAnimation(
              parent: ReverseAnimation(animation),
              curve: Interval(0.5, 1.0),
            ).value,
            child: backTitle,
          ),
          Opacity(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Interval(0.5, 1.0),
            ).value,
            child: frontTitle,
          ),
        ],
      ),
    );
  }
}
