import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:agre_lens_app/core/loger.dart';

class NetworkInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data is List) {
      response.data = {"data": response.data};
    }
    return super.onResponse(response, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    /*
    final removeToken = [APIconst.profileUpdateAuth, APIconst.verify].any((k) => options.path.contains(k));
    if (removeToken) options.headers.removeWhere((k, v) => k == 'Authorization');
    */
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    /*
    if (err.response?.statusCode == 401 && UserModel.i.isAuth) {
      UserModel.i.clear();
      FlashHelper.showToast(LocaleKeys.yourLoginSessionHasEnded.tr());
      pushAndRemoveUntil(NamedRoutes.welcome);
    }
    */
    return super.onError(err, handler);
  }
}

class CustomApiInterceptor extends Interceptor {
  final log = LoggerDebug(
    headColor: LogColors.red,
    constTitle: "Server Gate Logger",
  );

  CustomApiInterceptor();

  String _safeJsonEncode(dynamic data) {
    try {
      return jsonEncode(data);
    } catch (e) {
      return data.toString();
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log.red(
      "\x1B[37m------ Current Error Response (status code ${err.response?.statusCode}) -----\x1B[0m",
    );
    log.red(
      _safeJsonEncode(err.response?.data),
      err.requestOptions.path,
    );
    log.red(_generateCurlCommand(err.requestOptions));
    return super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log.green(
      "------ Current Response (status code ${response.statusCode}) ------",
    );
    log.green(
      _safeJsonEncode(response.data),
      response.requestOptions.path,
    );
    log.white(_generateCurlCommand(response.requestOptions));
    return super.onResponse(response, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log.yellow("------ Current Request Path -----");
    log.yellow(
      "${options.path} ${LogColors.red}API METHOD : (${options.method})${LogColors.reset}",
    );

    if (options.data != null) {
      log.cyan("------ Current Request body Data -----");
      if (options.data is FormData) {
        Map<String, dynamic> body = {};
        for (var element in (options.data as FormData).fields) {
          body[element.key] = element.value;
        }
        for (var element in (options.data as FormData).files) {
          body[element.key] = '${element.value.filename}';
        }
        log.cyan(_safeJsonEncode(body));
      } else {
        log.cyan(_safeJsonEncode(options.data));
      }
    }

    log.white("------ Current Request Parameters Data -----");
    log.white(_safeJsonEncode(options.queryParameters));
    log.yellow("------ Current Request Headers -----");
    log.yellow(_safeJsonEncode(options.headers));

    return super.onRequest(options, handler);
  }

  String _generateCurlCommand(RequestOptions options) {
    final method = options.method;
    final url = options.uri.toString();
    final headers = options.headers;
    final data = options.data;

    final curlCommand = StringBuffer("curl -X $method '$url'");

    headers.forEach((key, value) {
      curlCommand.write(" -H '$key: $value'");
    });

    if (data != null) {
      if (data is FormData) {
        for (var field in data.fields) {
          final escapedValue = field.value.replaceAll("'", r"'\''");
          curlCommand.write(" -F '${field.key}=$escapedValue'");
        }
        for (var file in data.files) {
          final filePath = (file.value.filename ?? 'file');
          curlCommand.write(" -F '${file.key}=@$filePath'");
        }
      } else if (data is Map) {
        curlCommand.write(" --data '${_safeJsonEncode(data)}'");
      } else {
        curlCommand.write(" --data '$data'");
      }
    }

    return curlCommand.toString();
  }
}
