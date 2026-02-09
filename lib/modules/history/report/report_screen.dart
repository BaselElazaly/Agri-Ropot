import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';

class ReportScreen extends StatefulWidget {
  final int reportNum;
  final int serialNum;
  final int healthPrecentage;
  const ReportScreen({
    Key? key,
    required this.reportNum,
    required this.serialNum,
    required this.healthPrecentage,
  }) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTimeRange? selectedDateRange;
  TimeOfDay? selectedTime;

  Future<void> _pickDateRange() async {
    DateTime now = DateTime.now();
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: now,
      initialEntryMode: DatePickerEntryMode.input,
      helpText: "Select a Date Range",
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.green,
            colorScheme: ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              primaryContainer: Colors.green.shade300,
              onPrimaryContainer: Colors.white,
              secondary: Colors.green.shade300,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: Colors.green.shade100,
              titleTextStyle: const TextStyle(
                color: Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.green.shade900),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => selectedDateRange = picked);
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green.shade600,
              surface: const Color(0xFFFEF7FF),
              onSurface: Colors.green.shade900,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: const Color(0xFFFEF7FF),
              hourMinuteColor: Colors.green[100],
              hourMinuteTextColor: Colors.green.shade900,
              dialHandColor: Colors.green.shade600,
              dialBackgroundColor: Colors.green[100],
              dayPeriodColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) return Colors.green.shade700;
                return Colors.white;
              }),
              dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) return Colors.white;
                return Colors.green.shade900;
              }),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA), 
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading:Padding(
                padding: const EdgeInsets.only(left: 10),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Transform.scale(
                    scale: 0.8,
                    child: SvgPicture.asset(
                      'assets/icons/ep_back.svg',
                      width: 32,
                      height: 32,
                    ),
                  ),
                ),
              ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReportInfoCard(), 
                  const SizedBox(height: 25),
                  _buildHeader(),
                  const SizedBox(height: 15),
                  _buildMainRecordCard(), 
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // كارت معلومات الريبورت (تصميمك الأصلي مع تحسين بسيط)
  Widget _buildReportInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFFFEF7FF),
        border: Border.all(color: const Color(0xFFD9D9D9), width: 1),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Report ${widget.reportNum}',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 22),
                ),
                const SizedBox(height: 5),
                Text('Report Serial', style: GoogleFonts.poppins(fontSize: 12, color: Colors.black45)),
                Text('${widget.serialNum}', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.black54),
                    const SizedBox(width: 5),
                    Text('02 Jan 2025', style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54)),
                    const SizedBox(width: 15),
                    const Icon(Icons.access_time, size: 14, color: Colors.black54),
                    const SizedBox(width: 5),
                    Text('11:00 AM', style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54)),
                  ],
                )
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/images/plant health2.webp',
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, 20 * (1 - value)), child: child),
        );
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.analytics_outlined, color: Colors.green, size: 24),
          ),
          const SizedBox(width: 12),
          Text(
            "Detailed Analysis",
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF2C3E50)),
          ),
        ],
      ),
    );
  }

  Widget _buildMainRecordCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        children: [
          _buildDiseaseSection(),
          const Divider(height: 1, indent: 25, endIndent: 25, color: Color(0xFFF1F1F1)),
          _buildRecommendSection(),
        ],
      ),
    );
  }

  Widget _buildDiseaseSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel("Detection Results", Icons.biotech_rounded, Colors.redAccent),
          const SizedBox(height: 20),
          Row(
            children: [
              _infoTile("Plant", "Tomato", Icons.local_florist_outlined),
              _infoTile("Status", "Early Blight", Icons.coronavirus_outlined),
            ],
          ),
          const SizedBox(height: 20),
          _buildConfidenceBar(widget.healthPrecentage / 100), // استخدام الداتا القادمة من السكرين
          const SizedBox(height: 20),
          Text("Expert Description", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.grey[700])),
          const SizedBox(height: 5),
          Text(
            "Target-like spots with concentric rings. This fungal disease thrives in humid conditions and can spread rapidly if not treated.",
            style: GoogleFonts.poppins(color: const Color(0xFF5D6D7E), fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.04),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel("Smart Recommendation", Icons.auto_awesome_outlined, Colors.orange[700]!),
          const SizedBox(height: 20),
          Row(
            children: [
              _weatherChip("Air Temp", "24°C", Icons.thermostat),
              const SizedBox(width: 12),
              _weatherChip("Humidity", "62%", Icons.cloud_outlined),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)]),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: Row(
              children: [
                const Icon(Icons.eco, color: Colors.white, size: 30),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Best Crop to Plant", style: TextStyle(color: Colors.white70, fontSize: 11)),
                    Text("Organic Lettuce", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widgets مساعدة
  Widget _sectionLabel(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(title.toUpperCase(), style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.w700, fontSize: 12, letterSpacing: 1)),
      ],
    );
  }

  Widget _infoTile(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.blueGrey[400]),
              const SizedBox(width: 6),
              Flexible(child: Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceBar(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Analysis Confidence", style: TextStyle(color: Colors.grey, fontSize: 11)),
            Text("${(progress * 100).toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[200], color: Colors.green, minHeight: 6),
        ),
      ],
    );
  }

  Widget _weatherChip(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.withOpacity(0.1))),
        child: Row(
          children: [
            Icon(icon, color: Colors.blueAccent, size: 18),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 9)),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}