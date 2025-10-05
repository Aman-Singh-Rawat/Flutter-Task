// ignore_for_file: non_constant_identifier_names, file_names

abstract class BaseApiServices {
  Future<dynamic> GetApiRequest(
    String url, {
    Function? success,
    Function? failure,
  });
}
