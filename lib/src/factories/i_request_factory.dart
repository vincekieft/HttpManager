import 'dart:async';
import 'package:http_manager/http_manager.dart';

abstract class IRequestFactory {
  Future<Request> create(Uri uri, String method, String body, Map<String, String> headers, Completer completer);
}
