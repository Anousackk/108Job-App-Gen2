import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/function/sized.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key, required this.internet}) : super(key: key);
  final bool internet;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: mediaWidthSized(context, 10),
              width: mediaWidthSized(context, 10),
              child: CircularProgressIndicator(
                strokeWidth: mediaWidthSized(context, 80),
                valueColor: const AlwaysStoppedAnimation(AppColors.blue),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
                internet == true
                    ? (indexL == 0
                        ? 'Waiting for internet...'
                        : 'ລໍຖ້າອິນເຕີເນັດ')
                    : l.loading,
                style: TextStyle(
                  color: AppColors.blue,
                  fontFamily: 'PoppinsSemiBold',
                  fontSize: mediaWidthSized(context, 25),
                ))
          ],
        ),
      ),
    );
  }
}
