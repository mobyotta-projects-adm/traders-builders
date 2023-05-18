import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traders_builders/TBOnboarding/TBOnboardingScreen.dart';
import 'package:traders_builders/TBUsers/UserRegister.dart';
import 'package:traders_builders/shared/TBAppColors.dart';
import 'firebase_options.dart';

int? isviewed;
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Palette.kToDark,
            inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)
                )
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    backgroundColor: Palette.appSecondaryDark,
                    primary: Colors.black
                )
            ),
          scaffoldBackgroundColor: Palette.appPrimaryLight
        ),
      home: isviewed != 0 ? TBOnboardingScreen() : UserRegister(),
    );
  }


}