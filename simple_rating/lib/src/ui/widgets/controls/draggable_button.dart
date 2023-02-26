import 'package:flutter/material.dart';
import 'package:simple_rating_app/src/constants/emotion.dart';

class DraggableButton extends StatelessWidget {
  const DraggableButton({
    super.key,
    required this.child,
    required this.onEmotionChanged,
  });

  final Widget child;
  final ValueChanged<Emotion> onEmotionChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        final size = MediaQuery.of(context).size;
        final position = details.globalPosition;
        final emotion = position.dx / size.width;

        if (emotion < .33) {
          onEmotionChanged(Emotion.sad);
        } else if (emotion < .66) {
          onEmotionChanged(Emotion.confuse);
        } else {
          onEmotionChanged(Emotion.happy);
        }
      },
      child: child,
    );
  }
}