import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swat_nation/base/base_model.dart';
import 'package:swat_nation/models/team_member_model.dart';

/// Represents the about SWAT Nation information.
class AboutModel extends BaseModel {
  AboutModel.fromSnapshot(DocumentSnapshot snapshot) {
    headerUrl = snapshot.data['headerUrl'];
    teamUrl = snapshot.data['teamUrl'];
    roadmapUrl = snapshot.data['roadmapUrl'];
    text = snapshot.data['text'];

    final List<TeamMemberModel> members = <TeamMemberModel>[];
    snapshot.data['team'].forEach((dynamic member) {
      members.add(TeamMemberModel.fromData(member));
    });
    team = members;
  }
  
  String headerUrl;
  String teamUrl;
  String roadmapUrl;
  String text;
  List<TeamMemberModel> team;

  @override
  Map<String, dynamic> toMap() => null;
}
