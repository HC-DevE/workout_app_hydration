import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FitbitData extends ChangeNotifier {
  final String accessToken;

  FitbitData(SharedPreferences prefs, {required this.accessToken});

  Future<Map<String, dynamic>> getHeartRate(DateTime date) async {
    final response = await http.get(
        Uri.parse('https://api.fitbit.com/1.2/user/-/activities/heart/date/${_formatDate(date)}/1d.json'),
        headers: {
          'Authorization': 'Bearer $accessToken'
        });

    if (response.statusCode != 200) {
      throw Exception('Failed to load heart rate data');
    }

    final responseData = json.decode(response.body);
    return responseData['activities-heart'][0]['value'];
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${_padNumber(date.month)}-${_padNumber(date.day)}';
  }

  String _padNumber(int number) {
    return number.toString().padLeft(2, '0');
  }
}
