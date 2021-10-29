import 'package:cached_network_image/cached_network_image.dart';

imageNetworkBuild(uri) {
  return CachedNetworkImageProvider(
    uri,
    errorListener: () {},
  );
}
