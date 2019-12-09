import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:swat_nation/blocs/about_bloc.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/about_model.dart';
import 'package:swat_nation/models/team_member_model.dart';
import 'package:swat_nation/routes.dart';
import 'package:swat_nation/utils/url_launcher.dart';
import 'package:swat_nation/widgets/cards/member_card.dart';
import 'package:swat_nation/widgets/common/card_section.dart';
import 'package:swat_nation/widgets/headers/text_header.dart';
import 'package:swat_nation/widgets/lists/horizontal_card_list.dart';

/// Represents the about us screen.
class AboutScreen extends StatefulWidget {
  const AboutScreen({
    Key key,
  }) : super(key: key);

  static Handler routeHandler() {
    return Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
        return const AboutScreen();
      }
    );
  }

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  AboutBloc bloc;

  @override
  void initState() {
    bloc = AboutBloc();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: StreamBuilder<AboutModel>(
        stream: bloc.infoStream,
        builder: (BuildContext context, AsyncSnapshot<AboutModel> snapshot) {
          if (snapshot.hasError) {
            print('About error: ${snapshot.error}');
            return const SizedBox();
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final AboutModel model = snapshot.data;
          return ListView(
            children: <Widget>[
              // What's SWAT Nation?
              const TextHeader('What\'s SWAT Nation?'),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(model.text.replaceAll('###', '\n\n')),
              ),

              // The Team
              CardSection(
                header: const TextHeader('The Team'),
                cardList: HorizontalCardList(
                  height: 300.0,
                  cards: model.team.map((TeamMemberModel member) {
                    return MemberCard(
                      key: PageStorageKey<String>(member.handle),
                      model: member,
                    );
                  }).toList(),
                ),
              ),

              // The Roadmap
              TextHeader('The ${DateTime.now().year} Roadmap'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    final List<int> bytes = utf8.encode(model.roadmapUrl);
                    final String encodedUrl = base64.encode(bytes);
                    Routes.router.navigateTo(context, '/image-viewer/$encodedUrl');
                  },
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    semanticContainer: true,
                    child: CachedNetworkImage(
                      imageUrl: model.roadmapUrl,
                      fadeInDuration: const Duration(milliseconds: 300),
                    ),
                  ),
                ),
              ),

              // Legal
              const TextHeader(
                'Legal & Disclaimers',
              ),
              GestureDetector(
                onTap: () => openUrl(kContentUsageRulesUrl),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(kGameContentUsageRules),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
