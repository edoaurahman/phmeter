import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phmeter/app/modules/home/controllers/home_controller.dart';
import 'package:phmeter/app/modules/home/views/utils/app_spaces.dart';

class LightsScreen extends GetView<HomeController> {
  final String title;
  final double min, max, value;

  const LightsScreen(
      {Key? key,
      required this.title,
      required this.min,
      required this.max,
      required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Column(children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w200,
          ),
        ),
        AppSpaces.vertical10,
        AppSpaces.vertical10,
        Expanded(
          child: RotatedBox(
            quarterTurns: 3,
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: Get.theme.primaryColor,
                inactiveTrackColor: Get.theme.disabledColor,
                thumbColor: Colors.transparent,
                overlayColor: Colors.transparent,
                thumbSelector: (textDirection, values, tapValue, thumbSize,
                        trackSize, dx) =>
                    Thumb.start,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 1,
                  elevation: 0.0,
                ),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 1),
                trackHeight: Get.width / 6,
                // trackShape: CustomRoundedRectSliderTrackShape(const Radius.circular(12),
              ),
              child: Slider(
                onChanged: (value) => {},
                min: min,
                max: max,
                value: value,
              ),
            ),
          ),
        ),
        AppSpaces.vertical20,
        AppSpaces.vertical20,
      ]),
    );
  }
}

class CustomRoundedRectSliderTrackShape with BaseSliderTrackShape {
  final Radius trackRadius;
  CustomRoundedRectSliderTrackShape(this.trackRadius);

  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledInactiveTrackColor,
        end: sliderTheme.inactiveTrackColor);
    final Paint leftTrackPaint = Paint()
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint rightTrackPaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    var activeRect = RRect.fromLTRBAndCorners(
      trackRect.left,
      trackRect.top - (additionalActiveTrackHeight / 2),
      thumbCenter.dx,
      trackRect.bottom + (additionalActiveTrackHeight / 2),
      topLeft: trackRadius,
      bottomLeft: trackRadius,
    );
    var inActiveRect = RRect.fromLTRBAndCorners(
      thumbCenter.dx,
      trackRect.top,
      trackRect.right,
      trackRect.bottom,
      topRight: trackRadius,
      bottomRight: trackRadius,
    );
    var percent =
        ((activeRect.width / (activeRect.width + inActiveRect.width)) * 100)
            .toInt();
    if (percent > 99) {
      activeRect = RRect.fromLTRBAndCorners(
        trackRect.left,
        trackRect.top - (additionalActiveTrackHeight / 2),
        thumbCenter.dx,
        trackRect.bottom + (additionalActiveTrackHeight / 2),
        topLeft: trackRadius,
        bottomLeft: trackRadius,
        bottomRight: trackRadius,
        topRight: trackRadius,
      );
    }

    if (percent < 1) {
      inActiveRect = RRect.fromLTRBAndCorners(
        thumbCenter.dx,
        trackRect.top,
        trackRect.right,
        trackRect.bottom,
        topRight: trackRadius,
        bottomRight: trackRadius,
        bottomLeft: trackRadius,
        topLeft: trackRadius,
      );
    }
    context.canvas.drawRRect(
      activeRect,
      leftTrackPaint,
    );

    context.canvas.drawRRect(
      inActiveRect,
      rightTrackPaint,
    );

    drawText(context.canvas, '%$percent', activeRect.center.dx,
        activeRect.center.dy, pi * 0.5, activeRect.width);
  }

  void drawText(Canvas context, String name, double x, double y,
      double angleRotationInRadians, double height) {
    context.save();
    var span = TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: height >= 24.0 ? 24.0 : height),
        text: name);
    var tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    context.translate((x + (tp.height * 0.5)), (y - (tp.width * 0.5)));
    context.rotate(angleRotationInRadians);
    tp.layout();
    tp.paint(context, const Offset(0.0, 0.0));
    context.restore();
  }
}
