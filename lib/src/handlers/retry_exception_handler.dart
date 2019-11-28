import 'dart:collection';
import 'package:http_manager/http_manager.dart';
import 'package:http_manager/src/interfaces/i_exception_handler.dart';

abstract class RetryExceptionHandler implements IExceptionHandler {

  HttpManager _manager;
  Queue<IRequest> _requestQueue = Queue<IRequest>();
  bool _handling = false;

  void handle(IRequest request, exception, HttpManager manager){
    _manager = manager;
    _requestQueue.add(request);
    _initializeFix();
  }

  Future<bool> onFix();
  void onFailure();

  // Private methods
  Future<void> _initializeFix() async {
    if(_handling) return;

    _handling = true;

    try{
      bool fixed = await onFix();
      _evaluateFix(fixed);
    } catch(e){
      _failed();
    }

    _handling = false;
  }

  void _evaluateFix(bool fixed){
    if(!fixed) return _failed();
    _retryRequests();
  }

  void _failed(){
    onFailure();
  }

  void _retryRequests(){
    while(_requestQueue.isNotEmpty){
      IRequest request = _requestQueue.removeFirst();
      _manager.send(request);
    }
  }

}