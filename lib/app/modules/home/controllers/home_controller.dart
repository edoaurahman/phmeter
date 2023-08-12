import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';
import 'package:phmeter/app/modules/home/providers/home_provider.dart';

@pragma("vm:entry-point")
void backgroundCallback(Uri? data) async {
  double _temp = 0.0;
  double _ph = 0.0;
  double _ppm = 0.0;
  final provider = Get.put(HomeProvider());
  var res = await provider.getTemp();
  _temp = double.parse(res.temp!);
  _ph = double.parse(res.ph!);
  _ppm = double.parse(res.ppm!);

  HomeWidget.saveWidgetData<String>('suhu', 'SUHU : ${_temp.toString()}°');
  HomeWidget.saveWidgetData<String>('ph', 'PH : ${_ph.toString()}');
  HomeWidget.saveWidgetData<String>('ppm', 'PPM : ${_ppm.toString()}');
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

  Rx<double> _temp = 0.1.obs;

  Rx<double> get temp => _temp;

  Rx<double> _tempLabel = 0.1.obs;

  Rx<double> get tempLabel => _tempLabel;

  Rx<double> _ppm = 0.0.obs;

  Rx<double> get ppm => _ppm;

  set tempLabel(Rx<double> value) {
    _tempLabel = value;
  }

  set temp(Rx<double> value) {
    _temp = value;
  }

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

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  getTemp() async {
    var res = await provider.getTemp();
    _temp.value = double.parse((double.parse(res.temp!) / 50).toString());
    _tempLabel.value = double.parse(res.temp!);
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
