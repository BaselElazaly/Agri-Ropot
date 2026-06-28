import 'package:agre_lens_app/modules/settings/settings_screen.dart';
import 'package:agre_lens_app/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../modules/profile/profile_screen.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);

        return Scaffold(
          extendBody: true,
          appBar: (cubit.currentIndex == 0 || cubit.currentIndex == 1)
              ? AppBar(
                  backgroundColor: const Color(0xFFFAFAFA),
                  toolbarHeight: 80,
                  automaticallyImplyLeading: false,
                  title: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      children: [
                        Text(
                          'Hi, ${cubit.fullName ?? "User"}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(65, 64, 66, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 23,
                        end: 23,
                        top: 20.0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsScreen()),
                          );
                          cubit.emit(AppProfileOpenedState());
                        },
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                            child: cubit.profileImageUrl != null &&
                                    cubit.profileImageUrl!.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: cubit.profileImageUrl!,
                                    fit: BoxFit.cover,
                                    width: 45,
                                    height: 44,
                                    placeholder: (context, url) => Image.asset(
                                      'assets/images/profile_pic2.png',
                                      fit: BoxFit.cover,
                                      width: 45,
                                      height: 44,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      'assets/images/profile_pic2.png',
                                      fit: BoxFit.cover,
                                      width: 45,
                                      height: 44,
                                    ),
                                  )
                                : Image.asset(
                                    'assets/images/profile_pic2.png',
                                    fit: BoxFit.cover,
                                    width: 45,
                                    height: 44,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : null,
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
            decoration: BoxDecoration(
              color: cubit.currentIndex == 2
                  ? Colors.black
                  : const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BottomNavigationBar(
                items: cubit.bottomItems,
                currentIndex: cubit.currentIndex,
                elevation: 0,
                backgroundColor: Colors.transparent,
                selectedItemColor: ColorManager.greenColor,
                unselectedItemColor: const Color(0xFF484C52),
                selectedLabelStyle:
                    TextStyle(color: ColorManager.greenColor, fontSize: 12),
                unselectedLabelStyle:
                    const TextStyle(color: Color(0xFF484C52), fontSize: 12),
                type: BottomNavigationBarType.fixed,
                onTap: (index) {
                  cubit.changeNavBarIndex(index);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
