import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:fun_flutter/config/net/api.dart';
import 'package:fun_flutter/config/storage_manager.dart';

final Http http = Http();

class Http extends BaseHttp {
  @override
  void init() {
    options.baseUrl = 'https://www.wanandroid.com/';
    interceptors
      ..add(ApiInterceptor())
      // cookie持久化 异步
      ..add(CookieManager(
          PersistCookieJar(dir: StorageManager.temporaryDirectory.path)));
  }
}

class ApiInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) async {
    debugPrint('---api-request--->url--> ${options.baseUrl}${options.path}' +
        ' queryParameters: ${options.queryParameters}');
//    debugPrint('---api-request--->data--->${options.data}');
    return options;
  }

  @override
  Future onResponse(Response response) {
//    debugPrint('---api-response--->resp----->${response.data}');
    ResponseData responseData = ResponseData.fromJson(response.data);
    if (responseData.success) {
      response.data = responseData.data;
      return http.resolve(response);
    } else {
      if (responseData.code == -1001) {
        throw const UnAuthorizedException();
      } else {
        throw NotSuccessException.fromRespData(responseData);
      }
    }
  }
}

class ResponseData extends BaseResponseData {
  @override
  bool get success => 0 == code;

  ResponseData.fromJson(Map<String, dynamic> json) {
    code = json['errorCode'];
    message = json['errorMsg'];
    data = json['data'];
  }
}
