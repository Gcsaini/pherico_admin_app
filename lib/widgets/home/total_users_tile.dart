import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico_admin_app/config/my_color.dart';
import 'package:pherico_admin_app/screens/users.dart';

class TotalUserTiles extends StatelessWidget {
  const TotalUserTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => const Users(), transition: Transition.rightToLeft);
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
                  'Total Users',
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
                            'https://firebasestorage.googleapis.com/v0/b/pherico-4a1e4.appspot.com/o/profiles%2Fc8ed2310-10c5-11ee-8e56-ed16787f87af?alt=media&token=8eb06ea1-58b3-4219-b44f-97e835b498d8',
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
                              'https://firebasestorage.googleapis.com/v0/b/pherico-4a1e4.appspot.com/o/store_profile%2F16cbe360-0f5d-11ee-99a5-bbf42b1ed316?alt=media&token=aa494cc8-4ab3-4a50-bc03-c566456b84e5',
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
                              'https://i.pinimg.com/564x/54/26/a5/5426a51fe15b4bb1dca378b3f6963d30.jpg',
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
