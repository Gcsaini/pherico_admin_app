import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pherico_admin_app/config/my_color.dart';
import 'package:pherico_admin_app/models/user.dart';
import 'package:pherico_admin_app/screens/blogs/blogs.dart';
import 'package:pherico_admin_app/screens/users.dart';
import 'package:pherico_admin_app/screens/web_setting.dart';
import 'package:pherico_admin_app/utils/color.dart';
import 'package:pherico_admin_app/widgets/home/sales.dart';
import 'package:pherico_admin_app/widgets/home/top_five_product.dart';
import 'package:pherico_admin_app/widgets/home/total_seller_tile.dart';
import 'package:pherico_admin_app/widgets/home/total_users_tile.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class MainHome extends StatelessWidget {
  MainHome({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        titleSpacing: 10,
        leadingWidth: 38,
        leading: InkWell(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: SvgPicture.asset(
              'assets/images/navigation-icon/3_line.svg',
              colorFilter: svgColor(color: iconColor),
            ),
          ),
          onTap: () {
            scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: Image.asset(
          'assets/images/logo/logo.png',
          fit: BoxFit.contain,
          width: 100,
        ),
        iconTheme: IconThemeData(color: iconColor),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 10,
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 16),
            constraints: const BoxConstraints(),
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/images/navigation-icon/bell.svg',
              colorFilter: svgColor(
                color: HexColor('#F76436'),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        width: deviceSize.width * 0.7,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  'Menus',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Divider(),
                ListTile(
                  visualDensity: const VisualDensity(vertical: -4),
                  horizontalTitleGap: 0,
                  leading: Icon(
                    CupertinoIcons.gift_alt_fill,
                    color: iconColor,
                  ),
                  title: const Text('Blogs'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.to(() => const Blogs(),
                        transition: Transition.leftToRight);
                  },
                ),
                const Divider(),
                ListTile(
                  horizontalTitleGap: 0,
                  visualDensity: const VisualDensity(vertical: -4),
                  leading: Icon(
                    CupertinoIcons.gear_solid,
                    color: iconColor,
                  ),
                  title: const Text('Website Settings'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.to(
                      () => const WebSetting(),
                      transition: Transition.leftToRight,
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  horizontalTitleGap: 0,
                  visualDensity: const VisualDensity(vertical: -4),
                  leading: Icon(
                    CupertinoIcons.gear_solid,
                    color: iconColor,
                  ),
                  title: const Text('Users'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.to(
                      () => const Users(),
                      transition: Transition.leftToRight,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TotalUserTiles(),
                TotalSellerTiles(),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Sales(),
            SizedBox(
              height: 12,
            ),
            TopFiveProduct(),
          ],
        ),
      ),
    );
  }
}