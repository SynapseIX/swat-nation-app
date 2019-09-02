import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/base/base_tab.dart';
import 'package:swat_nation/base/base_theme.dart';
import 'package:swat_nation/blocs/auth_bloc.dart';
import 'package:swat_nation/blocs/theme_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/routes.dart';
import 'package:swat_nation/themes/dark_theme.dart';
import 'package:swat_nation/widgets/common/verified_badge.dart';
import 'package:swat_nation/widgets/dialogs/dialog_helper.dart';

/// Represents the team finder tab screen.
class FinderTab extends StatefulWidget implements BaseTab {
  const FinderTab({ Key key }) : super(key: key);

  @override
  State createState() => _FinderTabState();

  @override
  IconData get icon => MdiIcons.accountSearch;

  @override
  String get title => 'Finder';
}

class _FinderTabState extends State<FinderTab> with AutomaticKeepAliveClientMixin {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchNode = FocusNode();

  UserBloc bloc;
  String query;

  @override
  void initState() {
    bloc = UserBloc();
    query = '';

    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchNode.dispose();
    bloc.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GestureDetector(
      onTap: _dismissKeyboard,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            floating: true,
            automaticallyImplyLeading: false,
            title: const Text('Member Finder'),
            bottom: PreferredSize(
              preferredSize: const Size(
                double.infinity,
                60.0,
              ),
              child: StreamBuilder<BaseTheme>(
                stream: ThemeBloc.instance().stream,
                builder: (BuildContext context, AsyncSnapshot<BaseTheme> snapshot) {
                  final BaseTheme theme = snapshot.data;

                  return Container(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    color: theme is DarkTheme
                      ? const Color(0xFF202020)
                      : Colors.white,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            keyboardAppearance: theme is DarkTheme
                              ? Brightness.dark
                              : Brightness.light,
                            controller: searchController,
                            focusNode: searchNode,
                            autocorrect: false,
                            textInputAction: TextInputAction.search,
                            decoration: const InputDecoration(
                              icon: Icon(MdiIcons.magnify),
                              border: InputBorder.none,
                              hintText: 'Search members...',
                            ),
                            onChanged: (String value) {
                              setState(() {
                                query = value;
                              });
                            },
                          ),
                        ),
                        if (query.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            searchController.clear();
                            setState(() {
                              query = '';
                            });
                          },
                          child: Container(
                            height: 40.0,
                            width: 40.0,
                            child: Icon(
                              MdiIcons.closeCircle,
                              color: Theme.of(context).hintColor,
                              size: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16.0)),

          StreamBuilder<List<UserModel>>(
            stream: bloc.allUsers,
            initialData: const <UserModel>[],
            builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
              if (!snapshot.hasData) {
                return const SliverToBoxAdapter(child: SizedBox());
              }

              final List<UserModel> data = snapshot.data.where(
                (UserModel model) => model.displayName
                  .toLowerCase()
                  .contains(query.toLowerCase()),
              ).toList();

              if (data.isEmpty) {
                return SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    child: Text(
                      'There are no members matching \'$query\'',
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final UserModel model = data[index];

                    return ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF333333),
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 3.0,
                            color: Colors.white,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: CachedNetworkImage(
                            imageUrl: model.photoUrl ?? kDefaultAvi,
                            width: 40.0,
                            height: 40.0,
                            fit: BoxFit.cover,
                            fadeInDuration: const Duration(milliseconds: 300),
                          ),
                        ),
                      ),
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            model.displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (model.verified)
                          const VerifiedBadge(
                            margin: EdgeInsets.only(left: 4.0),
                          ),
                        ],
                      ),
                      trailing: StreamBuilder<FirebaseUser>(
                        stream: AuthBloc.instance().onAuthStateChanged,
                        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
                          if (snapshot.hasData && model.uid == snapshot.data.uid) {
                            return const Icon(
                              MdiIcons.account,
                              color: Colors.amber,
                            );
                          }
                          
                          if (model.private) {
                            return const Icon(MdiIcons.lock);
                          }

                          return const SizedBox();
                        },
                      ),
                      onTap: () async {
                        _dismissKeyboard();

                        Future<void>.delayed(
                          kKeyboardAnimationDuration,
                          () async {
                            final FirebaseUser currentUser = await AuthBloc
                              .instance()
                              .currentUser;
                            if (currentUser == null) {
                              return DialogHelper
                                .instance()
                                .showSignInDIalog(context: context);
                            } else {
                              Routes
                                .router
                                .navigateTo(context, 'profile/${model.uid}');
                            }
                          }
                        );
                      }
                    );
                  },
                  childCount: data.length,
                ),
              );
            }
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _dismissKeyboard() {
    if (searchNode.hasFocus) {
      searchNode.unfocus();
    }
  }
}
