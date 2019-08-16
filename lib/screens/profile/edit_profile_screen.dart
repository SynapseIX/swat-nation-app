import 'package:flutter/material.dart';
import 'package:swat_nation/models/user_model.dart';

/// Represents the edit profile screen.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    @required this.model,
  });

  final UserModel model;
  
  @override
  State<StatefulWidget> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  UserModel user;

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
