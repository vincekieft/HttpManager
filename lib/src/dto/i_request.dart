import 'dart:async';

abstract class IRequest {
  Uri get uri;
  String get method;
  Map<String, String> get headers;
  Completer get completer;
  String get body;
}