import 'package:auto_size_text/auto_size_text.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:flutter/material.dart';
import 'package:dreamcast/theme/app_colors.dart';

import '../../../routes/my_constant.dart';

class RoundedOutlineButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final double textSize;
  final double radius;
  final bool showIcon;
  const RoundedOutlineButton(
      {Key? key,
      required this.text,
      required this.press,
      this.color = colorSecondary,
      this.textColor = colorSecondary,
      this.textSize = 14,
        this.radius=12,
      this.showIcon = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      width: size.width,
      height: 55,
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.white,
            side: BorderSide(color: color, width: 1),
            shape:  RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(radius))),
          ),
          onPressed: () {
            Future.delayed(Duration.zero, () async {
              press();
            });
          },
          child: CustomTextView(
            text: text,
            color: textColor,
            fontSize: textSize,
          )),
    );
  }
}


class ButtonMeetingAction extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final double textSize;
  final bool showIcon;
  const ButtonMeetingAction(
      {Key? key,
      required this.text,
      required this.press,
      this.color = colorSecondary,
      this.textColor = colorSecondary,
      this.textSize = 14,
      this.showIcon = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: color,
          side: BorderSide(color: color, width: 1),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        onPressed: () {
          Future.delayed(Duration.zero, () async {
            press();
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: CustomTextView(
            text: text,
            color: textColor,
            fontSize: textSize,
          ),
        ));
  }
}

class MyOutlineButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final double textSize;
  final bool showIcon;
  const MyOutlineButton(
      {Key? key,
      required this.text,
      required this.press,
      this.color = colorSecondary,
      this.textColor = colorSecondary,
      this.textSize = 14,
      this.showIcon = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.white,
          side: BorderSide(color: color, width: 1),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
        onPressed: () {
          Future.delayed(Duration.zero, () async {
            press();
          });
        },
        child: CustomTextView(
          text: text,
          color: textColor,
          fontSize: textSize,
        ));
  }
}

class SessionButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final double textSize;
  final bool showIcon;
  const SessionButton(
      {Key? key,
      required this.text,
      required this.press,
      this.color = colorSecondary,
      this.textColor = colorSecondary,
      this.textSize = 14,
      this.showIcon = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: color,
          side: BorderSide(color: color, width: 1),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
        onPressed: () {
          Future.delayed(Duration.zero, () async {
            press();
          });
        },
        child: AutoSizeText(text,style: TextStyle(color: textColor),
        ));
  }
}

class MeetingButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final double textSize;
  final bool showIcon;
  final String iconPath;
  const MeetingButton(
      {Key? key,
      required this.text,
      required this.press,
      this.color = colorSecondary,
      this.textColor = colorSecondary,
      this.textSize = 14,
      required this.iconPath,
      this.showIcon = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.white,
          side: BorderSide(color: color, width: 1),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3))),
        ),
        onPressed: () {
          Future.delayed(Duration.zero, () async {
            press();
          });
        },
        child: SizedBox(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                iconPath,
                height: 20,
                color: colorSecondary,
              ),
              const SizedBox(
                width: 6,
              ),
              CustomTextView(
                text: text,
                color: textColor,
                fontSize: textSize,
              )
            ],
          ),
        ));
  }
}

class MeetingButtonChat extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final double textSize;
  final bool showIcon;
  final String iconPath;
  const MeetingButtonChat(
      {Key? key,
      required this.text,
      required this.press,
      this.color = colorSecondary,
      this.textColor = colorSecondary,
      this.textSize = 14,
      required this.iconPath,
      this.showIcon = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.white,
          side: BorderSide(color: color, width: 1),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
        onPressed: () {
          Future.delayed(Duration.zero, () async {
            press();
          });
        },
        child: SizedBox(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                iconPath,
                height: 22,
                color: color,
              ),
              const SizedBox(
                width: 6,
              ),
              CustomTextView(
                text: text,
                color: textColor,
                fontSize: textSize,
                fontWeight: FontWeight.normal,
              )
            ],
          ),
        ));
  }
}

class ProfileSaveButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final double textSize;
  final bool showIcon;
  const ProfileSaveButton(
      {Key? key,
      required this.text,
      required this.press,
      this.color = colorSecondary,
      this.textColor = colorSecondary,
      this.textSize = 14,
      this.showIcon = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: 160,
      height: 45,
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.white,
            side: BorderSide(color: color, width: 1),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
          onPressed: () {
            Future.delayed(Duration.zero, () async {
              press();
            });
          },
          child: CustomTextView(
            text: text,
            color: textColor,
            fontSize: textSize,
          )),
    );
  }
}
