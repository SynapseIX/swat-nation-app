import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:swat_nation/blocs/about_bloc.dart';
import 'package:swat_nation/models/about_model.dart';
import 'package:swat_nation/models/team_member_model.dart';
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
  State<AboutScreen> createState() => _AboutScreenState();
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
            print(snapshot.error);
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
                      key: UniqueKey(),
                      model: member,
                    );
                  }).toList(),
                ),
              ),

              // The Roadmap
              TextHeader('The ${DateTime.now().year} Roadmap'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  semanticContainer: true,
                  child: CachedNetworkImage(
                    imageUrl: 'https://images.squarespace-cdn.com/content/v1/5bfb2111372b964077959077/1562944049862-3WTU5D09XURRSB97GF9R/ke17ZwdGBToddI8pDm48kNvT88LknE-K9M4pGNO0Iqd7gQa3H78H3Y0txjaiv_0fDoOvxcdMmMKkDsyUqMSsMWxHk725yiiHCCLfrh8O1z5QPOohDIaIeljMHgDF5CVlOqpeNLcJ80NK65_fV7S1USOFn4xF8vTWDNAUBm5ducQhX-V3oVjSmr829Rco4W2Uo49ZdOtO_QXox0_W7i2zEA/public.jpeg?format=500w',
                    fadeInDuration: const Duration(milliseconds: 300),
                  ),
                ),
              )
            ],
          );
        }
      ),
    );
  }
}
