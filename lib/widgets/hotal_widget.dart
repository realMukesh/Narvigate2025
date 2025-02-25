import 'package:dreamcast/theme/app_decoration.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:dreamcast/widgets/button/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../theme/app_colors.dart';
import '../view/home/screen/pdfViewer.dart';
import 'button/custom_elevated_button.dart';

class HotelWidget extends StatelessWidget {
  const HotelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecoration.commonDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          hotelNameWidget(),
          const Divider(),
          hotelDateWidget(),
          const Divider(),
          hotelRoomNumber(),
          CommonMaterialButton(
            color: colorSecondary,
            text: "Download Hotel Details",
            onPressed: () async {
              Get.to(PdfViewPage(
                htmlPath: "",
                title: "Download Hotel Details",
              ));
            },
          )
        ],
      ),
    );
  }

  hotelDateWidget() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextView(
                color: colorGray,
                fontWeight: FontWeight.normal,
                fontSize: 16,
                text: "Check in Date",
                textAlign: TextAlign.start,
              ),
              CustomTextView(
                text: "Thu, 15 Jun 23",
                color: colorSecondary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextView(
                color: colorGray,
                fontWeight: FontWeight.normal,
                fontSize: 16,
                text: "Check out Date",
              ),
              CustomTextView(
                text: "Mon, 19 Jun 23",
                color: colorSecondary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ],
          )
        ],
      ),
    );
  }

  hotelNameWidget() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextView(
            color: colorGray,
            fontWeight: FontWeight.normal,
            fontSize: 16,
            text: "Hotel Name",
            textAlign: TextAlign.start,
          ),
          CustomTextView(
            text: "The Taj Hotel, Mumbai",
            color: colorSecondary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  hotelRoomNumber() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextView(
                  color: colorGray,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  text: "Room Number"),
              CustomTextView(
                text: "208",
                textAlign: TextAlign.start,
                color: colorSecondary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextView(
                color: colorGray,
                fontWeight: FontWeight.normal,
                fontSize: 16,
                text: "Booked For",
              ),
              CustomTextView(
                text: "Adult",
                color: colorSecondary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ],
          )
        ],
      ),
    );
  }
}
