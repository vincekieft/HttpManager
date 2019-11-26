import 'package:http_manager/http_manager.dart';
import 'package:http_manager/src/dto/request.dart';

abstract class IExceptionHandler {
  bool shouldHandle(Exception exception);
  void handle(Request request, Exception exception, HttpManager manager);
}