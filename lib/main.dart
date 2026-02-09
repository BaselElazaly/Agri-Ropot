import 'package:agre_lens_app/modules/splash/splash_screen.dart';
import 'package:agre_lens_app/shared/bloc_observer.dart';
import 'package:agre_lens_app/shared/cubit/cubit.dart';
import 'package:agre_lens_app/shared/network/local/cash_helper.dart';
import 'package:agre_lens_app/shared/network/remote/dio_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';



void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  runApp(
    BlocProvider(
      create: (context) => AppCubit(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFEF7FF)
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
