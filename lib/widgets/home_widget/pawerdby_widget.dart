import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/my_constant.dart';
import '../../theme/app_colors.dart';
import '../../utils/image_constant.dart';

class PawerdByDreamcastWidget extends StatelessWidget {
  const PawerdByDreamcastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "powered_by".tr,
              style: GoogleFonts.getFont(MyConstant.currentFont,
                  color: colorSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
            ),
          ),
          SvgPicture.asset(
            ImageConstant.dreamcast_logo,
            height: 20,
          ),
        ],
      ),
    );
  }
}
