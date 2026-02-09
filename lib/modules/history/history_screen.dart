import 'package:agre_lens_app/modules/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../../shared/styles/colors.dart';

class HistoryScreen extends StatefulWidget {
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late AppCubit cubit;
  DateTimeRange? selectedDateRange;
  String startDate = "Select Start";
  String endDate = "Select End";
  var scafoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

  Future<void> _pickDateRange() async {
    DateTime now = DateTime.now();
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: now, 
      initialDateRange: cubit.selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.green,
            hintColor: Colors.green,
            scaffoldBackgroundColor: Colors.green.shade50,
            colorScheme: ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              primaryContainer: Colors.green.shade300,
              onPrimaryContainer: Colors.white,
              secondary: Colors.green.shade300,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green.shade900,
              ),
            ),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.green,
              selectionColor: Colors.green.shade200,
              selectionHandleColor: Colors.green,
            ),
            dialogBackgroundColor: Colors.green.shade100,
            dialogTheme: DialogThemeData(
              titleTextStyle: TextStyle(
                color: Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              contentTextStyle: TextStyle(
                color: Colors.green.shade800,
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green, width: 1.5),
              ),
              labelStyle: TextStyle(color: Colors.green.shade700),
              hintStyle: TextStyle(color: Colors.green.shade900),
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            iconTheme: IconThemeData(color: Colors.green),
          ),
          child: child ?? SizedBox.shrink(),
        );
      },
    );

    if (picked != null) {
      cubit.setDateRange(picked);
    }
  }



  @override
  void initState() {
    super.initState();
    cubit = AppCubit.get(context);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cubit.changeBottomSheetState(isShow: false);
  }

  @override
  void dispose() {
    cubit.changeBottomSheetState(isShow: false);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    String startDate = selectedDateRange != null
        ? DateFormat('dd MMM yyyy').format(selectedDateRange!.start)
        : "Select Start";
    String endDate = selectedDateRange != null
        ? DateFormat('dd MMM yyyy').format(selectedDateRange!.end)
        : "Select End";
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return PopScope(
          canPop: !cubit.isBottomSheetShown,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop && cubit.isBottomSheetShown) {
              Navigator.pop(context);
              cubit.changeBottomSheetState(isShow: false);
            }
          },
          child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: InkWell(
                  onTap: () => cubit.changeNavBarIndex(0),
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
              centerTitle: true,
              title: Text(
                "History",
                style: TextStyle(
                  color: ColorManager.blackColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () => toggleBottomSheet(),
                  icon: SvgPicture.asset(
                    'assets/icons/settings.svg',
                    width: 28,
                    height: 22.6,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/icons/check.svg',
                      width: 28,
                      height: 22.6,
                    ),
                  ),
                ),
              ],
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Expanded(child: historyItemBuilder(context)),
                  ],
                ),
              ),
            ),
           ),
        );
      },
    );
  }

  void toggleBottomSheet() {
    if (cubit.isBottomSheetShown) {
      Navigator.pop(context);
      cubit.changeBottomSheetState(isShow: false);
    } else {
      PersistentBottomSheetController? bottomSheetController =
      scaffoldKey.currentState?.showBottomSheet(
            (context) => Container(
          height: MediaQuery.of(context).size.height * 0.49,
          decoration: BoxDecoration(
            color: Color(0xFFFEF7FF),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Filters',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF26273A),
                        ),
                      ),
                    ),
                    BlocBuilder<AppCubit, AppStates>(
                      builder: (context, state) {
                        return TextButton(
                          onPressed: cubit.isDefault
                              ? null
                              : () {
                            cubit.resetFilter();
                            cubit.resetFilter2();
                            cubit.clearDateRange();
                          },
                          child: Text(
                            'Clear',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: cubit.isDefault
                                  ? ColorManager.greenColor.withAlpha(150)
                                  : ColorManager.greenColor,
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              Container(
                height: 1,
                width: double.infinity,
                color: Color(0xFFE0E8F2),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Period',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF26273A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 10,
                        children: [
                          CustomButton(text: "Today"),
                          CustomButton(text: "Yesterday"),
                          CustomButton(text: "This Week"),
                          CustomButton(text: "This month"),
                          CustomButton(text: "Previous month"),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Select period',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF26273A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<AppCubit, AppStates>(
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: _pickDateRange,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _dateBox(cubit.startDate),
                              const SizedBox(width: 10),
                              Text("-", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 10),
                              _dateBox(cubit.endDate),
                            ],
                          ),
                        );
                      },
                    ),

                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 1,
                width: double.infinity,
                color: Color(0xFFE0E8F2),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5,left: 20,top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF26273A),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 10,
                    children: [
                      CustomButton2(text: "Healthy"),
                      CustomButton2(text: "Medium"),
                      CustomButton2(text: "Bad"),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30,right: 30,top: 15),
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorManager.greenColor
                    ),
                    child: Center(
                      child: Text(
                        'Show results (20)',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFEF7FF)
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      );

      cubit.changeBottomSheetState(isShow: true);
      bottomSheetController?.closed.then((_) {
        cubit.changeBottomSheetState(isShow: false);
      });
    }
  }
  Widget _dateBox(String date) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: Color(0xFFFEF7FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFFE0E8F2)),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/Calendar.svg',
                width: 14,
                height: 16,
              ),
              const SizedBox(width: 5),
              Text(date, style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF26273A)
              )),
            ],
          ),
        );
      },
    );
  }
}


class CustomButton extends StatelessWidget {
  final String text;

  const CustomButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        bool isSelected = cubit.selectedButton == text;


        return GestureDetector(
          onTap: () {
            cubit.selectButton(text);
            cubit.startDate = "Select Start";
            cubit.endDate = "Select End";
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: isSelected ? ColorManager.greenColor.withOpacity(0.3) : Color(0xFFFEF7FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:  Color(0xFFE0E8F2),
              ),
            ),
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color:  Color(0xFF26273A),
              ),
            ),
          ),
        );
      },
    );
  }
}
class CustomButton2 extends StatelessWidget {
  final String text;

  const CustomButton2({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        bool isSelected = cubit.selectedButton2 == text;

        return GestureDetector(
          onTap: () {
            cubit.selectButton2(text);
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: isSelected ? ColorManager.greenColor.withOpacity(0.3) : Color(0xFFFEF7FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:  Color(0xFFE0E8F2),
              ),
            ),
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color:  Color(0xFF26273A),
              ),
            ),
          ),
        );
      },
    );
  }
}

