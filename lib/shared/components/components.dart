import 'dart:math';
import 'dart:ui';

import 'package:agre_lens_app/models/last_five_detetct_model.dart';
import 'package:agre_lens_app/modules/history/report/report_screen.dart';
import 'package:agre_lens_app/shared/cubit/cubit.dart';
import 'package:agre_lens_app/shared/cubit/states.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../modules/home/floor/floor_screen.dart';
import '../../modules/home/plant details/plant_details_screen.dart';
import '../styles/colors.dart';

Widget defaultFormField({
  required BuildContext context,
  required TextEditingController controller,
  required TextInputType type,
  required String? Function(String?)? validator,
  Function(String)? onSubmit,
  Function(String)? onChanged,
  Function()? onTap,
  String? labelText,
  String? errorText,
  IconData? prefixIcon,
  Widget? suffixIcon,
  VoidCallback? suffixPressed,
  bool isPassword = false,
  bool isClickable = true,
}) =>
    Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: ColorManager.greenColor,
          selectionColor: ColorManager.greenColor.withOpacity(0.5),
          selectionHandleColor: ColorManager.greenColor,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        obscureText: isPassword,
        enabled: isClickable,
        onFieldSubmitted: onSubmit,
        onTap: onTap,
        onChanged: onChanged,
        cursorColor: Colors.black,
        selectionControls: MaterialTextSelectionControls(),
        validator: validator,
        decoration: InputDecoration(
          errorText: errorText,
          errorMaxLines: 2,
          labelText: labelText,
          labelStyle: TextStyle(
            color: Color(0xFF475569),
          ),
          floatingLabelStyle: TextStyle(color: Colors.black),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon,
          border: const UnderlineInputBorder(),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFCBD5E1)),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2.0),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.5),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10.0),
        ),
      ),
    );

Widget profileFormField({
  required String label,
  required TextEditingController controller,
  required bool isEnabled,
  bool obscureText = false,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 0.88,
            letterSpacing: 0,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 44,
          child: TextFormField(
            obscureText: obscureText,
            enabled: isEnabled,
            controller: controller,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.black),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );

Widget defaultButton({
  required Color? colorButton,
  required Color? textColorButton,
  required Widget? text,
  Function()? onTap,
}) =>
    InkWell(
      onTap: onTap,
      child: Container(
        height: 36,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: colorButton),
        child: Center(child: text),
      ),
    );

List<Map<String, dynamic>> plantItems = List.generate(
    3,
    (index) => {
          "floor": "Floor 1",
          "cell": "Cell ${index + 1}",
          "healthPercentage": min(index * 65 + 10, 100),
          "cellNumber": index + 1
        });

Widget buildHealthPlantItem({
  required BuildContext context,
  required String floor,
  required String cell,
  required int healthPercentage,
  required int cellNumber,
  //required String imgUrl,
}) =>
    InkWell(
      onTap: () {},
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 104,
                width: 104,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                    child: Image.asset(
                      'assets/images/plant health.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: getColorOfStats(healthPercentage),
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: getColorOfStats(healthPercentage),
                    ),
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.55)),
              ),
              Text(
                '$healthPercentage%',
                style: GoogleFonts.reemKufi(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            '$floor\n$cell',
            style: GoogleFonts.reemKufi(
                fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
          )
        ],
      ),
    );

Widget healthPlantBuilder() => BuildCondition(
      condition: true,
      builder: (context) => ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(right: 10),
          itemBuilder: (context, index) => buildHealthPlantItem(
                context: context,
                floor: "Floor 1",
                cell: "Cell ${index + 1}",
                cellNumber: index + 1,
                healthPercentage: min(index * 65 + 10, 100),
              ),
          separatorBuilder: (context, index) => SizedBox(
                width: 15,
              ),
          itemCount: 3),
      fallback: (context) => Center(
          child: CircularProgressIndicator(
        color: ColorManager.greenColor,
      )),
    );

Widget buildDetectionItem({
  required BuildContext context,
  required DetectionModel model,
}) =>
    InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlantDetailsScreen(
            label: model.label,
            date: model.receivedDate,
            confidence: model.confidence,
            imageUrl: model.imageUrl,
          ),
        ),
      ),
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: ColorManager.greenColor),
          // ... باقي الـ decoration
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // مهم جداً عشان يلم المساحة
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                      child: Image.asset(
                        'assets/images/diecease_plant.webp',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: getColorOfConfidence(model.confidence),
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: getColorOfConfidence(model.confidence),
                      ),
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.55)),
                ),
                Text(
                  '${model.confidence}%',
                  style: GoogleFonts.reemKufi(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${model.label}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(/* ستايلك */),
            ),
          ],
        ),
      ),
    );
Widget detectionBuilder() => BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        var cubit = AppCubit.get(context);

        return BuildCondition(
          // الشرط هنا إن الـ List متبقاش فاضية
          condition: cubit.detections.isNotEmpty,
          builder: (context) => ListView.separated(
            clipBehavior: Clip.none,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) => buildDetectionItem(
              context: context,
              model: cubit.detections[index], // بنبعت العنصر حسب الـ index
            ),
            separatorBuilder: (context, index) => SizedBox(width: 15),
            itemCount: cubit.detections.length, // عددهم حسب اللي جاي من الباك
          ),
          fallback: (context) => Center(
            child: cubit.detections.isEmpty &&
                    state is AppGetDetectionsLoadingState
                ? CircularProgressIndicator(color: ColorManager.greenColor)
                : Text("No detections found"),
          ),
        );
      },
    );
Widget buildAllHealthPlantItem({
  required BuildContext context,
  required String floor,
  required String cell,
  required int healthPercentage,
  required int cellNumber,
}) =>
    Padding(
      padding: const EdgeInsets.only(left: 22),
      child: Column(
        children: [
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 104,
                      width: 104,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: ImageFiltered(
                          imageFilter:
                              ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                          child: Image.asset(
                            'assets/images/plant health.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: getColorOfStats(healthPercentage),
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: getColorOfStats(healthPercentage),
                          ),
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.55)),
                    ),
                    Text(
                      '$healthPercentage%',
                      style: GoogleFonts.reemKufi(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$floor\n$cell',
                      style: GoogleFonts.reemKufi(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    Text(
                      'Health Percentage $healthPercentage%',
                      style: GoogleFonts.reemKufi(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );

Widget allHealthPlantBuilder() => BuildCondition(
      condition: true,
      builder: (context) => ListView.separated(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(right: 10),
        itemCount: 5,
        itemBuilder: (context, index) {
          if (index == 4 || index == 0) {
            return SizedBox(height: 20);
          }
          return buildAllHealthPlantItem(
            context: context,
            floor: 'Floor 1',
            cell: 'Cell $index',
            cellNumber: index,
            healthPercentage: min((index - 1) * 10, 100),
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 10),
      ),
      fallback: (context) => Center(
        child: CircularProgressIndicator(
          color: ColorManager.greenColor,
        ),
      ),
    );

List<Widget> historyWidgets = [];

Widget buildHistoryItem({
  required int reportNum,
  required int reportSerial,
  required int healthPrecentage,
  required BuildContext context,
}) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReportScreen(
                  reportNum: reportNum,
                  serialNum: reportSerial,
                  healthPrecentage: healthPrecentage,
                )),
      );
    },
    child: SizedBox(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/plant health2.webp',
              width: 52,
              height: 52,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Report $reportNum',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xFF26273A),
                    ),
                  ),
                ),
                Text(
                  'Report Serial',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black45,
                  ),
                ),
                Text(
                  '$reportSerial',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF26273A),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: getColorOfStats(healthPrecentage),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '$healthPrecentage%',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(child: Container()),
              Row(
                children: [
                  Text(
                    '02 Jan 2025',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black45,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '11:00 AM',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black45,
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    ),
  );
}

Widget historyItemBuilder(BuildContext context) {
  List<Widget> historyWidgets = [];

  for (int index = 0; index < 22; index++) {
    int randomNumber = Random().nextInt(101);
    if (index == 21 || index == 0) {
      historyWidgets.add(SizedBox(height: 10));
    } else {
      historyWidgets.add(
        buildHistoryItem(
          context: context, // pass context here
          healthPrecentage: randomNumber,
          reportNum: index,
          reportSerial: 6980945543 + randomNumber - 1,
        ),
      );
      historyWidgets.add(SizedBox(height: 10));
    }
  }

  List<Widget> reversedHistoryWidgets = historyWidgets.reversed.toList();

  return BuildCondition(
    condition: true,
    builder: (context) => SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: reversedHistoryWidgets,
      ),
    ),
    fallback: (context) => Center(
      child: CircularProgressIndicator(
        color: ColorManager.greenColor,
      ),
    ),
  );
}

Widget sensorReading1({
  required String? sensorName,
  required int? sensorStats,
}) =>
    Container(
      height: 72,
      width: 104,
      decoration: BoxDecoration(
        color: Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: getColorOfStats(sensorStats!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
        child: Column(
          children: [
            Text(
              '$sensorName',
              style: TextStyle(
                  color: Color(0xFF414042),
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
            Spacer(),
            Text(
              '$sensorStats',
              style: GoogleFonts.poppins(
                  color: getColorOfStats(sensorStats!),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );

Widget sensorReading2({
  required String? sensorName,
  required double? sensorStats,
}) =>
    Container(
      height: 72,
      width: 104,
      decoration: BoxDecoration(
        color: Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: getColorOfTempStats(sensorStats!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
        child: Column(
          children: [
            Text(
              '$sensorName',
              style: TextStyle(
                  color: Color(0xFF414042),
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            Spacer(),
            Text(
              '$sensorStats°',
              style: GoogleFonts.poppins(
                  color: getColorOfTempStats(sensorStats!),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );

Widget detailesText({
  required String headText,
  required String bodyText,
  Color headColor = ColorManager.greenColor,
  Color bodyColor = const Color(0xFF494949),
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headText,
          style: GoogleFonts.reemKufi(
              fontWeight: FontWeight.w700, fontSize: 20, color: headColor),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          bodyText,
          style: GoogleFonts.reemKufi(
              fontWeight: FontWeight.w400, fontSize: 14, color: bodyColor),
        ),
      ],
    );

Widget timerButton({
  required Function()? onTap,
  required String textButton,
  required Color buttonColor,
  required Color borderButtonColor,
  required Color textColorButton,
}) =>
    GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        width: 145,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: buttonColor,
          border: Border.all(color: borderButtonColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            textButton,
            style: TextStyle(
                color: textColorButton,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );

Color getColorOfStats(int stats) {
  if (stats <= 50) {
    return ColorManager.redColor;
  } else if (stats <= 75) {
    return ColorManager.yellowColor;
  } else {
    return ColorManager.greenColor;
  }
}

Color getColorOfConfidence(double? stats) {
  if (stats! <= 50) {
    return ColorManager.redColor;
  } else if (stats <= 75) {
    return ColorManager.yellowColor;
  } else {
    return ColorManager.greenColor;
  }
}

Color getColorOfTempStats(double stats) {
  if (stats <= 30 && stats >= 15) {
    return ColorManager.greenColor;
  } else if (stats <= 35 && stats >= 10) {
    return ColorManager.yellowColor;
  } else {
    return ColorManager.redColor;
  }
}
