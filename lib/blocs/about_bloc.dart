import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swat_nation/base/base_bloc.dart';
import 'package:swat_nation/mixins/about_transfromer.dart';
import 'package:swat_nation/models/about_model.dart';

const String _collection = 'about';
const String _path = 'eKW6bxm4WwZunbeOFm4g';

/// BLoC that contains logic to extract data for the About Us screen.
class AboutBloc extends BaseBloc with AboutTransformer {
  final Firestore _firestore = Firestore.instance;

  Stream<AboutModel> get infoStream => _firestore
    .collection(_collection)
    .document(_path)
    .snapshots()
    .transform(transformAbout);

  @override
  void dispose() {
    print('AboutBloc disposed');
  }
}
