import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(const NotificationState());

  // System & services update
  void toggleSystemUpdates(bool value) {
    emit(state.copyWith(systemUpdates: value));
  }

  void toggleBillReminder(bool value) {
    emit(state.copyWith(billReminder: value));
  }

  void togglePromotion(bool value) {
    emit(state.copyWith(promotion: value));
  }

  void toggleDiscount(bool value) {
    emit(state.copyWith(discountAvailable: value));
  }

  void togglePaymentRequest(bool value) {
    emit(state.copyWith(paymentRequest: value));
  }

  // Others
  void toggleNewService(bool value) {
    emit(state.copyWith(newServiceAvailable: value));
  }

  void toggleNewTips(bool value) {
    emit(state.copyWith(newTipsAvailable: value));
  }

  // Common
  void toggleGeneral(bool value) {
    emit(state.copyWith(generalNotification: value));
  }

  void toggleSound(bool value) {
    emit(state.copyWith(sound: value));
  }

  void toggleVibrate(bool value) {
    emit(state.copyWith(vibrate: value));
  }
}
