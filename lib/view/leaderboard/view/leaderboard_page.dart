import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/customImageWidget.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: colorLightGray,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.maxFinite,
                        margin: const EdgeInsets.all(2),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: CustomTextView(
                          text: '#2',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            children: [
                              CustomImageWidget(
                                imageUrl: "",
                                shortName: "DM",
                                fontSize: 18,
                                size: 70,
                                color: const Color(0x334658a7),
                              ),
                              const SizedBox(height: 5),
                              Flexible(
                                child: CustomTextView(
                                  text: 'John Thomas',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  maxLines: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                              CustomTextView(
                                text: '6654',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: colorPrimary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 136.v,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: colorPrimary,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(ImageConstant.crown_icon),
                    const SizedBox(height: 5),
                    CustomImageWidget(
                      imageUrl: "",
                      shortName: "DM",
                      fontSize: 18,
                      size: 90,
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      child: CustomTextView(
                        text: 'Arman Sharma',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                        color: white,
                      ),
                    ),
                    CustomTextView(
                      text: '7754',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      maxLines: 1,
                      color: white,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: colorLightGray,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.maxFinite,
                        margin: const EdgeInsets.all(2),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: CustomTextView(
                          text: '#3',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            children: [
                              CustomImageWidget(
                                imageUrl: "",
                                shortName: "DM",
                                fontSize: 18,
                                size: 70,
                                color: const Color(0x334658a7),
                              ),
                              const SizedBox(height: 5),
                              Flexible(
                                child: CustomTextView(
                                  text: 'Liza Ray',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  maxLines: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // const SizedBox(height: 8),
                              CustomTextView(
                                text: '6423',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: colorPrimary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                decoration: index == 0
                    ? BoxDecoration(
                        color: colorLightGray,
                        borderRadius: BorderRadius.circular(10.0),
                      )
                    : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  child: Row(
                    children: [
                      CustomTextView(
                        text: '#${index + 1}',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: index == 0 ? colorPrimary : Colors.black,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Row(
                          children: [
                            CustomImageWidget(
                              imageUrl: "",
                              shortName: "DM",
                              fontSize: 18,
                              size: 50,
                              color: index == 0
                                  ? const Color(0x334658a7)
                                  : colorLightGray,
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: CustomTextView(
                                text: index == 0 ? 'You' : 'Aman Mehra',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: index == 0 ? colorPrimary : Colors.black,
                                maxLines: 2,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      CustomTextView(
                        text: '1345',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: index == 0 ? colorPrimary : Colors.black,
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return const SizedBox(height: 8);
              }
              return const Divider();
            },
          ),
        ),
      ],
    );
  }
}
