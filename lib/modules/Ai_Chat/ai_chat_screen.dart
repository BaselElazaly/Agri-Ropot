import 'package:agre_lens_app/modules/Ai_Chat/cubit/cubit.dart';
import 'package:agre_lens_app/modules/Ai_Chat/cubit/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/svg.dart';

// تأكد من استدعاء الـ Cubit والـ States الخاصة بك هنا
// import 'chat_cubit.dart';
// import 'chat_states.dart';
// import 'package:agre_lens_app/shared/styles/colors.dart'; 

class AiChatScreen extends StatelessWidget {
  final String plantLabel;
  final double confidence;

  const AiChatScreen({
    Key? key,
    required this.plantLabel,
    required this.confidence,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // تهيئة الـ Cubit وإضافة الرسالة الثابتة أول ما السكرينة تفتح
      create: (context) => ChatCubit()..initChat(plantLabel, confidence),
      child: const _AiChatView(),
    );
  }
}

class _AiChatView extends StatefulWidget {
  const _AiChatView({Key? key}) : super(key: key);

  @override
  State<_AiChatView> createState() => _AiChatViewState();
}

class _AiChatViewState extends State<_AiChatView> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // قائمة الاقتراحات الثابتة
  final List<String> suggestions = [
    "Best soil? 🌱",
    "Signs of disease?",
    "Sunlight needs ☀️",
    "When to prune? ✂️"
  ];

  // دالة للنزول لآخر الشات تلقائياً
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAF6),
      appBar: AppBar(
        // ... نفس كود الـ AppBar بدون تغيير
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
        title: Column(
          children: [
            Text(
              'ASK YOUR PLANT ASSISTANT',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF3B7254).withOpacity(0.8),
              ),
            ),
            // const SizedBox(height: 4),
            // Container(
            //   width: 40,
            //   height: 2,
            //   color: const Color(0xFF3B7254).withOpacity(0.5),
            // )
          ],
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ChatCubit, ChatStates>(
        listener: (context, state) {
          if (state is ChatMessageSendingState || state is ChatMessageSuccessState) {
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          var cubit = ChatCubit.get(context);

          return Column(
            children: [
              // 1. منطقة عرض الرسائل
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: cubit.messages.length + (state is ChatMessageSendingState ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == cubit.messages.length && state is ChatMessageSendingState) {
                      return _buildTypingIndicator();
                    }
                    final message = cubit.messages[index];
                    return FadeInUp(
                      duration: const Duration(milliseconds: 300),
                      child: _buildMessageBubble(message),
                    );
                  },
                ),
              ),

              // 2. منطقة الاقتراحات (ثابتة وقابلة للتمرير الأفقي)
              _buildSuggestionsArea(cubit),

              // 3. منطقة إدخال النص
              _buildInputArea(context, cubit),
            ],
          );
        },
      ),
    );
  }

  // ويدجت جديدة مخصصة للاقتراحات عشان تفضل ثابتة
 // ويدجت الاقتراحات الثابتة (شكل شبكة 2x2 زي الصورة)
  Widget _buildSuggestionsArea(ChatCubit cubit) {
    return Container(
      width: double.infinity, // عشان ياخد العرض كله والـ Wrap يسنترهم
      color: const Color(0xFFF6FAF6), // نفس لون الخلفية
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        alignment: WrapAlignment.center, // توسيط الاقتراحات في الشاشة
        spacing: 12, // المسافة الأفقية بين كل زرار والتاني
        runSpacing: 12, // المسافة الرأسية بين الصف الأول والتاني
        children: suggestions.map((suggestion) {
          return GestureDetector(
            onTap: () {
              cubit.sendMessage(suggestion);
            },
            child: Container(
              // حطينا mainAxisSize.min جوا الـ Row لو هنستخدم أيقونات، أو نسيبها نص بس
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3EA),
                borderRadius: BorderRadius.circular(20),
                // إطار خفيف جداً لو حابب تبرزه أكتر
                border: Border.all(color: Colors.transparent, width: 0), 
              ),
              child: Text(
                suggestion,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  color: Color(0xFF2D8A4E), // اللون الأخضر الغامق للنص
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  // ويدجت إدخال النص بعد تعديل الألوان
  Widget _buildInputArea(BuildContext context, ChatCubit cubit) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFF6FAF6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3EA),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFFCDE2D2), width: 1),
              ),
              // هنا التعديل السحري للألوان
              child: Theme(
                data: Theme.of(context).copyWith(
                  textSelectionTheme: const TextSelectionThemeData(
                    cursorColor: Color(0xFF3B7254), // لون مؤشر الكتابة
                    selectionColor: Color(0xFFCDE2D2), // لون تظليل النص
                    selectionHandleColor: Color(0xFF3B7254), // لون النقطتين بتوع النسخ
                  ),
                ),
                child: TextField(
                  controller: _msgController,
                  cursorColor: const Color(0xFF3B7254), // تأكيد على لون المؤشر
                  style: const TextStyle(color: Colors.black87), // لون النص المكتوب
                  decoration: const InputDecoration(
                    hintText: "Ask about your plant...",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      cubit.sendMessage(value);
                      _msgController.clear();
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              if (_msgController.text.isNotEmpty) {
                cubit.sendMessage(_msgController.text);
                _msgController.clear();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF3B7254),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
  // ويدجت فقاعة الرسالة (Chat Bubble)
  Widget _buildMessageBubble(ChatMessage message) {
    bool isMe = message.isUser;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            // أيقونة البوت (ورقة شجر)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3EA),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.eco, color: Color(0xFF2D8A4E), size: 16),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF3B7254) : Colors.white, // ألوان مطابقة للصورة
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(5),
                  bottomRight: isMe ? const Radius.circular(5) : const Radius.circular(20),
                ),
                boxShadow: isMe
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  color: isMe ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          if (isMe) ...[
             // صورة مصغرة لليوزر لو حابب تضيفها (اختياري)
             const SizedBox(width: 8),
             const CircleAvatar(
               radius: 14,
               backgroundColor: Color(0xFF3B7254),
               child: Icon(Icons.person, color: Colors.white, size: 18),
             )
          ]
        ],
      ),
    );
  }

  // ويدجت إدخال الن
  // مؤشر الكتابة (Typing Indicator)
  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F3EA),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.eco, color: Color(0xFF2D8A4E), size: 16),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dotAnimation(0),
                const SizedBox(width: 4),
                _dotAnimation(100),
                const SizedBox(width: 4),
                _dotAnimation(200),
              ],
            ),
          ),
        ],
      ),
    );
  }

 Widget _dotAnimation(int delay) {
    return Flash( // استبدلنا FadeIn بـ Flash
      delay: Duration(milliseconds: delay),
      infinite: true, // دلوقتي هتشتغل بدون أي مشاكل
      duration: const Duration(milliseconds: 1000), // تقدر تتحكم في سرعة النبضة من هنا
      child: Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}