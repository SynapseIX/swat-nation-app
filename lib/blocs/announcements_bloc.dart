import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/mixins/announcements_transformer.dart';
import 'package:swat_nation/models/announcement_model.dart';

class AnnouncementsBloc extends BaseBloc with AnnouncementsTransformer {
  final Firestore _firestore = Firestore.instance;

  Stream<List<AnnouncementModel>> get latest => _firestore
    .collection('announcements')
    .limit(5)
    .snapshots()
    .transform(transformAnnouncements);

  @override
  void dispose() {
    print('AnnouncementsBloc disposed');
  }
}
