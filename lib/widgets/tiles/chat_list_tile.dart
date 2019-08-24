import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:swat_nation/constants.dart';
import 'package:swat_nation/models/chat_model.dart';
import 'package:swat_nation/widgets/common/verified_badge.dart';

/// List tile for chat messages.
class ChatListTile extends StatelessWidget {
  const ChatListTile({
    Key key,
    @required this.model,
    this.padding = const EdgeInsets.only(
      left: 16.0,
      right: 16.0,
      bottom: 8.0,
    ),
    this.onTap,
  }) : assert(model != null),
       super(key: key);

  final ChatModel model;
  final EdgeInsets padding;
  final void Function(ChatModel) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(model),
      child: Padding(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
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

            const SizedBox(width: 8.0),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
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
                  Text(model.message),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
