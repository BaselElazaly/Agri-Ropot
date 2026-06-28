enum RequestState { initial, loading, done, error }

class ScanningState {
  final RequestState requestState;
  final String msg;

  final dynamic errorType;

  const ScanningState({
    this.requestState = RequestState.initial,
    this.msg = '',
    this.errorType,
  });

  ScanningState copyWith({
    RequestState? requestState,
    String? msg,
    dynamic errorType,
  }) {
    return ScanningState(
      requestState: requestState ?? this.requestState,
      msg: msg ?? this.msg,
      errorType: errorType ?? this.errorType,
    );
  }
}
