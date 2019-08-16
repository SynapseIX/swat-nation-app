import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/auth_bloc.dart';
import 'package:swat_nation/blocs/edit_profile_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/dialogs/dialog_helper.dart';
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
  final Map<String, dynamic> data = <String, dynamic>{};

  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController gamertagController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final TextEditingController mixerController = TextEditingController();
  final TextEditingController twitchController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  final FocusNode displayNameNode = FocusNode();
  final FocusNode gamertagNode = FocusNode();
  final FocusNode twitterNode = FocusNode();
  final FocusNode mixerNode = FocusNode();
  final FocusNode twitchNode = FocusNode();
  final FocusNode bioNode = FocusNode();

  EditProfileBloc bloc;

  @override
  void initState() {
    super.initState();
    
    bloc = EditProfileBloc();
    bloc.onChangeDisplayName(widget.model.displayName);
    bloc.onChangePrivacy(widget.model.private);

    displayNameController.text = widget.model.displayName;
    gamertagController.text = widget.model.gamertag;
    twitterController.text = widget.model.twitter;
    mixerController.text = widget.model.mixer;
    twitchController.text = widget.model.twitch;
    bioController.text = widget.model.bio;
  }

  @override
  void dispose() {
    displayNameController.dispose();
    gamertagController.dispose();
    twitterController.dispose();
    mixerController.dispose();
    twitchController.dispose();
    bioController.dispose();

    displayNameNode.dispose();
    gamertagNode.dispose();
    twitterNode.dispose();
    mixerNode.dispose();
    twitchNode.dispose();
    bioNode.dispose();

    bloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit My Profile'),
      ),
      body: GestureDetector(
        onTap: _dismissKeyboard,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              // Profile picture and header
              Container(
                height: 200.0,
                child: Stack(
                  children: <Widget>[
                    // Header background
                    CachedNetworkImage(
                      imageUrl: widget.model.headerUrl ?? kDefaultProfileHeader,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 300),
                    ),

                    // Overlay
                    Container(color: Colors.black45),

                    // Edit header icon
                    Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: IconButton(
                        icon: Icon(
                          MdiIcons.image,
                          color: Colors.white,
                        ),
                        onPressed: () => print('TODO: show image picker'),
                      ),
                    ),

                    // Profile picture
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => print('TODO: show image picker'),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF333333),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 3.0,
                                  color: Colors.white,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: CachedNetworkImage(
                                  imageUrl: widget.model.photoUrl,
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.cover,
                                  fadeInDuration: const Duration(milliseconds: 300),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Change Picture',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: const Offset(1.0, 1.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ),
                  ],
                ),
              ),

              // Display name
              StreamBuilder<String>(
                stream: bloc.displayNameStream,
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return TextField(
                    controller: displayNameController,
                    focusNode: displayNameNode,
                    maxLength: kDisplayNameMaxChararcters,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      icon: const Icon(MdiIcons.account),
                      labelText: 'Username',
                      hintText: 'Username',
                      errorText: snapshot.error,
                    ),
                    onChanged: bloc.onChangeDisplayName,
                    onSubmitted: (String text) {
                      displayNameNode.nextFocus();
                    },
                  );
                },
              ),

              // Gamertag
              TextField(
                controller: gamertagController,
                focusNode: gamertagNode,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  icon: Icon(MdiIcons.xbox),
                  labelText: 'Gamertag',
                  hintText: 'Gamertag',
                ),
                onSubmitted: (String text) {
                  gamertagNode.nextFocus();
                },
              ),

              // Twitter
              TextField(
                controller: twitterController,
                focusNode: twitterNode,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  icon: Icon(MdiIcons.twitter),
                  labelText: 'Twitter',
                  hintText: 'Twitter',
                ),
                onSubmitted: (String text) {
                  twitterNode.nextFocus();
                },
              ),

              // Mixer
              TextField(
                controller: mixerController,
                focusNode: mixerNode,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  icon: Icon(MdiIcons.mixer),
                  labelText: 'Mixer',
                  hintText: 'Mixer',
                ),
                onSubmitted: (String text) {
                  mixerNode.nextFocus();
                },
              ),

              // Twitch
              TextField(
                controller: twitchController,
                focusNode: twitchNode,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  icon: Icon(MdiIcons.twitch),
                  labelText: 'Twitch',
                  hintText: 'Twitch',
                ),
                onSubmitted: (String text) {
                  twitchNode.nextFocus();
                },
              ),

              // Bio
              TextField(
                controller: bioController,
                focusNode: bioNode,
                maxLength: kMaxBioLength,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  icon: Icon(MdiIcons.bio),
                  labelText: 'Biography',
                  hintText: 'Biography',
                ),
                onSubmitted: (String text) {
                  _dismissKeyboard();
                },
              ),

              const SizedBox(height: 16.0),

              // Privacy
              Row(
                children: <Widget>[
                  Icon(
                    MdiIcons.lock,
                    color: Theme.of(context).hintColor,
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    'Private',
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 15.0,
                    ),
                  ),
                  Spacer(),
                  StreamBuilder<bool>(
                    stream: bloc.privacyStream,
                    initialData: false,
                    builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      return Switch(
                        value: snapshot.data,
                        onChanged: bloc.onChangePrivacy,
                        activeColor: Theme.of(context).primaryColor,
                      );
                    },
                  ),
                ],
              ),

              // Save button
              Container(
                margin: const EdgeInsets.only(top: 16.0),
                width: double.infinity,
                height: 40.0,
                child: StreamBuilder<String>(
                  stream: bloc.displayNameStream,
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return RaisedButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: snapshot.hasData 
                        ? () => _saveChanges(context)
                        : null,
                      child: const Text('Save Profile'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveChanges(BuildContext context) async {
    DialogHelper.instance().showWaitingDialog(
      context: context,
      title: 'Saving changes...'
    );

    final UserBloc userBloc = UserBloc();
    final UserModel model = widget.model;

    final FirebaseUser firebaseUser = await AuthBloc.instance().currentUser;
    final UserUpdateInfo info = UserUpdateInfo();

    // Display name
    final String displayName = displayNameController.text;
    model.displayName = displayName;
    info.displayName = displayName;
    data['displayName'] = displayName;

    // Gamertag
    final String gamertag = gamertagController.text.isNotEmpty
      ? gamertagController.text
      : null;
    model.gamertag = gamertag;
    data['gamertag'] = gamertag;

    // Twitter
    final String twitter = twitterController.text.isNotEmpty
      ? twitterController.text
      : null;
    model.twitter = twitter;
    data['twitter'] = twitter;

    // Mixer
    final String mixer = mixerController.text.isNotEmpty
      ? mixerController.text
      : null;
    model.mixer = mixer;
    data['mixer'] = mixer;

    // Twitch
    final String twitch = twitchController.text.isNotEmpty
      ? twitchController.text
      : null;
    model.twitch = twitch;
    data['twitch'] = twitch;

    // Twitch
    final String bio = bioController.text.isNotEmpty
      ? bioController.text
      : null;
    model.bio = bio;
    data['bio'] = bio;

    // Privacy
    model.private = bloc.privacyValue;
    data['private'] = bloc.privacyValue;

    await firebaseUser.updateProfile(info);
    await firebaseUser.reload();

    // TODO(itsprof): validate
    data['photoUrl'] = model.photoUrl;

    await userBloc.update(
      uid: model.uid,
      data: data,
    );

    Navigator.of(context)
      ..pop()
      ..pop(model);
  }

  void _dismissKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
