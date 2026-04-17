import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';
import '../../../shared/components/components.dart'; // مكان الـ Item اللي عملناه

class AllDetectPlantScreen extends StatelessWidget {
  const AllDetectPlantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // نداء الـ API أول ما الصفحة تفتح
    AppCubit.get(context).getAllDetectPlants();

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'All Detect Plants',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Transform.scale(
                  scale: 0.7,
                  child: SvgPicture.asset(
                    'assets/icons/ep_back.svg',
                  ),
                ),
              ),
            ),
          ),
          body: BuildCondition(
            // بنستخدم الـ list الكبيرة اللي عملناها في الكيوبيت
            condition: cubit.allDetections.isNotEmpty,
            builder: (context) => GridView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              // هنا السحر: عرض عنصرين جنب بعض
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20, // المسافة الأفقية
                mainAxisSpacing: 20, // المسافة الرأسية
                childAspectRatio:
                    0.95, // جرب تغير الرقم ده (0.7 لـ 0.8) لحد ما يظبط الطول مع الـ Item بتاعك
              ),
              itemBuilder: (context, index) => buildDetectionItem(
                context: context,
                model: cubit.allDetections[index],
              ),
              itemCount: cubit.allDetections.length,
            ),
            fallback: (context) => Center(
              child: state is AppGetAllDetectionsLoadingState
                  ? const CircularProgressIndicator(color: Colors.green)
                  : const Text("No Plants Detected Yet"),
            ),
          ),
        );
      },
    );
  }
}
