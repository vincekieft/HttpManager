import 'dart:async';
import 'package:http_manager/src/dto/response.dart';

class Request {

  final Uri uri;
  final String method;
  final Map<String, String> headers;
  final Completer<Response> completer;
  final String body;

  Request({
    this.uri,
    this.method,
    this.headers,
    this.body,
    this.completer
  });

}