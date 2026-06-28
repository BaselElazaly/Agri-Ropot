import 'dart:ui';
import 'dart:math';

import 'package:agre_lens_app/models/last_five_detetct_model.dart';
import 'package:agre_lens_app/modules/home/all%20detect%20plants/all_detect_plants.dart';
import 'package:agre_lens_app/modules/home/plant%20details/plant_details_screen.dart';
import 'package:agre_lens_app/modules/home/search/search_screen.dart';
import 'package:agre_lens_app/shared/styles/colors.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import 'all plants/all_plant_screen.dart';

Widget sensorReading1({
  required BuildContext context,
  required String? sensorName,
  required int? sensorStats,
}) {
  final size = MediaQuery.of(context).size;
  return Container(
    height: size.height * 0.09,
    decoration: BoxDecoration(
      color: const Color(0xFFFAFAFA),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: getColorOfStats(sensorStats!)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 4,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
      child: Column(
        children: [
          Text(
            '$sensorName',
            style: const TextStyle(
                color: Color(0xFF414042),
                fontSize: 12,
                fontWeight: FontWeight.w600),
          ),
          const Spacer(),
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
}

Widget sensorReading2({
  required BuildContext context,
  required String? sensorName,
  required int? sensorStats,
}) {
  final size = MediaQuery.of(context).size;
  return Container(
    height: size.height * 0.09,
    decoration: BoxDecoration(
      color: const Color(0xFFFAFAFA),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: getColorOfTempStats(sensorStats!)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 4,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
      child: Column(
        children: [
          Text(
            '$sensorName',
            style: const TextStyle(
                color: Color(0xFF414042),
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          const Spacer(),
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
}

Widget buildDetectionItem({
  required BuildContext context,
  required DetectionModel model,
}) {
  final size = MediaQuery.of(context).size;
  bool hasData = model.detections != null && model.detections!.isNotEmpty;
  String displayLabel =
      hasData ? model.detections![0].label ?? "Unknown" : "Tomato Blight";
  double displayConfidence =
      hasData ? model.detections![0].confidence ?? 83.0 : 83.0;

  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlantDetailsScreen(
            model: model,
            date: model.receivedDate,
          ),
        ),
      );
    },
    child: Container(
      width: size.width * 0.4,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ColorManager.greenColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: size.width * 0.3,
                width: size.width * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 4),
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
                height: size.width * 0.18,
                width: size.width * 0.18,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: getColorOfConfidence(displayConfidence),
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                height: size.width * 0.15,
                width: size.width * 0.15,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: getColorOfConfidence(displayConfidence),
                    ),
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.55)),
              ),
              Text(
                '${displayConfidence.toStringAsFixed(1)}%',
                style: GoogleFonts.reemKufi(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: size.width * 0.27,
            child: Text(
              displayLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget detectionBuilder(BuildContext context) =>
    BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return BuildCondition(
          condition: cubit.detections.isNotEmpty,
          builder: (context) => ListView.separated(
            clipBehavior: Clip.none,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(right: 10, bottom: 10, top: 10),
            itemBuilder: (context, index) => buildDetectionItem(
              context: context,
              model: cubit.detections[index],
            ),
            separatorBuilder: (context, index) => const SizedBox(width: 15),
            itemCount: cubit.detections.length,
          ),
          fallback: (context) => Center(
            child: cubit.detections.isEmpty &&
                    state is AppGetDetectionsLoadingState
                ? const CircularProgressIndicator(
                    color: ColorManager.greenColor)
                : const Text("No scans found"),
          ),
        );
      },
    );

Widget buildHealthPlantItem({
  required BuildContext context,
  required String floor,
  required String cell,
  required int healthPercentage,
  required int cellNumber,
}) {
  final size = MediaQuery.of(context).size;
  return InkWell(
    onTap: () {},
    child: Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: size.width * 0.35,
              width: size.width * 0.35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 4),
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
              height: size.width * 0.18,
              width: size.width * 0.18,
              decoration: BoxDecoration(
                border: Border.all(
                  color: getColorOfStats(healthPercentage),
                ),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              height: size.width * 0.15,
              width: size.width * 0.15,
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
        const SizedBox(height: 5),
        Text(
          '$floor\n$cell',
          textAlign: TextAlign.center,
          style: GoogleFonts.reemKufi(
              fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
        )
      ],
    ),
  );
}

Widget healthPlantBuilder(BuildContext context) => BuildCondition(
      condition: true,
      builder: (context) => ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(right: 10),
          itemBuilder: (context, index) => buildHealthPlantItem(
                context: context,
                floor: "Floor 1",
                cell: "Cell ${index + 1}",
                cellNumber: index + 1,
                healthPercentage: min(index * 65 + 10, 100),
              ),
          separatorBuilder: (context, index) => const SizedBox(width: 15),
          itemCount: 3),
      fallback: (context) => const Center(
          child: CircularProgressIndicator(
        color: ColorManager.greenColor,
      )),
    );

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    AppCubit.get(context).getLastFiveDetects();
    AppCubit.get(context).getSensorReadings();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is ControlSavedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Control updated!', style: TextStyle(fontSize: 16)),
              duration: Duration(seconds: 1),
              backgroundColor: ColorManager.greenColor,
            ),
          );
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);

        if (state is AppGetSensorsLoadingState ||
            state is AppGetProfileLoadingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: ColorManager.greenColor,
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.only(left: size.width * 0.05),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  cubit.farmName ?? "My Farm",
                  style: GoogleFonts.reemKufi(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.greenColor),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(right: size.width * 0.06),
                  child: TextField(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPage(items: plantItems),
                        ),
                      );
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.search, color: Color(0xFF414042)),
                      hintText: "Search",
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF414042),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Color(0xFF414042)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Color(0xFF414042)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                            color: Color(0xFF414042), width: 1.5),
                      ),
                    ),
                    cursorColor: const Color(0xFF414042),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AllPlantScreen())),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Your Plants Health',
                          style: GoogleFonts.reemKufi(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF414042))),
                      const Icon(Icons.keyboard_arrow_right,
                          color: Color(0xFF414042))
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                    height: size.height * 0.22,
                    child: healthPlantBuilder(context)),
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AllDetectPlantScreen())),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('All Detect Plants',
                          style: GoogleFonts.reemKufi(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF414042))),
                      const Icon(Icons.keyboard_arrow_right,
                          color: Color(0xFF414042))
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                    height: size.height * 0.22,
                    child: detectionBuilder(context)),
                const SizedBox(height: 5),
                Text('Sensors Reading',
                    style: GoogleFonts.reemKufi(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF414042))),
                const SizedBox(height: 5),
                Padding(
                  padding:
                      EdgeInsets.only(right: size.width * 0.05, bottom: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: sensorReading2(
                              context: context,
                              sensorName: 'Temperature',
                              sensorStats: cubit.temperature)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: sensorReading1(
                              context: context,
                              sensorName: 'Smoke Level',
                              sensorStats: cubit.smokeLevel)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: sensorReading1(
                              context: context,
                              sensorName: 'Soil Moisture',
                              sensorStats: cubit.soilMoisture)),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.12),
              ],
            ),
          ),
        );
      },
    );
  }
}
