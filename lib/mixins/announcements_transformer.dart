import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swat_nation/models/announcement_model.dart';

/// Mixin with stream transformers for announcments.
class AnnouncementsTransformer {
  final StreamTransformer<QuerySnapshot, List<AnnouncementModel>> transformAnnouncements
    = StreamTransformer<QuerySnapshot, List<AnnouncementModel>>
      .fromHandlers(
        handleData: (QuerySnapshot snapshot, EventSink<List<AnnouncementModel>> sink) {
          if (snapshot.documents.isNotEmpty) {
            sink.add(
              snapshot.documents.map((DocumentSnapshot document) {
                return AnnouncementModel.fromSnapshot(document);
              }).toList(),
            );
          } else {
            sink.addError('No announcements found.');
          }
        }
      );
}
