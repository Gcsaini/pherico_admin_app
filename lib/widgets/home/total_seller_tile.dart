import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico_admin_app/config/my_color.dart';
import 'package:pherico_admin_app/screens/sellers.dart';

class TotalSellerTiles extends StatelessWidget {
  const TotalSellerTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => const Sellers(), transition: Transition.rightToLeft);
      },
      child: Card(
        elevation: 0,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.43,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '120',
                  style: TextStyle(
                    color: white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  'Total Sellers',
                  style: TextStyle(
                    color: white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.23,
                  child: Stack(children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://firebasestorage.googleapis.com/v0/b/pherico-4a1e4.appspot.com/o/store_profile%2F16cbe360-0f5d-11ee-99a5-bbf42b1ed316?alt=media&token=aa494cc8-4ab3-4a50-bc03-c566456b84e5',
                        fit: BoxFit.cover,
                        height: 28,
                        width: 28,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                      ),
                    ),
                    Positioned(
                      left: 15,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://firebasestorage.googleapis.com/v0/b/pherico-4a1e4.appspot.com/o/store_profile%2F6329b410-0f28-11ee-8f4a-e506407f6171?alt=media&token=7fa32078-37c4-4e11-9eab-c3e2aae55dcb',
                          fit: BoxFit.cover,
                          height: 28,
                          width: 28,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 30,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://firebasestorage.googleapis.com/v0/b/pherico-4a1e4.appspot.com/o/store_profile%2F2d99fc40-241a-11ee-8cf8-b9e9bdccef2f?alt=media&token=13d3ab98-77f5-4571-9d68-8c38ed9dcad8',
                          fit: BoxFit.cover,
                          height: 28,
                          width: 28,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
