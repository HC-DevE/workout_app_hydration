import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FitbitAuth {
  static const String clientId = 'your-client-id';
  static const String clientSecret = 'your-client-secret';
  static const String redirectUri = 'your-redirect-uri';
  static const String scope = 'activity heartrate';
  static const String authorizationUrl =
      'https://www.fitbit.com/oauth2/authorize';
  static const String tokenUrl = 'https://api.fitbit.com/oauth2/token';
  static const callbackUrlScheme = 'fitbit';
  static const authorizationEndpoint =
      'https://www.fitbit.com/oauth2/authorize';
  static const tokenEndpoint = 'https://api.fitbit.com/oauth2/token';
  static const scopes = <String>[
    'activity',
    'heartrate',
    'location',
    'nutrition',
    'profile',
    'settings',
    'sleep',
    'social',
    'weight',
  ];

  static Future<Map<String, dynamic>> authorize() async {
    final String url =
        '$authorizationUrl?response_type=code&client_id=$clientId&redirect_uri=$redirectUri&scope=$scope';
    final result = await FlutterWebAuth.authenticate(
        url: url, callbackUrlScheme: redirectUri);
    final code = Uri.parse(result).queryParameters['code'];
    final response = await http.post(tokenUrl as Uri, headers: {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('${clientId}:${clientSecret}'))}',
      'Content-Type': 'application/x-www-form-urlencoded'
    }, body: {
      'client_id': clientId,
      'grant_type': 'authorization_code',
      'redirect_uri': redirectUri,
      'code': code,
      'scope': scope
    });
    final responseData = json.decode(response.body);
    return responseData;
  }

  Future<void> authenticateWithFitbit() async {
    final callbackUrlScheme = FitbitAuth.callbackUrlScheme;
    final authorizationEndpoint = FitbitAuth.authorizationEndpoint;
    final clientId = FitbitAuth.clientId;
    final scopes = FitbitAuth.scopes.join(' ');

    final authorizeUrl =
        '$authorizationEndpoint?response_type=code&client_id=$clientId&scope=$scopes&redirect_uri=$callbackUrlScheme://fitbit-auth';

    final result = await FlutterWebAuth.authenticate(
        url: authorizeUrl, callbackUrlScheme: callbackUrlScheme);

    final uri = Uri.parse(result);
    final authCode = uri.queryParameters['code'];

    final tokenEndpoint = FitbitAuth.tokenEndpoint;
    final clientCredentials =
        base64.encode(utf8.encode('$clientId:${FitbitAuth.clientSecret}'));

    final tokenResponse = await http.post(
      tokenEndpoint as Uri,
      headers: {
        'Authorization': 'Basic $clientCredentials',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'code': authCode,
        'grant_type': 'authorization_code',
        'redirect_uri': '$callbackUrlScheme://fitbit-auth'
      },
    );

    final accessToken = jsonDecode(tokenResponse.body)['access_token'];

    // TODO: Store the access token in shared preferences and use it to make requests to the Fitbit API
  }

  void init(SharedPreferences prefs) {}
}
