import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fitbit_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: use_key_in_widget_constructors
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _accessToken = '';
  int _hydrationGoal = 0;

  final FitbitAuth _fitbitAuth = FitbitAuth();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  void _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _fitbitAuth.init(_prefs);
    setState(() {
      _accessToken = _prefs.getString('fitbit_access_token') ?? '';
      _hydrationGoal = _prefs.getInt('hydration_goal') ?? 0;
    });
  }

  void _authorize() async {
    final responseData = await FitbitAuth.authorize();
    final accessToken = responseData['access_token'];
    final expiresIn = responseData['expires_in'];
    _prefs.setString('fitbit_access_token', accessToken);
    _prefs.setInt('fitbit_access_token_expires_in', expiresIn);
    setState(() {
      _accessToken = accessToken;
    });
  }

  void _fetchHydrationGoal() async {
    final response = await http.get(
      Uri.parse('https://api.fitbit.com/1/user/-/foods/log/water/goal.json'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
        'Content-Type': 'application/json'
      },
    );
    final responseData = json.decode(response.body);
    final hydrationGoal = responseData['goal']['goal'];
    _prefs.setInt('hydration_goal', hydrationGoal);
    setState(() {
      _hydrationGoal = hydrationGoal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hydration Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your daily hydration goal:',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '$_hydrationGoal oz',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _accessToken.isEmpty ? _authorize : _fetchHydrationGoal,
              child: Text(_accessToken.isEmpty ? 'Authorize with Fitbit' : 'Refresh hydration goal'),
            ),
          ],
        ),
      ),
    );
  }
}
