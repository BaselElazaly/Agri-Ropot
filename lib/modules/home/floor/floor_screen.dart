import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/components/components.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';


class FloorScreen extends StatelessWidget {
  final int floorNum;
  const FloorScreen({super.key, required this.floorNum});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Floor $floorNum',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                ),
              ),
              centerTitle: true,
              leading: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Transform.scale(
                    scale: 0.8,
                    child: SvgPicture.asset(
                      'assets/icons/ep_back.svg',
                      width: 32,
                      height: 32,
                    ),
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(child: allHealthPlantBuilder())
              ],
            ),
          );
        }
    );
  }
}
