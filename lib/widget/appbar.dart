// ignore_for_file: prefer_if_null_operators, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, unnecessary_null_in_if_null_operators

import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/textSize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class AppBarDefault extends StatefulWidget implements PreferredSizeWidget {
  const AppBarDefault({
    Key? key,
    required this.textTitle,
    this.textColor,
    required this.leadingIcon,
    this.leadingPress,
    this.backgroundColor,
    this.actionTitle,
    this.fontWeight,
    this.textTitleFontFamily,
  }) : super(key: key);
  final String textTitle;
  final String? textTitleFontFamily;
  final FontWeight? fontWeight;
  final actionTitle;
  final Color? backgroundColor, textColor;
  final Icon leadingIcon;

  final Function()? leadingPress;

  @override
  State<AppBarDefault> createState() => _AppBarDefaultState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AppBarDefaultState extends State<AppBarDefault> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: widget.backgroundColor == null
          ? AppColors.backgroundAppBar
          : widget.backgroundColor,
      toolbarHeight: 15.w,
      leading: IconButton(
        onPressed: widget.leadingPress,
        iconSize: IconSize.mIcon,
        icon: widget.leadingIcon,
        color:
            widget.textColor == null ? AppColors.fontWhite : widget.textColor,
      ),
      centerTitle: true,
      title: Container(
        child: Text(
          widget.textTitle,
          style: appbarTextMedium(
            widget.textTitleFontFamily ?? null,
            widget.textColor == null ? AppColors.fontWhite : widget.textColor,
            widget.fontWeight == null ? FontWeight.normal : widget.fontWeight,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      actions: [
        Container(
          padding: EdgeInsets.only(right: 20),
          alignment: Alignment.center,
          child: Text(
            widget.actionTitle == null ? "" : widget.actionTitle,
          ),
        ),
      ],
    );
  }
}

class AppBarAddAction extends StatefulWidget implements PreferredSizeWidget {
  const AppBarAddAction({
    Key? key,
    required this.textTitle,
    this.textColor,
    required this.leadingIcon,
    this.leadingPress,
    this.backgroundColor,
    this.actionTitle,
    this.action,
    this.fontWeight,
    this.toolbarHeightAppBar,
    this.systemOverlayStyleColor,
  }) : super(key: key);
  final SystemUiOverlayStyle? systemOverlayStyleColor;
  final double? toolbarHeightAppBar;
  final String textTitle;
  final FontWeight? fontWeight;

  final actionTitle;
  final Color? backgroundColor, textColor;
  final Icon leadingIcon;

  final Function()? leadingPress;
  final List<Widget>? action;

  @override
  State<AppBarAddAction> createState() => _AppBarAddActionState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AppBarAddActionState extends State<AppBarAddAction> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: widget.systemOverlayStyleColor == null
          ? SystemUiOverlayStyle.dark
          : widget.systemOverlayStyleColor,
      backgroundColor: widget.backgroundColor == null
          ? AppColors.backgroundAppBar
          : widget.backgroundColor,
      toolbarHeight: widget.toolbarHeightAppBar == null
          ? 15.w
          : widget.toolbarHeightAppBar,
      leading: IconButton(
        onPressed: widget.leadingPress,
        iconSize: IconSize.mIcon,
        icon: widget.leadingIcon,
        color:
            widget.textColor == null ? AppColors.fontWhite : widget.textColor,
      ),
      centerTitle: true,
      title: Container(
        child: Text(
          widget.textTitle,
          style: appbarTextMedium(
            null,
            widget.textColor == null ? AppColors.fontWhite : widget.textColor,
            widget.fontWeight == null ? FontWeight.normal : widget.fontWeight,
          ),
        ),
      ),
      actions: widget.action,
    );
  }
}

class AppBarThreeWidgt extends StatefulWidget {
  const AppBarThreeWidgt(
      {Key? key,
      this.leading,
      this.title,
      this.actions,
      this.boxShadow,
      this.boxColor})
      : super(key: key);
  final Widget? leading, title, actions;
  final Color? boxColor;
  final List<BoxShadow>? boxShadow;

  @override
  State<AppBarThreeWidgt> createState() => _AppBarThreeWidgtState();
}

class _AppBarThreeWidgtState extends State<AppBarThreeWidgt> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      // height: 80,
      decoration: BoxDecoration(
        color: widget.boxColor == null ? AppColors.primary600 : widget.boxColor,
        // borderRadius: BorderRadius.only(
        //   bottomLeft: Radius.circular(40),
        //   bottomRight: Radius.circular(40),
        // ),
        // boxShadow: widget.boxShadow == null
        //     ? [
        //         BoxShadow(
        //           color: AppColors.grey.withOpacity(0.15),
        //           spreadRadius: 3,
        //           blurRadius: 16,
        //           offset: Offset(0, 10),
        //         ),
        //       ]
        //     : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.leading ?? Container(),
          widget.title ?? Container(),
          widget.actions ?? Container(),
        ],
      ),
    );
  }
}
