import 'dart:io' show File, Platform;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/blocs/auth_bloc.dart';
import 'package:swat_nation/blocs/edit_profile_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/utils/device_model.dart';
import 'package:swat_nation/widgets/dialogs/dialog_helper.dart';

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

  File photoFile;
  File headerFile;

  @override
  void initState() {
    super.initState();
    
    bloc = EditProfileBloc();
    bloc.onChangeDisplayName(widget.model.displayName);
    bloc.onChangePrivacy(widget.model.private);

    displayNameController.text = bloc.displayNameValue;
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
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: CustomScrollView(
        slivers: <Widget>[
          // App bar
          SliverAppBar(
            pinned: true,
            title: const Text('Edit Profile'),
            actions: <Widget>[
              StreamBuilder<String>(
                stream: bloc.displayNameStream,
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return IconButton(
                    icon: Icon(
                      MdiIcons.contentSave,
                    ),
                    tooltip: 'Save',
                    onPressed: snapshot.hasData 
                      ? () => _saveChanges(context)
                      : null,
                  );
                },
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Container(
              height: 200.0,
              margin: const EdgeInsets.only(bottom: 8.0),
              child: Stack(
                children: <Widget>[
                  // Header background
                  _HeaderBackground(
                    headerFile: headerFile,
                    headerUrl: widget.model.headerUrl,
                  ),

                  // Edit header icon
                  Positioned(
                    top: 75.0 - 32.0,
                    right: MediaQuery.of(context).size.width / 2.0 - 32.0,
                    child: IconButton(
                      icon: const Icon(
                        MdiIcons.camera,
                        color: Colors.white,
                        size: 32.0,
                      ),
                      onPressed: () => _showImagePicker(
                        context: context,
                        title: 'Change Background',
                        cameraCallBack: () async {
                          final File pickedImage = await ImagePicker.pickImage(
                            source: ImageSource.camera,
                            imageQuality: 70,
                          );

                          setState(() {
                            headerFile = pickedImage;  
                          });
                        },
                        galleryCallback: () async {
                          final File pickedImage = await ImagePicker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 70,
                          );

                          setState(() {
                            headerFile = pickedImage;  
                          });
                        },
                      ),
                    ),
                  ),

                  // Profile picture
                  Positioned(
                    bottom: 0.0,
                    left: 16.0,
                    child: GestureDetector(
                      onTap: () => _showImagePicker(
                        context: context,
                        title: 'Change Avatar',
                        cameraCallBack: () async {
                          final File pickedImage = await ImagePicker.pickImage(
                            source: ImageSource.camera,
                            imageQuality: 70,
                          );

                          setState(() {
                            photoFile = pickedImage;
                          });
                        },
                        galleryCallback: () async {
                          final File pickedImage = await ImagePicker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 70,
                          );
                          
                          setState(() {
                            photoFile = pickedImage;
                          });
                        },
                      ),
                      child: _ProfilePicture(
                        photoFile: photoFile,
                        photoUrl: widget.model.photoUrl,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Fields
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                // Display name
                StreamBuilder<String>(
                  stream: bloc.displayNameStream,
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                      ),
                      child: TextField(
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

                      ),
                    );
                  },
                ),

                // Gamertag
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: TextField(
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
                ),

                // Twitter
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: TextField(
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
                ),

                // Mixer
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: TextField(
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
                ),

                // Twitch
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: TextField(
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
                ),

                // Bio
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: TextField(
                    controller: bioController,
                    focusNode: bioNode,
                    maxLength: kMaxBioLength,
                    maxLines: iPhoneX(context) ? 3 : 4,
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
                ),

                const SizedBox(height: 16.0),

                // Privacy
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Row(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showImagePicker({
    @required BuildContext context,
    @required VoidCallback galleryCallback,
    @required VoidCallback cameraCallBack,
    String title,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(
            top: 32.0,
            left: 16.0,
            right: 16.0,
            bottom: 32.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title ?? 'Select a Source',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              ListTile(
                leading: const Icon(MdiIcons.camera),
                title: const Text('Take Picture'),
                onTap: () {
                  Navigator.of(context).pop();
                  cameraCallBack();
                },
              ),
              ListTile(
                leading: const Icon(MdiIcons.imageAlbum),
                title: Text(
                  Platform.isIOS ? 'Camera Roll' : 'Gallery'
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  galleryCallback();
                },
              ),
            ],
          ),
        );
      },
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
    final String displayName = bloc.displayNameValue;
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
      
    if (photoFile != null) {
      final StorageReference pictureRef = FirebaseStorage
        .instance
        .ref()
        .child('profiles')
        .child(model.uid)
        .child('profile.jpeg');
      final StorageUploadTask uploadTask = pictureRef.putFile(photoFile);
      await uploadTask.onComplete;
      
      final String photoUrl = await pictureRef.getDownloadURL();
      info.photoUrl = photoUrl;
      model.photoUrl = photoUrl;
      data['photoUrl'] = photoUrl;
    } else {
      data['photoUrl'] = model.photoUrl;
    }

    if (headerFile != null) {
      final StorageReference headerRef = FirebaseStorage
          .instance
          .ref()
          .child('profiles')
          .child(model.uid)
          .child('header.jpeg');

      final StorageUploadTask uploadTask = headerRef.putFile(headerFile);
      await uploadTask.onComplete;
      
      final String headerUrl = await headerRef.getDownloadURL();
      model.headerUrl = headerUrl;
      data['headerUrl'] = headerUrl;
    } else {
      data['headerUrl'] = model.headerUrl;
    }

    await firebaseUser.updateProfile(info);
    await firebaseUser.reload();

    await userBloc.update(
      uid: model.uid,
      data: data,
    );

    Navigator.of(context)
      ..pop()
      ..pop(model);
  }

  void _dismissKeyboard() {
    if (displayNameNode.hasFocus) {
      displayNameNode.unfocus();
    }

    if (gamertagNode.hasFocus) {
      gamertagNode.unfocus();
    }

    if (twitterNode.hasFocus) {
      twitterNode.unfocus();
    }

    if (mixerNode.hasFocus) {
      mixerNode.unfocus();
    }

    if (twitchNode.hasFocus) {
      twitchNode.unfocus();
    }

    if (bioNode.hasFocus) {
      bioNode.unfocus();
    }
  }
}

class _ProfilePicture extends StatelessWidget {
  const _ProfilePicture({
    this.photoUrl,
    this.photoFile,
  });
  
  final String photoUrl;
  final File photoFile;


  @override
  Widget build(BuildContext context) {
    Widget image;
    if (photoFile != null) {
      image = Image.file(
        photoFile,
        width: 100.0,
        height: 100.0,
        fit: BoxFit.cover
      );
    } else if (photoUrl != null) {
      image = CachedNetworkImage(
        imageUrl: photoUrl,
        width: 100.0,
        height: 100.0,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 300),
      );
    } else {
      image = Container(
        width: 100.0,
        height: 100.0,
        color: Colors.lightBlue,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        shape: BoxShape.circle,
        border: Border.all(
          width: 3.0,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            image,
            Container(
              width: 100.0,
              height: 100.0,
              color: Colors.black54,
            ),
            const Icon(
              MdiIcons.camera,
              color: Colors.white,
              size: 32.0,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderBackground extends StatelessWidget {
  const _HeaderBackground({
    this.headerUrl,
    this.headerFile,
  });

  final String headerUrl;
  final File headerFile;

  @override
  Widget build(BuildContext context) {

    Widget image;

    if (headerFile != null) {
      image = Image.file(
        headerFile,
        width: double.infinity,
        height: 150.0,
        fit: BoxFit.fitWidth,
      );
    } else {
      image = CachedNetworkImage(
        imageUrl: headerUrl ?? kDefaultProfileHeader,
        width: double.infinity,
        height: 150.0,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 300),
      );
    }

    return Stack(
      children: <Widget>[
        image,
        Container(
          height: 150.0,
          color: Colors.black54,
        ),
      ],
    );
  }
}
