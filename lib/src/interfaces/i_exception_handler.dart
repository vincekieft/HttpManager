import 'package:http_manager/http_manager.dart';

abstract class IExceptionHandler {
  Future<bool> shouldHandle(exception);
  void handle(IRequest request, exception, HttpManager manager);
}