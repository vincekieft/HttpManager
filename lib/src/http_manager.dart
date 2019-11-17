import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class HttpManager extends http.BaseClient{

  final http.Client _inner;

  HttpManager(this._inner);

  Future<StreamedResponse> send(BaseRequest request) {
    return _inner.send(request);
  }

}