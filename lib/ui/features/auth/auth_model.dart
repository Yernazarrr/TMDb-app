import 'package:flutter/material.dart';
import 'package:themdb_app/domain/api_client/api_client.dart';
import 'package:themdb_app/domain/data_providers/session_data_provider.dart';
import 'package:themdb_app/ui/navigation/main_navigation.dart';

enum ApiClientExceptionType { network, auth, other }

class ApiClientException implements Exception {
  final ApiClientExceptionType type;

  ApiClientException({required this.type});
}

class AuthModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _sessionDataProvider = SessionDataProvider();

  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;
  bool get isAuthProgress => _isAuthProgress;

  Future<void> auth(BuildContext context) async {
    final login = loginTextController.text;
    final password = passwordTextController.text;

    if (login.isEmpty || password.isEmpty) {
      _errorMessage = 'Заполните пароль или логин!';
      notifyListeners();
      return;
    }
    _errorMessage = null;
    _isAuthProgress = true;
    notifyListeners();

    String? sessionId;
    try {
      sessionId = await _apiClient.auth(
        username: login,
        password: password,
      );
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.network:
          _errorMessage = 'Сервер не доступен. Проверьте подключение к сети';
          break;
        case ApiClientExceptionType.auth:
          _errorMessage = 'Неправильная логин или пароль';
          break;
        case ApiClientExceptionType.other:
          _errorMessage = 'Неизвестная ошибка, повторите попытку';
          break;
      }
      _errorMessage = 'Сервер не доступен';
      notifyListeners();
    }

    _isAuthProgress = false;
    if (_errorMessage != null) {
      notifyListeners();
      return;
    }

    if (sessionId == null) {
      _errorMessage = 'Неизвестная ошибка, повторите попытку';
      notifyListeners();
      return;
    }

    await _sessionDataProvider.setSessionId(sessionId);

    if (!context.mounted) return;
    Navigator.of(context)
        .pushReplacementNamed(MainNavigationRouteNames.mainScreen);
  }
}
