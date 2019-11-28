import 'dart:async';
import 'package:http_manager/src/dto/i_request.dart';

abstract class IRequestFactory {
  Future<IRequest> create(Uri uri, String method, String body, Map<String, String> headers, Completer completer);
}
