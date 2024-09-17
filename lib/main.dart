import 'dart:convert';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_air/const/size.dart';
import 'package:project_air/function/backend/backend_bloc.dart';
import 'package:project_air/screen/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<void> fetchAmadeusToken() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final url =
      Uri.parse('https://travel.api.amadeus.com/v1/security/oauth2/token');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'client_id': 'UMUAsriqhFWJpHcdhmHzjfMZIGOljscG',
      'client_secret': 'XsIBSnkTiUsqV3lr',
      'grant_type': 'client_credentials',
    },
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    print(responseData['access_token']);
    // token store in shared preference
    sharedPreferences.setString('token', responseData['access_token']);
  } else {
    print('Failed to fetch token: ${response.statusCode}');
    print('Error: ${response.body}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await fetchAmadeusToken();
  //  runApp(DevicePreview(
  //   enabled: !kReleaseMode,
  //    builder: (context) => const MyApp(),
  // ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return BlocProvider(
      create: (context) => BackendBloc(),
      child: const MaterialApp(
        home: Home(),
      ),
    );
  }
}
