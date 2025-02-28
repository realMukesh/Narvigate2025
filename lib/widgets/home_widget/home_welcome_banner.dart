import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/view/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../utils/image_constant.dart';

class HomeWelcomeBanner extends GetView<HomeController> {
  const HomeWelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) {
        return SizedBox(
          height: 240,
          child: CachedNetworkImage(
            imageUrl: controller.configDetailBody.value.heroBanner ?? "",
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) =>
                Skeletonizer(
                    enabled: true,
                    child: Image.asset(ImageConstant.banner_img, fit: BoxFit.cover)),
          ),
        );
      },
    );
  }
}
