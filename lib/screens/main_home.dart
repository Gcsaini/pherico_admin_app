import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pherico_admin_app/config/my_color.dart';
import 'package:pherico_admin_app/screens/categories.dart';
import 'package:pherico_admin_app/screens/sellers.dart';
import 'package:pherico_admin_app/screens/users.dart';
import 'package:pherico_admin_app/screens/web_setting.dart';
import 'package:pherico_admin_app/utils/color.dart';
import 'package:pherico_admin_app/widgets/global/inside_circle_svg.dart';
import 'package:pherico_admin_app/widgets/home/recent_orders_widget.dart';
import 'package:pherico_admin_app/widgets/home/sales.dart';
import 'package:pherico_admin_app/widgets/home/top_five_product.dart';
import 'package:pherico_admin_app/widgets/home/total_sales_widget.dart';
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
        centerTitle: true,
        leading: InkWell(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: SvgPicture.asset(
              'assets/images/navigation-icon/3_line.svg',
              colorFilter: svgColor(color: white),
            ),
          ),
          onTap: () {
            scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: SvgPicture.asset(
          'assets/images/icons/pherico_white.svg',
          fit: BoxFit.contain,
          width: 100,
          height: 40,
        ),
        iconTheme: IconThemeData(color: iconColor),
        backgroundColor: HexColor('#F9881F'),
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 16),
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/images/icons/bell.svg',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
              colorFilter: svgColor(
                color: white,
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
                  height: 16,
                ),
                menuTile(
                  CupertinoIcons.gear_solid,
                  () {
                    Navigator.of(context).pop();
                    Get.to(
                      () => const WebSetting(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  'Website Settings',
                ),
                menuTile(
                  CupertinoIcons.person_crop_circle,
                  () {
                    Navigator.of(context).pop();
                    Get.to(
                      () => const Users(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  'Users',
                ),
                menuTile(
                  CupertinoIcons.person_3_fill,
                  () {
                    Navigator.of(context).pop();
                    Get.to(
                      () => const Sellers(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  'Sellers',
                ),
                menuTile(
                  CupertinoIcons.equal_circle_fill,
                  () {
                    Navigator.of(context);
                    Get.to(() => const Categories(),
                        transition: Transition.rightToLeft);
                  },
                  'Categories',
                ),
                menuTile(
                  CupertinoIcons.square_arrow_right_fill,
                  () {
                    Navigator.of(context);
                    Get.to(() => const Categories(),
                        transition: Transition.rightToLeft);
                  },
                  'Logout',
                )
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InsideCircleSvg(
                  path: 'assets/images/icons/users.svg',
                  onTap: () {
                    Get.to(() => const Users(),
                        transition: Transition.rightToLeft);
                  },
                  borderColor: HexColor('#F4F3F3'),
                  label: 'Users',
                ),
                InsideCircleSvg(
                  path: 'assets/images/icons/users.svg',
                  onTap: () {
                    Get.to(() => const Sellers(),
                        transition: Transition.rightToLeft);
                  },
                  borderColor: HexColor('#F4F3F3'),
                  label: 'Sellers',
                ),
                InsideCircleSvg(
                  path: 'assets/images/icons/products.svg',
                  onTap: () {},
                  borderColor: HexColor('#F4F3F3'),
                  label: 'Products',
                ),
                InsideCircleSvg(
                  path: 'assets/images/icons/categories.svg',
                  onTap: () {
                    Get.to(() => const Categories(),
                        transition: Transition.rightToLeft);
                  },
                  borderColor: HexColor('#F4F3F3'),
                  label: 'Categories',
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TotalSales(),
                RecentOrderWidget(),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            const Sales(),
            const SizedBox(
              height: 12,
            ),
            const TopFiveProduct(),
          ],
        ),
      ),
    );
  }
}

Widget menuTile(IconData icon, VoidCallback onTap, String title) {
  return ListTile(
    horizontalTitleGap: 4,
    leading: Icon(
      icon,
      color: iconColor,
      size: 30,
    ),
    title: Text(title),
    onTap: onTap,
  );
}
