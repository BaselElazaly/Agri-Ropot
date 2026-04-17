import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';
import '../../../shared/styles/colors.dart';

class PlantDetailsScreen extends StatelessWidget {
  final String? label; // اسم النبتة
  final String? date; // تاريخ الالتقاط
  final double? confidence; // نسبة الصحة
  final String? imageUrl; // صورة الباك إند

  const PlantDetailsScreen({
    Key? key,
    required this.label,
    required this.date,
    required this.confidence,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA), // لون خلفية هادي
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Transform.scale(
                  scale: 0.7,
                  child: SvgPicture.asset(
                    'assets/icons/ep_back.svg',
                  ),
                ),
              ),
            ),
            title: const Text('Plant Analysis',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. الصورة في شكل Card
                  FadeInDown(
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(imageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // 2. اسم النبتة والتاريخ
                  FadeInLeft(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label!,
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_month_outlined,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              'Analyzed on: ${formatFullDateTime(date)}', // قص التاريخ عشان ميبقاش طويل
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // 3. النسبة المئوية للصحة (Health Percentage Card)
                  FadeInUp(
                    child: _buildStatusCard(
                      title: 'Health Status',
                      value: '$confidence%',
                      icon: Icons.favorite,
                      iconColor: Colors.redAccent,
                      progressValue: confidence! / 100,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 4. الـ Status والـ Recommendation
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: _buildInfoSection(
                      title: 'Status',
                      content: confidence! > 70
                          ? 'Your plant is in excellent condition. Growth parameters are optimal.'
                          : 'Warning: Some issues detected. The plant requires immediate attention.',
                      icon: Icons.info_outline,
                      color: ColorManager.greenColor,
                    ),
                  ),
                  const SizedBox(height: 20),

                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: _buildInfoSection(
                      title: 'Recommendation',
                      content:
                          '• Increase watering frequency.\n• Ensure adequate sunlight exposure.\n• Apply organic fertilizer if symptoms persist.',
                      icon: Icons.lightbulb_outline,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ودجت كارت الصحة مع الـ Progress Bar
  Widget _buildStatusCard(
      {required String title,
      required String value,
      required IconData icon,
      required Color iconColor,
      required double progressValue}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 10),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(value,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
            ],
          ),
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: progressValue,
            backgroundColor: Colors.grey.shade200,
            color: ColorManager.greenColor,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

  // ودجت السكاشن (Status & Recommendation)
  Widget _buildInfoSection(
      {required String title,
      required String content,
      required IconData icon,
      required Color color}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Text(title,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
                fontSize: 15, color: Colors.black87, height: 1.5),
          ),
        ],
      ),
    );
  }

  String formatFullDateTime(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return 'No date available';

    try {
      DateTime dateTime = DateTime.parse(rawDate);
      String datePart = DateFormat('yyyy-MM-dd').format(dateTime);
      String timePart = DateFormat('hh:mm a').format(dateTime);
      return '$datePart  |  $timePart';
    } catch (e) {
      return 'Invalid Date'; // لو الصيغة مش ISO 8601
    }
  }
}
