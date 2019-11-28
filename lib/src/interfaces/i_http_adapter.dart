import 'package:http_manager/src/dto/i_request.dart';

abstract class IHttpAdapter<T> {
  Future<T> request(IRequest request);
}