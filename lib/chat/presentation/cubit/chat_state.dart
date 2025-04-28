import '../../data/models/user_model.dart';
import '../../data/models/message_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class UsersLoaded extends ChatState {
  final List<UserModel> users;
  UsersLoaded(this.users);
}

class MessagesLoaded extends ChatState {
  final List<MessageModel> messages;
  MessagesLoaded(this.messages);
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}
