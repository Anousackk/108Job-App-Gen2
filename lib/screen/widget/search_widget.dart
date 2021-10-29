import 'package:flutter/material.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/function/sized.dart';

class HeaderSortbyAndSelect extends StatelessWidget {
  const HeaderSortbyAndSelect({Key? key, this.title, this.onTap, this.height})
      : super(key: key);
  final String? title;
  final GestureTapCallback? onTap;
  final int? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mediaWidthSized(context, 1) / height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: Text(
              '$title',
              style: TextStyle(
                color: AppColors.grey,
                fontFamily: 'PoppinsMedium',
                fontSize: indexL == 0
                    ? mediaWidthSized(context, 28)
                    : mediaWidthSized(context, 25),
              ),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              child: Text(
                l.clear,
                style: TextStyle(
                  color: AppColors.yellow,
                  fontFamily: 'PoppinsMedium',
                  fontSize: indexL == 0
                      ? mediaWidthSized(context, 30)
                      : mediaWidthSized(context, 27),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListItemForSearch extends StatelessWidget {
  const ListItemForSearch(
      {Key? key, this.onTap, this.onTapIcon, this.title, this.height})
      : super(key: key);
  final GestureTapCallback? onTap;
  final GestureTapCallback? onTapIcon;
  final String? title;
  final int? height;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.only(left: 10),
      decoration: const BoxDecoration(
          // color: AppColors.BlueSky,
          border: Border(top: BorderSide(width: 0.3, color: AppColors.grey))),
      height: mediaWidthSized(context, 1) / height,
      width: mediaWidthSized(context, 40),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: AppColors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '$title',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.grey,
                    fontFamily: 'PoppinsRegular',
                    fontSize: mediaWidthSized(context, 30),
                  ),
                ),
              ),
              Container(
                height: mediaWidthSized(context, 14),
                decoration: const BoxDecoration(
                    border: Border(
                        left: BorderSide(width: 0.3, color: AppColors.grey))),
                child: IconButton(
                  onPressed: onTapIcon,
                  icon: Text(
                    'times',
                    style: TextStyle(
                      fontFamily: 'FontAwesomeProlight',
                      fontSize: mediaWidthSized(context, 28),
                      color: AppColors.greyOpacity,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
