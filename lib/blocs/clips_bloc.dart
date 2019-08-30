import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/mixins/clip_transformer.dart';
import 'package:swat_nation/models/clip_model.dart';

/// BLoC that contains logic to manage video clips.
class ClipsBloc extends BaseBloc with ClipTransformer {
  final BehaviorSubject<ClipModel> _randomClipSubject = BehaviorSubject<ClipModel>();

  final Firestore _firestore = Firestore.instance;
  final String clipsCollection = 'clips';

  Stream<ClipModel> get randomClipStream => _randomClipSubject.stream;
  ClipModel get randomClip => _randomClipSubject.value;
  
  Stream<List<ClipModel>> get allClips => _firestore
    .collection(clipsCollection)
    .snapshots()
    .transform(transformClips);

  Stream<List<ClipModel>> allClipsForUser(String uid) {
    return _firestore
      .collection(clipsCollection)
      .where('author', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .transform(transformClips);
  }

  Future<ClipModel> clipByUid(String uid) async {
    final QuerySnapshot snapshot = await _firestore
      .collection(clipsCollection)
      .where('uid', isEqualTo: uid)
      .getDocuments();

    final List<DocumentSnapshot> docs = snapshot.documents;
    return docs.isNotEmpty
      ? ClipModel.fromSnapshot(docs.first)
      : null;
  }

  Future<DocumentReference> create(ClipModel model) {
    return _firestore
      .collection(clipsCollection)
      .add(model.toMap());
  }

  Future<void> remove(ClipModel model) async {
    return _firestore
      .collection(clipsCollection)
      .document(model.uid)
      .delete();
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
        onError: (Object error) {
          _firestore
            .collection(clipsCollection)
            .where('random', isLessThanOrEqualTo: seed)
            .orderBy('random', descending: true)
            .limit(1)
            .snapshots()
            .transform(transformRandomClip)
            .listen(
              (ClipModel data) {
                _randomClipSubject.add(data);
              },
              onError: (Object error) {
                _randomClipSubject.addError('There are no clips to choose from');
              }
            );
        }
      );
  }

  Future<void> reseed(ClipModel model) {
    if (Random().nextInt(kReseedValue) == 0) {
      final Random random = Random(DateTime.now().millisecondsSinceEpoch);
      
      final DocumentReference ref = _firestore
        .collection(clipsCollection)
        .document(model.uid);
      
      return ref.setData(
        <String, dynamic>{
          'random': random.nextInt(kMaxRandomValue),
        },
        merge: true,
      );
    }

    return null;
  }

  @override
  void dispose() {
    print('ClipsBloc disposed');
    _randomClipSubject.close();
  }
}
