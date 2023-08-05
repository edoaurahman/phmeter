import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:phmeter/app/modules/home/TempModel.dart';
import 'package:phmeter/config.dart';

class HomeProvider extends GetConnect {
  @override
  void onInit() {
    var env = ConfigEnvironments.getEnvironments();
    httpClient.baseUrl = env['url'];
    httpClient.defaultContentType = "application/json";
    httpClient.addRequestModifier((Request request) async {
      return request;
    });
  }

  Future<temp_model> getTemp() async {
    final response = await get("phmeter.php?getFirst");

    return temp_model.fromJson(response.body[0]);
  }
}
