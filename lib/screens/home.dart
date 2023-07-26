import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:pherico_admin_app/config/my_color.dart';
import 'package:pherico_admin_app/resources/user_resource.dart';
import 'package:pherico_admin_app/screens/main_home.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List pages = [
    MainHome(),
    MainHome(),
    MainHome(),
    MainHome(),
  ];

  int currentPage = 0;

  void onTap(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  void initState() {
    super.initState();
    UserResource.getUserInfo();
    SystemChannels.lifecycle.setMessageHandler((message) {
      return Future.value(message);
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {});
  }

  late DateTime backPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(backPressTime) > const Duration(seconds: 2)) {
      backPressTime = now;

      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: DoubleBackToCloseApp(
        child: pages[currentPage],
        snackBar: const SnackBar(
          content: Text('Double tap to exit'),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 245, 245, 245),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      currentPage = 0;
                    });
                  },
                  icon: Icon(
                    Icons.home,
                    color: currentPage == 0 ? gradient1 : iconColor,
                  ),
                ),
                Text(
                  'Home',
                  style: TextStyle(
                      height: -0.001,
                      fontSize: 12,
                      color: currentPage == 0 ? gradient1 : iconColor),
                )
              ],
            ),
            Column(
              children: [
                IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      currentPage = 1;
                    });
                  },
                  icon: Icon(
                    CupertinoIcons.news_solid,
                    color: currentPage == 1 ? gradient1 : iconColor,
                  ),
                ),
                Text(
                  'Reports',
                  style: TextStyle(
                      height: -0.001,
                      fontSize: 12,
                      color: currentPage == 1 ? gradient1 : iconColor),
                )
              ],
            ),
            Column(
              children: [
                IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      currentPage = 2;
                    });
                  },
                  icon: Icon(
                    CupertinoIcons.person_2_fill,
                    color: currentPage == 2 ? gradient1 : iconColor,
                  ),
                ),
                Text(
                  'Sellers',
                  style: TextStyle(
                      height: -0.001,
                      fontSize: 12,
                      color: currentPage == 2 ? gradient1 : iconColor),
                )
              ],
            ),
            Column(
              children: [
                IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      currentPage = 3;
                    });
                  },
                  icon: Icon(
                    CupertinoIcons.person_solid,
                    color: currentPage == 3 ? gradient1 : iconColor,
                  ),
                ),
                Text(
                  'Account',
                  style: TextStyle(
                      height: -0.001,
                      fontSize: 12,
                      color: currentPage == 3 ? gradient1 : iconColor),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
