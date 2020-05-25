import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ui_challenge_cooking/models/food.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController _controller;
  int currentIndex = 1;

  // 플레이트 애니메이션 변수
  Animation<double> _clockWiseRotationAnimation;
  Animation<double> _antiClockWiseRotationAnimation;
  Tween<double> _antiClockWiseRotationTween;
  Tween<double> _clockWiseRotationTween;
  bool isClockwise = false;
  double rotationValue = 0.0;

  // 배경 애니메이션
  bool isBgBlack = false;
  double blackBgHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _clockWiseRotationTween = Tween<double>(end: 2 * pi);
    _clockWiseRotationAnimation = _clockWiseRotationTween.animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _antiClockWiseRotationTween = Tween<double>(end: -2 * pi);
    _antiClockWiseRotationAnimation = _clockWiseRotationTween.animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    )..addListener(() {
        setState(() {
          rotationValue = isClockwise
              ? _clockWiseRotationAnimation.value
              : _antiClockWiseRotationAnimation.value;
        });
      });
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
              children: <Widget>[
                _buildBlackBg(),
                _buildPlate(),
                _buildGestureDetection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBlackBg() {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: AnimatedContainer(
        color: Color(0xFF384450),
        height: blackBgHeight,
        duration: Duration(milliseconds: 400),
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
          child: Transform.rotate(
            angle: rotationValue,
            child: Image.asset(
              foodList[currentIndex].foodAssetsPath,
              width: 180,
              height: 250,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGestureDetection() {
    return Positioned(
      top: 0,
      bottom: 0,
      right: 0,
      left: MediaQuery.of(context).size.width / 2,
      child: GestureDetector(
        onVerticalDragStart: _onVerticalDragStart,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
      ),
    );
  }

  void _onVerticalDragStart(DragStartDetails details) {}
  void _onVerticalDragUpdate(DragUpdateDetails details) {
    print(details.delta.dy);
    isClockwise = details.delta.dy < 0;
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    rotationValue = 0.0;
    _antiClockWiseRotationTween.begin = rotationValue;
    _clockWiseRotationTween.begin = rotationValue;

    if (!_controller.isAnimating) {
      _controller.forward(from: 0.0);
      isBgBlack = !isBgBlack;
      setState(() {
        blackBgHeight = isBgBlack ? MediaQuery.of(context).size.height : 0.0;
      });
    }

    _changeFood();
  }

  void _changeFood() {
    setState(() {
      if (!isClockwise) {
        currentIndex =
            currentIndex < foodList.length - 1 ? currentIndex + 1 : 0;
      } else {
        currentIndex =
            currentIndex > 0 ? currentIndex - 1 : foodList.length - 1;
      }
    });
  }
}
