import 'package:flutter/material.dart';
import 'package:simple_rating_app/src/constants/emotion.dart';

class Eye extends StatefulWidget {
  const Eye({super.key, required this.emotion});

  final Emotion emotion;

  @override
  State<Eye> createState() => _EyeState();
}

class _EyeState extends State<Eye> {
  late double _pupilTop;
  late double _pupilLeft;

  late double _pupilLightTop;
  late double _pupilLightLeft;

  late double _cristalinTopPadding;

  @override
  void initState() {
    _initPupilPosition();
    super.initState();
  }

  void _initPupilPosition() {
    switch (widget.emotion) {
      case Emotion.happy:
        _pupilTop = 50;
        _pupilLeft = 45;

        _pupilLightLeft = 52;
        _pupilLightTop = 53.5;

        _cristalinTopPadding = 50;
        break;
      case Emotion.confuse:
        _pupilTop = 20;
        _pupilLeft = 20;

        _pupilLightLeft = 30;
        _pupilLightTop = 30;

        _cristalinTopPadding = 0;
        break;
      case Emotion.sad:
        _pupilTop = 45;
        _pupilLeft = 45;

        _pupilLightLeft = 55;
        _pupilLightTop = 55;

        _cristalinTopPadding = 20;
        break;
    }
  }

  @override
  void didUpdateWidget(covariant Eye oldWidget) {
    if (oldWidget.emotion != widget.emotion) {
      _initPupilPosition();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.only(top: _cristalinTopPadding),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 5,
                  offset: Offset(3, 7),
                ),
              ],
            ),
          ),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.black.withOpacity(0.0),
                  Colors.black.withOpacity(0.2),
                ],
                center: const AlignmentDirectional(0.0, -0.1),
                focal: const AlignmentDirectional(0.0, -.05),
                radius: 0.6,
                focalRadius: 0.001,
                stops: const [0.75, 1.0],
              ),
            ),
          ),
          AnimatedPositioned(
            left: _pupilLeft,
            top: _pupilTop,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
          AnimatedPositioned(
            left: _pupilLightLeft,
            top: _pupilLightTop,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
