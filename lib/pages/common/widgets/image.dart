import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../values/radii.dart';

Widget netImageCached(
  String url, {
  double width = 48,
  double height = 48,
  EdgeInsetsGeometry? margin,
}) {
  return Container(
    height: height.h,
    width: width.w,
    margin: margin,
    child: ClipRRect(
      borderRadius: Radii.k54pxRadius,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder:
            (
              BuildContext context,
              Widget child,
              ImageChunkEvent? loadingProgress,
            ) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
              return Image.asset("assets/images/jpg.jpg", fit: BoxFit.cover);
            },
      ),
    ),
  );
}
