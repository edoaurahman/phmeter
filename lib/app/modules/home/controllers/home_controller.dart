import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';
import 'package:phmeter/app/modules/home/providers/home_provider.dart';

@pragma("vm:entry-point")
void backgroundCallback(Uri? data) async {
  double temp = 0.0;
  double ph = 0.0;
  double ppm = 0.0;
  final provider = Get.put(HomeProvider());
  var res = await provider.getTemp();
  temp = double.parse(res.temp!);
  ph = double.parse(res.ph!);
  ppm = double.parse(res.ppm!);

  HomeWidget.saveWidgetData<String>('suhu', 'SUHU : ${temp.toString()}°');
  HomeWidget.saveWidgetData<String>('ph', 'PH : ${ph.toString()}');
  HomeWidget.saveWidgetData<String>('ppm', 'PPM : ${ppm.toString()}');
  HomeWidget.updateWidget(
    name: "MonitorWidget",
    androidName: "MonitorWidget",
    qualifiedAndroidName: "com.edoaurahman.phmeter.MonitorWidget",
  );
  Get.delete<HomeProvider>();
}

class HomeController extends GetxController {
  var switchData = true.obs;
  var index = 0.obs;
  var phSliderData = 0.0.obs;
  var ppmSliderData = 0.0.obs;

  final provider = Get.put(HomeProvider());

  final count = 0.obs;

  Rx<double> temp = 0.1.obs;

  Rx<double> tempLabel = 0.1.obs;

  final Rx<double> _ppm = 0.0.obs;

  Rx<double> get ppm => _ppm;

  @override
  void onInit() {
    getTemp();
    Timer.periodic(const Duration(seconds: 20), (timer) {
      getTemp();
    });
    HomeWidget.setAppGroupId("1");
    HomeWidget.registerBackgroundCallback(backgroundCallback);
    super.onInit();
  }



  void increment() => count.value++;

  getTemp() async {
    var res = await provider.getTemp();
    temp.value = double.parse((double.parse(res.temp!) / 50).toString());
    tempLabel.value = double.parse(res.temp!);
    _ppm.value = double.parse(res.ppm!);
    phSliderData.value = double.parse(res.ph!);
    ppmSliderData.value = double.parse(res.ppm!);
  }

  Color tempColor(double value) {
    Color result = Colors.green;
    if (value >= 0.8) {
      return Colors.red[900]!;
    }
    if (value >= 0.7) {
      return Colors.red[400]!;
    }
    if (value >= 0.6) {
      return const Color(0xFFFFC400);
    }
    if (value >= 0.5) {
      return const Color(0xFE61FF12);
    }
    if (value >= 0.4) {
      return const Color(0xfE43A047);
    }
    if (value >= 0.3) {
      return Colors.green[400]!;
    }
    if (value >= 0.2) {
      return Colors.green[300]!;
    }
    if (value >= 0.1) {
      return Colors.green[100]!;
    }
    return result;
  }

  String welcomeMessage() {
    // Welcome time message
    if (DateTime.now().hour < 12) {
      return "Selamat Pagi";
    }
    if (DateTime.now().hour < 17) {
      return "Selamat Siang";
    }
    if (DateTime.now().hour < 20) {
      return "Selamat Sore";
    }
    if (DateTime.now().hour < 23) {
      return "Selamat Malam";
    }
    return "Selamat Pagi";
  }
}
