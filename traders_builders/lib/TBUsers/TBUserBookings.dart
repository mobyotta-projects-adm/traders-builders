import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../shared/BookingDetails.dart';
import '../shared/TBAppColors.dart';

class TBUserBookings extends StatefulWidget {
  const TBUserBookings({Key? key}) : super(key: key);

  @override
  State<TBUserBookings> createState() => _TBUserBookingsState();
}

final tbUser = FirebaseAuth.instance.currentUser!;
String useremail = "";

class _TBUserBookingsState extends State<TBUserBookings> {
  List<BookingDetails> _bookings = [];

  @override
  void initState() {
    super.initState();
    useremail = tbUser.email.toString();
    _getBookings();
  }

  Future<void> _getBookings() async {
    String url =
        "http://mobyottadevelopers.online/traders/customerBookings.php?customer_email=${useremail}";
    print(url);
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)["data"];
      List<BookingDetails> bookings =
          data.map((booking) => BookingDetails.fromJson(booking)).toList();
      setState(() {
        _bookings = bookings;
      });
    } else {
      print("Failed to load bookings.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Change background color
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, // set color of back button
        ),
      ),
      backgroundColor: Palette.appPrimaryLight,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Text(
                    "My Bookings",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _bookings.length > 0
                ? SizedBox(
              height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                      itemCount: _bookings.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(16, 5, 16, 8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Booking : ${_bookings[index].bookingCode}",
                                          style: TextStyle(
                                            fontFamily: 'Ubuntu',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Spacer(),
                                        Chip(
                                          label: Text("${_bookings[index].bookingStatus}",style: TextStyle(color: Colors.black),),
                                          backgroundColor: Colors.yellow.shade300,
                                        )
                                      ],
                                    ),
                                    Text(
                                      "Description: ${_bookings[index].description}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Ubuntu',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      "Address: ${_bookings[index].addressLineOne} ${_bookings[index].addressLineTwo}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Ubuntu',
                                          color: Colors.blueGrey
                                      ),
                                    ),
                                    Text(
                                      "${_bookings[index].city}, ${_bookings[index].postalCode}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Ubuntu',
                                          color: Colors.blueGrey
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        "${_bookings[index].creationDateTime}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Ubuntu',
                                            color: Colors.blueGrey
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          ),
                        );
                      },
                    ),
                )
                : Center(
                    child: Text("No bookings found."),
                  ),

          ],
        ),
      ),
    );
  }
}
