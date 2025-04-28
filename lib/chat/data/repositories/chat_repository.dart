import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/user_model.dart';
import '../models/message_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Get Users from Firestore
   Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      List<UserModel> users = querySnapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      return users;
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }
  // Send Message to Realtime Database
  Future<void> sendMessage(MessageModel message) async {
    String chatId = getChatId(message.senderId, message.receiverId);
    await _database.ref("chats/$chatId").push().set(message.toJson());
  }

  // Fetch Messages from Realtime Database
  Stream<List<MessageModel>> getMessages(String senderId, String receiverId) {
    String chatId = getChatId(senderId, receiverId);
    return _database.ref("chats/$chatId").orderByChild("timestamp").onValue.map((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> messagesMap = event.snapshot.value as Map<dynamic, dynamic>;
        return messagesMap.values.map((msg) => MessageModel.fromJson(Map<String, dynamic>.from(msg))).toList();
      } else {
        return [];
      }
    });
  }

  // Generate Chat ID (Ensures same ID for both users)
  String getChatId(String user1, String user2) {
    return user1.hashCode <= user2.hashCode ? "$user1-$user2" : "$user2-$user1";
  }
}
