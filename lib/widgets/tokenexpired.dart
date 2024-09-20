import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_air/const/const.dart';
import 'package:http/http.dart' as http;

import 'package:project_air/main.dart';
import 'package:project_air/screen/home.dart';
import 'package:project_air/widgets/button.dart';
import 'package:project_air/widgets/textShow.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tokenexpired extends StatelessWidget {
  const Tokenexpired({super.key});

  Future<void> fetchAmadeusToken(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      // Check if token already exists and if it is valid
      final token = sharedPreferences.getString('token');
      final tokenExpiry = sharedPreferences.getInt('token_expiry') ?? 0;
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      if (token != null && currentTime < tokenExpiry) {
        print('Using existing token');
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
        return;
      }

      final url = Uri.parse(tokenUrl);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'client_id': dotenv.env['client_id']!,
          'client_secret': dotenv.env['client_secret']!,
          'grant_type': 'client_credentials',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final accessToken = responseData['access_token'];
        final expiresIn = responseData['expires_in']; // Time in seconds

        print('Token: $accessToken');

        // Save token and its expiry time  SharedPreferences
        sharedPreferences.setString('token', accessToken);
        sharedPreferences.setInt(
            'token_expiry', (currentTime + (expiresIn * 1000)).toInt());
      } else {}
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Textshow(
                text: "Your Token Expired",
                fontSize: 40,
                fontWeight: FontWeight.bold),
            Button(
                text: "Go To Home",
                onPressed: () {
                  fetchAmadeusToken(context);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                })
          ],
        ),
      ),
    );
  }
}
