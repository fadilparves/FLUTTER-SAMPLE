import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './secret.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  
  Future<void> signup(String email, String password, Future<Secret> apiKey) async {
    String key;

    await apiKey.then((value) {
      key = value.apiKey;
    });
    
    final String url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$key';
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
  }
}
