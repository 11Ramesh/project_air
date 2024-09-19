import 'dart:convert';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_air/const/const.dart';
import 'package:project_air/const/size.dart';
import 'package:project_air/function/backend/backend_bloc.dart';
import 'package:project_air/screen/home.dart';
import 'package:project_air/widgets/checkconnection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

bool isconnection = true;

class LocationDataStore {
  static final LocationDataStore _instance = LocationDataStore._internal();

  Map<String, Map<String, String>> locationData = {};

  LocationDataStore._internal();

  factory LocationDataStore() {
    return _instance;
  }

  // Method to load data from the Excel file
  Future<void> loadLocationData() async {
    var bytes = await rootBundle.load('assets/localdata.xlsx');
    var excel = Excel.decodeBytes(bytes.buffer.asUint8List());

    for (var sheetName in excel.tables.keys) {
      var sheet = excel.tables[sheetName];
      if (sheet == null) continue;

      for (int rowIndex = 1; rowIndex < sheet.maxRows; rowIndex++) {
        List<Data?> row = sheet.row(rowIndex);

        if (row.length >= 3) {
          var city = row[0]?.value?.toString() ?? '';
          var country = row[1]?.value?.toString() ?? '';
          var code = row[2]?.value?.toString() ?? '';

          if (code.isNotEmpty) {
            locationData[code] = {"city": city, "country": country};
          }
        }
      }
    }
  }
}

Future<void> fetchAmadeusToken(BuildContext context) async {
  try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Check if token already exists and if it is valid
    final token = sharedPreferences.getString('token');
    final tokenExpiry = sharedPreferences.getInt('token_expiry') ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (token != null && currentTime < tokenExpiry) {
      print('Using existing token');

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
    } else {
      isconnection = false;
      _showErrorDialog(context, 'Failed to fetch token: ${response.statusCode}',
          response.body);
    }
  } catch (e) {
    isconnection = false;
    _showErrorDialog(context, 'Error', e.toString());
  }
}

void _showErrorDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await LocationDataStore().loadLocationData();
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
        debugShowCheckedModeBanner: false,
        home: TokenFetchWrapper(),
      ),
    );
  }
}

class TokenFetchWrapper extends StatefulWidget {
  const TokenFetchWrapper({super.key});

  @override
  _TokenFetchWrapperState createState() => _TokenFetchWrapperState();
}

class _TokenFetchWrapperState extends State<TokenFetchWrapper> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchToken();
  }

  Future<void> _fetchToken() async {
    await fetchAmadeusToken(context);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return isconnection ? const Home() : const Checkconnection();
  }
}
