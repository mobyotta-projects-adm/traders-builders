import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:traders_builders/TBUsers/TBBookingScreen.dart';

class TBTradersListForSelection extends StatefulWidget {
  final String service;

  const TBTradersListForSelection({Key? key, required this.service})
      : super(key: key);

  @override
  _TBTradersListForSelectionState createState() =>
      _TBTradersListForSelectionState();
}

class _TBTradersListForSelectionState extends State<TBTradersListForSelection> {
  List tradersList = [];
  int count = 0;

  @override
  void initState() {
    super.initState();
    fetchTraders();
  }

  Future<void> fetchTraders() async {
    final response = await http.get(Uri.parse(
        'http://mobyottadevelopers.online/traders/searchtraders.php?service_name=${widget.service}'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        setState(() {
          tradersList = responseData['data'];
          count = tradersList.length;
        });
      } else {
        throw Exception('Failed to load traders');
      }
    } else {
      throw Exception('Failed to load traders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
            height: 80.0,
            child: Text(
              '$count Traders found for "${widget.service}"',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Ubuntu',
                  fontSize: 32,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: tradersList == null || tradersList.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/nodatafound.png',height: 80,),
                  SizedBox(height: 20,),
                  Text(
                    'No traders found for this service',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Ubuntu',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: tradersList.length,
              itemBuilder: (BuildContext context, int index) {
                final trader = tradersList[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
                  child: GestureDetector(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(2, 8, 5, 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              'http://mobyottadevelopers.online/traders/${trader['photo']}',
                            ),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  'http://mobyottadevelopers.online/traders/${trader['photo']}',
                                  fit: BoxFit.cover,
                                  height: 100,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            trader['name'],
                            style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'Ubuntu',
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trader['address'],
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Ubuntu',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w200),
                              ),
                              Text(trader['postal_code']),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                children: [
                                  Spacer(),
                                  Text(
                                    "Book Now",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(width: 10),
                                  FaIcon(
                                    FontAwesomeIcons.arrowRightLong,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=>TBBookingScreen(traderId: trader['trader_id'], service: widget.service,))
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
