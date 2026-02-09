import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with SingleTickerProviderStateMixin {
  CameraController? _controller;
  XFile? _capturedImage;
  bool _isFlashOn = false;

  late AnimationController _animationController;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) _animationController.reverse();
        else if (status == AnimationStatus.dismissed) _animationController.forward();
      });

    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _controller = CameraController(cameras[0], ResolutionPreset.high);
      await _controller!.initialize();
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _animationController.dispose(); 
    super.dispose();
  }

  void _startFakeScan() {
    setState(() => _isScanning = true);
    _animationController.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
          _animationController.stop();
          _animationController.reset();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Scanning Complete!')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: _capturedImage == null
                  ? (_controller != null && _controller!.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: CameraPreview(_controller!),
                        )
                      : const Center(child: CircularProgressIndicator(color: Colors.white)))
                  : Image.file(File(_capturedImage!.path), fit: BoxFit.contain),
            ),

            if (_isScanning) _buildScannerAnimation(),

            if (_capturedImage == null)
              Positioned(
                top: 20, right: 20,
                child: FloatingActionButton.small(
                  heroTag: 'flashBtn',
                  backgroundColor: Colors.black.withOpacity(0.5),
                  child: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off, color: _isFlashOn ? Colors.yellow : Colors.white),
                  onPressed: () {
                    setState(() {
                      _isFlashOn = !_isFlashOn;
                      _controller?.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
                    });
                  },
                ),
              ),

            if (_capturedImage == null) _buildBottomButtons(),
            if (_capturedImage != null && !_isScanning) _buildPreviewActions(),
            
            if (_isScanning)
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                  child: const Text("Scanning...", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerAnimation() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: _animationController.value * MediaQuery.of(context).size.height * 0.7,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.8),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ],
                  gradient: const LinearGradient(
                    colors: [Colors.transparent, Colors.greenAccent, Colors.transparent],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildGradientButton(
              text: 'Take Photo',
              onTap: () async {
                if (_controller != null && _controller!.value.isInitialized) {
                  final img = await _controller!.takePicture();
                  setState(() => _capturedImage = img);
                }
              },
              gradientColors: [Colors.green.shade400, const Color(0xFF2E7D32)],
              shadowColor: Colors.green.shade900.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            _buildGradientButton(
              text: 'Upload Photo',
              onTap: () async {
                final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (picked != null) setState(() => _capturedImage = picked);
              },
              gradientColors: [const Color(0xFF546E7A), const Color(0xFF263238)],
              shadowColor: Colors.black.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientButton({required String text, required VoidCallback onTap, required List<Color> gradientColors, required Color shadowColor}) {
    return Container(
      height: 60, width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: shadowColor, offset: const Offset(0, 4), blurRadius: 10.0)],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Center(child: Text(text, style: GoogleFonts.poppins(fontSize: 19, color: Colors.white, fontWeight: FontWeight.w600))),
        ),
      ),
    );
  }

  Widget _buildPreviewActions() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCircularActionButton(
              icon: Icons.close_rounded,
              color: Colors.redAccent,
              onTap: () => setState(() => _capturedImage = null),
            ),
            _buildCircularActionButton(
              icon: Icons.check_rounded,
              color: Colors.greenAccent,
              onTap: _startFakeScan,
              isPrimary: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularActionButton({required IconData icon, required Color color, required VoidCallback onTap, bool isPrimary = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isPrimary ? 18 : 15),
        decoration: BoxDecoration(
          color: isPrimary ? color.withOpacity(0.2) : Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: Icon(icon, color: color, size: isPrimary ? 35 : 30),
      ),
    );
  }
}