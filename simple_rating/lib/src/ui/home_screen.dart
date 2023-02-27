import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_rating_app/src/constants/color_constants.dart';
import 'package:simple_rating_app/src/constants/emotion.dart';
import 'package:simple_rating_app/src/ui/widgets/controls/bar.dart';
import 'package:simple_rating_app/src/ui/widgets/controls/circle.dart';
import 'package:simple_rating_app/src/ui/widgets/controls/draggable_button.dart';
import 'package:simple_rating_app/src/ui/widgets/face/eye.dart';
import 'package:simple_rating_app/src/ui/widgets/face/mouth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _colorAnimationController;
  late AnimationController _sizeAnimationController;
  late AnimationController _textAnimationController;

  late Animation<Color?> _colorAnimation;
  late Animation<double> _sizeAnimation;
  late Emotion _emotion;

  @override
  void initState() {
    _emotion = Emotion.sad;
    _sizeAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _sizeAnimation = Tween(begin: 0.0, end: 1.0).animate(_sizeAnimationController);
    _colorAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    _colorAnimation = TweenSequence([
      TweenSequenceItem(tween: ColorTween(begin: ColorConstants.orange, end: ColorConstants.yellow), weight: 1),
      TweenSequenceItem(tween: ColorTween(begin: ColorConstants.yellow, end: ColorConstants.green), weight: 1),
    ]).animate(_colorAnimationController);
    super.initState();
  }

  @override
  void dispose() {
    _colorAnimationController.dispose();
    _sizeAnimationController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AnimatedBuilder(
          animation: _colorAnimationController,
          builder: (context, child) {
            return AppBar(
              backgroundColor: _colorAnimation.value,
              elevation: 0,
              toolbarHeight: 0,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: _colorAnimation.value,
                statusBarIconBrightness: Brightness.light,
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        top: false,
        child: FractionallySizedBox(
          heightFactor: 1,
          widthFactor: 1,
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _colorAnimationController,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      color: _colorAnimation.value,
                    ),
                    child: child,
                  );
                },
              ),
              AnimatedBuilder(
                animation: _colorAnimationController,
                builder: (context, child) {
                  return AnimatedBuilder(
                    animation: _sizeAnimationController,
                    builder: (context, _) {
                      return OverflowBox(
                        maxWidth: ((size.height * 3) - (size.height * 3) * _sizeAnimation.value).abs(),
                        maxHeight: ((size.height * 3) - (size.height * 3) * _sizeAnimation.value).abs(),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10000),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              _sizeAnimationController.isAnimating ? Colors.black.withOpacity(.05) : Colors.transparent,
                              BlendMode.darken,
                            ),
                            child: Container(
                              decoration: BoxDecoration(color: _colorAnimation.value),
                              child: child,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, Colors.transparent],
                      ).createShader(Rect.fromLTRB(0, rect.height, rect.width, rect.height * .35));
                    },
                    blendMode: BlendMode.dstOut,
                    child: SlideInDown(
                      manualTrigger: true,
                      duration: const Duration(milliseconds: 500),
                      controller: (controller) {
                        _textAnimationController = controller;
                      },
                      child: Text(
                        () {
                          switch (_emotion) {
                            case Emotion.happy:
                              return 'Happy';
                            case Emotion.confuse:
                              return 'Confuse';
                            case Emotion.sad:
                              return 'Sad';
                          }
                        }(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: size.height * .2),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Eye(emotion: _emotion),
                          Eye(emotion: _emotion),
                        ],
                      ),
                      const SizedBox(height: 30),
                      AnimatedBuilder(
                        animation: _colorAnimationController,
                        builder: (context, _) {
                          return Mouth(
                            emotion: _emotion,
                            color: _colorAnimation.value!,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    FractionallySizedBox(
                      heightFactor: .2,
                      widthFactor: 1,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Bar(
                                color: _emotion == Emotion.sad ? Colors.black : Colors.grey[300],
                                onTap: () {
                                  _setEmotion(emotion: Emotion.sad);
                                },
                              ),
                              ...List.generate(3, (index) => const Circle()),
                              Bar(
                                color: _emotion == Emotion.confuse ? Colors.black : Colors.grey[300],
                                onTap: () {
                                  _setEmotion(emotion: Emotion.confuse);
                                },
                              ),
                              ...List.generate(3, (index) => const Circle()),
                              Bar(
                                color: _emotion == Emotion.happy ? Colors.black : Colors.grey[300],
                                onTap: () {
                                  _setEmotion(emotion: Emotion.happy);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      top: -45,
                      left: () {
                        switch (_emotion) {
                          case Emotion.happy:
                            return size.width - 116.0;
                          case Emotion.confuse:
                            return size.width / 2 - 50;
                          case Emotion.sad:
                            return 16.0;
                        }
                      }(),
                      duration: const Duration(milliseconds: 300),
                      child: DraggableButton(
                        onEmotionChanged: (emotion) {
                          _setEmotion(emotion: emotion);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          width: 100,
                          height: 100,
                          child: AnimatedBuilder(
                            animation: _colorAnimationController,
                            builder: (context, _) {
                              return Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _colorAnimation.value,
                                  shape: BoxShape.circle,
                                ),
                                child: const RotatedBox(
                                  quarterTurns: 3,
                                  child: Icon(
                                    Icons.drag_handle,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _setEmotion({required Emotion emotion}) {
    setState(() {
      _emotion = emotion;
    });
    switch (emotion) {
      case Emotion.happy:
        _colorAnimationController.animateTo(1.0);
        _sizeAnimationController.forward(from: 0.0);
        _textAnimationController.forward(from: 0.0);
        break;
      case Emotion.confuse:
        _sizeAnimationController.forward(from: 0.0);
        _colorAnimationController.animateTo(.35);
        _textAnimationController.forward(from: 0.0);
        break;
      case Emotion.sad:
        _sizeAnimationController.forward(from: 0.0);
        _colorAnimationController.animateTo(0);
        _textAnimationController.forward(from: 0.0);
        break;
    }
  }
}
