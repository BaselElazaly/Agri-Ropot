import 'dart:io';

abstract class AppStates{}

class AppInitialStates extends AppStates{}

class AppBottomNavState extends AppStates{}

class AppProfileOpenedState extends AppStates{}

class AppProfileClosedState extends AppStates{}

class ControlResetState extends AppStates{}

class ControlSavedState extends AppStates{}

class AppUpdateTimeState extends AppStates{}

class AppHealthUpdatedState extends AppStates{}

class BottomSheetShownState extends AppStates{}

class ButtonChangeState extends AppStates{}
class ButtonResetState extends AppStates{}
class AppChangeFilterState extends AppStates{}
class DateRangeUpdatedState extends AppStates{}
class DateRangeClearedState extends AppStates{}

class FarmLoading extends AppStates {}

class FarmDataUpdated extends AppStates {}

class UserDataLoadedState extends AppStates {}
class UserDataLoadingState extends AppStates {}
class UserDataErrorState extends AppStates {}

class UserDataImageUpdatedState extends AppStates {
  final File? updatedImage;

  UserDataImageUpdatedState(this.updatedImage);
}

class FarmLoaded extends AppStates {
  final Map<String, dynamic> farmData;
  FarmLoaded(this.farmData);
}

class FarmError extends AppStates {
  final String message;
  FarmError(this.message);
}

class AppRegisterLoadingState extends AppStates {}
class AppRegisterSuccessState extends AppStates {
  final String message;
  AppRegisterSuccessState(this.message);
}
class AppRegisterErrorState extends AppStates {
  final String error;
  AppRegisterErrorState(this.error);
}

class AppLoginLoadingState extends AppStates {}
class AppLoginSuccessState extends AppStates {
  final String token;
  AppLoginSuccessState(this.token);
}
class AppLoginErrorState extends AppStates {
  final String error;
  AppLoginErrorState(this.error);
}

class AppForgetPasswordLoadingState extends AppStates {}
class AppForgetPasswordSuccessState extends AppStates {
  final String message;
  AppForgetPasswordSuccessState(this.message);
}
class AppForgetPasswordErrorState extends AppStates {
  final String error;
  AppForgetPasswordErrorState(this.error);
}

class AppGetSensorsLoadingState extends AppStates {}
class AppGetSensorsSuccessState extends AppStates {}
class AppGetSensorsErrorState extends AppStates {
  final String error;
  AppGetSensorsErrorState(this.error);
}

class AppGetProfileLoadingState extends AppStates {}
class AppGetProfileSuccessState extends AppStates {}
class AppGetProfileErrorState extends AppStates {
  final String error;
  AppGetProfileErrorState(this.error);
}





