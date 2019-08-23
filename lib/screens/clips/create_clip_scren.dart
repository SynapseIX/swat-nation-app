import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/clips_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/mixins/clip_transformer.dart';
import 'package:swat_nation/models/clip_model.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/widgets/cards/clip_card.dart';
import 'package:swat_nation/widgets/dialogs/dialog_helper.dart';

/// Represent the creat clip screen.
class CreateClipScreen extends StatefulWidget {
  const CreateClipScreen({
    @required this.user,
  });

  final UserModel user;

  @override
  State<StatefulWidget> createState() {
    return _CreateClipScreenState();
  }
}

class _CreateClipScreenState extends State<CreateClipScreen> with ClipTransformer {
  final TextEditingController linkController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  final FocusNode linkNode = FocusNode();
  final FocusNode titleNode = FocusNode();

  ClipsBloc bloc;
  ClipModel model;

  @override
  void initState() {
    bloc = ClipsBloc();

    model = ClipModel.blank();
    model.createdAt = Timestamp.now();

    super.initState();
  }

  @override
  void dispose() {
    linkController.dispose();
    titleController.dispose();

    linkNode.dispose();
    titleNode.dispose();

    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Clip'),
          actions: <Widget>[
            IconButton(
              icon: Icon(MdiIcons.cloudUpload),
              onPressed: validateLink(model.link)
                ? () async {
                  DialogHelper.instance().showWaitingDialog(
                    context: context,
                    title: 'Adding clip...'
                  );

                  final Random random = Random(DateTime.now().millisecondsSinceEpoch);

                  model.random = random.nextInt(kMaxRandomValue);
                  model.author = widget.user.uid;
                  model.createdAt = Timestamp.now();
                  model.title = titleController.text.isNotEmpty
                    ? titleController.text
                    : null;

                  final DocumentReference ref = await bloc.create(model);
                  await ref.setData(
                    <String, dynamic>{
                      'uid': ref.documentID,
                    },
                    merge: true,
                  );

                  Navigator.of(context)
                    ..pop()
                    ..pop();
                }
                : null,
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            // Preview
            IgnorePointer(
              child: ClipCard(
                model: model,
                padding: const EdgeInsets.all(8.0),
              ),
            ),

            const SizedBox(height: 16.0),

            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              child: TextField(
                controller: linkController,
                focusNode: linkNode,
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  icon: Icon(MdiIcons.web),
                  labelText: 'XboxClips.com Link',
                  hintText: '$kXboxClipsHost...',
                  errorText: !validateLink(model.link)
                    ? 'Enter a valid XboxClips.com link for your clip'
                    : null,
                ),
                onChanged: (String value) {
                  setState(() {
                    model.link = value;
                  });
                },
                onSubmitted: (String value) {
                  linkNode.nextFocus();
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              child: TextField(
                controller: titleController,
                focusNode: titleNode,
                autocorrect: true,
                maxLength: 30,
                maxLines: 2,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  icon: Icon(MdiIcons.textShort),
                  labelText: 'Title',
                  hintText: 'Optional Title',
                ),
                onChanged: (String value) {
                  setState(() {
                    model.title = value;
                  });
                },
                onSubmitted: (String value) => _dismissKeyboard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _dismissKeyboard() {
    if (linkNode.hasFocus) {
      linkNode.unfocus();
    }

    if (titleNode.hasFocus) {
      titleNode.unfocus();
    }
  }
}
