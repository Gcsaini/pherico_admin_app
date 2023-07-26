import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pherico_admin_app/config/my_color.dart';
import 'package:pherico_admin_app/utils/border.dart';

class Sales extends StatelessWidget {
  const Sales({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        color: cardBg,
        elevation: 0.5,
        shape: borderShape(radius: 10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sales',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: brownText),
                      ),
                      Text(
                        'Week comparision',
                        style: TextStyle(color: greyText),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '1.2%',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: brownText,
                            fontSize: 16),
                      ),
                      Icon(
                        CupertinoIcons.up_arrow,
                        color: green,
                        size: 14,
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 8,
                decoration: BoxDecoration(
                  color: greyColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Container(
                  margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.2,
                  ),
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 8,
                  decoration: BoxDecoration(
                    color: green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
