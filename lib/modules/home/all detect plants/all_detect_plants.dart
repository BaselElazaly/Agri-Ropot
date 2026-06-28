import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';
import '../../../shared/components/components.dart';

class AllDetectPlantScreen extends StatelessWidget {
  const AllDetectPlantScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            condition: cubit.allDetections.isNotEmpty,
            builder: (context) => GridView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.95,
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
