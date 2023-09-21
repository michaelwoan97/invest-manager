import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:invest_manager/controllers/mangement_API.dart';
import 'package:invest_manager/main.dart';
import 'package:invest_manager/models/sneaker_manager.dart';
import 'package:invest_manager/pages/login_register_page.dart';
import 'package:invest_manager/utils/mange_token.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

enum TokenErrorType{
  tokenNotFound,
  invalidAccessToken,
  refreshTokenHasExpired,
  failedToRegenerateAccessToken
}

const webUrl = 'https://invest-manager-server.onrender.com';

/*
* class: InterceptorAPI
* purpose: This class used for intercepting all the outgoing requests to check whether they needed to be adjusted before
*           reaching the server
* server-detail:
* */
class InterceptorAPI extends Interceptor{
  final Dio _dio;
  final _sneakerManager = SneakerManager();
  static const String _url = webUrl;

  InterceptorAPI(this._dio);

  /*
  * function: onRequest
  * purpose: The purpose of this function is to intercept all the outgoing requests to check whether they needed to be adjusted before
  *           reaching the server
  * */
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print("intercepting request!!!");
    // check whether request require token
    if (options.headers['requiresToken'] == false ){
      options.headers.remove("requiresToken");
      return handler.next(options); // continue to send to servers
    }

    // get token from singleton
    // await to get token before continue
    final accessToken = await ManageToken.getAccessToken();
    final refreshToken = await ManageToken.getRefreshToken();

    if(accessToken == null || refreshToken ==null ){
      _performLogout(_dio);

      options.extra["tokenErrorType"] = TokenErrorType.tokenNotFound;
      final error = DioError(requestOptions: options, type: DioErrorType.other);
      return handler.reject(error);
    }

    // check if tokens have already expired or not
    // I use jwt_decoder package
    // Note: ensure your tokens has "exp" claim
    final accessTokenHasExpired = JwtDecoder.isExpired(accessToken);
    final refreshTokenHasExpired = JwtDecoder.isExpired(refreshToken);

    var _refreshed = true;

    // check whether the refresh token has expired
    if(refreshTokenHasExpired){
      _performLogout(_dio);

      // create custom dio error
      options.extra["tokenErrorType"] = TokenErrorType.refreshTokenHasExpired;
      final error = DioError(requestOptions: options, type: DioErrorType.other);

      return handler.reject(error);
    } else if (accessTokenHasExpired) {
      // regenerate access token
      _dio.interceptors.requestLock.lock();
      _refreshed = await _regenerateAccessToken();
      _dio.interceptors.requestLock.unlock();
    }

    if(_refreshed){
      final securedAccessToken = await ManageToken.getAccessToken();
      // add access token to the request header
      // print("Token to used is " + securedAccessToken);
      options.headers["Authorization"] = "Bearer " + securedAccessToken;
      return handler.next(options);
    } else {
      // create custom dio error
      options.extra["tokenErrorType"] = TokenErrorType.failedToRegenerateAccessToken;
      final error = DioError(requestOptions: options, type: DioErrorType.other);
      return handler.reject(error);
    }
  }

  /*
  * function: onError
  * purpose: The purpose of this function is to check whether the token from the response
  *           is expired or invalidated. If the token is expired, the app will be automatically perform logout
  * */
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 403 || err.response?.statusCode == 401) {
      // for some reasons the token can be invalidated before it is expired by the backend.
      // then we should navigate the user back to login page

      _performLogout(_dio);

      // create custom dio error
      err.type = DioErrorType.other;
      err.requestOptions.extra["tokenErrorType"] = TokenErrorType.invalidAccessToken;
    }

    return handler.next(err);
  }

  /*
  * function: _performLogout
  * purpose: The purpose of this function is to stop and clear everything then log out
  * */
  void _performLogout(Dio dio) {
    // clear and lock for all request
    _dio.interceptors.requestLock.clear();
    _dio.interceptors.requestLock.lock();

    // remove tokens
    // SneakerManager().accessToken = "";
    // SneakerManager().refreshToken = "";

    // back to login page without using context
    // check this https://stackoverflow.com/a/53397266/9101876
    navigatorKey.currentState?.pop();
    navigatorKey.currentState?.pushReplacementNamed("/");

    _dio.interceptors.requestLock.unlock();
  }

  /*
  * function: _regenerateAccessToken
  * purpose: The purpose of this function is trying to regenerate access token if it is expired
  * */
  Future<bool> _regenerateAccessToken() async {
    try{
      var dio = Dio();// should create new dio instance because the request interceptor is being locked

      // get userID from the singleton or storage
      final userID = await ManageToken.getUserID();
      // make request to server to get the access token from server using refresh token
      final response = await dio.post("$_url/token",
          data: {"userID": userID},
          options: Options(contentType: Headers.formUrlEncodedContentType));

      if(response.statusCode == 200 || response.statusCode == 201){
        final data = json.decode(response.data);
        // final data = response.data;
        final newAccessToken = data["msg"]; // parse data based on your JSON structure
        print("New access token is " + newAccessToken);
        await ManageToken.saveAccessToken(newAccessToken); // await to save token
        return true;
      } else if (response.statusCode == 401 || response.statusCode == 403){
        // it means your refresh token no longer valid now, it may be revoked by the backend
        _performLogout(_dio);
        return false;
      } else {
        print(response.statusCode);
        return false;
      }

    } on DioError {
      return false;
    } catch (e){
      return false;
    }
  }

}