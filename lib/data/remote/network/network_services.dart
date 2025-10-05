// ignore_for_file: file_names, avoid_print, non_constant_identifier_names, avoid_renaming_method_parameters, deprecated_member_use, depend_on_referenced_packages, unnecessary_import
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_task/data/remote/errors/error_controller.dart';
import 'package:flutter_task/data/remote/errors/exception.dart';
import 'package:flutter_task/data/remote/network/base_api_services.dart';
import 'package:flutter_task/presentation/widgets/customToast.dart';
import 'package:flutter_task/utils/logger.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

Map<String, String> header = {"Accept": "application/json"};

class NetworkApiServices extends BaseApiServices {
  final AppErrorController appErrorController = Get.put(AppErrorController());
  Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    return connectivityResult[0] != ConnectivityResult.none;
  }

  @override
  Future GetApiRequest(
    String url, {
    Function? success,
    Function? failure,
  }) async {
    dynamic responseJson;

    try {
      bool isConnected = await checkConnectivity();
      if (!isConnected) {
        Toasts.getErrorToast(text: "No internet connection is available.");
        return;
      }

      log('API Request Start', name: 'Get request');
      log('$header', name: 'Header');

      final response = await Dio()
          .get(
            url,
            options: Options(headers: header),
            onReceiveProgress: (int received, int total) {},
          )
          .timeout(const Duration(seconds: 10));

      Logger.printSuccess('$response');
      log('API Request End', name: 'Get request');

      responseJson = returnResponse(response);
      appErrorController.clearError();
      success!(responseJson);
      return responseJson;
    } on DioError catch (error) {
      if (error.response != null) {
        log('Error Response::', name: 'API Request Error');
        Logger.printError('${error.response}');
        final errorMessage = error.response!.data?['message'];
        if (errorMessage != null) {
          if (errorMessage ==
              'Your account has been logged into on another device.') {
            Logger.printError(
              'Your account has been logged into on another device.',
            );
            return;
          }

          log('Error Message: $errorMessage', name: 'API Request Error');
          appErrorController.setError(
            statusCode: error.response?.statusCode.toString() ?? "",
            errorMessage: errorMessage.toString(),
          );
          failure?.call(errorMessage.toString());
        }
      } else {
        log('DioError: $error', name: 'API Request Error');
        failure?.call('Something went wrong.');
      }
    } catch (error) {
      log('Error: $error', name: 'API Request Error');

      failure?.call('Something went wrong.');
    }
  }

  dynamic returnResponse(dynamic response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        dynamic responseJson = response.data;

        if (responseJson is Map<String, dynamic>) {
          appErrorController.setError(
            statusCode: response.statusCode.toString(),
            errorMessage: responseJson["message"]?.toString() ?? "",
          );
        } else {
          appErrorController.setError(
            statusCode: response.statusCode.toString(),
            errorMessage: responseJson.toString(),
          );
        }

        return responseJson;
      case 400:
        dynamic responseJson = response.data;
        appErrorController.setError(
          statusCode: response.statusCode.toString(),
          errorMessage: responseJson["message"].toString(),
        );
        print(response.statusCode);
        throw BadRequestException(
          responseJson["message"].toString(),
          response.statusCode,
        );

      case 401:
        dynamic responseJson = response.data;
        appErrorController.setError(
          statusCode: response.statusCode.toString(),
          errorMessage: responseJson["message"].toString(),
        );

        throw UnauthorizedException(response.data);

      case 404:
        dynamic responseJson = response.data;
        appErrorController.setError(
          statusCode: response.statusCode.toString(),
          errorMessage: responseJson["message"].toString(),
        );
        throw UnauthorizedException(response.data);
      case 500:
        dynamic responseJson = response.data;
        appErrorController.setError(
          statusCode: response.statusCode.toString(),
          errorMessage: responseJson["message"].toString(),
        );
        throw SomethingWentWrong("Something went wrong");
      default:
        throw FetchDataException(
          'Error occurred while communicating with server with status code ${response.statusCode}',
        );
    }
  }
}
