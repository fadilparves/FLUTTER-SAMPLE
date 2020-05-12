import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './secret.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlS, String apikey) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlS?key=$apikey';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(
      String email, String password, Future<Secret> apiKey) async {
    String key;
    await apiKey.then((value) {
      key = value.apiKey;
    });
    return _authenticate(email, password, 'signUp', key);
  }

  Future<void> login(
      String email, String password, Future<Secret> apiKey) async {
    String key;
    await apiKey.then((value) {
      key = value.apiKey;
    });
    return _authenticate(email, password, 'signInWithPassword', key);
  }
}
