import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:agre_lens_app/models/last_five_detetct_model.dart';
import 'package:agre_lens_app/modules/history/history_screen.dart';
import 'package:agre_lens_app/modules/home/home_screen.dart';
import 'package:agre_lens_app/modules/scan/scan_screen.dart';
import 'package:agre_lens_app/modules/settings/settings_screen.dart';
import 'package:agre_lens_app/modules/control/control_screen.dart';
import 'package:agre_lens_app/shared/cubit/states.dart';
import 'package:agre_lens_app/shared/network/local/cash_helper.dart';
import 'package:agre_lens_app/shared/styles/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio_package;
import 'dart:async';

class AppCubit extends Cubit<AppStates> {

  AppCubit() : super(AppInitialStates()) {
    hourController = FixedExtentScrollController(initialItem: selectedHour);
    minuteController = FixedExtentScrollController(initialItem: selectedMinute);
    _init();

    username = username ?? 'Default Username';
  }

  void _init() async {
    await loadSavedControl();
    getSensorReadings();
    getLastFiveDetects();
    getUserInfo();
    
  }

  static AppCubit get(BuildContext context) => BlocProvider.of(context);


final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://finalgraduationproject.runasp.net/api/',
    receiveDataWhenStatusError: true,
  ));
int smokeLevel = 0;
int soilMoisture = 0;
double temperature = 0;

void getSensorReadings() {
  emit(AppGetSensorsLoadingState());

  String? token = CacheHelper.getData(key: 'token');

  _dio.get(
    'customer/homes/sensorReadings',
    options: Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', 
      },
    ),
  ).then((value) {
    debugPrint("✅ SUCCESS DATA: ${value.data}");
    
    smokeLevel = value.data['smokeLevel'] ?? 0;
    soilMoisture = value.data['soilMoisture'] ?? 0;
    temperature = value.data['temperature'] ?? 0.0;
    
    emit(AppGetSensorsSuccessState());
  }).catchError((error) {
    if (error is DioException) {
      // السطور دي هي اللي هتحل اللغز
      debugPrint("🚨 Status Code: ${error.response?.statusCode}"); 
      debugPrint("🚨 Server Message: ${error.response?.data}"); 
      debugPrint("🚨 Full URL: ${error.requestOptions.uri}"); 
    } else {
      debugPrint("🚨 Unexpected Error: ${error.toString()}");
    }
    emit(AppGetSensorsErrorState(error.toString()));
  });
}


List<DetectionModel> detections = [];

void getLastFiveDetects() {
  emit(AppGetDetectionsLoadingState());

  String? token = CacheHelper.getData(key: 'token');

  _dio.get(
    'customer/homes/lastFiveDetects', // الـ endpoint من الصورة
    options: Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    ),
  ).then((value) {
    debugPrint("✅ DETECTIONS SUCCESS");
    
    // تصفير القائمة عشان م تكررش البيانات لو ناديت الفانكشن تاني
    detections = [];
    
    // بما إن اللي راجع List بنمشي عليها بـ loop
    value.data.forEach((element) {
      detections.add(DetectionModel.fromJson(element));
    });

    emit(AppGetDetectionsSuccessState());
  }).catchError((error) {
    if (error is DioException) {
      debugPrint("🚨 Status Code: ${error.response?.statusCode}");
      debugPrint("🚨 Server Message: ${error.response?.data}");
    } else {
      debugPrint("🚨 Unexpected Error: ${error.toString()}");
    }
    emit(AppGetDetectionsErrorState(error.toString()));
  });
}

List<DetectionModel> allDetections = []; // قائمة جديدة لكل الداتا

void getAllDetectPlants() {
  emit(AppGetAllDetectionsLoadingState());

  String? token = CacheHelper.getData(key: 'token');

  _dio.get(
    'customer/homes/allDetectPlants',
    options: Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    ),
  ).then((value) {
    allDetections = [];
    value.data.forEach((element) {
      allDetections.add(DetectionModel.fromJson(element));
    });
    emit(AppGetAllDetectionsSuccessState());
  }).catchError((error) {
    debugPrint("🚨 Error: ${error.toString()}");
    emit(AppGetAllDetectionsErrorState(error.toString()));
  });
}



String? userId;
String? fullName;
String? farmName;
String? userEmail;
String? userPhone;
String? profileImageUrl;

void getUserInfo() {
  emit(AppGetProfileLoadingState()); 

  String? token = CacheHelper.getData(key: 'token');

  _dio.get(
    'identity/profiles/info',
    options: Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    ),
  ).then((value) {
    userId = value.data['id'];
    fullName = value.data['fullName'];
    farmName = value.data['farmName'] ?? "My Farm"; 
    userEmail = value.data['email'];
    userPhone = value.data['phoneNumber'] ?? "Add Phone Number";
    profileImageUrl = value.data['imgUrl'];

    userNameController.text = fullName ?? '';
    farmNameController.text = farmName ?? '';
    emailController.text = userEmail ?? '';

    emit(AppGetProfileSuccessState());
  }).catchError((error) {
    debugPrint("🚨 Profile Info Error: ${error.toString()}");
    emit(AppGetProfileErrorState(error.toString()));
  });
}

  String? username;
  String? profileImageUrl2;
  String? email;
  String? farmName2;
  TextEditingController userNameController = TextEditingController(text: 'Basel Gamal');
  TextEditingController farmNameController = TextEditingController(text: 'My Smart Farm');
  TextEditingController emailController = TextEditingController(text: 'basel@example.com');
  TextEditingController passwordController = TextEditingController(text: '********');

  StreamSubscription? userDataSubscription;

  File? profileImage;
  File? temporaryProfileImage;

 

  @override
  Future<void> close() {
    userDataSubscription?.cancel();
    return super.close();
  }

  






  final DatabaseReference farmRef = FirebaseDatabase.instance.ref('farm');

 
  //

  String selectedButton = '';
  String selectedButton2 = '';

  String startDate = "Select Start";
  String endDate = "Select End";

  DateTimeRange? selectedDateRange;
  void setDateRange(DateTimeRange range) {
    selectedDateRange = range;
    startDate = DateFormat('dd MMM yyyy').format(range.start);
    endDate = DateFormat('dd MMM yyyy').format(range.end);
    resetFilter();

    emit(DateRangeUpdatedState());
  }
  void clearDateRange() {
    selectedDateRange = null;
    startDate = "Select Start";
    endDate = "Select End";
    emit(DateRangeClearedState()); 
  }

  bool get isDefault => selectedButton.isEmpty && selectedButton2.isEmpty && startDate == "Select Start" && endDate == "Select End";

  // اختيار زر أول
  void selectButton(String text) {
    if (selectedButton != text) {
      selectedButton = text;
      emit(ButtonChangeState());  
    }
  }

  void selectButton2(String text) {
    if (selectedButton2 != text) {
      selectedButton2 = text;
      emit(ButtonChangeState()); 
    }
  }


  void changeBottomSheetState({required bool isShow}) {
    if (isBottomSheetShown != isShow) { 
      isBottomSheetShown = isShow;
      emit(ButtonChangeState());  
    }
  }

  void resetFilter() {
    if (selectedButton.isNotEmpty) { 
      selectedButton = '';  
      emit(AppChangeFilterState());
    }
  }

  void resetFilter2() {
    if (selectedButton2.isNotEmpty) { 
      selectedButton2 = '';  
      emit(AppChangeFilterState());
    }
  }





  int healthPlantPrecentage = 45;

  void updateHealth(int newHealth) {
    healthPlantPrecentage = newHealth;
    emit(AppHealthUpdatedState());
  }

  bool isBottomSheetShown = false;



  int selectedHour = 1;
  int selectedMinute = 0;

  int savedHour = 1;
  int savedMinute = 0;

  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;

  Future<void> loadSavedControl() async {
    final prefs = await SharedPreferences.getInstance();

    savedHour = prefs.getInt('savedHour') ?? 1;
    savedMinute = prefs.getInt('savedMinute') ?? 0;

    selectedHour = savedHour;
    selectedMinute = savedMinute;

    hourController.jumpToItem(selectedHour);
    minuteController.jumpToItem(selectedMinute);

    emit(ControlResetState()); 
  }

  Future<void> saveControl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('savedHour', selectedHour);
    await prefs.setInt('savedMinute', selectedMinute);

    savedHour = selectedHour;
    savedMinute = selectedMinute;

    emit(ControlSavedState()); 
  }





  void updateHour(int hour) {
    selectedHour = hour;
    emit(AppUpdateTimeState());
  }

  void updateMinute(int minute) {
    selectedMinute = minute;
    emit(AppUpdateTimeState());
  }

  void resetControl() {
    selectedHour = savedHour;
    selectedMinute = savedMinute;

    hourController.jumpToItem(selectedHour);
    minuteController.jumpToItem(selectedMinute);

    emit(ControlResetState());
  }



  int currentIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    ControlScreen(),
    ScanScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];



  final List<String> svgIcons = [
    'assets/icons/home.svg',
    'assets/icons/control.svg',
    'assets/icons/scan.svg',
    'assets/icons/history.svg',
    'assets/icons/settings.svg',
  ];

  final List<String> labels = ['Home', 'Control', '', 'History', 'Settings'];

  void changeNavBarIndex(int index) {
    currentIndex = index;
    emit(AppBottomNavState());
  }

  List<BottomNavigationBarItem> get bottomItems {
    return List.generate(svgIcons.length, (index) {
      final bool isSelected = currentIndex == index;

      return BottomNavigationBarItem(
        icon: index == 2
            ? Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: ColorManager.greenColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    svgIcons[index],
                    width: 24,
                    height: 24,
                  ),
                ),
              )
            : SvgPicture.asset(
                svgIcons[index],
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isSelected ? ColorManager.greenColor : const Color(0xFF484C52),
                  BlendMode.srcIn,
                ),
              ),
        label: labels[index],
      );
    });
  }

Future<void> userRegister({
  required String fullName,
  required String email,
  required String password,
  required String confirmPassword,
  String? phone,
}) async {
  emit(AppRegisterLoadingState());

  try {
    Dio dio = Dio(BaseOptions(
      baseUrl: 'https://finalgraduationproject.runasp.net/api/',
      receiveDataWhenStatusError: true, 
      contentType: 'application/json',
    ));

    final response = await dio.post(
      'identity/identities/register',
      data: {
        "FullName": fullName,
        "email": email,
        "password": password,
        "ConfirmPassword": confirmPassword,
        if (phone != null && phone.isNotEmpty) "phoneNumber": phone,
      },
    );

    emit(AppRegisterSuccessState(response.data['msg'] ?? "تم التسجيل بنجاح"));

  } on DioException catch (e) {
  debugPrint("🔴 Server Rejected Request: ${e.response?.data}");
  String errorMessage = "An unexpected error occurred.";

  if (e.response?.data != null) {
    var data = e.response?.data;

    if (data is Map<String, dynamic>) {
      if (data.containsKey('description')) {
        errorMessage = data['description'];
      } else if (data.containsKey('errors')) {
        var errors = data['errors'];
        if (errors is Map) {
          errorMessage = errors.values.first[0].toString();
        } else if (errors is List) {
          errorMessage = errors[0].toString();
        }
      } else if (data.containsKey('msg')) {
        errorMessage = data['msg'];
      }
    } 
    
    else if (data is List && data.isNotEmpty) {
      errorMessage = data[0]['description'] ?? "Data error";
    }
  } else {
    errorMessage = "There is a problem connecting to the server; please check your internet connection.";
  }

  emit(AppRegisterErrorState(errorMessage));
}
}
Future<void> userLogin({
  required String email,
  required String password,
}) async {
  emit(AppLoginLoadingState());

  try {
    final response = await Dio(BaseOptions(
      baseUrl: 'https://finalgraduationproject.runasp.net/api/',
      receiveDataWhenStatusError: true,
      contentType: 'application/json',
    )).post(
      'identity/identities/login',
      data: {
        "email": email,
        "Password": password, 
      },
    );

    String token = response.data['token'];
    debugPrint("Token Received: $token");
    
    emit(AppLoginSuccessState(token));

  } on DioException catch (e) {
    debugPrint("🔴 Login Error Data: ${e.response?.data}");
    
    // Default English error message
    String errorMessage = "Invalid email or password";

    if (e.response?.data != null) {
      var data = e.response?.data;

      if (data is Map) {
        errorMessage = data['msg'] ?? data['description'] ?? errorMessage;
      } 
      else if (data is List && data.isNotEmpty) {
        errorMessage = data[0]['description'] ?? data[0]['msg'] ?? errorMessage;
      }
    } else {
      errorMessage = "Connection error. Please check your internet.";
    }

    emit(AppLoginErrorState(errorMessage));

  } catch (e) {
    debugPrint("🚨 Global Login Error: ${e.toString()}");
    emit(AppLoginErrorState("An unexpected error occurred."));
  }
}
void loginWithGoogle(String idToken) {
  emit(AppLoginLoadingState());

  Dio().post(
    'https://finalgraduationproject.runasp.net/api/identity/identities/googleLogin',
    data: {
      "idToken": idToken, 
    },
  ).then((value) {
    emit(AppLoginSuccessState(value.data['token']));
  }).catchError((error) {
    emit(AppLoginErrorState("Google Login Failed on Server"));
  });
}
Future<void> forgetPassword({required String email}) async {
  emit(AppForgetPasswordLoadingState());

  try {
    final response = await Dio(BaseOptions(
      baseUrl: 'https://finalgraduationproject.runasp.net/api/',
      receiveDataWhenStatusError: true,
    )).post(
      'identity/identities/forgetPassword',
      data: {
        "email": email,
      },
    );

    emit(AppForgetPasswordSuccessState(response.data['msg'] ?? "Reset link sent to your email."));

  } on DioException catch (e) {
    String errorMessage = "Failed to send reset link.";
    if (e.response?.data != null && e.response?.data is Map) {
      errorMessage = e.response?.data['msg'] ?? errorMessage;
    }
    emit(AppForgetPasswordErrorState(errorMessage));
  } catch (e) {
    emit(AppForgetPasswordErrorState("An unexpected error occurred."));
  }
}



}
