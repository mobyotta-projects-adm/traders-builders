import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:traders_builders/TBUsers/TBUsersProfile.dart';
import 'package:traders_builders/shared/servicesListModel.dart';
import '../shared/TBAppColors.dart';
import 'TBTradersListForSelection.dart';

class TBUserHome extends StatefulWidget {
  const TBUserHome({Key? key}) : super(key: key);

  @override
  State<TBUserHome> createState() => _TBUserHomeState();
}

final tbUser = FirebaseAuth.instance.currentUser!;

class _TBUserHomeState extends State<TBUserHome> {
  TextEditingController _controller = TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<String>> _key = GlobalKey();
  List<String> _options = [];
  String dropdownValue = '123 Main St. Suite 456';

  List<String> locations = ['123 Main St. Suite 456', 'Location 2', 'Location 3'];

  @override
  void initState() {
    super.initState();
    fetchOptions().then((options) {
      setState(() {
        _options = options;
      });
    });
  }

  Future<List<String>> fetchOptions() async {
    final response = await http.get(
        Uri.parse('http://mobyottadevelopers.online/traders/servicelist.php'));

    if (response != null && response.statusCode == 200) {
      List<String> options = (jsonDecode(response.body) as List<dynamic>)
          .map((item) => item['service_name'].toString())
          .toList();
      return options;
    } else {
      throw Exception('Failed to fetch options');
    }
  }

  String currentText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.appPrimaryDark,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.locationDot,
                            color: Palette.appSecondaryDark,
                            size: 20.0,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Select Location",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(width: 2),
                          FaIcon(
                            FontAwesomeIcons.chevronDown,
                            color: Colors.white,
                            size: 10.0,
                          ),
                        ],
                      ),
                      DropdownButton<String>(
                        value: dropdownValue,
                        elevation: 16,
                        style: const TextStyle(color: Colors.white),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: locations
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,style: TextStyle(color: Colors.black),),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    child: CircleAvatar(
                      child: FaIcon(
                        FontAwesomeIcons.solidBell,
                        color: Colors.black,
                        size: 15.0,
                      ),
                      backgroundColor: Palette.appSecondaryDark,
                      radius: 20.0,
                    ),
                    onTap: () {},
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    child: CircleAvatar(
                      child: FaIcon(
                        FontAwesomeIcons.solidUser,
                        color: Colors.black,
                        size: 15.0,
                      ),
                      backgroundColor: Palette.appSecondaryDark,
                      radius: 20.0,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TBUsersProfile()));
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
              child: Text(
                "What are you looking for today?",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Ubuntu',
                    fontSize: 18,
                    fontWeight: FontWeight.w100),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TypeAheadField<String>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _controller,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      // set the border radius
                      borderSide: BorderSide.none,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      // set the border radius
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Palette.appPrimaryLight,
                    filled: true,
                    hintText: "Select a service",
                    hintStyle: const TextStyle(fontStyle: FontStyle.italic),
                    contentPadding: const EdgeInsets.all(18.0),
                  ),
                ),
                suggestionsCallback: (String pattern) async {
                  return _options.where((option) =>
                      option.toLowerCase().contains(pattern.toLowerCase()));
                },
                itemBuilder: (BuildContext context, String suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (String suggestion) {
                  _controller.text = suggestion;
                  currentText = suggestion;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TBTradersListForSelection(
                                service: currentText,
                              )));
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
              child: Row(
                children: [
                  Text(
                    "Popular Services",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 10),
                  FaIcon(
                    FontAwesomeIcons.arrowRightLong,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 300,
              child: PageView(
                controller: PageController(
                  viewportFraction: 0.8,
                  initialPage: 0,
                ),
                padEnds: false,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      child: Stack(
                        children: [
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/painters.jpg"),
                                  fit: BoxFit.cover,
                                  opacity: 0.6),
                            ),
                          ),
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                                color:
                                    Palette.appPrimaryAccent.withOpacity(0.2)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Painting",
                                      style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                          fontSize: 26,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TBTradersListForSelection(
                                                      service: "Painting",
                                                    )));
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: Palette.appSecondaryDark),
                                      child: Text(
                                        "Book now",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Ubuntu'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      child: Stack(
                        children: [
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/carpenter.jpg"),
                                  fit: BoxFit.cover,
                                  opacity: 0.6),
                            ),
                          ),
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                                color: Palette.appPrimaryDark.withOpacity(0.2)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Carpentry",
                                      style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                          fontSize: 26,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TBTradersListForSelection(
                                                      service: "Carpentry",
                                                    )));
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: Palette.appSecondaryDark),
                                      child: Text(
                                        "Book now",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Ubuntu'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      child: Stack(
                        children: [
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/builders.jpg"),
                                  fit: BoxFit.cover,
                                  opacity: 0.6),
                            ),
                          ),
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                                color: Palette.appPrimaryDark.withOpacity(0.2)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Commercial Construction",
                                      style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                          fontSize: 26,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TBTradersListForSelection(
                                                      service:
                                                          "Commercial Construction",
                                                    )));
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: Palette.appSecondaryDark),
                                      child: Text(
                                        "Book now",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Ubuntu'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      child: Stack(
                        children: [
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/electrician.jpg"),
                                  fit: BoxFit.cover,
                                  opacity: 0.6),
                            ),
                          ),
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                                color: Palette.appPrimaryDark.withOpacity(0.2)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Electrical",
                                      style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                          fontSize: 26,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TBTradersListForSelection(
                                                      service: "Electrical",
                                                    )));
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: Palette.appSecondaryDark),
                                      child: Text(
                                        "Book now",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Ubuntu'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }


}
