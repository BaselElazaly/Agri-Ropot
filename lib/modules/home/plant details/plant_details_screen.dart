import 'package:agre_lens_app/models/last_five_detetct_model.dart';
import 'package:agre_lens_app/modules/Ai_Chat/ai_chat_screen.dart';
import 'package:agre_lens_app/shared/cubit/cubit.dart';
import 'package:agre_lens_app/shared/cubit/states.dart';
import 'package:agre_lens_app/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
// استيراد المكتبة الجديدة
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PlantDetailsScreen extends StatefulWidget {
  // المستقبل الآن هو الموديل بالكامل الذي يحتوي على الصورة وقائمة التشخيصات
  final DetectionModel model;
  final String? date; // التاريخ غالباً بيجي موحد للفحص ككل

  const PlantDetailsScreen({
    Key? key,
    required this.model,
    this.date,
  }) : super(key: key);

  @override
  State<PlantDetailsScreen> createState() => _PlantDetailsScreenState();
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen> {
  // كنترولر للتحكم في السلايدر ومعرفة الصفحة الحالية
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose(); // تنظيف الذاكرة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // التأكد من وجود بيانات تشخيص، إذا لم يوجد نعتبرها صورة صحية افتراضياً أو نتعامل معها
    bool hasDetections =
        widget.model.detections != null && widget.model.detections!.isNotEmpty;
    int itemCount = hasDetections ? widget.model.detections!.length : 1;

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Transform.scale(
              scale: 0.6,
              child: SvgPicture.asset(
                'assets/icons/ep_back.svg',
                color: Colors.black,
              ),
            ),
          ),
        ),
        title: const Text('Plant Analysis',
            style: TextStyle(
                fontFamily: 'Roboto',
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
        // إضافة أيقونة القائمة الجانبية كما في الصورة الجديدة
        
      ),
      body: Column(
        children: [
          // 1. الجزء الثابت: الصورة والتاريخ
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الصورة الكبيرة (ثابتة)
                FadeInDown(
                  child: _buildStaticImage(),
                ),
                const SizedBox(height: 15),
                // التاريخ (ثابت)
                FadeInLeft(
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month_outlined,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        'Analyzed on: ${formatFullDateTime(widget.date)}',
                        style: const TextStyle(
                            fontFamily: 'Roboto',
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. الجزء المتحرك (Slider) باستخدام PageView
          Expanded(
            child: hasDetections
                ? PageView.builder(
                    controller: _pageController,
                    itemCount: itemCount,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      // جلب بيانات التشخيص الحالي بناءً على الـ index
                      final detection = widget.model.detections![index];
                      return FadeIn(
                        child: SingleChildScrollView(
                          // للسماح بالتمرير الرأسي داخل كل صفحة لو المحتوى كتير
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: _buildSwipeableContent(detection),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                        "No objects detected")), // حالة عدم وجود بيانات
          ),

          // 3. مؤشر الصفحات (Dots Indicator) - ثابت في الأسفل
          if (hasDetections && itemCount > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 10),
              child: FadeInUp(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: itemCount,
                  effect: ExpandingDotsEffect(
                    activeDotColor: ColorManager
                        .greenColor, // اللون الأخضر من ملف الألوان بتاعك
                    dotColor: Colors.grey.shade300,
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor:
                        3, // تأثير التمدد للنقطة النشطة كما في الصورة
                    spacing: 6,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 10), // مسافة إضافية للـ Bottom Navigation Bar
        ],
      ),
      // زر الشات العائم (كما في الصورة الجديدة)
     // لاحظ هنا إحنا استخدمنا GestureDetector بدل FloatingActionButton
      floatingActionButton: GestureDetector(
        onTap: () {
          // جلب الـ index الحالي للـ PageView لمعرفة النبات المعروض حالياً
          int currentIndex = _pageController.hasClients ? (_pageController.page?.round() ?? 0) : 0;
          
          // التأكد من وجود بيانات قبل إرسالها
          if (widget.model.detections != null && widget.model.detections!.isNotEmpty) {
            final currentDetection = widget.model.detections![currentIndex];
            String label = currentDetection.label ?? "Unknown Plant";
            double confidence = currentDetection.confidence ?? 0.0;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AiChatScreen(
                  plantLabel: label,
                  confidence: confidence,
                ),
              ),
            );
          }
        },
        child: Container(
          width: 80,
          height: 80,
          // هنا السحر عشان نعمل Elevation بسيط من غير ما نبوظ الصورة الشفافة
          decoration: BoxDecoration(
            shape: BoxShape.circle, // عشان الشادو يتبع شكل الأيقونة الدائري
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06), // لون ظل أسود خفيف جداً
                blurRadius: 20, // مدى نعومة الظل (كل ما زاد بقى أنعم)
                spreadRadius: 0, // مدى انتشار الظل
                offset: const Offset(0, 5), // إزاحة الظل لتحت شوية (بيعمل إحساس البروز)
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/Ai_Confidence.png',
            height: 80,
            width: 80,
            fit: BoxFit.contain, // أفضل استخدام Contain عشان نحافظ على الأبعاد
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // ويدجت لبناء الصورة الثابتة مع زر التكبير
  Widget _buildStaticImage() {
    return GestureDetector(
      onTap: () {
        if (widget.model.imageUrl != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlantImageZoomScreen(
                imageUrl: widget.model.imageUrl!,
                label: "Plant Image",
              ),
            ),
          );
        }
      },
      child: Hero(
        tag: 'plant_image_hero',
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 220, // زيادة الطول قليلاً ليناسب الصورة الجديدة
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: widget.model.imageUrl != null
                    ? Image.network(
                        widget.model.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                                child: Icon(Icons.broken_image,
                                    size: 50, color: Colors.grey)),
                      )
                    : const Center(child: Icon(Icons.image_not_supported)),
              ),
            ),
            // زر الـ Scan الأخضر الصغير على الصورة
            Positioned(
              bottom: 15,
              right: 15,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorManager.greenColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.zoom_out_map_rounded,
                    color: Colors.white, size: 20),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ويدجت لبناء المحتوى القابل للسحب (اسم المرض، الكروت) لكل عنصر تشخيص
  Widget _buildSwipeableContent(DetectionItem detection) {
    // تحديد هل النبات صحي بناءً على الليبل (أو الكونفدنس لو حابب)
    bool isHealthy =
        detection.label?.toLowerCase().contains('healthy') ?? false;
    Color healthColor = isHealthy ? const Color(0xFF2D8A4E) : Colors.redAccent;

    // تحويل قائمة الريكومنديشن لنص مفصول بنقاط (Bullets)
    String recommendationsText = (detection.recommendation != null &&
            detection.recommendation!.isNotEmpty)
        ? detection.recommendation!.map((e) => '• $e').join('\n')
        : 'No specific recommendations available.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        // 1. اسم النبتة والتشخيص مع علامة التوثيق
        Row(
          children: [
            Expanded(
              child: Text(
                detection.label ?? "Unknown Condition",
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
              ),
            ),
            
          ],
        ),
        const SizedBox(height: 20),

        // 2. كارت نسبة التأكيد (AI Confidence) - تم تحديث الشكل ليطابق الصورة
        _buildConfidenceCard(
          confValue: detection.confidence ?? 0,
          healthColor: healthColor,
        ),
        const SizedBox(height: 18),

        // 3. كارت الـ Status
        _buildSection(
          title: 'Status',
          // استخدام الـ status القادم من الـ API
          content: (detection.status != null && detection.status!.isNotEmpty)
              ? detection.status!
              : (isHealthy
                  ? 'Your plant is in excellent condition.'
                  : 'Issue detected.'),
          icon: "assets/images/info.png", // تأكد من وجود الصور في الـ assets
          bgColor: const Color(0xFFF3F9F5),
          accentColor: const Color(0xFF2D8A4E),
          sideImage: "assets/images/plant.png", // صورة الأصيص
        ),
        const SizedBox(height: 18),

        // 4. كارت الـ Recommendations
        _buildSectionR(
          title: 'Recommendations',
          content: recommendationsText,
          icon: "assets/images/bulb.png",
          bgColor: const Color(0xFFFFF9ED),
          accentColor: const Color(0xFFDCA529),
          sideImage: "assets/images/watering_can.png", // صورة الرشاش
        ),
        const SizedBox(height: 30), // مسافة نهائية داخل السلايدر
      ],
    );
  }

  // --- الهيلبر ويدجت (تم تحديثها لتطابق الديزاين الجديد) ---

  // كارت الـ Confidence الجديد (شكل مدمج مع بروجرس بار ورسالة توضيحية)
  Widget _buildConfidenceCard({
    required double confValue,
    required Color healthColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100), // إطار خفيف جداً
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // أيقونة AI
              Image.asset(
                'assets/images/Ai_Confidence.png',
                width: 56,
              ),
              const Text(
                'AI Confidence',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
              ),
              // أيقونة معلومات صغيرة
              const SizedBox(width: 5),
              Icon(Icons.info_outline, size: 16, color: Colors.grey.shade400),
              const Spacer(),
              // النسبة المئوية
              Text(
                '${confValue.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color:
                      const Color(0xFF2E7D32), // اللون الأخضر الغامق في الصورة
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // البروجرس بار
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: confValue / 100,
              backgroundColor: Colors.grey.shade100,
              color: const Color(0xFF4CAF50), // لون أخضر فاتح للبار
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 10),
          // نص توضيحي صغير تحت البار (كما في الصورة)
          Text(
            "This is the confidence score of the AI model for this result.",
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 11,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }

  // ويدجت موحدة للـ Status والـ Recommendations (تم دمج _buildSection و _buildSection2)
  Widget _buildSection({
    required String title,
    required String content,
    required String icon,
    required Color bgColor,
    required Color accentColor,
    required String sideImage,
  }) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          // حذف البوردر الخارجي ليكون أنظف مثل الصورة الجديدة
        ),
        child: Row(
          // 1. الـ Row الخارجي معمول Center عشان يخلي الصورة الجانبية في النص عمودياً
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 2. حطينا الأيقونة والنص جوه Row داخلي واخد Start عشان يبدأوا من فوق
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الأيقونة الدائرية
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white, // خلفية بيضاء للأيقونة
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      icon,
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // النص
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          content,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 13,
                            color: Colors.black87,
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // 3. الصورة الجانبية بقت مباشرة جوه الـ Row الخارجي المتسنتر
            // فبالتالي هتيجي في النص بالظبط مهما كان طول النص اللي جنبها
            Image.asset(sideImage, width: 50, height: 50, fit: BoxFit.contain),
          ],
        ));
  }

  Widget _buildSectionR({
    required String title,
    required String content,
    required String icon,
    required Color bgColor,
    required Color accentColor,
    required String sideImage,
  }) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          // حذف البوردر الخارجي ليكون أنظف مثل الصورة الجديدة
        ),
        child: Row(
          // 1. الـ Row الخارجي معمول Center عشان يخلي الصورة الجانبية في النص عمودياً
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 2. حطينا الأيقونة والنص جوه Row داخلي واخد Start عشان يبدأوا من فوق
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الأيقونة الدائرية
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white, // خلفية بيضاء للأيقونة
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      icon,
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // النص
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          content,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 13,
                            color: Colors.black87,
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // 3. الصورة الجانبية بقت مباشرة جوه الـ Row الخارجي المتسنتر
            // فبالتالي هتيجي في النص بالظبط مهما كان طول النص اللي جنبها
            Image.asset(sideImage, width: 50, height: 50, fit: BoxFit.contain),
          ],
        ));
  }

  String formatFullDateTime(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return 'No Date';
    try {
      DateTime dateTime = DateTime.parse(rawDate);
      return DateFormat('yyyy-MM-dd  |  hh:mm a').format(dateTime);
    } catch (e) {
      return rawDate;
    }
  }
}

// سكرينة الزوم (تبقى كما هي تقريباً مع تحديث بسيط للأيقونة)
class PlantImageZoomScreen extends StatelessWidget {
  final String imageUrl;
  final String label;

  const PlantImageZoomScreen({
    Key? key,
    required this.imageUrl,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white), // أيقونة إغلاق
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Hero(
          tag: 'plant_image_hero',
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const CircularProgressIndicator(color: Colors.white);
              },
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, color: Colors.white, size: 50),
            ),
          ),
        ),
      ),
    );
  }
}
