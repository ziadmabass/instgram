import 'package:testfirebase/chat/data/models/message_model.dart';
import 'package:testfirebase/chat/data/models/user_model.dart';

abstract class ChatRepoInterface {
  Future<List<UserModel>> fetchUsers();
  Future<void> sendMessage(MessageModel message);
  Stream<List<MessageModel>> getMessages(String senderId, String receiverId);
}
