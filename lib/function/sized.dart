import 'package:flutter/material.dart';
import 'package:app/constant/languagedemo.dart';

mediaWidthSized(BuildContext context, double size) {
  if (MediaQuery.of(context).size.height <= MediaQuery.of(context).size.width) {
    return MediaQuery.of(context).size.width * 0.4 / size;
  }
  if (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width <=
      1.4) {
    return MediaQuery.of(context).size.width * 0.65 / size;
  }
  return MediaQuery.of(context).size.width / size;
}

mediaHeightSized(BuildContext context, double size) {
  return MediaQuery.of(context).size.height / size;
}

appbarsize(BuildContext context) {
  return mediaWidthSized(context, 8.5);
}

appbarTextSize(BuildContext context) {
  if (indexL == 0) {
    return mediaWidthSized(context, 24);
  } else {
    return mediaWidthSized(context, 21.2);
  }
}

tabbarheight(BuildContext context) {
  return mediaWidthSized(context, 45);
}

// double tabbarheight = 10;
double? tabbarTextSize;

hometitleSize(context) {
  if (indexL == 0) {
    return mediaWidthSized(context, 25);
  } else {
    return mediaWidthSized(context, 20);
  }
}

tabSelectTitle(context) {
  if (indexL == 0) {
    return mediaWidthSized(context, 28);
  } else {
    return mediaWidthSized(context, 24);
  }
}

tabUnselectTitle(context) {
  if (indexL == 0) {
    return mediaWidthSized(context, 30);
  } else {
    return mediaWidthSized(context, 26);
  }
}

tabContainer(context) {
  return mediaWidthSized(context, 9.2);
}
