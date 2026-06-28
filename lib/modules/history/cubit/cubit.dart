import 'package:agre_lens_app/core/server_gate.dart';
import 'package:agre_lens_app/models/history_model.dart';
import 'package:agre_lens_app/modules/history/cubit/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScanningCubit extends Cubit<ScanningState> {
  ScanningCubit() : super(const ScanningState());

  List<HistoryModel> scansList = [];

  Future<void> getAllScans() async {
    emit(state.copyWith(requestState: RequestState.loading));

    final result = await ServerGate.i.getFromServer(
      url:
          'https://finalgraduationproject.runasp.net/api/customer/histories/history',
    );

    if (result.success) {
      final dynamic responseData =
          result.data is Map ? result.data['data'] : result.data;

      if (responseData != null && responseData is List) {
        scansList = HistoryModel.fromJsonList(responseData);
      } else {
        scansList = [];
      }
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
