import 'package:flutter/material.dart';

class PreviousRecordBody extends StatelessWidget {
  const PreviousRecordBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildMainRecordCard(),
        ],
      ),
    );
  }

  // عنوان القسم
  Widget _buildHeader() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: const Row(
        children: [
          Icon(Icons.history_rounded, color: Colors.green, size: 28),
          SizedBox(width: 10),
          Text(
            "Latest Analysis Report",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
          ),
        ],
      ),
    );
  }

  // الكارت الرئيسي
  Widget _buildMainRecordCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDiseaseSection(),
          const Divider(height: 1, indent: 20, endIndent: 20),
          _buildRecommendSection(),
        ],
      ),
    );
  }

  // قسم المرض - Disease Section
  Widget _buildDiseaseSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel("Disease Detection", Icons.biotech_rounded, Colors.redAccent),
          const SizedBox(height: 15),
          Row(
            children: [
              _infoTile("Plant Name", "Tomato", Icons.local_florist_outlined),
              const SizedBox(width: 20),
              _infoTile("Condition", "Early Blight", Icons.bug_report_outlined),
            ],
          ),
          const SizedBox(height: 15),
          _buildConfidenceBar(0.85), // نسبة الثقة 85% كمثال
          const SizedBox(height: 15),
          const Text(
            "Description",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
          ),
          const Text(
            "The leaves show small, brownish spots that are enlarging into circular lesions. It is recommended to remove infected leaves immediately.",
            style: TextStyle(color: Color(0xFF5D6D7E), height: 1.4),
          ),
        ],
      ),
    );
  }

  // قسم التوصيات - Recommend Section
  Widget _buildRecommendSection() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.03),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel("Environmental Recommendations", Icons.wb_sunny_outlined, Colors.orange),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _weatherChip("Temp", "24°C", Icons.thermostat_rounded),
              _weatherChip("Humidity", "65%", Icons.water_drop_rounded),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF43A047), Color(0xFF66BB6A)]),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Column(
              children: [
                Text("Recommended Plant", style: TextStyle(color: Colors.white70, fontSize: 12)),
                Text(
                  "Lettuce (Organic Variant)",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // أدوات مساعدة للواجهة (Helper Widgets)
  Widget _sectionLabel(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
      ],
    );
  }

  Widget _infoTile(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.blueGrey),
              const SizedBox(width: 5),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
            const Text("Confidence", style: TextStyle(color: Colors.grey, fontSize: 12)),
            Text("${(progress * 100).toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            color: Colors.green,
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _weatherChip(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}