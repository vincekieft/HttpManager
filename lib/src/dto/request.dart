import 'dart:async';
import 'i_request.dart';

class Request implements IRequest {

  final Uri uri;
  final String method;
  final Map<String, String> headers;
  final Completer completer;
  final String body;

  Request({
    this.uri,
    this.method,
    this.headers,
    this.body,
    this.completer
  });

}