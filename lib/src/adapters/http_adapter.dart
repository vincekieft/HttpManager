import 'package:http_manager/src/adapters/base_adapters/persistent_connection_adapter.dart';
import 'package:http_manager/src/dto/request.dart';
import 'package:http_manager/src/dto/response.dart';
import 'package:http/http.dart' as http;

class HttpAdapter extends PersistentConnectionAdapter<http.Client> {

  @override
  void dispose() {
    client.close();
  }

  @override
  http.Client initialize() => http.Client();

  @override
  Future<Response> internalRequest(Request request) async {
    // Build request
    http.Request httpRequest = http.Request(
        request.method,
        request.uri
    );
    if (request.headers != null) httpRequest.headers.addAll(request.headers);
    if (request.body != null) httpRequest.body = request.body;

    // Send request
    http.Response httpResponse = await http.Response.fromStream(await client.send(httpRequest));

    // Map result
    return Response(
      status: httpResponse.statusCode,
      body: httpResponse.body
    );
  }

}