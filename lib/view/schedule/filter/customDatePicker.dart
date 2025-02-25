import 'package:dreamcast/widgets/customTextView.dart';
import 'package:dreamcast/view/schedule/controller/session_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';

class CustomDatePicker extends GetView<SessionController> {
  String title;
  final Function(dynamic) chooseDate;
  CustomDatePicker({Key? key,required this.title,required this.chooseDate}) : super(key: key);

// Initial Selected Value

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: (){
            Future.delayed(Duration.zero, () async {
              chooseDate("");
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
            decoration:  BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                border: Border.all(color:indicatorColor,width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: const ListTile(
              title: CustomTextView(text: /*controller.defaultDate!.isEmpty?MyStrings.select_date:controller.defaultDate??"",*/""),
              trailing: Icon(Icons.arrow_drop_down),
            ),
          ),
        )
      ],
    );
  }

}
