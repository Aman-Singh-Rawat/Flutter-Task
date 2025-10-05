// ignore_for_file: unused_field
class AppExceptions implements Exception {
  final String? _prefix, _message, _status;

  AppExceptions([this._message, this._status, this._prefix]);

  @override
  String toString() {
    return "$_prefix: $_message";
  }
}

class FetchDataException extends AppExceptions {
  FetchDataException([String? message, status])
    : super(message, status, "no Internet");
}

class SomethingWentWrong extends AppExceptions {
  SomethingWentWrong([String? message, status])
    : super(message, status, "Something went wrong");
}

class ServerTimeOut extends AppExceptions {
  ServerTimeOut([String? message]) : super(message, "server Timeout");
}

class BadRequestException extends AppExceptions {
  BadRequestException([String? message, status])
    : super(message, status, "Bad Request Exception");
}

class InvalidInputException extends AppExceptions {
  InvalidInputException([String? message])
    : super(message, "Invalid input Exception Exception");
}

class UnauthorizedException extends AppExceptions {
  UnauthorizedException([String? message])
    : super(message, "Unauthorized Exception");
}
