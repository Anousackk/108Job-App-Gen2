// ignore_for_file: prefer_if_null_operators, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:app/functions/colors.dart';
import 'package:app/functions/iconSize.dart';
import 'package:app/functions/textSize.dart';
import 'package:flutter/material.dart';
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
  }) : super(key: key);
  final String textTitle;
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
            widget.textColor == null ? AppColors.fontWhite : widget.textColor,
            widget.fontWeight == null ? FontWeight.normal : widget.fontWeight,
          ),
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
  }) : super(key: key);
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
            widget.textColor == null ? AppColors.fontWhite : widget.textColor,
            widget.fontWeight == null ? FontWeight.normal : widget.fontWeight,
          ),
        ),
      ),
      actions: widget.action,
    );
  }
}
