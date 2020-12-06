import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xfff81e06);
const Color kWhiteBackground = Color(0xffeff0f3);
const Color kGreyText = Color(0xffc3bbbf);
const Color kDarkPrimary = Color(0xffd15016);
const Color kDarkGrey = Color(0xff7b7c82);
const Color kBlackPrimary = Color(0xff111314);
const Color kExtraGrey = Color(0xff545c62);
const String att =
    "https://www.freepik.com/vectors/background>Background vector created by rawpixel.com - www.freepik.com</a>";

const TextStyle kAlbumTextStyle = TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);


class CustomBoxShadow extends BoxShadow {
  final BlurStyle blurStyle;

  const CustomBoxShadow({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    this.blurStyle = BlurStyle.normal,
  }) : super(color: color, offset: offset, blurRadius: blurRadius);

  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(this.blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows)
        result.maskFilter = null;
      return true;
    }());
    return result;
  }
}