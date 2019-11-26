import 'package:http_manager/src/dto/request.dart';
import 'package:http_manager/src/dto/response.dart';

abstract class IHttpAdapter {
  Future<Response> request(Request request);
}