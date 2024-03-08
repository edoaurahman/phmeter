import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phmeter/app/modules/home/views/widget/water.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                controller.tempColor(controller.temp()),
                Colors.white
              ]),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      controller.welcomeMessage(),
                      style: const TextStyle(
                          fontSize: 28,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const CircleAvatar(
                        minRadius: 16,
                        backgroundImage: AssetImage("assets/images/user.webp"))
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0),
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "Clock",
                            style: TextStyle(
                                height: 1.1,
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          Center(
                              child: Text(
                            DateFormat('hh:mm').format(DateTime.now()),
                            style:
                                TextStyle(color: Colors.red[400], fontSize: 70),
                          )),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Data",
                                style: TextStyle(
                                    height: 1.1,
                                    fontSize: 17,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                    height: Get.height * 0.5,
                                    width: 100,
                                    child: Thermo(
                                        curve: Curves.bounceIn,
                                        color: controller
                                            .tempColor(controller.temp()),
                                        value: controller.temp(),
                                        duration: const Duration(seconds: 1))),
                                SizedBox(
                                    height: 450,
                                    child: LightsScreen(
                                      title: 'PH',
                                      min: 0,
                                      max: 20,
                                      value: controller.phSliderData.value,
                                    )),
                                SizedBox(
                                    height: 450,
                                    child: LightsScreen(
                                      title: 'PPM',
                                      min: 0,
                                      max: 2000,
                                      value: controller.ppmSliderData.value,
                                    )),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "SUHU: ${(controller.tempLabel()).toString()}°C",
                                style: const TextStyle(
                                    height: 1.1,
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "PH: ${controller.phSliderData() < 0 ? 0 : controller.phSliderData()}",
                                style: const TextStyle(
                                    height: 1.1,
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "PPM: ${controller.ppm < 0 ? 0 : controller.ppm}",
                                style: const TextStyle(
                                    height: 1.1,
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class Thermo extends ImplicitlyAnimatedWidget {
  const Thermo({
    super.key,
    super.curve,
    required this.color,
    required this.value,
    required super.duration,
    super.onEnd,
  });

  final Color color;
  final double value;

  @override
  AnimatedWidgetBaseState<Thermo> createState() => _ThermoState();
}

class _ThermoState extends AnimatedWidgetBaseState<Thermo> {
  ColorTween? _color;
  Tween<double>? _value;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FittedBox(
        child: CustomPaint(
          size: const Size(18, 63),
          painter: _ThermoPainter(
            color: _color!.evaluate(animation)!,
            value: _value!.evaluate(animation),
          ),
        ),
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _color = visitor(_color, widget.color, (dynamic v) => ColorTween(begin: v))
        as ColorTween?;
    _value =
        visitor(_value, widget.value, (dynamic v) => Tween<double>(begin: v))
            as Tween<double>?;
  }
}

class _ThermoPainter extends CustomPainter {
  _ThermoPainter({
    required this.color,
    required this.value,
  });

  final Color color;
  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    const bulbRadius = 6.0;
    const smallRadius = 3.0;
    const border = 1.0;
    final rect = (Offset.zero & size);
    final innerRect = rect.deflate(size.width / 2 - bulbRadius);
    final r1 = Alignment.bottomCenter
        .inscribe(const Size(2 * smallRadius, bulbRadius * 2), innerRect);
    final r2 = Alignment.center
        .inscribe(Size(2 * smallRadius, innerRect.height), innerRect);

    final bulb = Path()
      ..addOval(Alignment.bottomCenter
          .inscribe(Size.square(innerRect.width), innerRect));
    final outerPath = Path()
      ..addOval(Alignment.bottomCenter
          .inscribe(Size.square(innerRect.width), innerRect)
          .inflate(border))
      ..addRRect(RRect.fromRectAndRadius(r2, const Radius.circular(smallRadius))
          .inflate(border));

    final scaleRect = Rect.fromPoints(innerRect.topLeft,
        innerRect.bottomRight - const Offset(0, 2 * bulbRadius));
    Iterable<Offset> generatePoints() sync* {
      for (int i = 0; i < 11; i++) {
        final t = i / 10;
        final point = i.isOdd
            ? Offset.lerp(scaleRect.bottomLeft, scaleRect.topLeft, t)!
            : Offset.lerp(scaleRect.bottomRight, scaleRect.topRight, t)!;
        yield point;
        yield point.translate(i.isOdd ? 2 : -2, 0);
      }
    }

    final valueRect = Rect.lerp(r1, r2, value)!;
    final valuePaint = Paint()..color = color;

    canvas
      ..save()
      // draw scale
      ..drawPoints(
          PointMode.lines,
          generatePoints().toList(),
          Paint()
            ..color = Colors.black45
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1)
      // draw shadow
      ..drawPath(
          outerPath.shift(const Offset(1, 1)),
          Paint()
            ..color = Colors.black54
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1))
      ..clipPath(outerPath)
      // draw background
      ..drawPaint(Paint()..color = Color.alphaBlend(Colors.white60, color))
      // draw foreground
      ..drawPath(bulb, valuePaint)
      ..drawRRect(
          RRect.fromRectAndRadius(
              valueRect, const Radius.circular(smallRadius)),
          valuePaint)
      ..restore();

    // debug only:

    // canvas.drawRect(rect, Paint()..color = Colors.black38);
    // canvas.drawRect(innerRect, Paint()..color = Colors.black38);
    // canvas.drawRect(valueRect, Paint()..color = Colors.black38);
    // canvas.drawRect(scaleRect, Paint()..color = Colors.black38);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
