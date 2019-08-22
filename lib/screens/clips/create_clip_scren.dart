import 'package:flutter/material.dart';
import 'package:swat_nation/models/clip_info_model.dart';

/// Represent the creat clip screen.
class CreateClipScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateClipScreenState();
  }
}

class _CreateClipScreenState extends State<CreateClipScreen> {
  ClipInfoModel model;

  @override
  void initState() {
    super.initState();
    model = ClipInfoModel.blank();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
