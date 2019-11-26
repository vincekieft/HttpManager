import 'dart:async';
import 'package:http_manager/src/interfaces/i_exception_handler.dart';
import 'package:http_manager/src/interfaces/i_http_adapter.dart';
import 'dto/request.dart';
import 'dto/response.dart';

/// 1. Do requests
/// 2. On Success (Done)
/// 3. On failure, group failing requests with matching error
/// 4. Handle fault as group

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
  Future<Response> get(Uri uri, {Map<String, String> headers}) {
    return request(uri, GET, null, headers);
  }

  Future<Response> post(Uri uri, String body, {Map<String, String> headers}) {
    return request(uri, POST, body, headers);
  }

  Future<Response> put(Uri uri, String body, {Map<String, String> headers}) {
    return request(uri, PUT, body, headers);
  }

  Future<Response> delete(Uri uri, {Map<String, String> headers}) {
    return request(uri, DELETE, null, headers);
  }

  Future<Response> request(Uri uri, String method, String body, Map<String, String> headers){
    Completer<Response> completer = Completer<Response>();

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
      Response response = await _adapter.request(request);
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

  void _resolveRequest(Request request, Response response){
    request.completer.complete(response);
  }

}