import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pherico_admin_app/config/my_color.dart';
import 'package:pherico_admin_app/screens/users.dart';
import 'package:pherico_admin_app/utils/border.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class TotalSales extends StatelessWidget {
  const TotalSales({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => const Users(), transition: Transition.rightToLeft);
      },
      child: Card(
        elevation: 2,
        shape: borderShape(radius: 20),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: HexColor('#C5F6CD'),
                child: SvgPicture.asset('assets/images/icons/rupees.svg'),
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                'Total Sales',
                style: TextStyle(
                  color: iconColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
