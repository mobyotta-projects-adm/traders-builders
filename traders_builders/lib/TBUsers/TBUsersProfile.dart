import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:traders_builders/TBUsers/TBUserBookings.dart';
import 'package:traders_builders/TBUsers/UserRegister.dart';

import '../shared/TBAppColors.dart';

class TBUsersProfile extends StatefulWidget {
  const TBUsersProfile({Key? key}) : super(key: key);

  @override
  State<TBUsersProfile> createState() => _TBUsersProfileState();
}
final tbUser = FirebaseAuth.instance.currentUser!;
class _TBUsersProfileState extends State<TBUsersProfile> {
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
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tbUser.displayName.toString().split(" ").first.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontFamily: 'Ubuntu',
                                    fontWeight: FontWeight.w700
                                ),
                              ),
                              SizedBox(height: 5,),
                              Text(
                                tbUser.email.toString(),
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontFamily: 'Ubuntu',
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          GestureDetector(
                              child: FaIcon(FontAwesomeIcons.signOut),
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => UserRegister()), (route) => false);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Divider(
                        thickness: 1.5,
                        color: Colors.black,
                      ),
                      SizedBox(height: 10,),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          GestureDetector(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 46,
                                  width: 46,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Palette.appSecondaryDark
                                  ),
                                  child: FaIcon(FontAwesomeIcons.clipboardCheck,color: Colors.black,),
                                  alignment: Alignment.center,
                                ),
                                SizedBox(width: 20,),
                                Text(
                                  "Your Bookings",
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                                Spacer(),
                                FaIcon(FontAwesomeIcons.chevronRight,size: 16,)

                              ],
                            ),
                            onTap: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => TBUserBookings()));
                            },
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 46,
                                width: 46,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Palette.appSecondaryDark
                                ),
                                child: FaIcon(FontAwesomeIcons.question,color: Colors.black,),
                                alignment: Alignment.center,
                              ),
                              SizedBox(width: 20,),
                              Text(
                                "About the app",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                              Spacer(),
                              FaIcon(FontAwesomeIcons.chevronRight,size: 16,)

                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 46,
                                width: 46,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Palette.appSecondaryDark
                                ),
                                child: FaIcon(FontAwesomeIcons.headset,color: Colors.black,),
                                alignment: Alignment.center,
                              ),
                              SizedBox(width: 20,),
                              Text(
                                "Help & Support",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                              Spacer(),
                              FaIcon(FontAwesomeIcons.chevronRight,size: 16,)

                            ],
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
