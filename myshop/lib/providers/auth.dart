import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './secret.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> _authenticate(
      String email, String password, String urlS, String apikey) async {
    final String url = '$urlS$apikey';
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
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
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
    return _authenticate(
      email,
      password,
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=',
      key,
    );
  }

  Future<void> signin(
      String email, String password, Future<Secret> apiKey) async {
    String key;

    await apiKey.then((value) {
      key = value.apiKey;
    });

    return _authenticate(
      email,
      password,
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=',
      key,
    );
  }
}
