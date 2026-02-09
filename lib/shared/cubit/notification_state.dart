part of 'notification_cubit.dart';

class NotificationState extends Equatable {
  final bool systemUpdates;
  final bool billReminder;
  final bool promotion;
  final bool discountAvailable;
  final bool paymentRequest;
  final bool newServiceAvailable;
  final bool newTipsAvailable;

  final bool generalNotification;
  final bool sound;
  final bool vibrate;

  const NotificationState({
    this.systemUpdates = false,
    this.billReminder = false,
    this.promotion = false,
    this.discountAvailable = false,
    this.paymentRequest = false,
    this.newServiceAvailable = false,
    this.newTipsAvailable = false,
    this.generalNotification = false,
    this.sound = false,
    this.vibrate = false,
  });

  NotificationState copyWith({
    bool? systemUpdates,
    bool? billReminder,
    bool? promotion,
    bool? discountAvailable,
    bool? paymentRequest,
    bool? newServiceAvailable,
    bool? newTipsAvailable,
    bool? generalNotification,
    bool? sound,
    bool? vibrate,
  }) {
    return NotificationState(
      systemUpdates: systemUpdates ?? this.systemUpdates,
      billReminder: billReminder ?? this.billReminder,
      promotion: promotion ?? this.promotion,
      discountAvailable: discountAvailable ?? this.discountAvailable,
      paymentRequest: paymentRequest ?? this.paymentRequest,
      newServiceAvailable: newServiceAvailable ?? this.newServiceAvailable,
      newTipsAvailable: newTipsAvailable ?? this.newTipsAvailable,
      generalNotification: generalNotification ?? this.generalNotification,
      sound: sound ?? this.sound,
      vibrate: vibrate ?? this.vibrate,
    );
  }

  @override
  List<Object?> get props => [
        systemUpdates,
        billReminder,
        promotion,
        discountAvailable,
        paymentRequest,
        newServiceAvailable,
        newTipsAvailable,
        generalNotification,
        sound,
        vibrate,
      ];
}
