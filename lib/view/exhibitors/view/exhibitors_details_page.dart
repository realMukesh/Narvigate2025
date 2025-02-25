import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreamcast/routes/my_constant.dart';
import 'package:dreamcast/theme/ui_helper.dart';
import 'package:dreamcast/utils/image_constant.dart';
import 'package:dreamcast/utils/size_utils.dart';
import 'package:dreamcast/widgets/loading.dart';
import 'package:dreamcast/widgets/customTextView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:dreamcast/theme/app_colors.dart';
import 'package:dreamcast/view/beforeLogin/globalController/authentication_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../api_repository/app_url.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/flow_widget.dart';
import '../../../widgets/toolbarTitle.dart';
import '../../Notes/controller/my_notes_controller.dart';
import '../../Notes/model/common_notes_model.dart';
import '../../quiz/view/feedback_page.dart';
import '../../representatives/controller/user_detail_controller.dart';
import '../controller/exhibitorsController.dart';
import '../model/exhibitorTeamModel.dart';
import '../../askQuestion/view/ask_question_page.dart';

class ExhibitorsDetailPage extends GetView<BootController> {
  ExhibitorsDetailPage({Key? key}) : super(key: key);
  static const routeName = "/ExhibitorsDetailPage";

  var isKnowMore = false.obs;
  ScrollController scrollController = ScrollController();
  final TextEditingController textAreaController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  final notesController = Get.put(MyNotesController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value) {
        if (controller.notesEdtController.text.trim().isNotEmpty &&
            controller.notesEdtController.text.trim() !=
                controller.notesData.value.text!.trim()) {
          controller.saveEditNotesApi(context);
        } else {}
      },
      canPop: true,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: CustomAppBar(
          height: 72.v,
          leadingWidth: 45.h,
          leading: AppbarLeadingImage(
            imagePath: ImageConstant.imgArrowLeft,
            margin: EdgeInsets.only(
              left: 7.h,
              top: 3,
              // bottom: 12.v,
            ),
            onTap: () {
              Get.back();
            },
          ),
          title: ToolbarTitle(title: "exhibitors_detail".tr),
          actions: [
            const SizedBox(width: 20),
            Obx(
              () => Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      controller.exhibitorsBody.value.isLoading(true);
                      await controller.bookmarkToExhibitorItem(
                          id: controller.exhibitorsBody.value.id,
                          itemType: "exhibitor");
                      controller.exhibitorsBody.value.isLoading(false);
                      controller.update();
                    },
                    child: SvgPicture.asset(
                      controller.exhibitorsBody.value.favourite != null &&
                              controller
                                  .exhibitorsBody.value.favourite!.isNotEmpty
                          ? ImageConstant.bookmarkIcon
                          : ImageConstant.unBookmarkIcon,
                      width: 16,
                    ),
                  ),
                  controller.exhibitorsBody.value.isLoading.value
                      ? const FavLoading()
                      : const SizedBox()
                ],
              ),
            ),
            const SizedBox(
              width: 16,
            )
          ],
        ),
        body: Container(
            color: white,
            width: context.width,
            child: GetX<BootController>(builder: (controller) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0),
                          child: buildBannerWidget(context),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          child: buildHeaderWidget(context),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 0),
                          child: buildMenuWidget(context),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 0),
                          child: buildBodyWidget(context),
                        ),
                      ],
                    ),
                  ),
                  controller.isLoading.value
                      ? const Loading()
                      : const SizedBox()
                ],
              );
            })),
      ),
    );
  }

  /*header with gallery list view */
  buildHeaderWidget(BuildContext context) {
    var personalParam = controller.exhibitorsBody.value;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
          color: colorLightGray,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: rectangleImage(
                    shortName: "", url: personalParam.avatar ?? ""),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 8,
                child: ListTile(
                  contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: CustomTextView(
                      text: personalParam.company ?? "".capitalize ?? "",
                      fontSize: 18,
                      color: black,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(ImageConstant.iconLocationMap),
                          const SizedBox(
                            width: 6,
                          ),
                          Expanded(
                            child: CustomTextView(
                                fontSize: 14,
                                maxLines: 2,
                                color: colorGray,
                                fontWeight: FontWeight.normal,
                                textAlign: TextAlign.start,
                                text:
                                    "Hall No: ${personalParam.hallNumber ?? ""} | "
                                    "Booth No:${personalParam.boothNumber ?? ""} "),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          if (controller.exhibitorsBody.value.description?.isNotEmpty ?? false)
            Container(
              padding: const EdgeInsets.all(10),
              child: CustomReadMoreText(
                text: controller.exhibitorsBody.value.description ?? "",
                maxLines: 10,
                textAlign: TextAlign.justify,
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
        ],
      ),
    );
  }

  Widget buildNotesWidget(BuildContext context) {
    return Skeletonizer(
      enabled: controller.isNotesLoading.value,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
          color: colorLightGray,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.zero,
                  child: CustomTextView(
                    text: controller.isEditNotes.value
                        ? "add_note".tr
                        : "notes".tr,
                    fontSize: 18,
                    color: colorSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                controller.notesData.value.text != null &&
                        controller.notesData.value.text.toString().isNotEmpty
                    ? InkWell(
                        onTap: () async {
                          if (!controller.isEditNotes.value) {
                            controller
                                .isEditNotes(!controller.isEditNotes.value);
                            return;
                          }
                          if (formKey.currentState?.validate() ?? false) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (controller.notesEdtController.text
                                .trim()
                                .isEmpty) {
                              return;
                            }
                            controller.saveEditNotesApi(context);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: CustomTextView(
                            text:
                                controller.isEditNotes.value ? "Save" : "Edit",
                            fontSize: 18,
                            color: blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            Container(
              margin:
                  EdgeInsets.only(top: controller.isEditNotes.value ? 14 : 10),
              padding: EdgeInsets.zero,
              child: controller.isEditNotes.value
                  ? Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: formKey,
                      child: TextFormField(
                        enabled: controller.isEditNotes.value,
                        controller: controller.notesEdtController,
                        maxLength: 1024,
                        maxLines: 2,
                        minLines: 1,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        validator: (String? value) {
                          if (value == null ||
                              value.toString().trim().isEmpty) {
                            Future.delayed(const Duration(seconds: 1), () {
                              controller.notesData(NotesDataModel(text: value));
                            });
                            return "enter_notes".tr;
                          } else if (value.length < 3) {
                            return "notes_length_validation".tr;
                          } else {
                            Future.delayed(const Duration(seconds: 1), () {
                              controller.notesData(NotesDataModel(text: value));
                            });
                            return null;
                          }
                        },
                        onChanged: (value) {},
                        onEditingComplete: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        decoration: InputDecoration(
                            counter: const Offstage(),
                            contentPadding:
                                const EdgeInsets.fromLTRB(16, 15, 16, 15),
                            labelText: "notes".tr,
                            hintText: "type_here".tr,
                            hintStyle: GoogleFonts.getFont(MyConstant.currentFont,
                                fontSize: 14.fSize,
                                color: colorGray,
                                fontWeight: FontWeight.normal),
                            labelStyle: GoogleFonts.getFont(
                                MyConstant.currentFont,
                                fontSize: 14.fSize,
                                color: colorGray,
                                fontWeight: FontWeight.normal),
                            fillColor: Colors.white,
                            filled: true,
                            prefixIconConstraints:
                                const BoxConstraints(minWidth: 60),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: colorSecondary)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.red)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                            disabledBorder:
                                OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.grey))),
                      ),
                    )
                  : CustomTextView(
                      text: controller.notesData.value.text.toString(),
                      // color: textGrayColor,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      maxLines: 50,
                    ),
            )
          ],
        ),
      ),
    );
  }

  buildBodyWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 30,
          ),
          buildSocialWidget(
            context,
            controller.exhibitorsBody.value.socialMedia?.params ?? [],
          ),
          buildNotesWidget(context),
          SizedBox(
            height: 30.v,
          ),
          if (controller.representativesList.isNotEmpty)
            CustomTextView(
              text: "repersentatives".tr.capitalize ?? "",
              color: colorSecondary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          SizedBox(
            height: 6.v,
          ),
          buildTeamListWidget(context),
          SizedBox(
            height: 12.v,
          ),
          commonListWidget(
              controller.exhibitorsBody.value.about?.params ?? [], "About"),
          SizedBox(
            height: 12.v,
          ),
          commonListWidget(
              controller.exhibitorsBody.value.contact?.params ?? [],
              "contact_details".tr.toUpperCase()),
          SizedBox(
            height: 12.v,
          ),
          commonListWidget(
              controller.exhibitorsBody.value.virtual?.params ?? [],
              controller.exhibitorsBody.value.virtual?.label ?? ""),
          SizedBox(
            height: 12.v,
          ),
        ],
      ),
    );
  }

  buildMenuWidget(BuildContext context) {
    List<String> controlList = controller.exhibitorsBody.value.controls ?? [];
    return controlList.isNotEmpty
        ? SizedBox(
            height: 35,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: controller.exhibitorsMenuList.length,
              itemBuilder: (context, index) {
                var data = controller.exhibitorsMenuList[index];
                return controlList.contains(data.id?.toLowerCase())
                    ? GestureDetector(
                        onTap: () {
                          switch (data.id) {
                            case "ask_a_question":
                              Get.toNamed(AskQuestionPage.routeName,
                                  arguments: {
                                    "name": controller
                                            .exhibitorsBody.value.company ??
                                        "",
                                    "image": controller
                                            .exhibitorsBody.value.avatar ??
                                        "",
                                    "item_id":
                                        controller.exhibitorsBody.value.id ??
                                            "",
                                    "item_type": "exhibitor",
                                    "hall_no": controller
                                            .exhibitorsBody.value.hallNumber
                                            ?.toString() ??
                                        "",
                                    "booth_no": controller
                                            .exhibitorsBody.value.boothNumber
                                            ?.toString() ??
                                        "",
                                    "item_type": "exhibitor",
                                  });
                              break;
                            case "videos":
                              controller.getExhibitorsDocument(
                                  type: "videos",
                                  isRefresh: false,
                                  context: context);
                              break;
                            case "documents":
                              controller.getExhibitorsDocument(
                                  type: "documents",
                                  isRefresh: false,
                                  context: context);
                              break;
                            case "feedback":
                              Get.toNamed(FeedbackPage.routeName, arguments: {
                                "item_id": controller.exhibitorsBody.value.id,
                                "title": "Exhibitor Feedback",
                                "type": "exhibitor"
                              });

                              break;
                            /*case 4:
                  scrollController.jumpTo(1500);
                  break;
                case 5:
                  scrollController.jumpTo(400);
                  break;*/
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 0),
                          margin: const EdgeInsets.only(right: 14),
                          decoration: BoxDecoration(
                              color: white,
                              shape: BoxShape.rectangle,
                              border:
                                  Border.all(color: grayColorLight, width: 1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(29))),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                controller.exhibitorsMenuList[index].iconUrl ??
                                    "",
                                width: 18,
                                height: 18,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              CustomTextView(
                                text: controller
                                        .exhibitorsMenuList[index].title ??
                                    "",
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox();
              },
            ),
          )
        : const SizedBox();
  }

  buildTeamListWidget(BuildContext context) {
    return GetX<BootController>(builder: (controller) {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: controller.representativesList.length > 5
            ? 5
            : controller.representativesList.length,
        itemBuilder: (context, index) {
          return Container(
              margin: const EdgeInsets.symmetric(vertical: 7),
              decoration: const BoxDecoration(
                  color: colorLightGray,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: const EdgeInsets.all(4.0),
              child: _teamViewCard(
                  context, controller.representativesList[index]));
        },
      );
    });
  }

  _teamViewCard(
    BuildContext context,
    ExhibitorTeamData representativesParam,
  ) {
    return InkWell(
      onTap: () {
        _openUserDetail(
            userId: representativesParam.id, role: representativesParam.role);
      },
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        leading: circularImage(
            url: representativesParam.avatar ?? "",
            shortName: representativesParam.shortName),
        title: CustomTextView(
          text: representativesParam.name ?? "",
          textAlign: TextAlign.start,
          fontSize: 16, fontWeight: FontWeight.w500,
          // color: black,
        ),
        subtitle: CustomTextView(
          text:
              "${representativesParam.position} \n${representativesParam.company}",
          textAlign: TextAlign.start,
          fontSize: 14,
          color: colorGray,
          fontWeight: FontWeight.normal,
          maxLines: 2,
        ),
        trailing: SizedBox(
          width: 95,
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(0),
                decoration: const BoxDecoration(
                    color: CupertinoColors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: SvgPicture.asset(
                  ImageConstant.ic_one_to_one,
                  color: colorSecondary,
                ),
              ),
              Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(left: 6),
                decoration: const BoxDecoration(
                    color: CupertinoColors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Image.asset(
                  ImageConstant.chat_header,
                  color: colorSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildBannerWidget(BuildContext context) {
    var url = controller.exhibitorsBody.value.cover ?? "";
    var shortName = controller.exhibitorsBody.value.companyShortName ?? "";
    var mediaType = url.isNotEmpty ? "cover" : null;
    return SizedBox(
      height: 200,
      child: mediaType != null && url.isNotEmpty
          ? Stack(
              alignment: Alignment.center,
              children: [
                mediaType == "cover"
                    ? CachedNetworkImage(
                        imageUrl: url,
                        imageBuilder: (context, imageProvider) => Container(
                          height: context.height,
                          width: context.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.fill),
                          ),
                        ),
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Center(
                          child: Image.asset(
                            ImageConstant.imagePlaceholder,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    : mediaType == "video"
                        ? Container(
                            width: context.width,
                            height: context.height,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(url ?? ""),
                                    fit: BoxFit.fill)),
                            child: GestureDetector(
                              onTap: () {
                                UiHelper.inAppWebView(Uri.parse(url ?? ""));
                              },
                              child: const Icon(
                                Icons.play_circle,
                                color: Colors.black,
                                size: 50,
                              ),
                            ),
                          )
                        : const SizedBox()
              ],
            )
          : Container(
              width: context.width,
              decoration: const BoxDecoration(color: colorLightGray),
              child: SizedBox(
                  child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                        ImageConstant.banner_img,
                      )),
                ),
              ))),
    );
  }

  buildSocialWidget(BuildContext context, List<dynamic> items) {
    return items.isNotEmpty
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CustomTextView(
                    text:
                        controller.exhibitorsBody.value.socialMedia?.text ?? "",
                    color: colorSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    textAlign: TextAlign.start,
                  ),
                ),
                subtitle: Wrap(
                  spacing: 10,
                  children: <Widget>[
                    for (var item in items)
                      Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: SizedBox(
                            height: 32,
                            width: 32,
                            child: InkWell(
                                onTap: () {
                                  if (item.value.toString().contains("http") ||
                                      item.value.toString().contains("https")) {
                                    UiHelper.inAppWebView(
                                        Uri.parse(item.value.toString()));
                                  }
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: grayColorLight, width: 1)),
                                    padding: const EdgeInsets.all(1),
                                    child: SvgPicture.asset(
                                      UiHelper.getSocialIcon(
                                          item.text.toString().toLowerCase()),
                                    ))),
                          )),
                  ],
                ),
              ),
              SizedBox(
                height: 25.v,
              ),
            ],
          )
        : const SizedBox();
  }

  commonListWidget(dynamic params, String title) {
    return params != null && params.isNotEmpty
        ? ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: CustomTextView(
                text: title.capitalize ?? "",
                color: colorSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 18,
                textAlign: TextAlign.start,
              ),
            ),
            subtitle: ListView.separated(
              padding: const EdgeInsets.all(0),
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 0,
                  child: Divider(
                    color: Colors.transparent,
                  ),
                );
              },
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: params?.length ?? 0,
              itemBuilder: (context, index) {
                var data = params?[index];
                if (data.value is List) {
                  return _dynamicFilterWidget(
                      data.value ?? [], false, data?.label);
                } else {
                  return _textWidget(data?.text ?? "", data?.value ?? "");
                }
              },
            ),
          )
        : const SizedBox();
  }

  _textWidget(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: CustomTextView(
                  text: "$label :",
                  textAlign: TextAlign.start,
                  color: colorSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: colorLightGray,
                            borderRadius: BorderRadius.circular(6)),
                        child: value.toString().contains("http")
                            ? GestureDetector(
                                onTap: () {
                                  UiHelper.inAppBrowserView(Uri.parse(value));
                                },
                                child: CustomTextView(
                                  text: value,
                                  textAlign: TextAlign.end,
                                  color: Colors.blue,
                                  fontSize: 14,
                                  underline: true,
                                  maxLines: 10,
                                ),
                              )
                            : CustomTextView(
                                text: value,
                                textAlign: TextAlign.end,
                                color: Colors.black87,
                                fontSize: 14,
                                maxLines: 10,
                              ),
                      )
                    ],
                  ))
            ],
          ),
          // const Divider(),
        ],
      ),
    );
  }

  _dynamicFilterWidget(List<dynamic>? value, isBg, label) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: CustomTextView(
        text: "$label :",
        textAlign: TextAlign.start,
        color: colorSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      subtitle: Wrap(
        spacing: 10,
        children: <Widget>[
          for (var item in value!) MyFlowWidget(item ?? "", isBgColor: true),
        ],
      ),
    );
  }

  Widget circularImage({url, shortName}) {
    return url.toString().isNotEmpty
        ? SizedBox(
            height: 80,
            width: 80,
            child: CircleAvatar(backgroundImage: NetworkImage(url)))
        : Container(
            height: 80,
            width: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
                child: CustomTextView(
              text: shortName ?? "",
              textAlign: TextAlign.center,
            )),
          );
  }

  Widget rectangleImage({url, shortName}) {
    return Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        clipBehavior: Clip.hardEdge,
        child: Center(
          child: AspectRatio(
              aspectRatio: 7 / 7,
              child: UiHelper.getExhibitorDetailsImage(imageUrl: url)),
        ));
  }

  _openUserDetail({userId, role}) async {
    UserDetailController reController = Get.find();
    controller.isLoading(true);
    await reController.getUserDetailApi(userId, role);
    controller.isLoading(false);
  }
}
