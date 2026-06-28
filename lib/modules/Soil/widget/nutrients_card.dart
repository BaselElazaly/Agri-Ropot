import 'package:agre_lens_app/models/soilModel.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NutrientsCard extends StatelessWidget {
  final SoilModel? soilModel;
  final VoidCallback onTap;

  const NutrientsCard({
    super.key,
    required this.onTap,
    required this.soilModel,
  });

  @override
  Widget build(BuildContext context) {
    final double nitrogenRaw = soilModel?.avgNitrogen ?? 0.0;
    final double potassiumRaw = soilModel?.avgPotassium ?? 0.0;
    final double phosphorusRaw = soilModel?.avgPhosphorus ?? 0.0;

    final double nRatio = (nitrogenRaw / 100).clamp(0.0, 1.0);
    final double kRatio = (potassiumRaw / 300).clamp(0.0, 1.0);
    final double pRatio = (phosphorusRaw / 150).clamp(0.0, 1.0);

    return FadeInLeft(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Nutrients',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset('assets/icons/NaturalPlant.svg',
                        width: 16),
                  ],
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF419C48),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.sync, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildStatusTag('phosphor', _getNutrientStatus(pRatio)),
                _buildStatusTag('potassium', _getNutrientStatus(kRatio)),
                _buildStatusTag('Nitrogen', _getNutrientStatus(nRatio)),
              ],
            ),
            const SizedBox(height: 24),
            _buildNutrientBar('Nitrogen (N)', nRatio, const Color(0xFF16D25A)),
            const SizedBox(height: 16),
            _buildNutrientBar('potassium (K)', kRatio, const Color(0xFF0ABE46)),
            const SizedBox(height: 16),
            _buildNutrientBar('phosphor (P)', pRatio, const Color(0xFF3A8D42)),
          ],
        ),
      ),
    );
  }

  String _getNutrientStatus(double ratio) {
    if (ratio < 0.35) return 'Low';
    if (ratio < 0.70) return 'Medium';
    return 'Stable';
  }

  Widget _buildStatusTag(String name, String level) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF004C06).withValues(alpha: 0.73),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF0ABE46),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$name ',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            level,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientBar(String title, double value, Color color) {
    String percentage = '${(value * 100).toInt()}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E293B),
              ),
            ),
            Text(
              percentage,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        FractionallySizedBox(
          widthFactor: value,
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
