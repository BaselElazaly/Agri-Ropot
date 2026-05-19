import 'package:agre_lens_app/modules/Ai_Chat/cubit/state.dart';
import 'package:agre_lens_app/shared/network/local/cash_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitialState());

  static ChatCubit get(context) => BlocProvider.of(context);

  List<ChatMessage> messages = [];

  // متغير عشان نحفظ فيه اسم النبات ونستخدمه مع كل رسالة
  String currentPlantName = "";

  void initChat(String plantLabel, double confidence) {
    currentPlantName = plantLabel; // حفظ اسم النبات

    bool isHealthy = plantLabel.toLowerCase().contains('healthy');
    String conditionText = isHealthy ? "looks healthy" : "was detected";

    String initialMsg =
        "Hi! 👋 Your $plantLabel $conditionText at ${confidence.toStringAsFixed(1)}%. Ask me anything about care, watering, or diseases!";

    messages.add(ChatMessage(text: initialMsg, isUser: false));
    emit(ChatInitialState());
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 1. إضافة رسالة المستخدم للـ UI بشكلها الطبيعي (بدون السياق الخفي)
    messages.add(ChatMessage(text: text, isUser: true));
    emit(ChatMessageSendingState());
    String? token = CacheHelper.getData(key: 'token');
    try {
      // 2. تجهيز الـ Messages للـ API مع حقن "السياق الخفي" في آخر رسالة
      List<Map<String, dynamic>> apiMessages = [];

      for (int i = 0; i < messages.length; i++) {
        var m = messages[i];

        // لو دي آخر رسالة اليوزر لسه باعتها حالا، هنضيف قبلها السياق
        if (i == messages.length - 1 && m.isUser) {
          apiMessages.add({
            "role": "user",
            "content":
                "Context: I am currently asking about my '$currentPlantName' plant.\nMy question is: ${m.text}"
          });
          print(apiMessages);
        } else {
          // باقي الرسايل القديمة تتبعت زي ما هي
          apiMessages.add(
              {"role": m.isUser ? "user" : "assistant", "content": m.text});
        }
      }

      var response = await Dio().post(
        'https://finalgraduationproject.runasp.net/api/customer/Chats',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {"messages": apiMessages},
      );

      // 3. استلام الرد وإضافته
      if (response.statusCode == 200) {
        String aiReply = response.data['message'] ?? "No response from AI.";
        messages.add(ChatMessage(text: aiReply, isUser: false));
        print(aiReply);
        emit(ChatMessageSuccessState());
      } else {
        emit(ChatMessageErrorState('Failed to fetch response.'));
      }
    } catch (e) {
      messages.add(ChatMessage(
          text: "Sorry, I couldn't process that. Try again.", isUser: false));
      emit(ChatMessageErrorState(e.toString()));
    }
  }
}
