import 'dart:ui';

import 'package:agre_lens_app/modules/home/search/search_screen.dart';
import 'package:agre_lens_app/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import 'all plants/all_plant_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is ControlSavedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Control updated!', style: TextStyle(fontSize: 16)),
              duration: const Duration(seconds: 1),
              backgroundColor: ColorManager.greenColor,
            ),
          );
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);

        if (state is AppGetSensorsLoadingState || state is AppGetProfileLoadingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: ColorManager.greenColor,
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(left: 22),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cubit.farmName ?? "My Farm",
                  style: GoogleFonts.reemKufi(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF414042)),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 23),
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
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF414042)),
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
                        borderSide: const BorderSide(color: Color(0xFF414042), width: 1.5),
                      ),
                    ),
                    cursorColor: const Color(0xFF414042),
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AllPlantScreen())),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Your Plants Health', style: GoogleFonts.reemKufi(fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF414042))),
                      const Icon(Icons.keyboard_arrow_right, color: Color(0xFF414042))
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(height: 150, child: healthPlantBuilder()),
                const SizedBox(height: 5),
                // ... جزء الـ All Floors ...
                InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AllPlantScreen())),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('All Floors', style: GoogleFonts.reemKufi(fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF414042))),
                      const Icon(Icons.keyboard_arrow_right, color: Color(0xFF414042))
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(height: 160, child: floorPlantBuilder()),
                const SizedBox(height: 10),
                Text('Sensors Reading', style: GoogleFonts.reemKufi(fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF414042))),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 20, bottom: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(child: sensorReading1(sensorName: 'Water', sensorStats: cubit.waterLevel)),
                      const SizedBox(width: 10),
                      Expanded(child: sensorReading1(sensorName: 'Ph', sensorStats: cubit.phLevel)),
                      const SizedBox(width: 10),
                      Expanded(child: sensorReading2(sensorName: 'DHT', sensorStats: cubit.dhtTemp)),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}