import 'package:http_manager/src/adapters/base_adapters/persistent_connection_adapter.dart';
import 'package:http/http.dart' as http;
import 'package:http_manager/src/dto/i_request.dart';

class HttpAdapter extends PersistentConnectionAdapter<http.Client, http.Response> {

  final Function(http.Response response) filter;

  HttpAdapter({
    this.filter
  });

  @override
  void dispose() {
    client.close();
  }

  @override
  http.Client initialize() => http.Client();

  @override
  Future<http.Response> internalRequest(IRequest request) async {
    // Build request
    http.Request httpRequest = http.Request(
        request.method,
        request.uri
    );

    if (request.headers != null) httpRequest.headers.addAll(request.headers);
    if (request.body != null) httpRequest.body = request.body;

    // Send request
    http.Response response = await http.Response.fromStream(await client.send(httpRequest));

    // Optional filtering
    if(filter != null) filter(response);

    return response;
  }

}