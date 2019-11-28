import 'dart:async';
import 'package:http_manager/src/factories/default_factory.dart';
import 'package:http_manager/src/factories/i_request_factory.dart';
import 'package:http_manager/src/interfaces/i_exception_handler.dart';
import 'package:http_manager/src/interfaces/i_http_adapter.dart';
import 'dto/request.dart';


class HttpManager{

  // Statics
  static const String GET = 'GET';
  static const String POST = 'POST';
  static const String PUT = 'PUT';
  static const String DELETE = 'DELETE';

  // Variables
  final IHttpAdapter _adapter;
  final List<IExceptionHandler> _handlers;
  final IRequestFactory _factory;

  HttpManager(this._adapter, this._handlers, {
    IRequestFactory factory = const DefaultFactory()
  }) : _factory = factory;

  // Public methods
  Future<R> get<R>(Uri uri, {Map<String, String> headers}) {
    return request<R>(uri, GET, null, headers);
  }

  Future<R> post<R>(Uri uri, String body, {Map<String, String> headers}) {
    return request<R>(uri, POST, body, headers);
  }

  Future<R> put<R>(Uri uri, String body, {Map<String, String> headers}) {
    return request<R>(uri, PUT, body, headers);
  }

  Future<R> delete<R>(Uri uri, {Map<String, String> headers}) {
    return request<R>(uri, DELETE, null, headers);
  }

  Future<R> request<R>(Uri uri, String method, String body, Map<String, String> headers) async {
    Completer<R> completer = Completer<R>();
    Request request = await _factory.create(uri, method, body, headers, completer);
    send(request);
    return completer.future;
  }

  Future<void> send(Request request) async {
    try{
      dynamic response = await _adapter.request(request);
      _resolveRequest(request, response);
    } catch(e){ await _handleException(e, request); }
  }

  // Private methods

  Future<void> _handleException(e, Request request) async {
    for(IExceptionHandler handler in _handlers){ // Search matching exception handler
      if(await handler.shouldHandle(e)) return handler.handle(request, e, this);
    }

    throw e;
  }

  void _resolveRequest(Request request, dynamic response){
    request.completer.complete(response);
  }

}