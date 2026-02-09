import 'package:bloc/bloc.dart';
import 'app_info_state.dart';

class AppInfoCubit extends Cubit<AppInfoState> {
  AppInfoCubit() : super(AppInfoInitial());
}
