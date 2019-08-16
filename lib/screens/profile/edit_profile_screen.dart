import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/constants.dart';
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

  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController gamertagController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final TextEditingController mixerController = TextEditingController();
  final TextEditingController twitchController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
          child: Form(
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
                TextFormField(
                  controller: displayNameController,
                  maxLength: kDisplayNameMaxChararcters,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Username',
                  ),
                ),

                // Gamertag
                TextFormField(
                  controller: gamertagController,
                  decoration: InputDecoration(
                    labelText: 'Gamertag',
                    hintText: 'Gamertag',
                  ),
                ),

                // Twitter
                TextFormField(
                  controller: twitterController,
                  decoration: InputDecoration(
                    labelText: 'Twitter',
                    hintText: 'Twitter',
                  ),
                ),

                // Mixer
                TextFormField(
                  controller: mixerController,
                  decoration: InputDecoration(
                    labelText: 'Mixer',
                    hintText: 'Mixer',
                  ),
                ),

                // Twitch
                TextFormField(
                  controller: twitchController,
                  decoration: InputDecoration(
                    labelText: 'Twitch',
                    hintText: 'Twitch',
                  ),
                ),

                // Bio
                TextFormField(
                  controller: bioController,
                  maxLength: kMaxBioLength,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Bio',
                    hintText: 'Bio',
                  ),
                ),

                // Save button
                Container(
                  margin: const EdgeInsets.only(top: 32.0),
                  width: double.infinity,
                  height: 40.0,
                  child: RaisedButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    onPressed: () => _saveChanges(),
                    child: const Text('Save Profile'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    print('TODO: implement');
  }

  void _dismissKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
