import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayerAvatar extends StatelessWidget {

  final double size;
  final String url;

  PlayerAvatar({
    @required this.url,
    this.size = 48.0
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: CachedNetworkImage(
        width: size,
        height: size,
        imageUrl: url,
        // placeholder: (context, url) {
        //   return SizedBox(
        //     width: 24,
        //     height: 24,
        //     child: CircularProgressIndicator(),
        //   );
        // },
        placeholder: (context, url) {
          return SizedBox(
            width: 24,
            height: 24,
            child: Icon(Icons.person),
          );
        },
        // progressIndicatorBuilder: (context, url, downloadProgress) => 
        //       SizedBox(
        //         height: 28,
        //         width: 28,
        //         child: CircularProgressIndicator()
        //       ),
        errorWidget: (context, url, error) => Icon(Icons.person, size: size,)
      ),
    );
  }
}