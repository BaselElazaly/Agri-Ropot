import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class CropDetailsCard extends StatelessWidget {
  const CropDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Crop details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailItem(
              icon: 'assets/images/soil_temp.png',
              title: 'Temperature',
              subtitle: 'A warm summer requires of\n25-35°C.',
            ),
            const Divider(height: 24, color: Colors.transparent),
            _buildDetailItem(
              icon: 'assets/images/soil_mois.png',
              title: 'Soil and moisture',
              subtitle: 'Well-drained soil 70-85%',
            ),
            const Divider(height: 24, color: Colors.transparent),
            _buildDetailItem(
              icon: 'assets/images/soil_ph.png',
              title: 'Soil pH',
              subtitle: 'Ideal pH 7.0 - 6.0',
            ),
            const Divider(height: 24, color: Colors.transparent),
            _buildDetailItem(
              icon: 'assets/images/soil_season.png',
              title: 'Planting season',
              subtitle: 'March - May • Harvest after 75 -\n90 days',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({required String icon, required String title, required String subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          child: Image.asset(icon, width: 36),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      ],
    );
  }
}