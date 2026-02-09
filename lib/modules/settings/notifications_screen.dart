import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agre_lens_app/shared/cubit/notification_cubit.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationCubit(),
      child: const NotificationsView(),
    );
  }
}

class NotificationsView extends StatelessWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sections = [
      NotificationSectionData(
        title: 'Common',
        items: [
          NotificationItemData(
            label: 'General Notification',
            toggleCallback: (cubit, value) => cubit.toggleGeneral(value),
            selector: (state) => state.generalNotification,
          ),
          NotificationItemData(
            label: 'Sound',
            toggleCallback: (cubit, value) => cubit.toggleSound(value),
            selector: (state) => state.sound,
          ),
          NotificationItemData(
            label: 'Vibrate',
            toggleCallback: (cubit, value) => cubit.toggleVibrate(value),
            selector: (state) => state.vibrate,
          ),
        ],
      ),
      NotificationSectionData(
        title: 'System & services update',
        items: [
          NotificationItemData(
            label: 'App updates',
            toggleCallback: (cubit, value) => cubit.toggleSystemUpdates(value),
            selector: (state) => state.systemUpdates,
          ),
          NotificationItemData(
            label: 'Bill Reminder',
            toggleCallback: (cubit, value) => cubit.toggleBillReminder(value),
            selector: (state) => state.billReminder,
          ),
          NotificationItemData(
            label: 'Promotion',
            toggleCallback: (cubit, value) => cubit.togglePromotion(value),
            selector: (state) => state.promotion,
          ),
          NotificationItemData(
            label: 'Discount Available',
            toggleCallback: (cubit, value) => cubit.toggleDiscount(value),
            selector: (state) => state.discountAvailable,
          ),
          NotificationItemData(
            label: 'Payment Request',
            toggleCallback: (cubit, value) => cubit.togglePaymentRequest(value),
            selector: (state) => state.paymentRequest,
          ),
        ],
      ),
      NotificationSectionData(
        title: 'Others',
        items: [
          NotificationItemData(
            label: 'New Service Available',
            toggleCallback: (cubit, value) => cubit.toggleNewService(value),
            selector: (state) => state.newServiceAvailable,
          ),
          NotificationItemData(
            label: 'New Tips Available',
            toggleCallback: (cubit, value) => cubit.toggleNewTips(value),
            selector: (state) => state.newTipsAvailable,
          ),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            children: sections
                .asMap()
                .entries
                .map(
                  (entry) => Column(
                    children: [
                      NotificationSection(section: entry.value),
                      if (entry.key != sections.length - 1)
                        const Divider(
                          thickness: 1,
                          color: Color(0xFFEEEEEE),
                          height: 24,
                        ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class NotificationSectionData {
  final String title;
  final List<NotificationItemData> items;

  NotificationSectionData({required this.title, required this.items});
}

class NotificationItemData {
  final String label;
  final Function(NotificationCubit, bool) toggleCallback;
  final bool Function(NotificationState) selector;

  NotificationItemData({
    required this.label,
    required this.toggleCallback,
    required this.selector,
  });
}

class NotificationSection extends StatelessWidget {
  final NotificationSectionData section;

  const NotificationSection({Key? key, required this.section})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              section.title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.5,
                letterSpacing: 0.1,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: section.items
                  .asMap()
                  .entries
                  .map(
                    (entry) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: NotificationItem(item: entry.value),
                        ),
                        if (entry.key != section.items.length - 1)
                          const Divider(
                            thickness: 1,
                            color: Colors.transparent,
                            height: 1,
                          ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final NotificationItemData item;

  const NotificationItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        final cubit = context.read<NotificationCubit>();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 40,
                height: 20,
                child: Transform.scale(
                  scale: 1.0,
                  child: Switch(
                    value: item.selector(state),
                    onChanged: (value) => item.toggleCallback(cubit, value),
                    activeColor: Colors.white,
                    activeTrackColor: const Color(0xFF4CAF50),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color(0xFFD9D9D9),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
