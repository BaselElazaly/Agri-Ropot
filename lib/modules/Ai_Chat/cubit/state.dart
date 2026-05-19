abstract class ChatStates {}

class ChatInitialState extends ChatStates {}

class ChatMessageSendingState extends ChatStates {}

class ChatMessageSuccessState extends ChatStates {}

class ChatMessageErrorState extends ChatStates {
  final String error;
  ChatMessageErrorState(this.error);
}