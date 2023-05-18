import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:traders_builders/TBUsers/TBUserHome.dart';

import '../shared/TBAppColors.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({Key? key}) : super(key: key);

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return TBUserHome();
            }
            return SignInScreen(
              providerConfigs: [
                EmailProviderConfiguration(),
                GoogleProviderConfiguration(clientId: ''),
                AppleProviderConfiguration()
              ],
              headerBuilder: (context,constraints,_){
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: AspectRatio(
                    aspectRatio: 1  ,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Palette.appPrimaryDark
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Hey Tradey",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontSize: 28,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  Text(
                                    "Panyi and Thompson Ltd.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ),
                  ),
                );
              },
              subtitleBuilder: (context,action){
                return Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: Text(
                      action == AuthAction.signIn ? "Welcome back! Login to continue" : "Create an account to continue"
                  ),
                );
              },
            );
          }

      ),
    );
  }
}
