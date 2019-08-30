import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/mixins/about_transfromer.dart';
import 'package:swat_nation/models/about_model.dart';

class AboutBloc extends BaseBloc with AboutTransformer {
  final String collection = 'about';
  final String path = 'eKW6bxm4WwZunbeOFm4g';

  final Firestore _firestore = Firestore.instance;

  Stream<AboutModel> get infoStream => _firestore
    .collection(collection)
    .document(path)
    .snapshots()
    .transform(transformAbout);

  @override
  void dispose() {
    print('AboutBloc disposed');
  }
}
