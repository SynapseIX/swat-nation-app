import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/mixins/clip_transformer.dart';
import 'package:swat_nation/models/clip_model.dart';

/// BLoC that contains logic to manage video clips.
class ClipsBloc extends BaseBloc with ClipTransformer {
  final BehaviorSubject<ClipModel> _randomClipSubject = BehaviorSubject<ClipModel>();

  final Firestore _firestore = Firestore.instance;
  final String clipsCollection = 'clips';

  Stream<ClipModel> get randomClipStream => _randomClipSubject.stream;

  Stream<List<ClipModel>> get allClips => _firestore
    .collection(clipsCollection)
    .snapshots()
    .transform(transformClips);

  Stream<List<ClipModel>> allClipsForUser(String uid) {
    return _firestore
      .collection(clipsCollection)
      .where('author', isEqualTo: uid)
      .snapshots()
      .transform(transformClips);
  }

  Future<DocumentReference> create(ClipModel model) {
    return _firestore
      .collection(clipsCollection)
      .add(model.toMap());
  }

  void fetchRandomClip(int seed) {
    _firestore
      .collection(clipsCollection)
      .where('random', isGreaterThanOrEqualTo: seed)
      .orderBy('random')
      .limit(1)
      .snapshots()
      .transform(transformRandomClip)
      .listen(
        (ClipModel data) {
          _randomClipSubject.add(data);
        },
        onError: (String error) {
          _firestore
            .collection(clipsCollection)
            .where('random', isLessThanOrEqualTo: seed)
            .orderBy('random')
            .limit(1)
            .snapshots()
            .transform(transformRandomClip)
            .listen(
              (ClipModel data) {
                _randomClipSubject.add(data);
              },
            );
        }
      );
  }

  @override
  void dispose() {
    print('ClipsBloc disposed');
    _randomClipSubject.close();
  }
}
