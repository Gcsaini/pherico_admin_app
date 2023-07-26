import 'package:flutter/material.dart';

class CustomAppbarWithourBack extends StatelessWidget {
  final String title;
  const CustomAppbarWithourBack({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: AppBar(
        key: Key(title),
        title: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
