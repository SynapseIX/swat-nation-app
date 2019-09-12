import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:swat_nation/models/team_member_model.dart';
import 'package:swat_nation/utils/date_helper.dart';

/// Represents a SWAT Nation team meber information.
class MemberCard extends StatefulWidget {
  const MemberCard({
    Key key,
    @required this.model,
  }) : super(key: key);
  
  final TeamMemberModel model;

  @override
  State createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {
  int index;

  @override
  void initState() {
    index = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      semanticContainer: true,
      child: Container(
        width: MediaQuery.of(context).size.width / 2.0,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: IndexedStack(
            index: index,
            children: <Widget>[
              _buildFront(),
              _buildBack(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFront() {
    return GestureDetector(
      onTap: () {
        setState(() {
          index = 1;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 276.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(widget.model.photoUrl),
                fit: BoxFit.cover,
              )
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  color: Colors.black54,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '${widget.model.handle} ${widget.model.country}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.model.role,
                        style: const TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            MdiIcons.cakeVariant,
                            color: Colors.white,
                            size: 14.0,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            humanizeTimestamp(widget.model.birthday, 'MMMM d'),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(
                            MdiIcons.twitter,
                            color: Colors.white,
                            size: 14.0,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            widget.model.twitter,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  right: 8.0,
                  bottom: 8.0,
                  child: Icon(
                    MdiIcons.information,
                    color: Colors.white
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack() {
    return GestureDetector(
      onTap: () {
        setState(() {
          index = 0;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: widget.model.photoUrl,
            fit: BoxFit.cover,
            color: const Color(0xFF333333),
            fadeInDuration: const Duration(milliseconds: 300),
            placeholder: (BuildContext context, String url) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  'About ${widget.model.handle}...',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  widget.model.bio,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
