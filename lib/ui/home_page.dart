import 'package:flutter/material.dart';
import 'package:ui_challenge_cooking/models/food.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController _controller;
  int currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, widget) {
          return Container(
            color: Color(0xFFF1F1F3),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[_buildPlate()],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlate() {
    //
    return Container(
      child: Transform.translate(
        offset: Offset(80, 0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Image.asset(
            foodList[currentIndex].foodAssetsPath,
            width: 180,
            height: 250,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
