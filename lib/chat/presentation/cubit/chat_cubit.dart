import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/message_model.dart';
import '../../data/repositories/chat_repository.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _repository;

  ChatCubit(this._repository) : super(ChatInitial());

  void loadUsers() async {
    emit(ChatLoading());
    try {
      final users = await _repository.getAllUsers();
      emit(UsersLoaded(users));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void sendMessage(MessageModel message) async {
    await _repository.sendMessage(message);
  }

  void loadMessages(String senderId, String receiverId) {
    emit(ChatLoading());
    try {
      final messagesStream = _repository.getMessages(senderId, receiverId);
      messagesStream.listen((messages) {
        emit(MessagesLoaded(messages));
      });
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
