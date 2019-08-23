import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/mixins/chat_transformer.dart';
import 'package:swat_nation/models/chat_model.dart';

/// BLoC to manage chat and chat rooms
class ChatBloc extends BaseBloc with ChatTransformer {
  static const String generalRoomCollection = 'chats/general';
  static const String proRoomCollection = 'chats/pro';

  final Firestore _firestore = Firestore.instance;

  Stream<List<ChatModel>> get generalRoomStream => _firestore
    .collection(generalRoomCollection)
    .limit(kMaxChatMessages)
    .snapshots()
    .transform(roomTransformer);

  Stream<List<ChatModel>> get proRoomStream => _firestore
    .collection(proRoomCollection)
    .limit(kMaxChatMessages)
    .snapshots()
    .transform(roomTransformer);
  
  @override
  void dispose() {
    print('ChatBloc disposed');
  }
}
