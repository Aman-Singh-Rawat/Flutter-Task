import 'package:get/get.dart';

class AppErrorController extends GetxController {
  final RxString _statusCode = "".obs;
  final RxString _errorMessage = "".obs;

  String get showStatusCode => _statusCode.value;
  String get showErrorMessage => _errorMessage.value;

  void setError({String? statusCode, String? errorMessage}) {
    _statusCode.value = statusCode ?? "";
    _errorMessage.value = errorMessage ?? "";
    update();
  }

  void clearError() {
    _statusCode.value = "";
    _errorMessage.value = "";
    update();
  }
}
