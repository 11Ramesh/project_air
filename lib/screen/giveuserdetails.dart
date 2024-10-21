import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
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
  final List<String> PersonNames;

  GivenUserDetails(
      {required this.pricingData, required this.PersonNames, Key? key})
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
  final TextEditingController _emailControllers = TextEditingController();
  final TextEditingController _contactControllers = TextEditingController();

  String _paymentMethod = 'Cash';
  bool _acceptedTerms = false;
  Map<String, dynamic> flightOrderdata = {};
  String _countryCode = '41';
  bool _validatedPhone = false;

  @override
  void initState() {
    super.initState();
    initialized();

    int numberOfAdults = widget.PersonNames.length;

    _formKeys = List.generate(numberOfAdults, (_) => GlobalKey<FormState>());
    _firstNameControllers =
        List.generate(numberOfAdults, (_) => TextEditingController());
    _surnameControllers =
        List.generate(numberOfAdults, (_) => TextEditingController());
    _dobControllers =
        List.generate(numberOfAdults, (_) => TextEditingController());
    // _emailControllers =
    //     List.generate(numberOfAdults, (_) => TextEditingController());
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
                      itemCount: widget.PersonNames.length,
                      itemBuilder: (context, i) {
                        return Form(
                          key: _formKeys[
                              i], // Assign the form key for each adult
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Textshow(
                                  text: widget.PersonNames[i],
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
                                  DateTime dateTime = DateTime.parse(value);
                                  DateTime today = DateTime.now();
                                  if (dateTime.isAfter(today)) {
                                    return 'Date cannot be in the future';
                                  }
                                  // Calculate the difference in years
                                  int differenceInYears =
                                      today.year - dateTime.year;

// Convert the first character of the person's name to uppercase
                                  String isNameStartsWith =
                                      widget.PersonNames[i][0].toUpperCase();

// Determine if the person is under eleven years old
                                  bool isUnderElevenYearsOld =
                                      differenceInYears > 11 ||
                                          (differenceInYears == 11 &&
                                              (dateTime.month < today.month ||
                                                  (dateTime.month ==
                                                          today.month &&
                                                      dateTime.day <=
                                                          today.day)));

// Determine if the person is under two years old
                                  bool isUnderTwoYearsOld = differenceInYears <
                                          2 ||
                                      (differenceInYears == 2 &&
                                          (dateTime.month > today.month ||
                                              (dateTime.month == today.month &&
                                                  dateTime.day > today.day)));

// Determine if the person is between two and eleven years old
                                  bool isBetweenTwoAndEleven =
                                      (differenceInYears > 2 &&
                                              differenceInYears < 11) ||
                                          (differenceInYears == 2 &&
                                              (dateTime.month < today.month ||
                                                  (dateTime.month ==
                                                          today.month &&
                                                      dateTime.day <=
                                                          today.day))) ||
                                          (differenceInYears == 11 &&
                                              (dateTime.month > today.month ||
                                                  (dateTime.month ==
                                                          today.month &&
                                                      dateTime.day >=
                                                          today.day)));

// Now you can use isUnderElevenYearsOld, isUnderTwoYearsOld, and isBetweenTwoAndEleven accordingly

                                  if (isNameStartsWith == 'A' &&
                                      !isUnderElevenYearsOld) {
                                    return 'Age must be greater than 11 years';
                                  }

                                  if (isNameStartsWith == 'I' &&
                                      !isUnderTwoYearsOld) {
                                    return 'Age must be less than 2 years';
                                  }

                                  if (isNameStartsWith == 'C' &&
                                      !isBetweenTwoAndEleven) {
                                    return 'Age must be less than 11 and greater than 2 years';
                                  }

                                  return null;
                                },
                                keyboardType: TextInputType.datetime,
                              ),
                              Height(height: 15),
                              i == 0
                                  ? CustomTextFormField(
                                      controller: _emailControllers,
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
                                    )
                                  : Container(),
                              Height(height: 15),
                              i == 0
                                  ? IntlPhoneField(
                                      controller: _contactControllers,
                                      decoration: const InputDecoration(
                                        labelText: 'Phone Number',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(),
                                        ),
                                      ),
                                      initialCountryCode: 'IT',
                                      onChanged: (phone) {
                                        String a = phone.countryCode;
                                        _countryCode =
                                            a.replaceAll(RegExp(r'\D'), '');
                                        //print(phone.countryISOCode);
                                        try {
                                          if (phone.isValidNumber()) {
                                            _validatedPhone = true;
                                          } else {
                                            _validatedPhone = false;
                                          }
                                        } catch (e) {
                                          setState(() {
                                            _validatedPhone = false;
                                          });
                                        }

                                        print(_validatedPhone);
                                      },
                                      validator: (value) {
                                        if (!_validatedPhone ||
                                            _contactControllers.text.isEmpty) {
                                          print(_validatedPhone);
                                          return 'Please enter your valid Phone Number';
                                        }
                                        print(_validatedPhone);
                                        return null;
                                      },
                                    )
                                  : Container(),
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
        //print(data);
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
        widget.PersonNames.length; // Make sure widget.adult is a valid integer

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
          'email': _emailControllers.text,
          'contact': _contactControllers.text,
          'contactCode': _countryCode
        });
      }
      print(passengers);
      // Proceed with sending passenger data or further processing
      // backendBloc.add(OrderFlightEvent(flightOrderdata, passengers));

      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => OrderDataShow()));
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
