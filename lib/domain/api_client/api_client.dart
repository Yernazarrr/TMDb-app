import 'dart:convert';
import 'dart:io';

import 'package:themdb_app/ui/features/auth/auth_model.dart';

class ApiClient {
  final _client = HttpClient();
  static const _host = 'https://api.themoviedb.org/3';
  // static const _imageUrl = 'https://image.tmdb.org/t/p';
  static const _apiKey = '6307d905b2df602ae8f629286fea7bd6';

  //Авторизация пользователя
  Future<String> auth({
    required String username,
    required String password,
  }) async {
    //Проверка токена
    final token = await _makeToken();

    //Если токен верный, проверяем валидность логина и пароля
    final validToken = await _validateUser(
      username: username,
      password: password,
      requestToken: token,
    );

    //В конце если все верно, вернем сессию
    final sessionId = await _makeSession(requestToken: validToken);

    return sessionId;
  }

  Uri _makeUri(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse('$_host$path');

    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
  }

  //Делаем GET запрос
  Future<T> _get<T>(String path, T Function(dynamic json) parser,
      [Map<String, dynamic>? parameters]) async {
    final url = _makeUri(path, parameters);

    try {
      final request = await _client.getUrl(url);
      final response = await request.close();
      final json = await response.jsonDecode();

      //Проверяем корректность ответа
      _validateResponse(response, json);

      //Если ответ корректный верным результат
      final result = parser(json);

      return result;
    } on SocketException {
      //Если проблемы с соединением
      throw ApiClientException(type: ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (_) {
      throw ApiClientException(type: ApiClientExceptionType.other);
    }
  }

  //Делаем POST запрос
  //В параметры передаем путь, JSON парсер, и параметры body
  Future<T> _post<T>(String path, T Function(dynamic json) parser,
      Map<String, dynamic> bodyParameters,
      [Map<String, dynamic>? urlParameters]) async {
    try {
      final url = _makeUri(path, urlParameters);
      final request = await _client.postUrl(url);

      //Записываем headers
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(bodyParameters));

      final response = await request.close();
      final dynamic json = await response.jsonDecode();

      //Проверяем корректность ответа
      _validateResponse(response, json);

      //Если ответ корректный верным результат
      final result = parser(json);

      return result;
    } on SocketException {
      throw ApiClientException(type: ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (_) {
      throw ApiClientException(type: ApiClientExceptionType.other);
    }
  }

  //Получаем Токен авторизации
  Future<String> _makeToken() async {
    //Парсим JSON
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;

      return token;
    }

    //Делаем GET запрос
    final result = _get(
      '/authentication/token/new',
      parser,
      <String, dynamic>{'api_key': _apiKey},
    );

    return result;
  }

  //Проверяем
  Future<String> _validateUser({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;

      return token;
    }

    final parameters = <String, dynamic>{
      'username': username,
      'password': password,
      'request_token': requestToken,
    };

    //Делаем POST запрос
    final result = _post(
      '/authentication/token/validate_with_login',
      parser,
      parameters,
      <String, dynamic>{'api_key': _apiKey},
    );

    return result;
  }

  //Получаем сессию, передав в аргументы токен
  Future<String> _makeSession({
    required String requestToken,
  }) async {
    //Парсим JSON
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final sessionId = jsonMap['session_id'] as String;

      return sessionId;
    }

    final parameters = <String, dynamic>{
      'request_token': requestToken,
    };

    //Делаем POST запрос
    final result = _post(
      '/authentication/session/new',
      parser,
      parameters,
      <String, dynamic>{'api_key': _apiKey},
    );

    return result;
  }
}

//Проверяем ответ от сервера
void _validateResponse(HttpClientResponse response, dynamic json) {
  //Проверяем статус код
  //Если пользователь не авторизован (код 401), выдаем исключение об авторизации
  if (response.statusCode == 401) {
    final status = json['status_code'];
    final code = status is int ? status : 0;

    //Если статус код 30, то неверный логин или пароль
    if (code == 30) {
      throw ApiClientException(type: ApiClientExceptionType.auth);
    } else {
      throw ApiClientException(type: ApiClientExceptionType.other);
    }
  }
}

extension HttpClientResponseJsonDecode on HttpClientResponse {
  //Декодируем JSON
  Future<dynamic> jsonDecode() async {
    return transform(utf8.decoder).toList().then((value) {
      final result = value.join();
      return result;
    }).then<dynamic>((value) => json.decode(value));
  }
}
