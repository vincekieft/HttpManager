import 'package:http_manager/src/dto/request.dart';

abstract class IHttpAdapter<T> {
  Future<T> request(Request request);
}