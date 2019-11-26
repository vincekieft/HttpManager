import 'dart:async';
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

  HttpManager(this._adapter, this._handlers);

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

  Future<R> request<R>(Uri uri, String method, String body, Map<String, String> headers){
    Completer<R> completer = Completer<R>();

    send(Request(
        uri: uri,
        method: method,
        headers: headers,
        body: body,
        completer: completer
    ));

    return completer.future;
  }

  Future<void> send(Request request) async {
    try{
      dynamic response = await _adapter.request(request);
      _resolveRequest(request, response);
    } catch(e){ _handleException(e, request); }
  }


  // Private methods

  void _handleException(e, Request request){
    for(IExceptionHandler handler in _handlers){ // Search matching exception handler
      if(handler.shouldHandle(e)) return handler.handle(request, e, this);
    }

    // Failed to handle exception resolve and rethrow
    _resolveRequest(request, null);
    throw e;
  }

  void _resolveRequest(Request request, dynamic response){
    request.completer.complete(response);
  }

}