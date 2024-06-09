
import 'package:flutter/material.dart';

class ImageProviderUtil {
  static ImageProvider getImageProvider(String? imageUrl , String AssetImageDir) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return NetworkImage(imageUrl);
    } else {
      return AssetImage(AssetImageDir);
    }
  }
}
