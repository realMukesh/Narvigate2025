import 'package:dreamcast/core/extension/content_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:lottie/lottie.dart';
class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height,
      width: context.width,
      color: Colors.white.withOpacity(0.7),
     // color: Colors.transparent,
      child: Center(
        child:  normalLoading(),
      ),
    );
  }

  Widget normalLoading(){
    return const CupertinoActivityIndicator(color: Colors.black,
        radius: 20.0);
  }
  Widget animatedLoading(){
    return  Lottie.asset('assets/animated/loading.json',height: 200);
  }
}
class FavLoading extends StatelessWidget {
  const FavLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 25,width: 25,
      child: CircularProgressIndicator(
        backgroundColor: colorSecondary,
      ),
    );
  }

}
