// ignore_for_file: avoid_print, file_names

import 'package:flutter_task/data/remote/network/app_url.dart';
import 'package:flutter_task/data/remote/network/base_api_services.dart';
import 'package:flutter_task/data/remote/network/network_services.dart';

class PostRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> fetchPostListing(successCallback, failureCallback) async {
    try {
      dynamic response = await _apiServices.GetApiRequest(
        AppUrls.postListApi,
        success: successCallback,
        failure: failureCallback,
      );

      return response;
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> fetchPostData(
    successCallback,
    failureCallback,
    postId,
  ) async {
    try {
      dynamic response = await _apiServices.GetApiRequest(
        '${AppUrls.postListApi}/$postId',
        success: successCallback,
        failure: failureCallback,
      );

      return response;
    } catch (e) {
      print(e);
    }
  }
}
