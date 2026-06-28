import 'package:agre_lens_app/shared/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  bool isAutodriveOn = false;

  @override
  Widget build(BuildContext context) {
    const Color greenColor = Color(0xFF4CAF50);
    const Color lightGrey = Color(0xFFF8FAFC);
    const Color darkColor = Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildLiveStreamCard(),
            const SizedBox(height: 16),
            _buildAutodriveCard(greenColor, darkColor),
            const SizedBox(height: 16),
            _buildJoystickCard(greenColor, darkColor),
            const SizedBox(height: 16),
            _buildSavePositionCard(greenColor),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveStreamCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.videocam_outlined, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Live Stream',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
              ),
              const Spacer(),
              _buildLiveBadge(),
              const SizedBox(width: 8),
              const Icon(Icons.fullscreen, color: Colors.grey, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                'assets/images/liveStream.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.circle, color: Color(0xFF4CAF50), size: 8),
          SizedBox(width: 6),
          Text(
            'LIVE',
            style: TextStyle(
                color: Color(0xFF4CAF50),
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAutodriveCard(Color greenColor, Color darkColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(color: greenColor.withOpacity(0.2), width: 1.5),
            ),
            child: Icon(Icons.sports_esports_outlined,
                color: greenColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Autodrive',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: darkColor),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Enable autonomous navigation',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            children: [
              CupertinoSwitch(
                value: isAutodriveOn,
                activeColor: greenColor,
                onChanged: (value) {
                  setState(() {
                    isAutodriveOn = value;
                  });
                },
              ),
              const SizedBox(height: 4),
              Text(
                isAutodriveOn ? 'ON' : 'OFF',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isAutodriveOn ? greenColor : Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJoystickCard(Color greenColor, Color darkColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: greenColor.withOpacity(0.2), width: 1.5),
                ),
                child:
                    Icon(Icons.gamepad_outlined, color: greenColor, size: 20),
              ),
              const SizedBox(width: 16),
              Text(
                'Joystick Control',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: darkColor),
              ),
              const Spacer(),
              const Icon(Icons.info_outline, color: Colors.grey, size: 20),
            ],
          ),
          const SizedBox(height: 24),
          if (isAutodriveOn)
            _buildLockedJoystick(greenColor)
          else
            _buildActiveJoystick(greenColor),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildLockedJoystick(Color greenColor) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade100,
                border: Border.all(
                    color: Colors.grey.shade200, style: BorderStyle.solid),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200, width: 2),
              ),
              child:
                  const Icon(Icons.lock_outline, color: Colors.grey, size: 36),
            ),
            const Positioned(
                top: 15,
                child: Icon(Icons.keyboard_arrow_up,
                    color: Colors.grey, size: 20)),
            const Positioned(
                bottom: 15,
                child: Icon(Icons.keyboard_arrow_down,
                    color: Colors.grey, size: 20)),
            const Positioned(
                left: 15,
                child: Icon(Icons.keyboard_arrow_left,
                    color: Colors.grey, size: 20)),
            const Positioned(
                right: 15,
                child: Icon(Icons.keyboard_arrow_right,
                    color: Colors.grey, size: 20)),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Manual control locked',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildActiveJoystick(Color greenColor) {
    return Joystick(
      mode: JoystickMode.all,
      base: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade100, width: 2),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: 15,
                child: Icon(Icons.keyboard_arrow_up,
                    color: Colors.grey.shade400, size: 24)),
            Positioned(
                bottom: 15,
                child: Icon(Icons.keyboard_arrow_down,
                    color: Colors.grey.shade400, size: 24)),
            Positioned(
                left: 15,
                child: Icon(Icons.keyboard_arrow_left,
                    color: Colors.grey.shade400, size: 24)),
            Positioned(
                right: 15,
                child: Icon(Icons.keyboard_arrow_right,
                    color: Colors.grey.shade400, size: 24)),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
      stick: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: greenColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: greenColor.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1,
            )
          ],
        ),
      ),
      listener: (details) {},
      onStickDragEnd: () {
        debugPrint('Manual control ended');
      },
    );
  }

  Widget _buildSavePositionCard(Color greenColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.bookmark_border_outlined,
                color: greenColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Save Joystick Position',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1E293B)),
                ),
                SizedBox(height: 2),
                Text(
                  'Save current joystick position as default',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              debugPrint('Saved Joystick Position');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: greenColor,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'SAVE',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
