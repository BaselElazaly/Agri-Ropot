import 'package:agre_lens_app/core/loger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AppBlocObserver extends BlocObserver {
  LoggerDebug log = LoggerDebug(headColor: LogColors.white, constTitle: 'App Bloc Observer');
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log.blue('${bloc.runtimeType} ( onCreate )');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (change.nextState.runtimeType.toString().contains("Failed")) {
      log.red('$bloc  ( onChange ), ${change.currentState}==> ${change.nextState}');
    } else {
      log.green('$bloc  ( onChange ), ${change.currentState}==> ${change.nextState}');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log.red('${bloc.runtimeType} ( onError ), $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log.yellow('${bloc.runtimeType} ( onClose )');
  }
}
