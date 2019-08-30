import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swat_nation/base/base_model.dart';

/// Represents a SWAT Nation team member.
class TeamMemberModel extends BaseModel {
  TeamMemberModel.fromData(dynamic data) {
    handle = data['handle'];
    role = data['role'];
    bio = data['bio'];
    country = data['country'];
    birthday = data['birthday'];
    photoUrl = data['photoUrl'];
    twitter = data['twitter'];
  }

  String handle;
  String role;
  String bio;
  String country;
  Timestamp birthday;
  String photoUrl;
  String twitter;

  @override
  String toString() {
    return '''
    handle: $handle
    role: $role
    bio: $bio
    country: $country
    birthday: $birthday
    photoUrl: $photoUrl
    twitter: $twitter
    ''';
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'handle': handle,
      'role': role,
      'bio': bio,
      'country': country,
      'birthday': birthday,
      'photoUrl': photoUrl,
      'twitter': twitter,
    };
  }
}
