import 'package:dreamcast/widgets/hotal_widget.dart';
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/toolbarTitle.dart';
class HotelInfoPage extends StatelessWidget {
  const HotelInfoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: false,
        title: const ToolbarTitle(title: "Hotel Info"),
        backgroundColor: appBarColor,
        shape:
            const Border(bottom: BorderSide(color: indicatorColor, width: 1)),
        elevation: 0,
        iconTheme: const IconThemeData(color: colorSecondary),
      ),
      body: const Padding(
        padding: EdgeInsets.all(15.0),
        child: HotelWidget(),
      ),
    );
  }
}
