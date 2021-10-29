import 'package:flutter/material.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/function/sized.dart';

class EmptyQuery extends StatefulWidget {
  const EmptyQuery({Key? key}) : super(key: key);

  @override
  _EmptyQueryState createState() => _EmptyQueryState();
}

class _EmptyQueryState extends State<EmptyQuery> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'folder-open',
            style: TextStyle(
                color: AppColors.greyShimmer,
                fontFamily: 'FontAwesomeProLight',
                fontSize: mediaWidthSized(context, 5)),
          ),
          Text(
            indexL == 0 ? 'Empty ' : 'ບໍ່ມີ',
            style: TextStyle(
                color: AppColors.greyShimmer,
                fontFamily: 'PoppinsSemiBold',
                fontSize: mediaWidthSized(context, 15)),
          ),
          SizedBox(height: mediaWidthSized(context, 3))
        ],
      ),
    );
  }
}
