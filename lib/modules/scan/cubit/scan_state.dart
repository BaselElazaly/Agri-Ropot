import 'package:agre_lens_app/models/last_five_detetct_model.dart';
import 'package:agre_lens_app/shared/cubit/states.dart';

class ScanPlantLoadingState extends AppStates {}

class ScanPlantSuccessState extends AppStates {
  final DetectionModel detectionModel;
  ScanPlantSuccessState(this.detectionModel);
}

class ScanPlantErrorState extends AppStates {
  final String error;
  ScanPlantErrorState(this.error);
}