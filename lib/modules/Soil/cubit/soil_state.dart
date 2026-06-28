import 'package:agre_lens_app/core/enums.dart';

enum RequestState { initial, loading, done, error }



class SoilState {
  final RequestState requestState;
  final String msg;
  final ErrorType errorType;

  const SoilState({
    this.requestState = RequestState.initial,
    this.msg = '',
    this.errorType = ErrorType.none,
  });

  SoilState copyWith({
    RequestState? requestState,
    String? msg,
    ErrorType? errorType,
  }) {
    return SoilState(
      requestState: requestState ?? this.requestState,
      msg: msg ?? this.msg,
      errorType: errorType ?? this.errorType,
    );
  }
}
