import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SeasonBadgeImage extends StatelessWidget {
  final double size;
  final String url;

  SeasonBadgeImage({
    @required this.url,
    this.size = 24
  });

  @override
  Widget build(BuildContext context) {

    if ( url == null) {
      return Container();
    }

    return CachedNetworkImage(
      width: size,
      height: size,
      placeholder: (context, url) {
        return SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(),
        );
      },
      imageUrl: url,
      errorWidget: (context, url, error) => Icon(Icons.person, size: size,),
    );
  }
}