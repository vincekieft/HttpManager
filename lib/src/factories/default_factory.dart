import 'dart:async';
import 'package:http_manager/src/dto/request.dart';
import 'package:http_manager/src/factories/i_request_factory.dart';

class DefaultFactory implements IRequestFactory {

  const DefaultFactory();

  @override
  Future<Request> create(Uri uri, String method, String body, Map<String, String> headers, Completer completer) async {
    return Request(
        uri: uri,
        method: method,
        headers: headers,
        body: body,
        completer: completer
    );
  }

}