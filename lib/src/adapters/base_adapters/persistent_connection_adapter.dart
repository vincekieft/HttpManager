import 'package:http_manager/src/dto/i_request.dart';
import 'package:http_manager/src/interfaces/i_http_adapter.dart';

abstract class PersistentConnectionAdapter<T, R> implements IHttpAdapter{

  // Private variables
  int _requestCount = 0;
  T _client;

  // Overrides
  @override
  Future<R> request(IRequest request) async {
    _ensureClient();

    try {
      // Send request
      _requestCount++;
      return await internalRequest(request);
    } finally { _clean(); }

  }

  // Private methods
  void _ensureClient(){
    if(_client == null) _client = initialize();
  }

  void _clean(){
    _requestCount--;
    if(_requestCount <= 0) _closeClient();
  }

  void _closeClient(){
    dispose();
    _requestCount = 0;
    _client = null;
  }

  // Abstract methods
  T initialize();
  void dispose();
  Future<R> internalRequest(IRequest request);

  // Getters
  T get client => _client;
}