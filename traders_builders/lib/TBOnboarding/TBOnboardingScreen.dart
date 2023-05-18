import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traders_builders/TBUsers/UserRegister.dart';
import 'package:traders_builders/shared/TBAppColors.dart';
import 'TBOboard_model.dart';

class TBOnboardingScreen extends StatefulWidget {
  const TBOnboardingScreen({Key? key}) : super(key: key);

  @override
  State<TBOnboardingScreen> createState() => _TBOnboardingScreenState();
}

class _TBOnboardingScreenState extends State<TBOnboardingScreen> {
  int currentIndex = 0;
  late PageController _pageController;
  List<OnboardModel> screens = <OnboardModel>[
    OnboardModel(
      img: 'assets/customer-1.png',
      text: "Welcome to our App!",
      desc:
      "Easily schedule professional on-demand home services",
      bg: Colors.white,
      button: Color(0xFF4756DF),
    ),
    OnboardModel(
      img: 'assets/customer-3.png',
      text: "Find the Right Contractor for your project",
      desc:
      "Browse and compare quotes from vetted professionals, read reviews to make an informed decision",
      bg: Color(0xFF4756DF),
      button: Colors.white,
    ),
    OnboardModel(
      img: 'assets/customer-2.png',
      text: "Keep track of the project",
      desc:
      "Track progress, communicate and rate your contractor in real-time, all through our app",
      bg: Colors.white,
      button: Color(0xFF4756DF),
    ),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _storeOnboardInfo() async {
    print("Shared pref called");
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
    print(prefs.getInt('onBoard'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          TextButton(
            onPressed: () {
              _storeOnboardInfo();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => UserRegister()));
            },
            child: Text(
              "Skip",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: PageView.builder(
            itemCount: screens.length,
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (_, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(screens[index].img),
                  Container(
                    height: 10.0,
                    child: ListView.builder(
                      itemCount: screens.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 3.0),
                                width: 25,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: currentIndex == index
                                      ? Colors.brown
                                      : Colors.brown.shade100,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ]);
                      },
                    ),
                  ),
                  Text(
                    screens[index].text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 27.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Ubuntu-Medium',
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    screens[index].desc,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Ubuntu-Regular',
                      color: Colors.black,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      print(index);
                      if (index == screens.length - 1) {
                        await _storeOnboardInfo();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => UserRegister()));
                      }

                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.bounceIn,
                      );
                    },
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                      decoration: BoxDecoration(
                          color: Palette.appPrimaryDark,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(
                          "Next",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Icon(
                          Icons.arrow_forward_sharp,
                          color: Colors.white,
                        )
                      ]),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
