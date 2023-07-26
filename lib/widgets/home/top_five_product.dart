import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pherico_admin_app/config/my_color.dart';
import 'package:pherico_admin_app/config/variables.dart';
import 'package:pherico_admin_app/utils/border.dart';

class TopFiveProduct extends StatefulWidget {
  const TopFiveProduct({super.key});

  @override
  State<TopFiveProduct> createState() => _TopFiveProductState();
}

class _TopFiveProductState extends State<TopFiveProduct> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Text(
            'Top Performing products',
            style: TextStyle(fontWeight: FontWeight.bold, color: brownText),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Card(
              elevation: 0.4,
              color: cardBg,
              shape: borderShape(radius: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: defaultProduct,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              'Product name',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          Text(
                            'Stocks:15',
                            style: TextStyle(color: greyText),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${rupeeSymbol}9999',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: brownText),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
