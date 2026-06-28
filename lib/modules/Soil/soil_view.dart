import 'package:agre_lens_app/modules/Soil/cubit/soil_cubit.dart';
import 'package:agre_lens_app/modules/Soil/cubit/soil_state.dart';
import 'package:agre_lens_app/modules/Soil/widget/confidence_score_card.dart';
import 'package:agre_lens_app/modules/Soil/widget/crop_details_card.dart';
import 'package:agre_lens_app/modules/Soil/widget/detected_crop_card.dart';
import 'package:agre_lens_app/modules/Soil/widget/header.dart';
import 'package:agre_lens_app/modules/Soil/widget/nutrients_card.dart';
import 'package:agre_lens_app/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SoilView extends StatelessWidget {
  const SoilView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SoilCubit()..getFeatureData(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: SafeArea(
          child: BlocBuilder<SoilCubit, SoilState>(
            builder: (context, state) {
              if (state.requestState == RequestState.loading) {
                return const Center(
                  child:
                      CircularProgressIndicator(color: ColorManager.greenColor),
                );
              }

              if (state.requestState == RequestState.error) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.msg,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<SoilCubit>().getFeatureData();
                        },
                        child: const Text('Try Again'),
                      )
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeaderWidget(),
                    const SizedBox(height: 24),
                    DetectedCropCard(
                      plantName: context
                              .read<SoilCubit>()
                              .soilModel
                              ?.data
                              ?.prediction ??
                          'Unknown',
                    ),
                    const SizedBox(height: 16),
                    ConfidenceScoreCard(
                      confidence: context
                              .read<SoilCubit>()
                              .soilModel
                              ?.data
                              ?.confidence ??
                          0.0,
                    ),
                    const SizedBox(height: 16),
                    CropDetailsCard(),
                    const SizedBox(height: 16),
                    NutrientsCard(
                      soilModel: context.read<SoilCubit>().soilModel,
                      onTap: () {
                        context.read<SoilCubit>().getFeatureData();
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
