import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_air/const/const.dart';
import 'package:project_air/const/size.dart';
import 'package:project_air/widgets/button.dart';
import 'package:project_air/widgets/height.dart';
import 'package:project_air/widgets/radiolisttile.dart';
import 'package:project_air/widgets/textShow.dart';
import 'package:project_air/widgets/textformfields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GivenUserDetails extends StatefulWidget {
  final Map<String, dynamic> pricingData;

  GivenUserDetails({required this.pricingData, Key? key}) : super(key: key);

  @override
  State<GivenUserDetails> createState() => _GivenUserDetailsState();
}

class _GivenUserDetailsState extends State<GivenUserDetails> {
  String? token;
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> flightOrderdata = {};

  String _gender = 'Mr';
  String _paymentMethod = 'Cash';
  bool _acceptedTerms = false;

  @override
  void initState() {
    super.initState();

    initialized();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking Details')),
      body: widget.pricingData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.only(
                left: ScreenUtil.screenWidth * 0.025,
                right: ScreenUtil.screenWidth * 0.025,
              ),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Textshow(
                        text: "Adult",
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomRadioListTile(
                                value: 'Mrs',
                                groupValue: _gender,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value.toString();
                                  });
                                },
                                title: "Mrs"),
                          ),
                          Expanded(
                            child: CustomRadioListTile(
                                value: 'Mr',
                                groupValue: _gender,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value.toString();
                                  });
                                },
                                title: "Mr"),
                          )
                        ],
                      ),
                      CustomTextFormField(
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
                        labelText: 'Date of birth (YYYY-MM-DD)*',
                        hintText: '',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your date of birth';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.datetime,
                      ),
                      Height(height: 30),
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
                          onPressed: _acceptedTerms ? () {} : null)
                    ],
                  )),
            ),
    );
  }

  Future<void> initialized() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
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

        flightOrderdata = data['data']['flightOffers'][0];
      } else {
        print('Failed to load pricing data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
