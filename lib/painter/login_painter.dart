// import 'dart:ui' as ui;

import 'package:flutter/material.dart';

//Add this CustomPaint widget to the Widget Tree
// CustomPaint(
//     size: Size(WIDTH, (WIDTH*0.625).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
//     painter: RPSCustomPainter(),
// )

//Copy this CustomPainter code to the Bottom of the File
class GotoLoginCustomPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.1357500, size.height * 0.8875500);
    path_0.cubicTo(
        size.width * 0.1357500,
        size.height * 0.8875500,
        size.width * 0.03425000,
        size.height * 0.6898500,
        size.width * 0.08384375,
        size.height * 0.4863000);
    path_0.cubicTo(
        size.width * 0.1161875,
        size.height * 0.3536000,
        size.width * 0.2374688,
        size.height * 0.2809000,
        size.width * 0.3059375,
        size.height * 0.3536000);
    path_0.cubicTo(
        size.width * 0.3350937,
        size.height * 0.3845500,
        size.width * 0.4286250,
        size.height * 0.3546500,
        size.width * 0.4785937,
        size.height * 0.2264500);
    path_0.cubicTo(
        size.width * 0.5756562,
        size.height * -0.02265000,
        size.width * 0.9144062,
        size.height * 0.1286500,
        size.width * 0.8527187,
        size.height * 0.5111000);
    path_0.cubicTo(
        size.width * 0.8228750,
        size.height * 0.6962000,
        size.width * 0.9435312,
        size.height * 0.7029000,
        size.width * 0.8820625,
        size.height * 0.8879000);
    path_0.lineTo(size.width * 0.1357500, size.height * 0.8875500);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xffEBF3FA).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.5360625, size.height * 0.8856500);
    path_1.lineTo(size.width * 0.5358125, size.height * 0.8856500);
    path_1.cubicTo(
        size.width * 0.5336563,
        size.height * 0.8856000,
        size.width * 0.5320000,
        size.height * 0.8828000,
        size.width * 0.5322188,
        size.height * 0.8795500);
    path_1.lineTo(size.width * 0.5465313, size.height * 0.6508000);
    path_1.lineTo(size.width * 0.5590312, size.height * 0.6526000);
    path_1.lineTo(size.width * 0.5384688, size.height * 0.8825500);
    path_1.cubicTo(
        size.width * 0.5382813,
        size.height * 0.8843500,
        size.width * 0.5372500,
        size.height * 0.8856500,
        size.width * 0.5360625,
        size.height * 0.8856500);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = const Color(0xffACC7EB).withOpacity(1.0);
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.6739063, size.height * 0.8856500);
    path_2.lineTo(size.width * 0.6741563, size.height * 0.8856500);
    path_2.cubicTo(
        size.width * 0.6763125,
        size.height * 0.8856000,
        size.width * 0.6779688,
        size.height * 0.8828000,
        size.width * 0.6777500,
        size.height * 0.8795500);
    path_2.lineTo(size.width * 0.6634375, size.height * 0.6508000);
    path_2.lineTo(size.width * 0.6509375, size.height * 0.6526000);
    path_2.lineTo(size.width * 0.6715000, size.height * 0.8825500);
    path_2.cubicTo(
        size.width * 0.6716563,
        size.height * 0.8843500,
        size.width * 0.6726875,
        size.height * 0.8856500,
        size.width * 0.6739063,
        size.height * 0.8856500);
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = const Color(0xffC8DBF4).withOpacity(1.0);
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(size.width * 0.4350625, size.height * 0.8856500);
    path_3.lineTo(size.width * 0.4348125, size.height * 0.8856500);
    path_3.cubicTo(
        size.width * 0.4326563,
        size.height * 0.8856000,
        size.width * 0.4310000,
        size.height * 0.8828000,
        size.width * 0.4312188,
        size.height * 0.8795500);
    path_3.lineTo(size.width * 0.4455312, size.height * 0.6508000);
    path_3.lineTo(size.width * 0.4580313, size.height * 0.6526000);
    path_3.lineTo(size.width * 0.4374688, size.height * 0.8825500);
    path_3.cubicTo(
        size.width * 0.4372813,
        size.height * 0.8843500,
        size.width * 0.4362500,
        size.height * 0.8856500,
        size.width * 0.4350625,
        size.height * 0.8856500);
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.color = const Color(0xffBAD4F4).withOpacity(1.0);
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(size.width * 0.6696250, size.height * 0.6175000);
    path_4.lineTo(size.width * 0.6950313, size.height * 0.4167500);
    path_4.cubicTo(
        size.width * 0.6982813,
        size.height * 0.3895500,
        size.width * 0.6842188,
        size.height * 0.3647000,
        size.width * 0.6659375,
        size.height * 0.3654000);
    path_4.lineTo(size.width * 0.6169375, size.height * 0.3672000);
    path_4.cubicTo(
        size.width * 0.6000313,
        size.height * 0.3678000,
        size.width * 0.5853438,
        size.height * 0.3859000,
        size.width * 0.5806250,
        size.height * 0.4119000);
    path_4.lineTo(size.width * 0.5434375, size.height * 0.6175500);
    path_4.lineTo(size.width * 0.6696250, size.height * 0.6175500);
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.color = const Color(0xffBAD4F4).withOpacity(1.0);
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(size.width * 0.6542500, size.height * 0.6175000);
    path_5.lineTo(size.width * 0.6796563, size.height * 0.4167500);
    path_5.cubicTo(
        size.width * 0.6829063,
        size.height * 0.3895500,
        size.width * 0.6688438,
        size.height * 0.3647000,
        size.width * 0.6505625,
        size.height * 0.3654000);
    path_5.lineTo(size.width * 0.6015625, size.height * 0.3672000);
    path_5.cubicTo(
        size.width * 0.5846563,
        size.height * 0.3678000,
        size.width * 0.5699688,
        size.height * 0.3859000,
        size.width * 0.5652500,
        size.height * 0.4119000);
    path_5.lineTo(size.width * 0.5280625, size.height * 0.6175500);
    path_5.lineTo(size.width * 0.6542500, size.height * 0.6175500);
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.color = const Color(0xffACC7EB).withOpacity(1.0);
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(size.width * 0.6625313, size.height * 0.6541500);
    path_6.lineTo(size.width * 0.4686562, size.height * 0.6541500);
    path_6.cubicTo(
        size.width * 0.4647500,
        size.height * 0.6541500,
        size.width * 0.4615625,
        size.height * 0.6490500,
        size.width * 0.4615625,
        size.height * 0.6428000);
    path_6.lineTo(size.width * 0.4615625, size.height * 0.6288500);
    path_6.cubicTo(
        size.width * 0.4615625,
        size.height * 0.6226000,
        size.width * 0.4647500,
        size.height * 0.6175000,
        size.width * 0.4686562,
        size.height * 0.6175000);
    path_6.lineTo(size.width * 0.6696250, size.height * 0.6175000);
    path_6.lineTo(size.width * 0.6696250, size.height * 0.6428000);
    path_6.cubicTo(
        size.width * 0.6696250,
        size.height * 0.6490500,
        size.width * 0.6664375,
        size.height * 0.6541500,
        size.width * 0.6625313,
        size.height * 0.6541500);
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.color = const Color(0xffC8DBF4).withOpacity(1.0);
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(size.width * 0.5715625, size.height * 0.6541500);
    path_7.lineTo(size.width * 0.4479688, size.height * 0.6541500);
    path_7.cubicTo(
        size.width * 0.4448437,
        size.height * 0.6541500,
        size.width * 0.4422500,
        size.height * 0.6500500,
        size.width * 0.4422500,
        size.height * 0.6450000);
    path_7.lineTo(size.width * 0.4422500, size.height * 0.6266500);
    path_7.cubicTo(
        size.width * 0.4422500,
        size.height * 0.6216500,
        size.width * 0.4448125,
        size.height * 0.6175000,
        size.width * 0.4479688,
        size.height * 0.6175000);
    path_7.lineTo(size.width * 0.5715625, size.height * 0.6175000);
    path_7.cubicTo(
        size.width * 0.5746875,
        size.height * 0.6175000,
        size.width * 0.5772812,
        size.height * 0.6216000,
        size.width * 0.5772812,
        size.height * 0.6266500);
    path_7.lineTo(size.width * 0.5772812, size.height * 0.6450000);
    path_7.cubicTo(
        size.width * 0.5772812,
        size.height * 0.6500000,
        size.width * 0.5746875,
        size.height * 0.6541500,
        size.width * 0.5715625,
        size.height * 0.6541500);
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.color = const Color(0xffACC7EB).withOpacity(1.0);
    canvas.drawPath(path_7, paint7Fill);

    Path path_8 = Path();
    path_8.moveTo(size.width * 0.9355312, size.height * 0.8890000);
    path_8.lineTo(size.width * 0.07603125, size.height * 0.8890000);
    path_8.cubicTo(
        size.width * 0.07534375,
        size.height * 0.8890000,
        size.width * 0.07481250,
        size.height * 0.8881000,
        size.width * 0.07481250,
        size.height * 0.8870500);
    path_8.lineTo(size.width * 0.07481250, size.height * 0.8852000);
    path_8.cubicTo(
        size.width * 0.07481250,
        size.height * 0.8841000,
        size.width * 0.07537500,
        size.height * 0.8832500,
        size.width * 0.07603125,
        size.height * 0.8832500);
    path_8.lineTo(size.width * 0.9355000, size.height * 0.8832500);
    path_8.cubicTo(
        size.width * 0.9361875,
        size.height * 0.8832500,
        size.width * 0.9367188,
        size.height * 0.8841500,
        size.width * 0.9367188,
        size.height * 0.8852000);
    path_8.lineTo(size.width * 0.9367188, size.height * 0.8870500);
    path_8.cubicTo(
        size.width * 0.9367500,
        size.height * 0.8881500,
        size.width * 0.9361875,
        size.height * 0.8890000,
        size.width * 0.9355312,
        size.height * 0.8890000);
    path_8.close();

    Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.color = const Color(0xff2E3552).withOpacity(1.0);
    canvas.drawPath(path_8, paint8Fill);

    Path path_9 = Path();
    path_9.moveTo(size.width * 0.3721563, size.height * 0.4899000);
    path_9.lineTo(size.width * 0.4295625, size.height * 0.4899000);
    path_9.lineTo(size.width * 0.4295625, size.height * 0.4899000);
    path_9.cubicTo(
        size.width * 0.4295625,
        size.height * 0.4858500,
        size.width * 0.4275000,
        size.height * 0.4826000,
        size.width * 0.4250000,
        size.height * 0.4826000);
    path_9.lineTo(size.width * 0.3721563, size.height * 0.4826000);
    path_9.lineTo(size.width * 0.3721563, size.height * 0.4899000);
    path_9.close();

    Paint paint9Fill = Paint()..style = PaintingStyle.fill;
    paint9Fill.color = const Color(0xffED7D2B).withOpacity(1.0);
    canvas.drawPath(path_9, paint9Fill);

    Path path_10 = Path();
    path_10.moveTo(size.width * 0.3723125, size.height * 0.3898500);
    path_10.lineTo(size.width * 0.2835625, size.height * 0.3898500);
    path_10.lineTo(size.width * 0.3048438, size.height * 0.4899000);
    path_10.lineTo(size.width * 0.3941875, size.height * 0.4899000);
    path_10.close();

    Paint paint10Fill = Paint()..style = PaintingStyle.fill;
    paint10Fill.color = const Color(0xffED7D2B).withOpacity(1.0);
    canvas.drawPath(path_10, paint10Fill);

    Path path_11 = Path();
    path_11.moveTo(size.width * 0.2822500, size.height * 0.3898500);
    path_11.lineTo(size.width * 0.3035312, size.height * 0.4899000);
    path_11.lineTo(size.width * 0.3928750, size.height * 0.4899000);
    path_11.lineTo(size.width * 0.3710000, size.height * 0.3898500);
    path_11.close();

    Paint paint11Fill = Paint()..style = PaintingStyle.fill;
    paint11Fill.color = const Color(0xffF99746).withOpacity(1.0);
    canvas.drawPath(path_11, paint11Fill);

    Path path_12 = Path();
    path_12.moveTo(size.width * 0.3300937, size.height * 0.4389500);
    path_12.cubicTo(
        size.width * 0.3306562,
        size.height * 0.4427500,
        size.width * 0.3330313,
        size.height * 0.4458500,
        size.width * 0.3354062,
        size.height * 0.4458500);
    path_12.cubicTo(
        size.width * 0.3377812,
        size.height * 0.4458500,
        size.width * 0.3392813,
        size.height * 0.4427500,
        size.width * 0.3387187,
        size.height * 0.4389500);
    path_12.cubicTo(
        size.width * 0.3381562,
        size.height * 0.4351500,
        size.width * 0.3357812,
        size.height * 0.4320500,
        size.width * 0.3334062,
        size.height * 0.4320500);
    path_12.cubicTo(
        size.width * 0.3310312,
        size.height * 0.4320500,
        size.width * 0.3295625,
        size.height * 0.4351500,
        size.width * 0.3300937,
        size.height * 0.4389500);
    path_12.close();

    Paint paint12Fill = Paint()..style = PaintingStyle.fill;
    paint12Fill.color = const Color(0xffFFFFFF).withOpacity(1.0);
    canvas.drawPath(path_12, paint12Fill);

    Path path_13 = Path();
    path_13.moveTo(size.width * 0.7035625, size.height * 0.6538500);
    path_13.lineTo(size.width * 0.7035625, size.height * 0.6596500);
    path_13.cubicTo(
        size.width * 0.7035625,
        size.height * 0.6617000,
        size.width * 0.7039688,
        size.height * 0.6633500,
        size.width * 0.7044688,
        size.height * 0.6633500);
    path_13.lineTo(size.width * 0.8372500, size.height * 0.6633500);
    path_13.cubicTo(
        size.width * 0.8377500,
        size.height * 0.6633500,
        size.width * 0.8381563,
        size.height * 0.6617000,
        size.width * 0.8381563,
        size.height * 0.6596500);
    path_13.lineTo(size.width * 0.8381563, size.height * 0.6538500);
    path_13.cubicTo(
        size.width * 0.8381563,
        size.height * 0.6518000,
        size.width * 0.8377500,
        size.height * 0.6501500,
        size.width * 0.8372500,
        size.height * 0.6501500);
    path_13.lineTo(size.width * 0.7044688, size.height * 0.6501500);
    path_13.cubicTo(
        size.width * 0.7039687,
        size.height * 0.6501500,
        size.width * 0.7035625,
        size.height * 0.6518500,
        size.width * 0.7035625,
        size.height * 0.6538500);
    path_13.close();

    Paint paint13Fill = Paint()..style = PaintingStyle.fill;
    paint13Fill.color = const Color(0xff9ABFE2).withOpacity(1.0);
    canvas.drawPath(path_13, paint13Fill);

    Path path_14 = Path();
    path_14.moveTo(size.width * 0.7035625, size.height * 0.6538500);
    path_14.lineTo(size.width * 0.7035625, size.height * 0.6596500);
    path_14.cubicTo(
        size.width * 0.7035625,
        size.height * 0.6617000,
        size.width * 0.7039375,
        size.height * 0.6633500,
        size.width * 0.7044063,
        size.height * 0.6633500);
    path_14.lineTo(size.width * 0.8098437, size.height * 0.6633500);
    path_14.cubicTo(
        size.width * 0.8103125,
        size.height * 0.6633500,
        size.width * 0.8106875,
        size.height * 0.6617000,
        size.width * 0.8106875,
        size.height * 0.6596500);
    path_14.lineTo(size.width * 0.8106875, size.height * 0.6538500);
    path_14.cubicTo(
        size.width * 0.8106875,
        size.height * 0.6518000,
        size.width * 0.8103125,
        size.height * 0.6501500,
        size.width * 0.8098437,
        size.height * 0.6501500);
    path_14.lineTo(size.width * 0.7044063, size.height * 0.6501500);
    path_14.cubicTo(
        size.width * 0.7039375,
        size.height * 0.6501500,
        size.width * 0.7035625,
        size.height * 0.6518500,
        size.width * 0.7035625,
        size.height * 0.6538500);
    path_14.close();

    Paint paint14Fill = Paint()..style = PaintingStyle.fill;
    paint14Fill.color = const Color(0xffBAD4F4).withOpacity(1.0);
    canvas.drawPath(path_14, paint14Fill);

    Paint paint15Fill = Paint()..style = PaintingStyle.fill;
    paint15Fill.color = const Color(0xffC8DBF4).withOpacity(1.0);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.7371875, size.height * 0.6634000,
            size.width * 0.09428125, size.height * 0.2198500),
        paint15Fill);

    Paint paint16Fill = Paint()..style = PaintingStyle.fill;
    paint16Fill.color = const Color(0xffDFEBFD).withOpacity(1.0);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.7107500, size.height * 0.6634000,
            size.width * 0.09428125, size.height * 0.2198500),
        paint16Fill);

    Path path_17 = Path();
    path_17.moveTo(size.width * 0.7158125, size.height * 0.6696000);
    path_17.lineTo(size.width * 0.7999688, size.height * 0.6696000);
    path_17.lineTo(size.width * 0.7999688, size.height * 0.8711000);
    path_17.lineTo(size.width * 0.7158125, size.height * 0.8711000);
    path_17.lineTo(size.width * 0.7158125, size.height * 0.6696000);
    path_17.close();
    path_17.moveTo(size.width * 0.7990625, size.height * 0.6710500);
    path_17.lineTo(size.width * 0.7167500, size.height * 0.6710500);
    path_17.lineTo(size.width * 0.7167500, size.height * 0.8696500);
    path_17.lineTo(size.width * 0.7990625, size.height * 0.8696500);
    path_17.lineTo(size.width * 0.7990625, size.height * 0.6710500);
    path_17.close();

    Paint paint17Fill = Paint()..style = PaintingStyle.fill;
    paint17Fill.color = const Color(0xffB7D3F3).withOpacity(1.0);
    canvas.drawPath(path_17, paint17Fill);

    Paint paint18Fill = Paint()..style = PaintingStyle.fill;
    paint18Fill.color = const Color(0xffB7D3F3).withOpacity(1.0);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.7162812, size.height * 0.7362500,
            size.width * 0.08325000, size.height * 0.001450000),
        paint18Fill);

    Paint paint19Fill = Paint()..style = PaintingStyle.fill;
    paint19Fill.color = const Color(0xffB7D3F3).withOpacity(1.0);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.7162812, size.height * 0.8042000,
            size.width * 0.08325000, size.height * 0.001450000),
        paint19Fill);

    Path path_20 = Path();
    path_20.moveTo(size.width * 0.7493750, size.height * 0.6826000);
    path_20.lineTo(size.width * 0.7648125, size.height * 0.6826000);
    path_20.cubicTo(
        size.width * 0.7655625,
        size.height * 0.6826000,
        size.width * 0.7661875,
        size.height * 0.6816000,
        size.width * 0.7661875,
        size.height * 0.6804000);
    path_20.lineTo(size.width * 0.7661875, size.height * 0.6804000);
    path_20.cubicTo(
        size.width * 0.7661875,
        size.height * 0.6792000,
        size.width * 0.7655625,
        size.height * 0.6782000,
        size.width * 0.7648125,
        size.height * 0.6782000);
    path_20.lineTo(size.width * 0.7493750, size.height * 0.6782000);
    path_20.cubicTo(
        size.width * 0.7486250,
        size.height * 0.6782000,
        size.width * 0.7480000,
        size.height * 0.6792000,
        size.width * 0.7480000,
        size.height * 0.6804000);
    path_20.lineTo(size.width * 0.7480000, size.height * 0.6804000);
    path_20.cubicTo(
        size.width * 0.7480000,
        size.height * 0.6816000,
        size.width * 0.7486250,
        size.height * 0.6826000,
        size.width * 0.7493750,
        size.height * 0.6826000);
    path_20.close();

    Paint paint20Fill = Paint()..style = PaintingStyle.fill;
    paint20Fill.color = const Color(0xffB7D3F3).withOpacity(1.0);
    canvas.drawPath(path_20, paint20Fill);

    Path path_21 = Path();
    path_21.moveTo(size.width * 0.7493750, size.height * 0.7490500);
    path_21.lineTo(size.width * 0.7648125, size.height * 0.7490500);
    path_21.cubicTo(
        size.width * 0.7655625,
        size.height * 0.7490500,
        size.width * 0.7661875,
        size.height * 0.7480500,
        size.width * 0.7661875,
        size.height * 0.7468500);
    path_21.lineTo(size.width * 0.7661875, size.height * 0.7468500);
    path_21.cubicTo(
        size.width * 0.7661875,
        size.height * 0.7456500,
        size.width * 0.7655625,
        size.height * 0.7446500,
        size.width * 0.7648125,
        size.height * 0.7446500);
    path_21.lineTo(size.width * 0.7493750, size.height * 0.7446500);
    path_21.cubicTo(
        size.width * 0.7486250,
        size.height * 0.7446500,
        size.width * 0.7480000,
        size.height * 0.7456500,
        size.width * 0.7480000,
        size.height * 0.7468500);
    path_21.lineTo(size.width * 0.7480000, size.height * 0.7468500);
    path_21.cubicTo(
        size.width * 0.7480000,
        size.height * 0.7480500,
        size.width * 0.7486250,
        size.height * 0.7490500,
        size.width * 0.7493750,
        size.height * 0.7490500);
    path_21.close();

    Paint paint21Fill = Paint()..style = PaintingStyle.fill;
    paint21Fill.color = const Color(0xffB7D3F3).withOpacity(1.0);
    canvas.drawPath(path_21, paint21Fill);

    Path path_22 = Path();
    path_22.moveTo(size.width * 0.7493750, size.height * 0.8183500);
    path_22.lineTo(size.width * 0.7648125, size.height * 0.8183500);
    path_22.cubicTo(
        size.width * 0.7655625,
        size.height * 0.8183500,
        size.width * 0.7661875,
        size.height * 0.8173500,
        size.width * 0.7661875,
        size.height * 0.8161500);
    path_22.lineTo(size.width * 0.7661875, size.height * 0.8161500);
    path_22.cubicTo(
        size.width * 0.7661875,
        size.height * 0.8149500,
        size.width * 0.7655625,
        size.height * 0.8139500,
        size.width * 0.7648125,
        size.height * 0.8139500);
    path_22.lineTo(size.width * 0.7493750, size.height * 0.8139500);
    path_22.cubicTo(
        size.width * 0.7486250,
        size.height * 0.8139500,
        size.width * 0.7480000,
        size.height * 0.8149500,
        size.width * 0.7480000,
        size.height * 0.8161500);
    path_22.lineTo(size.width * 0.7480000, size.height * 0.8161500);
    path_22.cubicTo(
        size.width * 0.7480000,
        size.height * 0.8173500,
        size.width * 0.7486250,
        size.height * 0.8183500,
        size.width * 0.7493750,
        size.height * 0.8183500);
    path_22.close();

    Paint paint22Fill = Paint()..style = PaintingStyle.fill;
    paint22Fill.color = const Color(0xffB7D3F3).withOpacity(1.0);
    canvas.drawPath(path_22, paint22Fill);

    Path path_23 = Path();
    path_23.moveTo(size.width * 0.6836562, size.height * 0.2770500);
    path_23.lineTo(size.width * 0.6297187, size.height * 0.2770500);
    path_23.cubicTo(
        size.width * 0.6272500,
        size.height * 0.2770500,
        size.width * 0.6252187,
        size.height * 0.2738000,
        size.width * 0.6252187,
        size.height * 0.2698500);
    path_23.lineTo(size.width * 0.6252187, size.height * 0.1865500);
    path_23.cubicTo(
        size.width * 0.6252187,
        size.height * 0.1826000,
        size.width * 0.6272500,
        size.height * 0.1793500,
        size.width * 0.6297187,
        size.height * 0.1793500);
    path_23.lineTo(size.width * 0.6836562, size.height * 0.1793500);
    path_23.cubicTo(
        size.width * 0.6861250,
        size.height * 0.1793500,
        size.width * 0.6881563,
        size.height * 0.1826000,
        size.width * 0.6881563,
        size.height * 0.1865500);
    path_23.lineTo(size.width * 0.6881563, size.height * 0.2698500);
    path_23.cubicTo(
        size.width * 0.6881563,
        size.height * 0.2738000,
        size.width * 0.6861250,
        size.height * 0.2770500,
        size.width * 0.6836562,
        size.height * 0.2770500);
    path_23.close();

    Paint paint23Fill = Paint()..style = PaintingStyle.fill;
    paint23Fill.color = const Color(0xffC0D8FB).withOpacity(1.0);
    canvas.drawPath(path_23, paint23Fill);

    Path path_24 = Path();
    path_24.moveTo(size.width * 0.6813125, size.height * 0.2728500);
    path_24.lineTo(size.width * 0.6320625, size.height * 0.2728500);
    path_24.cubicTo(
        size.width * 0.6298125,
        size.height * 0.2728500,
        size.width * 0.6279375,
        size.height * 0.2699000,
        size.width * 0.6279375,
        size.height * 0.2662500);
    path_24.lineTo(size.width * 0.6279375, size.height * 0.1902000);
    path_24.cubicTo(
        size.width * 0.6279375,
        size.height * 0.1866000,
        size.width * 0.6297812,
        size.height * 0.1836000,
        size.width * 0.6320625,
        size.height * 0.1836000);
    path_24.lineTo(size.width * 0.6813125, size.height * 0.1836000);
    path_24.cubicTo(
        size.width * 0.6835625,
        size.height * 0.1836000,
        size.width * 0.6854375,
        size.height * 0.1865500,
        size.width * 0.6854375,
        size.height * 0.1902000);
    path_24.lineTo(size.width * 0.6854375, size.height * 0.2662500);
    path_24.cubicTo(
        size.width * 0.6854375,
        size.height * 0.2698500,
        size.width * 0.6835938,
        size.height * 0.2728500,
        size.width * 0.6813125,
        size.height * 0.2728500);
    path_24.close();

    Paint paint24Fill = Paint()..style = PaintingStyle.fill;
    paint24Fill.color = const Color(0xffDFEBFD).withOpacity(1.0);
    canvas.drawPath(path_24, paint24Fill);

    Path path_25 = Path();
    path_25.moveTo(size.width * 0.6553750, size.height * 0.1925000);
    path_25.cubicTo(
        size.width * 0.6553750,
        size.height * 0.1913500,
        size.width * 0.6559687,
        size.height * 0.1904000,
        size.width * 0.6566875,
        size.height * 0.1904000);
    path_25.cubicTo(
        size.width * 0.6574062,
        size.height * 0.1904000,
        size.width * 0.6580000,
        size.height * 0.1913500,
        size.width * 0.6580000,
        size.height * 0.1925000);
    path_25.cubicTo(
        size.width * 0.6580000,
        size.height * 0.1936500,
        size.width * 0.6574062,
        size.height * 0.1946000,
        size.width * 0.6566875,
        size.height * 0.1946000);
    path_25.cubicTo(
        size.width * 0.6559687,
        size.height * 0.1946000,
        size.width * 0.6553750,
        size.height * 0.1936500,
        size.width * 0.6553750,
        size.height * 0.1925000);
    path_25.close();

    Paint paint25Fill = Paint()..style = PaintingStyle.fill;
    paint25Fill.color = const Color(0xffB7D3F3).withOpacity(1.0);
    canvas.drawPath(path_25, paint25Fill);

    Path path_26 = Path();
    path_26.moveTo(size.width * 0.6659063, size.height * 0.1954500);
    path_26.cubicTo(
        size.width * 0.6662500,
        size.height * 0.1944500,
        size.width * 0.6670625,
        size.height * 0.1941000,
        size.width * 0.6676875,
        size.height * 0.1946500);
    path_26.cubicTo(
        size.width * 0.6683125,
        size.height * 0.1952000,
        size.width * 0.6685312,
        size.height * 0.1965000,
        size.width * 0.6681875,
        size.height * 0.1975000);
    path_26.cubicTo(
        size.width * 0.6678437,
        size.height * 0.1985000,
        size.width * 0.6670312,
        size.height * 0.1988500,
        size.width * 0.6664062,
        size.height * 0.1983000);
    path_26.cubicTo(
        size.width * 0.6657812,
        size.height * 0.1977500,
        size.width * 0.6655625,
        size.height * 0.1964500,
        size.width * 0.6659063,
        size.height * 0.1954500);
    path_26.close();

    Paint paint26Fill = Paint()..style = PaintingStyle.fill;
    paint26Fill.color = const Color(0xffB7D3F3).withOpacity(1.0);
    canvas.drawPath(path_26, paint26Fill);

    Path path_27 = Path();
    path_27.moveTo(size.width * 0.6749062, size.height * 0.2069000);
    path_27.cubicTo(
        size.width * 0.6755000,
        size.height * 0.2063000,
        size.width * 0.6763125,
        size.height * 0.2065500,
        size.width * 0.6767188,
        size.height * 0.2075000);
    path_27.cubicTo(
        size.width * 0.6771250,
        size.height * 0.2084500,
        size.width * 0.6769375,
        size.height * 0.2097500,
        size.width * 0.6763438,
        size.height * 0.2104000);
    path_27.cubicTo(
        size.width * 0.6757500,
        size.height * 0.2110000,
        size.width * 0.6749375,
        size.height * 0.2107500,
        size.width * 0.6745313,
        size.height * 0.2098000);
    path_27.cubicTo(
        size.width * 0.6741250,
        size.height * 0.2088500,
        size.width * 0.6743125,
        size.height * 0.2075500,
        size.width * 0.6749062,
        size.height * 0.2069000);
    path_27.close();

    Paint paint27Fill = Paint()..style = PaintingStyle.fill;
    paint27Fill.color = const Color(0xffB7D3F3).withOpacity(1.0);
    canvas.drawPath(path_27, paint27Fill);

    Path path_28 = Path();
    path_28.moveTo(size.width * 0.6793750, size.height * 0.2246500);
    path_28.cubicTo(
        size.width * 0.6800938,
        size.height * 0.2246500,
        size.width * 0.6806875,
        size.height * 0.2256000,
        size.width * 0.6806875,
        size.height * 0.2267500);
    path_28.cubicTo(
        size.width * 0.6806875,
        size.height * 0.2279000,
        size.width * 0.6800937,
        size.height * 0.2288500,
        size.width * 0.6793750,
        size.height * 0.2288500);
    path_28.cubicTo(
        size.width * 0.6786562,
        size.height * 0.2288500,
        size.width * 0.6780625,
        size.height * 0.2279000,
        size.width * 0.6780625,
        size.height * 0.2267500);
    path_28.cubicTo(
        size.width * 0.6780625,
        size.height * 0.2256000,
        size.width * 0.6786562,
        size.height * 0.2246500,
        size.width * 0.6793750,
        size.height * 0.2246500);
    path_28.close();

    Paint paint28Fill = Paint()..style = PaintingStyle.fill;
    paint28Fill.color = const Color(0xffB7D3F3).withOpacity(1.0);
    canvas.drawPath(path_28, paint28Fill);

    Path path_29 = Path();
    path_29.moveTo(size.width * 0.6770937, size.height * 0.2452500);
    path_29.cubicTo(
        size.width * 0.6775937,
        size.height * 0.2460500,
        size.width * 0.6775937,
        size.height * 0.2474000,
        size.width * 0.6770937,
        size.height * 0.2482000);
    path_29.cubicTo(
        size.width * 0.6765937,
        size.height * 0.2490000,
        size.width * 0.6757500,
        size.height * 0.2490000,
        size.width * 0.6752500,
        size.height * 0.2482000);
    path_29.cubicTo(
        size.width * 0.6747500,
        size.height * 0.2474000,
        size.width * 0.6747500,
        size.height * 0.2460500,
        size.width * 0.6752500,
        size.height * 0.2452500);
    path_29.cubicTo(
        size.width * 0.6757500,
        size.height * 0.2444000,
        size.width * 0.6765937,
        size.height * 0.2444000,
        size.width * 0.6770937,
        size.height * 0.2452500);
    path_29.close();

    Paint paint29Fill = Paint()..style = PaintingStyle.fill;
    paint29Fill.color = const Color(0xffB7D3F3).withOpacity(1.0);
    canvas.drawPath(path_29, paint29Fill);

    Path path_30 = Path();
    path_30.moveTo(size.width * 0.6689063, size.height * 0.2583500);
    path_30.cubicTo(
        size.width * 0.6694062,
        size.height * 0.2591500,
        size.width * 0.6694062,
        size.height * 0.2605000,
        size.width * 0.6689063,
        size.height * 0.2613000);
    path_30.cubicTo(
        size.width * 0.6684062,
        size.height * 0.2621000,
        size.width * 0.6675625,
        size.height * 0.2621000,
        size.width * 0.6670625,
        size.height * 0.2613000);
    path_30.cubicTo(
        size.width * 0.6665625,
        size.height * 0.2605000,
        size.width * 0.6665625,
        size.height * 0.2591500,
        size.width * 0.6670625,
        size.height * 0.2583500);
    path_30.cubicTo(
        size.width * 0.6675625,
        size.height * 0.2575500,
        size.width * 0.6684062,
        size.height * 0.2575500,
        size.width * 0.6689063,
        size.height * 0.2583500);
    path_30.close();

    Paint paint30Fill = Paint()..style = PaintingStyle.fill;
    paint30Fill.color = const Color(0xffB7D3F3).withOpacity(1.0);
    canvas.drawPath(path_30, paint30Fill);

    Path path_31 = Path();
    path_31.moveTo(size.width * 0.6553750, size.height * 0.2651500);
    path_31.cubicTo(
        size.width * 0.6553750,
        size.height * 0.2640000,
        size.width * 0.6559687,
        size.height * 0.2630500,
        size.width * 0.6566875,
        size.height * 0.2630500);
    path_31.cubicTo(
        size.width * 0.6574062,
        size.height * 0.2630500,
        size.width * 0.6580000,
        size.height * 0.2640000,
        size.width * 0.6580000,
        size.height * 0.2651500);
    path_31.cubicTo(
        size.width * 0.6580000,
        size.height * 0.2663000,
        size.width * 0.6574062,
        size.height * 0.2672500,
        size.width * 0.6566875,
        size.height * 0.2672500);
    path_31.cubicTo(
        size.width * 0.6559687,
        size.height * 0.2672000,
        size.width * 0.6553750,
        size.height * 0.2663000,
        size.width * 0.6553750,
        size.height * 0.2651500);
    path_31.close();

    Paint paint31Fill = Paint()..style = PaintingStyle.fill;
    paint31Fill.color = const Color(0xffB7D3F3).withOpacity(1.0);
    canvas.drawPath(path_31, paint31Fill);

    Path path_32 = Path();
    path_32.moveTo(size.width * 0.6474375, size.height * 0.1954500);
    path_32.cubicTo(
        size.width * 0.6470938,
        size.height * 0.1944500,
        size.width * 0.6462813,
        size.height * 0.1941000,
        size.width * 0.6456563,
        size.height * 0.1946500);
    path_32.cubicTo(
        size.width * 0.6450313,
        size.height * 0.1952000,
        size.width * 0.6448125,
        size.height * 0.1965000,
        size.width * 0.6451563,
        size.height * 0.1975000);
    path_32.cubicTo(
        size.width * 0.6455000,
        size.height * 0.1985000,
        size.width * 0.6463125,
        size.height * 0.1988500,
        size.width * 0.6469375,
        size.height * 0.1983000);
    path_32.cubicTo(
        size.width * 0.6475625,
        size.height * 0.1977500,
        size.width * 0.6477812,
        size.height * 0.1964500,
        size.width * 0.6474375,
        size.height * 0.1954500);
    path_32.close();

    Paint paint32Fill = Paint()..style = PaintingStyle.fill;
    paint32Fill.color = const Color(0xffB7D3F3).withOpacity(1.0);
    canvas.drawPath(path_32, paint32Fill);

    Path path_33 = Path();
    path_33.moveTo(size.width * 0.6384063, size.height * 0.2069000);
    path_33.cubicTo(
        size.width * 0.6378125,
        size.height * 0.2063000,
        size.width * 0.6370000,
        size.height * 0.2065500,
        size.width * 0.6365938,
        size.height * 0.2075000);
    path_33.cubicTo(
        size.width * 0.6361875,
        size.height * 0.2084500,
        size.width * 0.6363750,
        size.height * 0.2097500,
        size.width * 0.6369688,
        size.height * 0.2104000);
    path_33.cubicTo(
        size.width * 0.6375625,
        size.height * 0.2110000,
        size.width * 0.6383750,
        size.height * 0.2107500,
        size.width * 0.6387813,
        size.height * 0.2098000);
    path_33.cubicTo(
        size.width * 0.6391875,
        size.height * 0.2088500,
        size.width * 0.6390313,
        size.height * 0.2075500,
        size.width * 0.6384063,
        size.height * 0.2069000);
    path_33.close();

    Paint paint33Fill = Paint()..style = PaintingStyle.fill;
    paint33Fill.color = const Color(0xffB7D3F3).withOpacity(1.0);
    canvas.drawPath(path_33, paint33Fill);

    Path path_34 = Path();
    path_34.moveTo(size.width * 0.6339375, size.height * 0.2246500);
    path_34.cubicTo(
        size.width * 0.6332187,
        size.height * 0.2246500,
        size.width * 0.6326250,
        size.height * 0.2256000,
        size.width * 0.6326250,
        size.height * 0.2267500);
    path_34.cubicTo(
        size.width * 0.6326250,
        size.height * 0.2279000,
        size.width * 0.6332187,
        size.height * 0.2288500,
        size.width * 0.6339375,
        size.height * 0.2288500);
    path_34.cubicTo(
        size.width * 0.6346562,
        size.height * 0.2288500,
        size.width * 0.6352500,
        size.height * 0.2279000,
        size.width * 0.6352500,
        size.height * 0.2267500);
    path_34.cubicTo(
        size.width * 0.6352500,
        size.height * 0.2256000,
        size.width * 0.6346563,
        size.height * 0.2246500,
        size.width * 0.6339375,
        size.height * 0.2246500);
    path_34.close();

    Paint paint34Fill = Paint()..style = PaintingStyle.fill;
    paint34Fill.color = const Color(0xffB7D3F3).withOpacity(1.0);
    canvas.drawPath(path_34, paint34Fill);

    Path path_35 = Path();
    path_35.moveTo(size.width * 0.6362188, size.height * 0.2452500);
    path_35.cubicTo(
        size.width * 0.6357188,
        size.height * 0.2460500,
        size.width * 0.6357188,
        size.height * 0.2474000,
        size.width * 0.6362188,
        size.height * 0.2482000);
    path_35.cubicTo(
        size.width * 0.6367188,
        size.height * 0.2490000,
        size.width * 0.6375625,
        size.height * 0.2490000,
        size.width * 0.6380625,
        size.height * 0.2482000);
    path_35.cubicTo(
        size.width * 0.6385625,
        size.height * 0.2474000,
        size.width * 0.6385625,
        size.height * 0.2460500,
        size.width * 0.6380625,
        size.height * 0.2452500);
    path_35.cubicTo(
        size.width * 0.6375625,
        size.height * 0.2444000,
        size.width * 0.6367500,
        size.height * 0.2444000,
        size.width * 0.6362188,
        size.height * 0.2452500);
    path_35.close();

    Paint paint35Fill = Paint()..style = PaintingStyle.fill;
    paint35Fill.color = const Color(0xffB7D3F3).withOpacity(1.0);
    canvas.drawPath(path_35, paint35Fill);

    Path path_36 = Path();
    path_36.moveTo(size.width * 0.6444062, size.height * 0.2583500);
    path_36.cubicTo(
        size.width * 0.6439063,
        size.height * 0.2591500,
        size.width * 0.6439063,
        size.height * 0.2605000,
        size.width * 0.6444062,
        size.height * 0.2613000);
    path_36.cubicTo(
        size.width * 0.6449062,
        size.height * 0.2621000,
        size.width * 0.6457500,
        size.height * 0.2621000,
        size.width * 0.6462500,
        size.height * 0.2613000);
    path_36.cubicTo(
        size.width * 0.6467500,
        size.height * 0.2605000,
        size.width * 0.6467500,
        size.height * 0.2591500,
        size.width * 0.6462500,
        size.height * 0.2583500);
    path_36.cubicTo(
        size.width * 0.6457500,
        size.height * 0.2575500,
        size.width * 0.6449375,
        size.height * 0.2575500,
        size.width * 0.6444062,
        size.height * 0.2583500);
    path_36.close();

    Paint paint36Fill = Paint()..style = PaintingStyle.fill;
    paint36Fill.color = const Color(0xffB7D3F3).withOpacity(1.0);
    canvas.drawPath(path_36, paint36Fill);

    Path path_37 = Path();
    path_37.moveTo(size.width * 0.6563438, size.height * 0.2267500);
    path_37.cubicTo(
        size.width * 0.6563438,
        size.height * 0.2256000,
        size.width * 0.6569375,
        size.height * 0.2246500,
        size.width * 0.6576563,
        size.height * 0.2246500);
    path_37.cubicTo(
        size.width * 0.6583750,
        size.height * 0.2246500,
        size.width * 0.6589687,
        size.height * 0.2256000,
        size.width * 0.6589687,
        size.height * 0.2267500);
    path_37.cubicTo(
        size.width * 0.6589687,
        size.height * 0.2279000,
        size.width * 0.6583750,
        size.height * 0.2288500,
        size.width * 0.6576563,
        size.height * 0.2288500);
    path_37.cubicTo(
        size.width * 0.6569063,
        size.height * 0.2288500,
        size.width * 0.6563438,
        size.height * 0.2279000,
        size.width * 0.6563438,
        size.height * 0.2267500);
    path_37.close();

    Paint paint37Fill = Paint()..style = PaintingStyle.fill;
    paint37Fill.color = const Color(0xffB7D3F3).withOpacity(1.0);
    canvas.drawPath(path_37, paint37Fill);

    Paint paint38Fill = Paint()..style = PaintingStyle.fill;
    paint38Fill.color = const Color(0xffB7D3F3).withOpacity(1.0);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.6574688, size.height * 0.2007000,
            size.width * 0.0003437500, size.height * 0.02605000),
        paint38Fill);

    Paint paint39Fill = Paint()..style = PaintingStyle.fill;
    paint39Fill.color = const Color(0xffB7D3F3).withOpacity(1.0);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.6563125, size.height * 0.2204500,
            size.width * 0.01096875, size.height * 0.001700000),
        paint39Fill);

    Path path_40 = Path();
    path_40.moveTo(size.width * 0.2404375, size.height * 0.7292500);
    path_40.cubicTo(
        size.width * 0.2404375,
        size.height * 0.7292500,
        size.width * 0.2558750,
        size.height * 0.7004000,
        size.width * 0.2413750,
        size.height * 0.6821000);
    path_40.cubicTo(
        size.width * 0.2413750,
        size.height * 0.6821000,
        size.width * 0.2307812,
        size.height * 0.6718500,
        size.width * 0.2221562,
        size.height * 0.6726500);
    path_40.cubicTo(
        size.width * 0.2221562,
        size.height * 0.6726500,
        size.width * 0.2344063,
        size.height * 0.7055000,
        size.width * 0.2304375,
        size.height * 0.7087500);
    path_40.cubicTo(
        size.width * 0.2264687,
        size.height * 0.7120000,
        size.width * 0.2184375,
        size.height * 0.6706000,
        size.width * 0.2184375,
        size.height * 0.6706000);
    path_40.cubicTo(
        size.width * 0.2184375,
        size.height * 0.6706000,
        size.width * 0.1943437,
        size.height * 0.6668500,
        size.width * 0.1865938,
        size.height * 0.6728000);
    path_40.cubicTo(
        size.width * 0.1865938,
        size.height * 0.6728000,
        size.width * 0.2071875,
        size.height * 0.6998000,
        size.width * 0.2028438,
        size.height * 0.7014000);
    path_40.cubicTo(
        size.width * 0.1985000,
        size.height * 0.7030000,
        size.width * 0.1762500,
        size.height * 0.6765500,
        size.width * 0.1762500,
        size.height * 0.6765500);
    path_40.cubicTo(
        size.width * 0.1762500,
        size.height * 0.6765500,
        size.width * 0.1538125,
        size.height * 0.6826500,
        size.width * 0.1550000,
        size.height * 0.7045500);
    path_40.cubicTo(
        size.width * 0.1561875,
        size.height * 0.7264500,
        size.width * 0.1639375,
        size.height * 0.7332000,
        size.width * 0.1673125,
        size.height * 0.7326000);
    path_40.cubicTo(
        size.width * 0.1706875,
        size.height * 0.7320000,
        size.width * 0.1905938,
        size.height * 0.7199000,
        size.width * 0.1910000,
        size.height * 0.7243500);
    path_40.cubicTo(
        size.width * 0.1914062,
        size.height * 0.7288000,
        size.width * 0.1794687,
        size.height * 0.7433500,
        size.width * 0.1710937,
        size.height * 0.7440500);
    path_40.cubicTo(
        size.width * 0.1710937,
        size.height * 0.7440500,
        size.width * 0.1869062,
        size.height * 0.7719500,
        size.width * 0.1974062,
        size.height * 0.7639000);
    path_40.cubicTo(
        size.width * 0.2079062,
        size.height * 0.7558500,
        size.width * 0.2088125,
        size.height * 0.7431000,
        size.width * 0.2153750,
        size.height * 0.7383000);
    path_40.cubicTo(
        size.width * 0.2219375,
        size.height * 0.7335000,
        size.width * 0.2275312,
        size.height * 0.7335000,
        size.width * 0.2248125,
        size.height * 0.7384000);
    path_40.cubicTo(
        size.width * 0.2220937,
        size.height * 0.7433000,
        size.width * 0.2102500,
        size.height * 0.7480500,
        size.width * 0.2065000,
        size.height * 0.7586500);
    path_40.cubicTo(
        size.width * 0.2027500,
        size.height * 0.7692500,
        size.width * 0.1994062,
        size.height * 0.7764000,
        size.width * 0.2102813,
        size.height * 0.7738000);
    path_40.cubicTo(
        size.width * 0.2211562,
        size.height * 0.7712000,
        size.width * 0.2388437,
        size.height * 0.7584500,
        size.width * 0.2395937,
        size.height * 0.7438500);
    path_40.cubicTo(
        size.width * 0.2404375,
        size.height * 0.7292500,
        size.width * 0.2404375,
        size.height * 0.7292500,
        size.width * 0.2404375,
        size.height * 0.7292500);
    path_40.close();

    Paint paint40Fill = Paint()..style = PaintingStyle.fill;
    paint40Fill.color = const Color(0xffC8DBF4).withOpacity(1.0);
    canvas.drawPath(path_40, paint40Fill);

    Path path_41 = Path();
    path_41.moveTo(size.width * 0.1660312, size.height * 0.7051500);
    path_41.cubicTo(
        size.width * 0.1660312,
        size.height * 0.7051500,
        size.width * 0.2269687,
        size.height * 0.7014000,
        size.width * 0.2404062,
        size.height * 0.7292500);
    path_41.cubicTo(
        size.width * 0.2404062,
        size.height * 0.7292500,
        size.width * 0.2433750,
        size.height * 0.7435000,
        size.width * 0.2525312,
        size.height * 0.7565000);
    path_41.lineTo(size.width * 0.2539687, size.height * 0.7627000);
    path_41.cubicTo(
        size.width * 0.2539687,
        size.height * 0.7627000,
        size.width * 0.2434062,
        size.height * 0.7449000,
        size.width * 0.2396250,
        size.height * 0.7438000);
    path_41.cubicTo(
        size.width * 0.2396562,
        size.height * 0.7438500,
        size.width * 0.2455625,
        size.height * 0.7093000,
        size.width * 0.1660312,
        size.height * 0.7051500);
    path_41.close();

    Paint paint41Fill = Paint()..style = PaintingStyle.fill;
    paint41Fill.color = const Color(0xffC8DBF4).withOpacity(1.0);
    canvas.drawPath(path_41, paint41Fill);

    Path path_42 = Path();
    path_42.moveTo(size.width * 0.2525625, size.height * 0.7565000);
    path_42.cubicTo(
        size.width * 0.2525625,
        size.height * 0.7565000,
        size.width * 0.2656250,
        size.height * 0.7719500,
        size.width * 0.2665625,
        size.height * 0.7996000);
    path_42.lineTo(size.width * 0.2641875, size.height * 0.7999500);
    path_42.cubicTo(
        size.width * 0.2641875,
        size.height * 0.7999500,
        size.width * 0.2600000,
        size.height * 0.7713500,
        size.width * 0.2524688,
        size.height * 0.7602000);
    path_42.cubicTo(
        size.width * 0.2449375,
        size.height * 0.7490500,
        size.width * 0.2525625,
        size.height * 0.7565000,
        size.width * 0.2525625,
        size.height * 0.7565000);
    path_42.close();

    Paint paint42Fill = Paint()..style = PaintingStyle.fill;
    paint42Fill.color = const Color(0xffC8DBF4).withOpacity(1.0);
    canvas.drawPath(path_42, paint42Fill);

    Path path_43 = Path();
    path_43.moveTo(size.width * 0.2944688, size.height * 0.6930000);
    path_43.cubicTo(
        size.width * 0.2944688,
        size.height * 0.6930000,
        size.width * 0.2698750,
        size.height * 0.6710000,
        size.width * 0.2813438,
        size.height * 0.6411000);
    path_43.cubicTo(
        size.width * 0.2813438,
        size.height * 0.6411000,
        size.width * 0.2905312,
        size.height * 0.6227500,
        size.width * 0.3003437,
        size.height * 0.6180500);
    path_43.cubicTo(
        size.width * 0.3003437,
        size.height * 0.6180500,
        size.width * 0.2950937,
        size.height * 0.6626000,
        size.width * 0.3003437,
        size.height * 0.6636500);
    path_43.cubicTo(
        size.width * 0.3055937,
        size.height * 0.6647000,
        size.width * 0.3039375,
        size.height * 0.6133000,
        size.width * 0.3039375,
        size.height * 0.6133000);
    path_43.cubicTo(
        size.width * 0.3039375,
        size.height * 0.6133000,
        size.width * 0.3298437,
        size.height * 0.5933500,
        size.width * 0.3400000,
        size.height * 0.5949500);
    path_43.cubicTo(
        size.width * 0.3400000,
        size.height * 0.5949500,
        size.width * 0.3239375,
        size.height * 0.6384500,
        size.width * 0.3291875,
        size.height * 0.6374500);
    path_43.cubicTo(
        size.width * 0.3344375,
        size.height * 0.6364000,
        size.width * 0.3524688,
        size.height * 0.5923500,
        size.width * 0.3524688,
        size.height * 0.5923500);
    path_43.cubicTo(
        size.width * 0.3524688,
        size.height * 0.5923500,
        size.width * 0.3790313,
        size.height * 0.5845000,
        size.width * 0.3832813,
        size.height * 0.6096500);
    path_43.cubicTo(
        size.width * 0.3875312,
        size.height * 0.6348000,
        size.width * 0.3806562,
        size.height * 0.6474000,
        size.width * 0.3767187,
        size.height * 0.6490000);
    path_43.cubicTo(
        size.width * 0.3727813,
        size.height * 0.6506000,
        size.width * 0.3475625,
        size.height * 0.6500500,
        size.width * 0.3482187,
        size.height * 0.6553000);
    path_43.cubicTo(
        size.width * 0.3488750,
        size.height * 0.6605500,
        size.width * 0.3659062,
        size.height * 0.6689500,
        size.width * 0.3754062,
        size.height * 0.6642000);
    path_43.cubicTo(
        size.width * 0.3754062,
        size.height * 0.6642000,
        size.width * 0.3649062,
        size.height * 0.7056500,
        size.width * 0.3511563,
        size.height * 0.7035500);
    path_43.cubicTo(
        size.width * 0.3374063,
        size.height * 0.7014500,
        size.width * 0.3331250,
        size.height * 0.6878000,
        size.width * 0.3245938,
        size.height * 0.6867500);
    path_43.cubicTo(
        size.width * 0.3160625,
        size.height * 0.6857000,
        size.width * 0.3098437,
        size.height * 0.6893500,
        size.width * 0.3140938,
        size.height * 0.6930500);
    path_43.cubicTo(
        size.width * 0.3183438,
        size.height * 0.6967000,
        size.width * 0.3327813,
        size.height * 0.6942500,
        size.width * 0.3396563,
        size.height * 0.7036000);
    path_43.cubicTo(
        size.width * 0.3465313,
        size.height * 0.7129500,
        size.width * 0.3521250,
        size.height * 0.7187500,
        size.width * 0.3393438,
        size.height * 0.7229500);
    path_43.cubicTo(
        size.width * 0.3265625,
        size.height * 0.7271500,
        size.width * 0.3036250,
        size.height * 0.7245000,
        size.width * 0.2990313,
        size.height * 0.7088000);
    path_43.cubicTo(
        size.width * 0.2944375,
        size.height * 0.6931000,
        size.width * 0.2944688,
        size.height * 0.6930000,
        size.width * 0.2944688,
        size.height * 0.6930000);
    path_43.close();

    Paint paint43Fill = Paint()..style = PaintingStyle.fill;
    paint43Fill.color = const Color(0xffC8DBF4).withOpacity(1.0);
    canvas.drawPath(path_43, paint43Fill);

    Path path_44 = Path();
    path_44.moveTo(size.width * 0.3711563, size.height * 0.6175000);
    path_44.cubicTo(
        size.width * 0.3711563,
        size.height * 0.6175000,
        size.width * 0.3023438,
        size.height * 0.6531500,
        size.width * 0.2944688,
        size.height * 0.6930000);
    path_44.cubicTo(
        size.width * 0.2944688,
        size.height * 0.6930000,
        size.width * 0.2947812,
        size.height * 0.7108500,
        size.width * 0.2879063,
        size.height * 0.7313000);
    path_44.lineTo(size.width * 0.2879063, size.height * 0.7391500);
    path_44.cubicTo(
        size.width * 0.2879063,
        size.height * 0.7391500,
        size.width * 0.2951250,
        size.height * 0.7124000,
        size.width * 0.2990625,
        size.height * 0.7087500);
    path_44.cubicTo(
        size.width * 0.2990312,
        size.height * 0.7087500,
        size.width * 0.2836250,
        size.height * 0.6741000,
        size.width * 0.3711563,
        size.height * 0.6175000);
    path_44.close();

    Paint paint44Fill = Paint()..style = PaintingStyle.fill;
    paint44Fill.color = const Color(0xffC8DBF4).withOpacity(1.0);
    canvas.drawPath(path_44, paint44Fill);

    Path path_45 = Path();
    path_45.moveTo(size.width * 0.2879062, size.height * 0.7313000);
    path_45.cubicTo(
        size.width * 0.2879062,
        size.height * 0.7313000,
        size.width * 0.2772812,
        size.height * 0.7571000,
        size.width * 0.2833438,
        size.height * 0.7885000);
    path_45.lineTo(size.width * 0.2860625, size.height * 0.7873500);
    path_45.cubicTo(
        size.width * 0.2860625,
        size.height * 0.7873500,
        size.width * 0.2834062,
        size.height * 0.7527500,
        size.width * 0.2889687,
        size.height * 0.7354000);
    path_45.cubicTo(
        size.width * 0.2945313,
        size.height * 0.7179500,
        size.width * 0.2879062,
        size.height * 0.7313000,
        size.width * 0.2879062,
        size.height * 0.7313000);
    path_45.close();

    Paint paint45Fill = Paint()..style = PaintingStyle.fill;
    paint45Fill.color = const Color(0xffC8DBF4).withOpacity(1.0);
    canvas.drawPath(path_45, paint45Fill);

    Path path_46 = Path();
    path_46.moveTo(size.width * 0.2553437, size.height * 0.6626000);
    path_46.cubicTo(
        size.width * 0.2553437,
        size.height * 0.6626000,
        size.width * 0.2877500,
        size.height * 0.6335500,
        size.width * 0.2726250,
        size.height * 0.5941500);
    path_46.cubicTo(
        size.width * 0.2726250,
        size.height * 0.5941500,
        size.width * 0.2605312,
        size.height * 0.5699500,
        size.width * 0.2475625,
        size.height * 0.5637500);
    path_46.cubicTo(
        size.width * 0.2475625,
        size.height * 0.5637500,
        size.width * 0.2544687,
        size.height * 0.6225000,
        size.width * 0.2475625,
        size.height * 0.6239000);
    path_46.cubicTo(
        size.width * 0.2406562,
        size.height * 0.6253000,
        size.width * 0.2428125,
        size.height * 0.5575500,
        size.width * 0.2428125,
        size.height * 0.5575500);
    path_46.cubicTo(
        size.width * 0.2428125,
        size.height * 0.5575500,
        size.width * 0.2086875,
        size.height * 0.5313000,
        size.width * 0.1952812,
        size.height * 0.5333500);
    path_46.cubicTo(
        size.width * 0.1952812,
        size.height * 0.5333500,
        size.width * 0.2164375,
        size.height * 0.5907000,
        size.width * 0.2095312,
        size.height * 0.5893500);
    path_46.cubicTo(
        size.width * 0.2026250,
        size.height * 0.5879500,
        size.width * 0.1788437,
        size.height * 0.5299000,
        size.width * 0.1788437,
        size.height * 0.5299000);
    path_46.cubicTo(
        size.width * 0.1788437,
        size.height * 0.5299000,
        size.width * 0.1438437,
        size.height * 0.5195500,
        size.width * 0.1382187,
        size.height * 0.5527000);
    path_46.cubicTo(
        size.width * 0.1325937,
        size.height * 0.5859000,
        size.width * 0.1416875,
        size.height * 0.6024500,
        size.width * 0.1468437,
        size.height * 0.6045500);
    path_46.cubicTo(
        size.width * 0.1520312,
        size.height * 0.6066000,
        size.width * 0.1852812,
        size.height * 0.6059500,
        size.width * 0.1844375,
        size.height * 0.6128500);
    path_46.cubicTo(
        size.width * 0.1835625,
        size.height * 0.6197500,
        size.width * 0.1610937,
        size.height * 0.6308000,
        size.width * 0.1485937,
        size.height * 0.6246000);
    path_46.cubicTo(
        size.width * 0.1485937,
        size.height * 0.6246000,
        size.width * 0.1624062,
        size.height * 0.6792000,
        size.width * 0.1805625,
        size.height * 0.6764500);
    path_46.cubicTo(
        size.width * 0.1987187,
        size.height * 0.6737000,
        size.width * 0.2043125,
        size.height * 0.6557000,
        size.width * 0.2155625,
        size.height * 0.6543500);
    path_46.cubicTo(
        size.width * 0.2267812,
        size.height * 0.6529500,
        size.width * 0.2350000,
        size.height * 0.6578000,
        size.width * 0.2293750,
        size.height * 0.6626500);
    path_46.cubicTo(
        size.width * 0.2237500,
        size.height * 0.6675000,
        size.width * 0.2047500,
        size.height * 0.6642500,
        size.width * 0.1956875,
        size.height * 0.6766000);
    path_46.cubicTo(
        size.width * 0.1866250,
        size.height * 0.6889500,
        size.width * 0.1792812,
        size.height * 0.6965500,
        size.width * 0.1961250,
        size.height * 0.7020500);
    path_46.cubicTo(
        size.width * 0.2129687,
        size.height * 0.7076000,
        size.width * 0.2432187,
        size.height * 0.7041000,
        size.width * 0.2492500,
        size.height * 0.6834000);
    path_46.cubicTo(
        size.width * 0.2553437,
        size.height * 0.6626000,
        size.width * 0.2553437,
        size.height * 0.6626000,
        size.width * 0.2553437,
        size.height * 0.6626000);
    path_46.close();

    Paint paint46Fill = Paint()..style = PaintingStyle.fill;
    paint46Fill.color = const Color(0xffD4E4F8).withOpacity(1.0);
    canvas.drawPath(path_46, paint46Fill);

    Path path_47 = Path();
    path_47.moveTo(size.width * 0.1542500, size.height * 0.5631000);
    path_47.cubicTo(
        size.width * 0.1542500,
        size.height * 0.5631000,
        size.width * 0.2449688,
        size.height * 0.6101000,
        size.width * 0.2553437,
        size.height * 0.6626500);
    path_47.cubicTo(
        size.width * 0.2553437,
        size.height * 0.6626500,
        size.width * 0.2549063,
        size.height * 0.6861500,
        size.width * 0.2639688,
        size.height * 0.7131000);
    path_47.lineTo(size.width * 0.2639688, size.height * 0.7234500);
    path_47.cubicTo(
        size.width * 0.2639688,
        size.height * 0.7234500,
        size.width * 0.2544688,
        size.height * 0.6882000,
        size.width * 0.2492813,
        size.height * 0.6833500);
    path_47.cubicTo(
        size.width * 0.2493125,
        size.height * 0.6833500,
        size.width * 0.2695938,
        size.height * 0.6377500,
        size.width * 0.1542500,
        size.height * 0.5631000);
    path_47.close();

    Paint paint47Fill = Paint()..style = PaintingStyle.fill;
    paint47Fill.color = const Color(0xffD4E4F8).withOpacity(1.0);
    canvas.drawPath(path_47, paint47Fill);

    Path path_48 = Path();
    path_48.moveTo(size.width * 0.2640000, size.height * 0.7131000);
    path_48.cubicTo(
        size.width * 0.2640000,
        size.height * 0.7131000,
        size.width * 0.2780000,
        size.height * 0.7471000,
        size.width * 0.2700000,
        size.height * 0.7885000);
    path_48.lineTo(size.width * 0.2664063, size.height * 0.7869500);
    path_48.cubicTo(
        size.width * 0.2664063,
        size.height * 0.7869500,
        size.width * 0.2699063,
        size.height * 0.7413500,
        size.width * 0.2625937,
        size.height * 0.7184500);
    path_48.cubicTo(
        size.width * 0.2552500,
        size.height * 0.6955000,
        size.width * 0.2640000,
        size.height * 0.7131000,
        size.width * 0.2640000,
        size.height * 0.7131000);
    path_48.close();

    Paint paint48Fill = Paint()..style = PaintingStyle.fill;
    paint48Fill.color = const Color(0xffD4E4F8).withOpacity(1.0);
    canvas.drawPath(path_48, paint48Fill);

    Path path_49 = Path();
    path_49.moveTo(size.width * 0.2564375, size.height * 0.8782000);
    path_49.cubicTo(
        size.width * 0.2213750,
        size.height * 0.8782000,
        size.width * 0.1929687,
        size.height * 0.8327500,
        size.width * 0.1929687,
        size.height * 0.7766500);
    path_49.lineTo(size.width * 0.3199063, size.height * 0.7766500);
    path_49.cubicTo(
        size.width * 0.3199063,
        size.height * 0.8327500,
        size.width * 0.2915000,
        size.height * 0.8782000,
        size.width * 0.2564375,
        size.height * 0.8782000);
    path_49.close();

    Paint paint49Fill = Paint()..style = PaintingStyle.fill;
    paint49Fill.color = const Color(0xffD4E4F8).withOpacity(1.0);
    canvas.drawPath(path_49, paint49Fill);

    Path path_50 = Path();
    path_50.moveTo(size.width * 0.1920938, size.height * 0.8833500);
    path_50.lineTo(size.width * 0.3207813, size.height * 0.8833500);
    path_50.lineTo(size.width * 0.3207813, size.height * 0.8833500);
    path_50.cubicTo(
        size.width * 0.3207813,
        size.height * 0.8764500,
        size.width * 0.3172812,
        size.height * 0.8708000,
        size.width * 0.3129375,
        size.height * 0.8708000);
    path_50.lineTo(size.width * 0.1999375, size.height * 0.8708000);
    path_50.cubicTo(
        size.width * 0.1955937,
        size.height * 0.8708500,
        size.width * 0.1920938,
        size.height * 0.8764500,
        size.width * 0.1920938,
        size.height * 0.8833500);
    path_50.lineTo(size.width * 0.1920938, size.height * 0.8833500);
    path_50.close();

    Paint paint50Fill = Paint()..style = PaintingStyle.fill;
    paint50Fill.color = const Color(0xffD4E4F8).withOpacity(1.0);
    canvas.drawPath(path_50, paint50Fill);

    Paint paint51Fill = Paint()..style = PaintingStyle.fill;
    paint51Fill.color = const Color(0xff9FC1F4).withOpacity(1.0);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.1915312, size.height * 0.7766500,
            size.width * 0.1304687, size.height * 0.003100000),
        paint51Fill);

    Path path_52 = Path();
    path_52.moveTo(size.width * 0.2818125, size.height * 0.5124000);
    path_52.lineTo(size.width * 0.5805312, size.height * 0.5124000);
    path_52.cubicTo(
        size.width * 0.5835000,
        size.height * 0.5124000,
        size.width * 0.5858750,
        size.height * 0.5085500,
        size.width * 0.5858750,
        size.height * 0.5038500);
    path_52.lineTo(size.width * 0.5858750, size.height * 0.4985000);
    path_52.cubicTo(
        size.width * 0.5858750,
        size.height * 0.4937500,
        size.width * 0.5834687,
        size.height * 0.4899500,
        size.width * 0.5805312,
        size.height * 0.4899500);
    path_52.lineTo(size.width * 0.2818125, size.height * 0.4899500);
    path_52.cubicTo(
        size.width * 0.2788438,
        size.height * 0.4899500,
        size.width * 0.2764687,
        size.height * 0.4938000,
        size.width * 0.2764687,
        size.height * 0.4985000);
    path_52.lineTo(size.width * 0.2764687, size.height * 0.5038500);
    path_52.cubicTo(
        size.width * 0.2764688,
        size.height * 0.5085500,
        size.width * 0.2788750,
        size.height * 0.5124000,
        size.width * 0.2818125,
        size.height * 0.5124000);
    path_52.close();

    Paint paint52Fill = Paint()..style = PaintingStyle.fill;
    paint52Fill.color = const Color(0xff2A4E96).withOpacity(1.0);
    canvas.drawPath(path_52, paint52Fill);

    Path path_53 = Path();
    path_53.moveTo(size.width * 0.2855937, size.height * 0.8831500);
    path_53.lineTo(size.width * 0.2854375, size.height * 0.8831000);
    path_53.cubicTo(
        size.width * 0.2834375,
        size.height * 0.8827000,
        size.width * 0.2820313,
        size.height * 0.8798500,
        size.width * 0.2822812,
        size.height * 0.8767500);
    path_53.lineTo(size.width * 0.3126250, size.height * 0.5011500);
    path_53.lineTo(size.width * 0.3296250, size.height * 0.5019500);
    path_53.lineTo(size.width * 0.2888438, size.height * 0.8794000);
    path_53.cubicTo(
        size.width * 0.2885937,
        size.height * 0.8818000,
        size.width * 0.2871563,
        size.height * 0.8834500,
        size.width * 0.2855937,
        size.height * 0.8831500);
    path_53.close();

    Paint paint53Fill = Paint()..style = PaintingStyle.fill;
    paint53Fill.color = const Color(0xff2A4E96).withOpacity(1.0);
    canvas.drawPath(path_53, paint53Fill);

    Path path_54 = Path();
    path_54.moveTo(size.width * 0.5816562, size.height * 0.8831500);
    path_54.lineTo(size.width * 0.5818125, size.height * 0.8831000);
    path_54.cubicTo(
        size.width * 0.5838125,
        size.height * 0.8827000,
        size.width * 0.5852188,
        size.height * 0.8798500,
        size.width * 0.5849687,
        size.height * 0.8767500);
    path_54.lineTo(size.width * 0.5546250, size.height * 0.5011500);
    path_54.lineTo(size.width * 0.5376250, size.height * 0.5019500);
    path_54.lineTo(size.width * 0.5784063, size.height * 0.8794000);
    path_54.cubicTo(
        size.width * 0.5786562,
        size.height * 0.8818000,
        size.width * 0.5800937,
        size.height * 0.8834500,
        size.width * 0.5816562,
        size.height * 0.8831500);
    path_54.close();

    Paint paint54Fill = Paint()..style = PaintingStyle.fill;
    paint54Fill.color = const Color(0xff2A4E96).withOpacity(1.0);
    canvas.drawPath(path_54, paint54Fill);

    Paint paint55Fill = Paint()..style = PaintingStyle.fill;
    paint55Fill.color = const Color(0xffB5453C).withOpacity(1.0);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.7675625, size.height * 0.5576500,
            size.width * 0.003562500, size.height * 0.06705000),
        paint55Fill);

    Path path_56 = Path();
    path_56.moveTo(size.width * 0.7648438, size.height * 0.5464000);
    path_56.lineTo(size.width * 0.7642812, size.height * 0.5585000);
    path_56.lineTo(size.width * 0.7677813, size.height * 0.5576000);
    path_56.close();

    Paint paint56Fill = Paint()..style = PaintingStyle.fill;
    paint56Fill.color = const Color(0xffEFCBAB).withOpacity(1.0);
    canvas.drawPath(path_56, paint56Fill);

    Paint paint57Fill = Paint()..style = PaintingStyle.fill;
    paint57Fill.color = const Color(0xffB5453C).withOpacity(1.0);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.7984687, size.height * 0.5631500,
            size.width * 0.003562500, size.height * 0.06705000),
        paint57Fill);

    Path path_58 = Path();
    path_58.moveTo(size.width * 0.8054063, size.height * 0.5521000);
    path_58.lineTo(size.width * 0.8023125, size.height * 0.5632000);
    path_58.lineTo(size.width * 0.8058125, size.height * 0.5642500);
    path_58.close();

    Paint paint58Fill = Paint()..style = PaintingStyle.fill;
    paint58Fill.color = const Color(0xffEFCBAB).withOpacity(1.0);
    canvas.drawPath(path_58, paint58Fill);

    Paint paint59Fill = Paint()..style = PaintingStyle.fill;
    paint59Fill.color = const Color(0xffB5453C).withOpacity(1.0);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.7940313, size.height * 0.5438500,
            size.width * 0.003562500, size.height * 0.06705000),
        paint59Fill);

    Path path_60 = Path();
    path_60.moveTo(size.width * 0.8010000, size.height * 0.5328000);
    path_60.lineTo(size.width * 0.7978750, size.height * 0.5438500);
    path_60.lineTo(size.width * 0.8013750, size.height * 0.5449000);
    path_60.close();

    Paint paint60Fill = Paint()..style = PaintingStyle.fill;
    paint60Fill.color = const Color(0xffEFCBAB).withOpacity(1.0);
    canvas.drawPath(path_60, paint60Fill);

    Paint paint61Fill = Paint()..style = PaintingStyle.fill;
    paint61Fill.color = const Color(0xffED7D2B).withOpacity(1.0);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.7774375, size.height * 0.5855500,
            size.width * 0.02800000, size.height * 0.06460000),
        paint61Fill);

    Paint paint62Fill = Paint()..style = PaintingStyle.fill;
    paint62Fill.color = const Color(0xffF99746).withOpacity(1.0);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.7634375, size.height * 0.5855500,
            size.width * 0.02800000, size.height * 0.06460000),
        paint62Fill);

    Path path_63 = Path();
    path_63.moveTo(size.width * 0.7532500, size.height * 0.8664000);
    path_63.cubicTo(
        size.width * 0.7529687,
        size.height * 0.8673500,
        size.width * 0.7523125,
        size.height * 0.8726000,
        size.width * 0.7511250,
        size.height * 0.8769000);
    path_63.lineTo(size.width * 0.7511250, size.height * 0.8769000);
    path_63.cubicTo(
        size.width * 0.7504375,
        size.height * 0.8795000,
        size.width * 0.7495312,
        size.height * 0.8817500,
        size.width * 0.7484375,
        size.height * 0.8825500);
    path_63.cubicTo(
        size.width * 0.7455000,
        size.height * 0.8847500,
        size.width * 0.7405938,
        size.height * 0.8810000,
        size.width * 0.7405938,
        size.height * 0.8810000);
    path_63.cubicTo(
        size.width * 0.7405938,
        size.height * 0.8810000,
        size.width * 0.7321563,
        size.height * 0.8825500,
        size.width * 0.7313438,
        size.height * 0.8819500);
    path_63.cubicTo(
        size.width * 0.7305313,
        size.height * 0.8813500,
        size.width * 0.7297188,
        size.height * 0.8611000,
        size.width * 0.7297188,
        size.height * 0.8611000);
    path_63.cubicTo(
        size.width * 0.7297188,
        size.height * 0.8611000,
        size.width * 0.7362813,
        size.height * 0.8502000,
        size.width * 0.7368438,
        size.height * 0.8499000);
    path_63.cubicTo(
        size.width * 0.7374375,
        size.height * 0.8496000,
        size.width * 0.7422188,
        size.height * 0.8536500,
        size.width * 0.7430313,
        size.height * 0.8536500);
    path_63.cubicTo(
        size.width * 0.7438438,
        size.height * 0.8536500,
        size.width * 0.7486563,
        size.height * 0.8486500,
        size.width * 0.7499375,
        size.height * 0.8499000);
    path_63.cubicTo(
        size.width * 0.7512813,
        size.height * 0.8511500,
        size.width * 0.7537187,
        size.height * 0.8648000,
        size.width * 0.7532500,
        size.height * 0.8664000);
    path_63.close();

    Paint paint63Fill = Paint()..style = PaintingStyle.fill;
    paint63Fill.color = const Color(0xffFFFFFF).withOpacity(1.0);
    canvas.drawPath(path_63, paint63Fill);

    Path path_64 = Path();
    path_64.moveTo(size.width * 0.7430625, size.height * 0.8536000);
    path_64.cubicTo(
        size.width * 0.7430625,
        size.height * 0.8536000,
        size.width * 0.7415938,
        size.height * 0.8589000,
        size.width * 0.7411875,
        size.height * 0.8593500);
    path_64.cubicTo(
        size.width * 0.7407812,
        size.height * 0.8598000,
        size.width * 0.7368438,
        size.height * 0.8498500,
        size.width * 0.7368438,
        size.height * 0.8498500);
    path_64.cubicTo(
        size.width * 0.7374688,
        size.height * 0.8495500,
        size.width * 0.7422500,
        size.height * 0.8536000,
        size.width * 0.7430625,
        size.height * 0.8536000);
    path_64.close();

    Paint paint64Fill = Paint()..style = PaintingStyle.fill;
    paint64Fill.color = const Color(0xffF2F7FE).withOpacity(1.0);
    canvas.drawPath(path_64, paint64Fill);

    Path path_65 = Path();
    path_65.moveTo(size.width * 0.7498750, size.height * 0.8551000);
    path_65.cubicTo(
        size.width * 0.7498750,
        size.height * 0.8551000,
        size.width * 0.7438750,
        size.height * 0.8639500,
        size.width * 0.7439687,
        size.height * 0.8648000);
    path_65.cubicTo(
        size.width * 0.7440312,
        size.height * 0.8656500,
        size.width * 0.7504375,
        size.height * 0.8715500,
        size.width * 0.7506875,
        size.height * 0.8713500);
    path_65.cubicTo(
        size.width * 0.7509062,
        size.height * 0.8711500,
        size.width * 0.7493125,
        size.height * 0.8644000,
        size.width * 0.7494062,
        size.height * 0.8632500);
    path_65.cubicTo(
        size.width * 0.7494688,
        size.height * 0.8621000,
        size.width * 0.7498750,
        size.height * 0.8551000,
        size.width * 0.7498750,
        size.height * 0.8551000);
    path_65.close();

    Paint paint65Fill = Paint()..style = PaintingStyle.fill;
    paint65Fill.color = const Color(0xffF2F7FE).withOpacity(1.0);
    canvas.drawPath(path_65, paint65Fill);

    Path path_66 = Path();
    path_66.moveTo(size.width * 0.7532500, size.height * 0.8664000);
    path_66.cubicTo(
        size.width * 0.7529687,
        size.height * 0.8673500,
        size.width * 0.7523125,
        size.height * 0.8726000,
        size.width * 0.7511250,
        size.height * 0.8769000);
    path_66.lineTo(size.width * 0.7511250, size.height * 0.8769000);
    path_66.lineTo(size.width * 0.7511250, size.height * 0.8769000);
    path_66.lineTo(size.width * 0.7518438, size.height * 0.8670000);
    path_66.lineTo(size.width * 0.7499688, size.height * 0.8498500);
    path_66.cubicTo(
        size.width * 0.7512813,
        size.height * 0.8511500,
        size.width * 0.7537187,
        size.height * 0.8648000,
        size.width * 0.7532500,
        size.height * 0.8664000);
    path_66.close();

    Paint paint66Fill = Paint()..style = PaintingStyle.fill;
    paint66Fill.color = const Color(0xffF2F7FE).withOpacity(1.0);
    canvas.drawPath(path_66, paint66Fill);

    Path path_67 = Path();
    path_67.moveTo(size.width * 0.7406250, size.height * 0.8810000);
    path_67.cubicTo(
        size.width * 0.7406250,
        size.height * 0.8810000,
        size.width * 0.7321875,
        size.height * 0.8825500,
        size.width * 0.7313750,
        size.height * 0.8819500);
    path_67.cubicTo(
        size.width * 0.7305625,
        size.height * 0.8813500,
        size.width * 0.7297500,
        size.height * 0.8611000,
        size.width * 0.7297500,
        size.height * 0.8611000);
    path_67.cubicTo(
        size.width * 0.7297500,
        size.height * 0.8611000,
        size.width * 0.7315938,
        size.height * 0.8715000,
        size.width * 0.7316250,
        size.height * 0.8720000);
    path_67.cubicTo(
        size.width * 0.7316563,
        size.height * 0.8725000,
        size.width * 0.7342500,
        size.height * 0.8714000,
        size.width * 0.7342500,
        size.height * 0.8714000);
    path_67.lineTo(size.width * 0.7406250, size.height * 0.8810000);
    path_67.close();

    Paint paint67Fill = Paint()..style = PaintingStyle.fill;
    paint67Fill.color = const Color(0xffF2F7FE).withOpacity(1.0);
    canvas.drawPath(path_67, paint67Fill);

    Path path_68 = Path();
    path_68.moveTo(size.width * 0.7319375, size.height * 0.8611000);
    path_68.lineTo(size.width * 0.7328750, size.height * 0.8664500);
    path_68.lineTo(size.width * 0.7347813, size.height * 0.8664500);
    path_68.lineTo(size.width * 0.7333750, size.height * 0.8642000);
    path_68.close();

    Paint paint68Fill = Paint()..style = PaintingStyle.fill;
    paint68Fill.color = const Color(0xffF2F7FE).withOpacity(1.0);
    canvas.drawPath(path_68, paint68Fill);

    Path path_69 = Path();
    path_69.moveTo(size.width * 0.3880000, size.height * 0.8664000);
    path_69.cubicTo(
        size.width * 0.3877187,
        size.height * 0.8673500,
        size.width * 0.3870625,
        size.height * 0.8726000,
        size.width * 0.3858750,
        size.height * 0.8769000);
    path_69.lineTo(size.width * 0.3858750, size.height * 0.8769000);
    path_69.cubicTo(
        size.width * 0.3851875,
        size.height * 0.8795000,
        size.width * 0.3842813,
        size.height * 0.8817500,
        size.width * 0.3831875,
        size.height * 0.8825500);
    path_69.cubicTo(
        size.width * 0.3802500,
        size.height * 0.8847500,
        size.width * 0.3753438,
        size.height * 0.8810000,
        size.width * 0.3753438,
        size.height * 0.8810000);
    path_69.cubicTo(
        size.width * 0.3753438,
        size.height * 0.8810000,
        size.width * 0.3669063,
        size.height * 0.8825500,
        size.width * 0.3660938,
        size.height * 0.8819500);
    path_69.cubicTo(
        size.width * 0.3652813,
        size.height * 0.8813500,
        size.width * 0.3644688,
        size.height * 0.8611000,
        size.width * 0.3644688,
        size.height * 0.8611000);
    path_69.cubicTo(
        size.width * 0.3644688,
        size.height * 0.8611000,
        size.width * 0.3710313,
        size.height * 0.8502000,
        size.width * 0.3715938,
        size.height * 0.8499000);
    path_69.cubicTo(
        size.width * 0.3721875,
        size.height * 0.8496000,
        size.width * 0.3769688,
        size.height * 0.8536500,
        size.width * 0.3777813,
        size.height * 0.8536500);
    path_69.cubicTo(
        size.width * 0.3785938,
        size.height * 0.8536500,
        size.width * 0.3834063,
        size.height * 0.8486500,
        size.width * 0.3846875,
        size.height * 0.8499000);
    path_69.cubicTo(
        size.width * 0.3860000,
        size.height * 0.8511500,
        size.width * 0.3884687,
        size.height * 0.8648000,
        size.width * 0.3880000,
        size.height * 0.8664000);
    path_69.close();

    Paint paint69Fill = Paint()..style = PaintingStyle.fill;
    paint69Fill.color = const Color(0xffFFFFFF).withOpacity(1.0);
    canvas.drawPath(path_69, paint69Fill);

    Path path_70 = Path();
    path_70.moveTo(size.width * 0.3778125, size.height * 0.8536000);
    path_70.cubicTo(
        size.width * 0.3778125,
        size.height * 0.8536000,
        size.width * 0.3763437,
        size.height * 0.8589000,
        size.width * 0.3759375,
        size.height * 0.8593500);
    path_70.cubicTo(
        size.width * 0.3755313,
        size.height * 0.8598000,
        size.width * 0.3715937,
        size.height * 0.8498500,
        size.width * 0.3715937,
        size.height * 0.8498500);
    path_70.cubicTo(
        size.width * 0.3721875,
        size.height * 0.8495500,
        size.width * 0.3770000,
        size.height * 0.8536000,
        size.width * 0.3778125,
        size.height * 0.8536000);
    path_70.close();

    Paint paint70Fill = Paint()..style = PaintingStyle.fill;
    paint70Fill.color = const Color(0xffF2F7FE).withOpacity(1.0);
    canvas.drawPath(path_70, paint70Fill);

    Path path_71 = Path();
    path_71.moveTo(size.width * 0.3846250, size.height * 0.8551000);
    path_71.cubicTo(
        size.width * 0.3846250,
        size.height * 0.8551000,
        size.width * 0.3786250,
        size.height * 0.8639500,
        size.width * 0.3787187,
        size.height * 0.8648000);
    path_71.cubicTo(
        size.width * 0.3787812,
        size.height * 0.8656500,
        size.width * 0.3851875,
        size.height * 0.8715500,
        size.width * 0.3854375,
        size.height * 0.8713500);
    path_71.cubicTo(
        size.width * 0.3856875,
        size.height * 0.8711500,
        size.width * 0.3840625,
        size.height * 0.8644000,
        size.width * 0.3841562,
        size.height * 0.8632500);
    path_71.cubicTo(
        size.width * 0.3842500,
        size.height * 0.8621000,
        size.width * 0.3846250,
        size.height * 0.8551000,
        size.width * 0.3846250,
        size.height * 0.8551000);
    path_71.close();

    Paint paint71Fill = Paint()..style = PaintingStyle.fill;
    paint71Fill.color = const Color(0xffF2F7FE).withOpacity(1.0);
    canvas.drawPath(path_71, paint71Fill);

    Path path_72 = Path();
    path_72.moveTo(size.width * 0.3880000, size.height * 0.8664000);
    path_72.cubicTo(
        size.width * 0.3877187,
        size.height * 0.8673500,
        size.width * 0.3870625,
        size.height * 0.8726000,
        size.width * 0.3858750,
        size.height * 0.8769000);
    path_72.lineTo(size.width * 0.3858750, size.height * 0.8769000);
    path_72.lineTo(size.width * 0.3858750, size.height * 0.8769000);
    path_72.lineTo(size.width * 0.3865937, size.height * 0.8670000);
    path_72.lineTo(size.width * 0.3847187, size.height * 0.8498500);
    path_72.cubicTo(
        size.width * 0.3860000,
        size.height * 0.8511500,
        size.width * 0.3884687,
        size.height * 0.8648000,
        size.width * 0.3880000,
        size.height * 0.8664000);
    path_72.close();

    Paint paint72Fill = Paint()..style = PaintingStyle.fill;
    paint72Fill.color = const Color(0xffF2F7FE).withOpacity(1.0);
    canvas.drawPath(path_72, paint72Fill);

    Path path_73 = Path();
    path_73.moveTo(size.width * 0.3753437, size.height * 0.8810000);
    path_73.cubicTo(
        size.width * 0.3753437,
        size.height * 0.8810000,
        size.width * 0.3669062,
        size.height * 0.8825500,
        size.width * 0.3660937,
        size.height * 0.8819500);
    path_73.cubicTo(
        size.width * 0.3652813,
        size.height * 0.8813500,
        size.width * 0.3644688,
        size.height * 0.8611000,
        size.width * 0.3644688,
        size.height * 0.8611000);
    path_73.cubicTo(
        size.width * 0.3644688,
        size.height * 0.8611000,
        size.width * 0.3663125,
        size.height * 0.8715000,
        size.width * 0.3663437,
        size.height * 0.8720000);
    path_73.cubicTo(
        size.width * 0.3663750,
        size.height * 0.8725000,
        size.width * 0.3689688,
        size.height * 0.8714000,
        size.width * 0.3689688,
        size.height * 0.8714000);
    path_73.lineTo(size.width * 0.3753437, size.height * 0.8810000);
    path_73.close();

    Paint paint73Fill = Paint()..style = PaintingStyle.fill;
    paint73Fill.color = const Color(0xffF2F7FE).withOpacity(1.0);
    canvas.drawPath(path_73, paint73Fill);

    Path path_74 = Path();
    path_74.moveTo(size.width * 0.3666562, size.height * 0.8611000);
    path_74.lineTo(size.width * 0.3675937, size.height * 0.8664500);
    path_74.lineTo(size.width * 0.3695312, size.height * 0.8664500);
    path_74.lineTo(size.width * 0.3680938, size.height * 0.8642000);
    path_74.close();

    Paint paint74Fill = Paint()..style = PaintingStyle.fill;
    paint74Fill.color = const Color(0xffF2F7FE).withOpacity(1.0);
    canvas.drawPath(path_74, paint74Fill);

    Path path_75 = Path();
    path_75.moveTo(size.width * 0.7796250, size.height * 0.6327500);
    path_75.cubicTo(
        size.width * 0.7793750,
        size.height * 0.6337500,
        size.width * 0.7788750,
        size.height * 0.6391500,
        size.width * 0.7778438,
        size.height * 0.6436000);
    path_75.lineTo(size.width * 0.7778438, size.height * 0.6436000);
    path_75.cubicTo(
        size.width * 0.7772188,
        size.height * 0.6463000,
        size.width * 0.7764063,
        size.height * 0.6486500,
        size.width * 0.7753125,
        size.height * 0.6496000);
    path_75.cubicTo(
        size.width * 0.7724063,
        size.height * 0.6521000,
        size.width * 0.7672813,
        size.height * 0.6487000,
        size.width * 0.7672813,
        size.height * 0.6487000);
    path_75.cubicTo(
        size.width * 0.7672813,
        size.height * 0.6487000,
        size.width * 0.7587813,
        size.height * 0.6510500,
        size.width * 0.7579375,
        size.height * 0.6505000);
    path_75.cubicTo(
        size.width * 0.7570938,
        size.height * 0.6499500,
        size.width * 0.7555313,
        size.height * 0.6294500,
        size.width * 0.7555313,
        size.height * 0.6294500);
    path_75.cubicTo(
        size.width * 0.7555313,
        size.height * 0.6294500,
        size.width * 0.7618125,
        size.height * 0.6178000,
        size.width * 0.7623750,
        size.height * 0.6174500);
    path_75.cubicTo(
        size.width * 0.7629688,
        size.height * 0.6171000,
        size.width * 0.7679688,
        size.height * 0.6207500,
        size.width * 0.7688125,
        size.height * 0.6207000);
    path_75.cubicTo(
        size.width * 0.7696563,
        size.height * 0.6206500,
        size.width * 0.7743438,
        size.height * 0.6151000,
        size.width * 0.7756875,
        size.height * 0.6162500);
    path_75.cubicTo(
        size.width * 0.7770625,
        size.height * 0.6174000,
        size.width * 0.7800312,
        size.height * 0.6311000,
        size.width * 0.7796250,
        size.height * 0.6327500);
    path_75.close();

    Paint paint75Fill = Paint()..style = PaintingStyle.fill;
    paint75Fill.color = const Color(0xffFFFFFF).withOpacity(1.0);
    canvas.drawPath(path_75, paint75Fill);

    Path path_76 = Path();
    path_76.moveTo(size.width * 0.7688125, size.height * 0.6207000);
    path_76.cubicTo(
        size.width * 0.7688125,
        size.height * 0.6207000,
        size.width * 0.7675000,
        size.height * 0.6262000,
        size.width * 0.7671250,
        size.height * 0.6267000);
    path_76.cubicTo(
        size.width * 0.7667187,
        size.height * 0.6272000,
        size.width * 0.7624062,
        size.height * 0.6174500,
        size.width * 0.7624062,
        size.height * 0.6174500);
    path_76.cubicTo(
        size.width * 0.7629687,
        size.height * 0.6171000,
        size.width * 0.7680000,
        size.height * 0.6207500,
        size.width * 0.7688125,
        size.height * 0.6207000);
    path_76.close();

    Paint paint76Fill = Paint()..style = PaintingStyle.fill;
    paint76Fill.color = const Color(0xffF2F7FE).withOpacity(1.0);
    canvas.drawPath(path_76, paint76Fill);

    Path path_77 = Path();
    path_77.moveTo(size.width * 0.7757812, size.height * 0.6216000);
    path_77.cubicTo(
        size.width * 0.7757812,
        size.height * 0.6216000,
        size.width * 0.7700000,
        size.height * 0.6311500,
        size.width * 0.7701250,
        size.height * 0.6320000);
    path_77.cubicTo(
        size.width * 0.7702500,
        size.height * 0.6328500,
        size.width * 0.7769375,
        size.height * 0.6382500,
        size.width * 0.7771562,
        size.height * 0.6380500);
    path_77.cubicTo(
        size.width * 0.7773750,
        size.height * 0.6378500,
        size.width * 0.7755313,
        size.height * 0.6311000,
        size.width * 0.7755625,
        size.height * 0.6299500);
    path_77.cubicTo(
        size.width * 0.7755938,
        size.height * 0.6288000,
        size.width * 0.7757812,
        size.height * 0.6216000,
        size.width * 0.7757812,
        size.height * 0.6216000);
    path_77.close();

    Paint paint77Fill = Paint()..style = PaintingStyle.fill;
    paint77Fill.color = const Color(0xffF2F7FE).withOpacity(1.0);
    canvas.drawPath(path_77, paint77Fill);

    Path path_78 = Path();
    path_78.moveTo(size.width * 0.7796250, size.height * 0.6327500);
    path_78.cubicTo(
        size.width * 0.7793750,
        size.height * 0.6337500,
        size.width * 0.7788750,
        size.height * 0.6391500,
        size.width * 0.7778438,
        size.height * 0.6436000);
    path_78.lineTo(size.width * 0.7778438, size.height * 0.6436000);
    path_78.lineTo(size.width * 0.7778438, size.height * 0.6436000);
    path_78.lineTo(size.width * 0.7782188, size.height * 0.6335000);
    path_78.lineTo(size.width * 0.7757188, size.height * 0.6162500);
    path_78.cubicTo(
        size.width * 0.7770625,
        size.height * 0.6174000,
        size.width * 0.7800312,
        size.height * 0.6311000,
        size.width * 0.7796250,
        size.height * 0.6327500);
    path_78.close();

    Paint paint78Fill = Paint()..style = PaintingStyle.fill;
    paint78Fill.color = const Color(0xffF2F7FE).withOpacity(1.0);
    canvas.drawPath(path_78, paint78Fill);

    Path path_79 = Path();
    path_79.moveTo(size.width * 0.7672813, size.height * 0.6487500);
    path_79.cubicTo(
        size.width * 0.7672813,
        size.height * 0.6487500,
        size.width * 0.7587813,
        size.height * 0.6511000,
        size.width * 0.7579375,
        size.height * 0.6505500);
    path_79.cubicTo(
        size.width * 0.7570938,
        size.height * 0.6500000,
        size.width * 0.7555313,
        size.height * 0.6295000,
        size.width * 0.7555313,
        size.height * 0.6295000);
    path_79.cubicTo(
        size.width * 0.7555313,
        size.height * 0.6295000,
        size.width * 0.7577500,
        size.height * 0.6398500,
        size.width * 0.7578125,
        size.height * 0.6404000);
    path_79.cubicTo(
        size.width * 0.7578750,
        size.height * 0.6409500,
        size.width * 0.7604688,
        size.height * 0.6395500,
        size.width * 0.7604688,
        size.height * 0.6395500);
    path_79.lineTo(size.width * 0.7672813, size.height * 0.6487500);
    path_79.close();

    Paint paint79Fill = Paint()..style = PaintingStyle.fill;
    paint79Fill.color = const Color(0xffF2F7FE).withOpacity(1.0);
    canvas.drawPath(path_79, paint79Fill);

    Path path_80 = Path();
    path_80.moveTo(size.width * 0.7577813, size.height * 0.6293000);
    path_80.lineTo(size.width * 0.7589063, size.height * 0.6346500);
    path_80.lineTo(size.width * 0.7608750, size.height * 0.6344500);
    path_80.lineTo(size.width * 0.7593437, size.height * 0.6323000);
    path_80.close();

    Paint paint80Fill = Paint()..style = PaintingStyle.fill;
    paint80Fill.color = const Color(0xffF2F7FE).withOpacity(1.0);
    canvas.drawPath(path_80, paint80Fill);

    Path path_81 = Path();
    path_81.moveTo(size.width * 0.7315313, size.height * 0.6374000);
    path_81.cubicTo(
        size.width * 0.7313125,
        size.height * 0.6381000,
        size.width * 0.7309375,
        size.height * 0.6417000,
        size.width * 0.7301562,
        size.height * 0.6448000);
    path_81.lineTo(size.width * 0.7301562, size.height * 0.6448000);
    path_81.cubicTo(
        size.width * 0.7296875,
        size.height * 0.6466500,
        size.width * 0.7290313,
        size.height * 0.6482500,
        size.width * 0.7281875,
        size.height * 0.6489000);
    path_81.cubicTo(
        size.width * 0.7259375,
        size.height * 0.6506500,
        size.width * 0.7219687,
        size.height * 0.6484500,
        size.width * 0.7219687,
        size.height * 0.6484500);
    path_81.cubicTo(
        size.width * 0.7219687,
        size.height * 0.6484500,
        size.width * 0.7153750,
        size.height * 0.6502000,
        size.width * 0.7147187,
        size.height * 0.6498500);
    path_81.cubicTo(
        size.width * 0.7140625,
        size.height * 0.6495000,
        size.width * 0.7128750,
        size.height * 0.6357000,
        size.width * 0.7128750,
        size.height * 0.6357000);
    path_81.cubicTo(
        size.width * 0.7128750,
        size.height * 0.6357000,
        size.width * 0.7177500,
        size.height * 0.6277000,
        size.width * 0.7181875,
        size.height * 0.6274500);
    path_81.cubicTo(
        size.width * 0.7186250,
        size.height * 0.6272000,
        size.width * 0.7225312,
        size.height * 0.6296000,
        size.width * 0.7231875,
        size.height * 0.6295000);
    path_81.cubicTo(
        size.width * 0.7238437,
        size.height * 0.6294500,
        size.width * 0.7274687,
        size.height * 0.6256000,
        size.width * 0.7285312,
        size.height * 0.6264000);
    path_81.cubicTo(
        size.width * 0.7295625,
        size.height * 0.6271000,
        size.width * 0.7318750,
        size.height * 0.6363000,
        size.width * 0.7315313,
        size.height * 0.6374000);
    path_81.close();

    Paint paint81Fill = Paint()..style = PaintingStyle.fill;
    paint81Fill.color = const Color(0xffFFFFFF).withOpacity(1.0);
    canvas.drawPath(path_81, paint81Fill);

    Path path_82 = Path();
    path_82.moveTo(size.width * 0.7231875, size.height * 0.6294500);
    path_82.cubicTo(
        size.width * 0.7231875,
        size.height * 0.6294500,
        size.width * 0.7221875,
        size.height * 0.6332000,
        size.width * 0.7218750,
        size.height * 0.6335500);
    path_82.cubicTo(
        size.width * 0.7215625,
        size.height * 0.6339000,
        size.width * 0.7182188,
        size.height * 0.6274000,
        size.width * 0.7182188,
        size.height * 0.6274000);
    path_82.cubicTo(
        size.width * 0.7186250,
        size.height * 0.6271500,
        size.width * 0.7225312,
        size.height * 0.6295000,
        size.width * 0.7231875,
        size.height * 0.6294500);
    path_82.close();

    Paint paint82Fill = Paint()..style = PaintingStyle.fill;
    paint82Fill.color = const Color(0xffC4D9E8).withOpacity(1.0);
    canvas.drawPath(path_82, paint82Fill);

    Path path_83 = Path();
    path_83.moveTo(size.width * 0.7285625, size.height * 0.6299500);
    path_83.cubicTo(
        size.width * 0.7285625,
        size.height * 0.6299500,
        size.width * 0.7240937,
        size.height * 0.6365000,
        size.width * 0.7241563,
        size.height * 0.6370500);
    path_83.cubicTo(
        size.width * 0.7242188,
        size.height * 0.6376000,
        size.width * 0.7294375,
        size.height * 0.6411500,
        size.width * 0.7296250,
        size.height * 0.6410000);
    path_83.cubicTo(
        size.width * 0.7298125,
        size.height * 0.6408500,
        size.width * 0.7283750,
        size.height * 0.6363500,
        size.width * 0.7284063,
        size.height * 0.6355500);
    path_83.cubicTo(
        size.width * 0.7284375,
        size.height * 0.6348000,
        size.width * 0.7285625,
        size.height * 0.6299500,
        size.width * 0.7285625,
        size.height * 0.6299500);
    path_83.close();

    Paint paint83Fill = Paint()..style = PaintingStyle.fill;
    paint83Fill.color = const Color(0xffDFEBF5).withOpacity(1.0);
    canvas.drawPath(path_83, paint83Fill);

    Path path_84 = Path();
    path_84.moveTo(size.width * 0.7315313, size.height * 0.6374000);
    path_84.cubicTo(
        size.width * 0.7313125,
        size.height * 0.6381000,
        size.width * 0.7309375,
        size.height * 0.6417000,
        size.width * 0.7301562,
        size.height * 0.6448000);
    path_84.lineTo(size.width * 0.7301562, size.height * 0.6448000);
    path_84.lineTo(size.width * 0.7301562, size.height * 0.6448000);
    path_84.lineTo(size.width * 0.7304375, size.height * 0.6379500);
    path_84.lineTo(size.width * 0.7285000, size.height * 0.6263500);
    path_84.cubicTo(
        size.width * 0.7295625,
        size.height * 0.6271000,
        size.width * 0.7318750,
        size.height * 0.6363000,
        size.width * 0.7315313,
        size.height * 0.6374000);
    path_84.close();

    Paint paint84Fill = Paint()..style = PaintingStyle.fill;
    paint84Fill.color = const Color(0xffC4D9E8).withOpacity(1.0);
    canvas.drawPath(path_84, paint84Fill);

    Path path_85 = Path();
    path_85.moveTo(size.width * 0.7219688, size.height * 0.6484500);
    path_85.cubicTo(
        size.width * 0.7219688,
        size.height * 0.6484500,
        size.width * 0.7153750,
        size.height * 0.6502000,
        size.width * 0.7147188,
        size.height * 0.6498500);
    path_85.cubicTo(
        size.width * 0.7140625,
        size.height * 0.6495000,
        size.width * 0.7128750,
        size.height * 0.6357000,
        size.width * 0.7128750,
        size.height * 0.6357000);
    path_85.cubicTo(
        size.width * 0.7128750,
        size.height * 0.6357000,
        size.width * 0.7145938,
        size.height * 0.6426500,
        size.width * 0.7146562,
        size.height * 0.6430000);
    path_85.cubicTo(
        size.width * 0.7147187,
        size.height * 0.6433500,
        size.width * 0.7167187,
        size.height * 0.6423500,
        size.width * 0.7167187,
        size.height * 0.6423500);
    path_85.lineTo(size.width * 0.7219688, size.height * 0.6484500);
    path_85.close();

    Paint paint85Fill = Paint()..style = PaintingStyle.fill;
    paint85Fill.color = const Color(0xffDFEBF5).withOpacity(1.0);
    canvas.drawPath(path_85, paint85Fill);

    Path path_86 = Path();
    path_86.moveTo(size.width * 0.7145937, size.height * 0.6354500);
    path_86.lineTo(size.width * 0.7154687, size.height * 0.6390500);
    path_86.lineTo(size.width * 0.7170000, size.height * 0.6389000);
    path_86.lineTo(size.width * 0.7158125, size.height * 0.6375000);
    path_86.close();

    Paint paint86Fill = Paint()..style = PaintingStyle.fill;
    paint86Fill.color = const Color(0xffDFEBF5).withOpacity(1.0);
    canvas.drawPath(path_86, paint86Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
