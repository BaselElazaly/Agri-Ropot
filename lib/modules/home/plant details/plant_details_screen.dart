import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/components/components.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';
import '../../../shared/styles/colors.dart';



class PlantDetailsScreen extends StatelessWidget {
  final String floor;
  final String cell;
  final int healthPercentage;
  final int cellNumber;
  //final String imgUrl;

  const PlantDetailsScreen({
    Key? key,
    required this.floor,
    required this.cell,
    required this.healthPercentage,
    required this.cellNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder:  (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/plant_details.jpeg',
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 3,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20,top: 10),
                      child: InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Transform.scale(
                          scale: 1.2,
                          child: SvgPicture.asset(
                            'assets/icons/ep_back.svg',
                            width: 32,
                            height: 32,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25),
                              child: Text(
                                '$floor $cell',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: ColorManager.greenColor,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25),
                              child: Text(
                                'Health Percentage $healthPercentage%',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: detailesText(
                                  headText: 'Status:',
                                  bodyText: 'DHT :  0°'
                                      '\nSoil Moisture:  0%'
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}
