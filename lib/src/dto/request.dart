import 'dart:async';

class Request {

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