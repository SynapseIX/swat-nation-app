import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/base/base_tab.dart';
import 'package:swat_nation/blocs/theme_bloc.dart';
import 'package:swat_nation/blocs/user_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/user_model.dart';
import 'package:swat_nation/screens/profile/profile_screen.dart';
import 'package:swat_nation/themes/light_theme.dart';
import 'package:swat_nation/widgets/common/verified_badge.dart';

/// Represents the team finder tab screen.
class FinderTab extends StatefulWidget implements BaseTab {
  const FinderTab({ Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FinderTabState();

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
            backgroundColor: ThemeBloc.instance().currentTheme is LightTheme
              ? Colors.lightGreen
              : Theme.of(context).appBarTheme.color,
            title: const Text('Member Finder'),
            bottom: PreferredSize(
              preferredSize: const Size(
                double.infinity,
                60.0,
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                color: ThemeBloc.instance().currentTheme is LightTheme
                  ? Colors.white
                  : Theme.of(context).appBarTheme.color,
                child: TextField(
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
                          Container(
                            margin: const EdgeInsets.only(left: 4.0),
                            child: const VerifiedBadge(),
                          ),
                        ],
                      ),
                      trailing: model.private
                        ? const Icon(MdiIcons.lock)
                        : null,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => ProfileScreen(model: model),
                            ),
                          );
                        },
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
