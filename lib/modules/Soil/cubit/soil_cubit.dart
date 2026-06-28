import 'package:agre_lens_app/core/server_gate.dart';
import 'package:agre_lens_app/models/soilModel.dart';
import 'package:agre_lens_app/modules/Soil/cubit/soil_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SoilCubit extends Cubit<SoilState> {
  SoilCubit() : super(const SoilState());

  SoilModel? soilModel;

  Future<void> getFeatureData() async {
    emit(state.copyWith(requestState: RequestState.loading));

    final result = await ServerGate.i.getFromServer(
      url:
          'https://finalgraduationproject.runasp.net/api/Customer/Recommendation/Recommendation',
    );

    if (result.success) {
      soilModel = SoilModel.fromJson(result.data);

      emit(state.copyWith(
        requestState: RequestState.done,
      ));
    } else {
      emit(state.copyWith(
        requestState: RequestState.error,
        msg: result.msg,
        errorType: result.errType,
      ));
    }
  }
}
