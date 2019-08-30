import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/mixins/swat_art_transformer.dart';
import 'package:swat_nation/models/swat_art_model.dart';

class SwatArtBloc extends BaseBloc with SwatArtTransformer {
  final Firestore _firestore = Firestore.instance;
  final String swatIsArt = 'swat-is-art';

  Stream<List<SwatArtModel>> get latest => _firestore
    .collection(swatIsArt)
    .orderBy('latest', descending: true)
    .limit(5)
    .snapshots()
    .transform(transformArt);

  @override
  void dispose() {
    print('SwatArtBloc disposed');
  }
}
