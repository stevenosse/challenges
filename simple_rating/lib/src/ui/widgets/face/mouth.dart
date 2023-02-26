import 'package:flutter/material.dart';
import 'package:simple_rating_app/src/constants/emotion.dart';

class Mouth extends StatefulWidget {
  const Mouth({super.key, required this.emotion, required this.color});

  final Emotion emotion;
  final Color color;

  @override
  State<Mouth> createState() => _MouthState();
}

class _MouthState extends State<Mouth> {
  late double _mouthHeight = 0;
  late double _mouthWidth = 0;

  late Size _size;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _size = MediaQuery.of(context).size;
      setState(() {
        _initMouthSize();
      });
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Mouth oldWidget) {
    if (oldWidget.emotion != widget.emotion) {
      _initMouthSize();
    }
    super.didUpdateWidget(oldWidget);
  }

  _initMouthSize() {
    switch (widget.emotion) {
      case Emotion.confuse:
        _mouthHeight = 100;
        _mouthWidth = 60;
        break;
      case Emotion.happy:
      case Emotion.sad:
        _mouthHeight = 60;
        _mouthWidth = _size.width * .35;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedContainer(
      height: _mouthHeight,
      width: _mouthWidth,
      margin: widget.emotion == Emotion.confuse
          ? EdgeInsets.only(left: size.width * .35)
          : EdgeInsets.only(left: size.width * .5 - _mouthWidth * .5),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(3, 7),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                boxShadow: [
                  BoxShadow(
                    color: widget.color,
                    blurRadius: 5,
                    spreadRadius: 3,
                  ),
                ],
              ),
            ),
            if (widget.emotion == Emotion.sad)
              OverflowBox(
                maxHeight: 25,
                maxWidth: 100,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) => const _Tooth()),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) => const _Tooth(isTop: true)),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}

class _Tooth extends StatelessWidget {
  const _Tooth({this.isTop = false});

  final bool isTop;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 15,
      margin: const EdgeInsets.symmetric(horizontal: 1.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: isTop
            ? const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              )
            : const BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
      ),
    );
  }
}
