import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/mixins/clip_transformer.dart';
import 'package:swat_nation/models/clip_model.dart';

/// BLoC that contains logic to manage video clips.
class ClipsBloc extends BaseBloc with ClipTransformer {
  final Firestore _firestore = Firestore.instance;
  final String clipsCollection = 'clips';

  Stream<List<ClipModel>> get allClips => _firestore
    .collection(clipsCollection)
    .snapshots()
    .transform(transformClips);

  Stream<List<ClipModel>> allClipsForUser(String uid) {
    return _firestore
      .collection(clipsCollection)
      .where('userId', isEqualTo: uid)
      .snapshots()
      .transform(transformClips);
  }

  Stream<ClipModel> get randomClip => _firestore
      .collection(clipsCollection)
      .where('random', isGreaterThanOrEqualTo: 0)
      .orderBy('random')
      .limit(1)
      .snapshots()
      .transform(transformRandomClip);

  Future<DocumentReference> create(ClipModel model) {
    return _firestore
      .collection(clipsCollection)
      .add(model.toMap());
  }

  @override
  void dispose() {
    print('ClipsBloc disposed');
  }
}
