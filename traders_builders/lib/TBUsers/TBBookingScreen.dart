import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:traders_builders/TBUsers/TBUserHome.dart';

import '../shared/TBAppColors.dart';

class TBBookingScreen extends StatefulWidget {
  final String service;
  final int traderId;

  const TBBookingScreen(
      {Key? key, required this.service, required this.traderId})
      : super(key: key);

  @override
  State<TBBookingScreen> createState() => _TBBookingScreenState();
}

class _TBBookingScreenState extends State<TBBookingScreen> {
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  final _formKey = GlobalKey<FormState>();
  TextEditingController _addressLine1Controller = TextEditingController();
  TextEditingController _addressLine2Controller = TextEditingController();
  TextEditingController _townCityController = TextEditingController();
  TextEditingController _postalController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  // String booking_date_one = "";
  // String booking_date_two = "";
  bool _isLoading = false;
  String addressLineOne = "";
  String addressLineTwo = "";
  String bookingTownCity = "";
  String bookingPostalCode = "";
  String bookingDescription = "";
  String bookingPhone = "";
  final tbUser = FirebaseAuth.instance.currentUser!;
  String customerEmail = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      customerEmail = tbUser.email.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Palette.appPrimaryLight,
      body: _isLoading == true
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 58, 16, 16),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: FaIcon(FontAwesomeIcons.arrowLeft),
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          "Confirm date and address",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SfDateRangePicker(
                      onSelectionChanged: _onSelectionChanged,
                      backgroundColor: Colors.white,
                      selectionMode: DateRangePickerSelectionMode.range,
                      initialSelectedRange: PickerDateRange(
                          DateTime.now().subtract(const Duration(days: 4)),
                          DateTime.now().add(const Duration(days: 3))),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(color: Colors.black, width: 1.0)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Confirmed Date: $_range",
                              style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                    child: Center(
                      child: Text(
                        "Confirm Appointment Address",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Ubuntu',
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                            child: TextFormField(
                                controller: _addressLine1Controller,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Ubuntu',
                                    color: Colors.black),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "Address Line 1",
                                  fillColor: Palette.appPrimaryLight,
                                  floatingLabelStyle: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Ubuntu',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  focusedBorder: const OutlineInputBorder(),
                                  hintText: 'Ex. XYZ Street',
                                  hintStyle: const TextStyle(
                                      fontFamily: 'Futura',
                                      fontSize: 16,
                                      color: Colors.grey),
                                  contentPadding: const EdgeInsets.all(18.0),
                                ),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Address Line 1 cannot be empty';
                                  }
                                  return null;
                                }),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                            child: TextFormField(
                                controller: _addressLine2Controller,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Ubuntu',
                                    color: Colors.black),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "Address Line 2",
                                  floatingLabelStyle: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Ubuntu',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  focusedBorder: const OutlineInputBorder(),
                                  hintText: 'Ex. Area code',
                                  hintStyle: const TextStyle(
                                      fontFamily: 'Futura',
                                      fontSize: 16,
                                      color: Colors.grey),
                                  contentPadding: const EdgeInsets.all(18.0),
                                ),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Address Line 2 cannot be empty';
                                  }
                                  return null;
                                }),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                            child: TextFormField(
                                controller: _townCityController,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Ubuntu',
                                    color: Colors.black),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "Town/City",
                                  floatingLabelStyle: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Ubuntu',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  focusedBorder: const OutlineInputBorder(),
                                  hintText: 'Ex. Tambury',
                                  hintStyle: const TextStyle(
                                      fontFamily: 'Futura',
                                      fontSize: 16,
                                      color: Colors.grey),
                                  contentPadding: const EdgeInsets.all(18.0),
                                ),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Town/City cannot be empty';
                                  }
                                  return null;
                                }),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                            child: TextFormField(
                                controller: _postalController,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Ubuntu',
                                    color: Colors.black),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "Postal Code",
                                  floatingLabelStyle: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Ubuntu',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  focusedBorder: const OutlineInputBorder(),
                                  hintText: 'Ex. BA58',
                                  hintStyle: const TextStyle(
                                      fontFamily: 'Futura',
                                      fontSize: 16,
                                      color: Colors.grey),
                                  contentPadding: const EdgeInsets.all(18.0),
                                ),
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Postal code cannot be empty';
                                  }
                                  return null;
                                }),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                            child: TextFormField(
                                controller: _phoneController,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Ubuntu',
                                    color: Colors.black),
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: "Phone",
                                  floatingLabelStyle: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Ubuntu',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  focusedBorder: const OutlineInputBorder(),
                                  hintText: 'This phone will be used to contact you',
                                  hintStyle: const TextStyle(
                                      fontFamily: 'Futura',
                                      fontSize: 16,
                                      color: Colors.grey),
                                  contentPadding: const EdgeInsets.all(18.0),
                                ),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Phone cannot be empty';
                                  }
                                  return null;
                                }),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                            child: TextFormField(
                                controller: _descriptionController,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Ubuntu',
                                    color: Colors.black),
                                keyboardType: TextInputType.multiline,
                                maxLines: 4,
                                decoration: InputDecoration(
                                  labelText: "Description",
                                  floatingLabelStyle: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Ubuntu',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  focusedBorder: const OutlineInputBorder(),
                                  hintText:
                                      'Ex. Renovation and roofing',
                                  hintStyle: const TextStyle(
                                      fontFamily: 'Futura',
                                      fontSize: 16,
                                      color: Colors.grey),
                                  contentPadding: const EdgeInsets.all(18.0),
                                ),
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Description cannot be empty';
                                  }
                                  return null;
                                }),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Palette.appSecondaryDark,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 16),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    addressLineOne = _addressLine1Controller
                                        .text
                                        .trim()
                                        .toString();
                                    addressLineTwo = _addressLine2Controller
                                        .text
                                        .trim()
                                        .toString();
                                    bookingTownCity = _townCityController.text
                                        .trim()
                                        .toString();
                                    bookingPostalCode = _postalController.text
                                        .trim()
                                        .toString();
                                    bookingPhone =
                                        _phoneController.text.trim().toString();
                                    bookingDescription = _descriptionController
                                        .text
                                        .trim()
                                        .toString();

                                    setState(() {
                                      _isLoading = true;
                                    });
                                    createBooking();
                                  }
                                },
                                child: Text(
                                  "Complete Booking",
                                  style: TextStyle(
                                      fontFamily: "Ubuntu",
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
        setState(() {});
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  Future<void> createBooking() async {
    String booking_date_one = _range.split('-').first;
    String booking_date_two = _range.split('-').last;
    final url =
        Uri.parse('http://mobyottadevelopers.online/traders/createbooking.php');
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final body = {
      'customer_email': customerEmail,
      'trader_id': widget.traderId.toString(),
      'service_name': widget.service,
      'date_from': booking_date_one,
      'date_to': booking_date_two,
      'address_line_one': addressLineOne,
      'address_line_two': addressLineTwo,
      'city': bookingTownCity,
      'postal_code': bookingPostalCode,
      'customer_phone': bookingPhone,
      'description': bookingDescription,
      'booking_status': 'Pending',
    };

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        final bookingCode = data['data']['booking_code'];
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Booking created successfully'),
            content: Text('Booking code: $bookingCode'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => TBUserHome()));
                },
              ),
            ],
          ),
        );
      } else {
        final errorMessage = data['message'];
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    } else {
      print('HTTP request failed with status code: ${response.statusCode}');
    }
  }
}
