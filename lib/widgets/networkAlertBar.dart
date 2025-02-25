import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkAlertBar extends StatelessWidget {
  const NetworkAlertBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Container(
        width: context.width,
        height: context.height,
        color: Colors.red,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Icon(
                Icons.error,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "No Internet connection!!",
                style: TextStyle(
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