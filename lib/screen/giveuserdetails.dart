import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:project_air/const/const.dart';
import 'package:project_air/const/size.dart';
import 'package:project_air/function/backend/backend_bloc.dart';
import 'package:project_air/screen/orderdatashow.dart';
import 'package:project_air/widgets/button.dart';
import 'package:project_air/widgets/height.dart';
import 'package:project_air/widgets/radiolisttile.dart';
import 'package:project_air/widgets/textShow.dart';
import 'package:project_air/widgets/textformfields.dart';
import 'package:project_air/widgets/tokenexpired.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GivenUserDetails extends StatefulWidget {
  final Map<String, dynamic> pricingData;
  final String adult;

  GivenUserDetails({required this.pricingData, required this.adult, Key? key})
      : super(key: key);

  @override
  State<GivenUserDetails> createState() => _GivenUserDetailsState();
}

class _GivenUserDetailsState extends State<GivenUserDetails> {
  late BackendBloc backendBloc;
  String? token;
  late int tokenExpiry;
  List<GlobalKey<FormState>> _formKeys = [];
  List<String> _genders = [];
  List<TextEditingController> _firstNameControllers = [];
  List<TextEditingController> _surnameControllers = [];
  List<TextEditingController> _dobControllers = [];
  List<TextEditingController> _emailControllers = [];

  String _paymentMethod = 'Cash';
  bool _acceptedTerms = false;
  Map<String, dynamic> flightOrderdata = {};

  @override
  void initState() {
    super.initState();
    initialized();

    int numberOfAdults = int.parse(widget.adult);

    _formKeys = List.generate(numberOfAdults, (_) => GlobalKey<FormState>());
    _firstNameControllers =
        List.generate(numberOfAdults, (_) => TextEditingController());
    _surnameControllers =
        List.generate(numberOfAdults, (_) => TextEditingController());
    _dobControllers =
        List.generate(numberOfAdults, (_) => TextEditingController());
    _emailControllers =
        List.generate(numberOfAdults, (_) => TextEditingController());
    _genders = List.generate(
        numberOfAdults, (_) => 'Mr'); // Initialize gender as empty string
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking Details')),
      body: widget.pricingData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.only(
                left: ScreenUtil.screenWidth * 0.03,
                right: ScreenUtil.screenWidth * 0.03,
              ),
              child: ListView(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: int.parse(widget.adult),
                      itemBuilder: (context, i) {
                        return Form(
                          key: _formKeys[
                              i], // Assign the form key for each adult
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Textshow(
                                  text: "Adult ${i + 1}",
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomRadioListTile(
                                        value: 'Mrs',
                                        groupValue: _genders[i],
                                        onChanged: (value) {
                                          setState(() {
                                            _genders[i] = value.toString();
                                          });
                                        },
                                        title: "Mrs"),
                                  ),
                                  Expanded(
                                    child: CustomRadioListTile(
                                        value: 'Mr',
                                        groupValue: _genders[i],
                                        onChanged: (value) {
                                          setState(() {
                                            _genders[i] = value.toString();
                                          });
                                        },
                                        title: "Mr"),
                                  ),
                                ],
                              ),
                              CustomTextFormField(
                                controller: _firstNameControllers[i],
                                labelText: 'Firstname*',
                                hintText: '',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your first name';
                                  }
                                  return null;
                                },
                              ),
                              Height(height: 15),
                              CustomTextFormField(
                                controller: _surnameControllers[i],
                                labelText: 'Surname*',
                                hintText: '',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your surname';
                                  }
                                  return null;
                                },
                              ),
                              Height(height: 15),
                              CustomTextFormField(
                                controller: _dobControllers[i],
                                labelText: 'Date of birth (YYYY-MM-DD)*',
                                hintText: '',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your date of birth';
                                  }

                                  // Regular expression for validating the YYYY-MM-DD format
                                  final RegExp dateRegExp = RegExp(datepartten);

                                  if (!dateRegExp.hasMatch(value)) {
                                    return 'Please enter a valid date (YYYY-MM-DD)';
                                  }

                                  return null;
                                },
                                keyboardType: TextInputType.datetime,
                              ),
                              Height(height: 15),
                              CustomTextFormField(
                                controller: _emailControllers[i],
                                labelText: 'Email*',
                                hintText: '',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  final regExp = RegExp(pattern);

                                  if (!regExp.hasMatch(value)) {
                                    return 'Enter a valid email format';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                              ),
                              Height(height: 30),
                            ],
                          ),
                        );
                      }),

                  // Payment section
                  Textshow(
                    text: "Payment",
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  CustomRadioListTile(
                      value: 'Credit Card',
                      groupValue: _paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value.toString();
                        });
                      },
                      title: "Credit card (+ 0.00 € Fee)"),
                  CustomRadioListTile(
                      value: 'Cash',
                      groupValue: _paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value.toString();
                        });
                      },
                      title: "Cash"),
                  CheckboxListTile(
                    title: Textshow(
                      text:
                          'I have read and accept the terms of service of MIHIN TOURS SNC and the flight rules.',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    value: _acceptedTerms,
                    onChanged: (value) {
                      setState(() {
                        _acceptedTerms = value!;
                      });
                    },
                  ),
                  Height(height: 20),
                  Button(
                    text: 'Submit',
                    onPressed: _acceptedTerms
                        ? () {
                            if (token != null &&
                                DateTime.now().millisecondsSinceEpoch <
                                    tokenExpiry) {
                              _submitForm(context);
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Tokenexpired()));
                            }
                          }
                        : null,
                  ),
                  Height(height: 20)
                ],
              ),
            ),
    );
  }

  Future<void> initialized() async {
    backendBloc = BlocProvider.of<BackendBloc>(context);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
    tokenExpiry = sharedPreferences.getInt('token_expiry') ?? 0;
    if (token != null) {
      await pricingDataget();
    } else {
      print('No token found');
    }
  }

  Future<void> pricingDataget() async {
    var url = Uri.parse('$pricingURL'); // Ensure pricingURL is defined
    try {
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            "data": {
              "type": "flight-offers-pricing",
              "flightOffers": [widget.pricingData]
            }
          }));
      if (response.statusCode == 200) {
        print('Pricing data fetched successfully');
        Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          flightOrderdata = data['data']['flightOffers'][0];
        });
      } else {
        print('Failed to load pricing data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _submitForm(BuildContext context) {
    int count = 0;
    int numberOfAdults =
        int.parse(widget.adult); // Make sure widget.adult is a valid integer

    for (int i = 0; i < numberOfAdults; i++) {
      print(_formKeys[i]);

      // Check if currentState is not null before validation
      if (_formKeys[i].currentState != null &&
          _formKeys[i].currentState!.validate()) {
        _formKeys[i].currentState!.save();
        count++;
      } else {
        print('Form $i is invalid');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill correct all details for Adult ${i + 1}'),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    }

    // Check against the number of adults instead of _genders.length
    if (count == numberOfAdults) {
      List<Map<String, String>> passengers = [];
      for (int i = 0; i < numberOfAdults; i++) {
        passengers.add({
          'gender': _genders[i] == 'Mr' ? "MALE" : "FEMALE",
          'firstName': _firstNameControllers[i].text,
          'surname': _surnameControllers[i].text,
          'dob': _dobControllers[i].text,
          'email': _emailControllers[i].text
        });
      }

      // Proceed with sending passenger data or further processing
      backendBloc.add(OrderFlightEvent(widget.pricingData, passengers));

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => OrderDataShow()));
    } else {}
  }

  @override
  void dispose() {
    // Dispose of the controllers to prevent memory leaks
    _firstNameControllers.forEach((controller) => controller.dispose());
    _surnameControllers.forEach((controller) => controller.dispose());
    _dobControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }
}
