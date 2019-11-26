import 'package:http_manager/http_manager.dart';
import 'package:http_manager/src/handlers/retry_exception_handler.dart';
import 'package:http_manager/src/interfaces/i_http_adapter.dart';
import 'package:http_manager/src/dto/request.dart';
import 'package:http_manager/src/dto/response.dart';
import 'package:test/test.dart';

void main() {

  group('HttpManager', (){

    test('Test', () async {
      HttpManager manager = HttpManager(TestExceptionAdapter(1), [
        TestRetryHandler()
      ]);

      await manager.get(Uri());
      await manager.get(Uri());
    });

  });

}

class TestExceptionAdapter implements IHttpAdapter {

  final int failCount;
  int count = 0;

  TestExceptionAdapter(this.failCount);

  @override
  Future<Response> request(Request request) async {
    if(count >= failCount) return Response(body: "", status: 200);
    count++;
    throw TestException();
  }

}

class TestRetryHandler extends RetryExceptionHandler {

  @override
  void onFailure() {
    throw TestException();
  }

  @override
  Future<bool> onFix() async {
    return Future.delayed(Duration(seconds: 1), () => true);
  }

  @override
  bool shouldHandle(Exception exception) => exception is TestException;

}

class TestException implements Exception {}
