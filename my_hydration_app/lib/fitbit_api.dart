import 'dart:convert';
import 'package:http/http.dart' as http;

class FitbitApi {
  final String clientId;
  final String clientSecret;
  final String accessTokenUrl = 'https://api.fitbit.com/oauth2/token';
  final String baseApiUrl = 'https://api.fitbit.com/1.2/';

  FitbitApi({
    required this.clientId,
    required this.clientSecret,
  });

  Future<String> getAccessToken(String code) async {
    final response = await http.post(
      Uri.parse(accessTokenUrl),
      headers: {
        'Authorization':
            'Basic ${base64.encode(utf8.encode('$clientId:$clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'code': code,
        'grant_type': 'authorization_code',
        'client_id': clientId,
      },
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      return data['access_token'];
    } else {
      throw Exception('Failed to obtain access token: ${data['errors']}');
    }
  }
  //this method is to get water intake data, it will make a request to the fitbit api to retrieve water intake data for the current day
  Future<int> getWaterIntake(String accessToken) async {
  final response = await http.get(
    Uri.parse('${baseApiUrl}user/-/foods/log/water/date/today.json'),
    headers: {
      'Authorization': 'Bearer $accessToken'
    },
  );

  final data = json.decode(response.body);

  if (response.statusCode == 200) {
    return data['summary']['water'];
  } else {
    throw Exception('Failed to obtain water intake data: ${data['errors']}');
  }
}

}
