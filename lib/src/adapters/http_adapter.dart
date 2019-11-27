import 'package:http_manager/src/adapters/base_adapters/persistent_connection_adapter.dart';
import 'package:http_manager/src/dto/request.dart';
import 'package:http/http.dart' as http;

class HttpAdapter extends PersistentConnectionAdapter<http.Client, http.Response> {

  @override
  void dispose() {
    client.close();
  }

  @override
  http.Client initialize() => http.Client();

  @override
  Future<http.Response> internalRequest(Request request) async {
    // Build request
    http.Request httpRequest = http.Request(
        request.method,
        request.uri
    );

    if (request.headers != null) httpRequest.headers.addAll(request.headers);
    if (request.body != null) httpRequest.body = request.body;

    // Send request
    return await http.Response.fromStream(await client.send(httpRequest));
  }

}