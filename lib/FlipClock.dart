import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

// ignore: must_be_immutable
class FlipBoard extends StatefulWidget {
  /// This Widget form the animation of the flip clock
  FlipBoard({
    Key? key,
    required this.duration,
    required this.initialValue,
    required this.finalValue,
    required this.type,
  }) : super(key: key);

  Duration duration;
  String initialValue;
  String finalValue;
  String type;
  // type be either seconds, minutes, hours
  @override
  State<FlipBoard> createState() => _FlipBoardState();
}

class _FlipBoardState extends State<FlipBoard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  double pi = 22 / 7;

  String intialValue = "00";
  String finalValue = "00";
  bool flip = false;

  @override
  void initState() {
    super.initState();
    intialValue = widget.initialValue;
    finalValue = widget.finalValue;
    var oldValue = DateTime.now();

    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.forward();
    _animation = Tween(begin: 0.0, end: pi).animate(_controller);

    _controller.addListener(() {});

    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        // ignore: prefer_typing_uninitialized_variables
        var now;

        var datetime = DateTime.now();
        if (widget.type == "seconds") {
          now = datetime.second;
        } else if (widget.type == "minutes") {
          now = datetime.minute;
        } else if (widget.type == "hours") {
          now = datetime.hour;
        }
        if (datetime.minute != oldValue.minute && widget.type == "minutes") {
          log("minute changed");
          oldValue = datetime;
          intialValue = finalValue;
          finalValue = now.toString().length == 1 ? "0$now" : now.toString();
          flip = true;
        } else if (datetime.hour != oldValue.hour && widget.type == "hours") {
          log("hour changed");
          oldValue = datetime;
          intialValue = finalValue;
          finalValue = now.toString().length == 1 ? "0$now" : now.toString();
          flip = true;
        }
      });
      if (flip) {
        _controller.reset();
        _controller.forward();
        flip = false;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TweenAnimationBuilder(
            duration: const Duration(seconds: 4),
            tween: Tween<double>(begin: 0, end: 0),
            builder: (context, dynamic value, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.003)
                  ..rotateX(value),
                alignment: Alignment.bottomCenter,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: 0.5,
                    child: textblock(context, finalValue),
                  ),
                ),
              );
            },
          ),
          Container(
            height: 2,
            color: Colors.black,
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.003)
                  ..rotateX(0),
                alignment: Alignment.topCenter,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 0.5,
                    child: textblock(context, intialValue),
                  ),
                ),
              );
            },
          ),
        ]),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.003)
                  ..rotateX(
                      _animation.value > pi / 2 ? pi / 2 : _animation.value),
                alignment: Alignment.bottomCenter,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: 0.5,
                    child: textblock(context, intialValue),
                  ),
                ),
              );
            },
          ),
          Container(
            height: 2,
            color: Colors.black,
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.003)
                  ..rotateX(_animation.value > pi / 2
                      ? _animation.value - pi
                      : -pi / 2),
                alignment: Alignment.topCenter,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 0.5,
                    child: textblock(context, finalValue),
                  ),
                ),
              );
            },
          ),
        ]),
      ],
    );
  }
}

Widget textblock(BuildContext context, String i, {Color color = Colors.black}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: const Color(0xff0e0e0e),
    ),
    child: Text(
      i.toString(),
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      textScaleFactor: 15,
    ),
  );
}
