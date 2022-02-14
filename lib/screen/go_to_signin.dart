import 'package:app/painter/login_painter.dart';
import 'package:flutter/material.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/function/sized.dart';

import 'AuthenScreen/login_page.dart';

class GotoSignInPage extends StatelessWidget {
  const GotoSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomPaint(
                  size: Size(mediaWidthSized(context, 1.4),
                      (mediaWidthSized(context, 1.4) * 0.625).toDouble()),
                  painter: GotoLoginCustomPaint(),
                ),
                Text(
                  l.younotSignin,
                  style: TextStyle(
                    fontFamily: 'PoppinsSemiBold',
                    color: AppColors.blue,
                    fontSize: indexL == 0
                        ? mediaWidthSized(context, 20)
                        : mediaWidthSized(context, 17),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          settings: const RouteSettings(name: "/login"),
                          builder: (context) => const LoginPage()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.blue,
                    ),
                    child: Container(
                      height: mediaWidthSized(context, 10),
                      width: mediaWidthSized(context, 2.2),
                      alignment: Alignment.center,
                      child: Text(
                        l.gotoSignin,
                        style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'PoppinsRegular',
                            fontSize: indexL == 0
                                ? mediaWidthSized(context, 25)
                                : mediaWidthSized(context, 22)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
