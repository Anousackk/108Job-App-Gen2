import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/constant/colors.dart';
import 'package:app/constant/languagedemo.dart';
import 'package:app/function/sized.dart';

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({
    Key? key,
    this.controller,
    this.disablecontroller,
    this.onChanged,
    this.title,
    this.hintText,
  }) : super(key: key);
  final String? title;
  final TextEditingController? controller;
  final TextEditingController? disablecontroller;
  final Function(String)? onChanged;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '$title',
            style: TextStyle(
              fontFamily: 'PoppinsRegular',
              fontSize: mediaWidthSized(context, 28),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    // decoration: BoxDecoration(
                    //   color: AppColors.greyOpacity
                    //   borderRadius:
                    //       BorderRadius.all(Radius.circular(3)),
                    // ),
                    height: mediaWidthSized(context, 10),
                    width: 60,
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      controller: disablecontroller,
                      textAlign: TextAlign.center,
                      // maxLength: 8,
                      enabled: false,
                      style: TextStyle(
                        fontFamily: 'PoppinsRegular',
                        color: Colors.black,
                        fontSize: mediaWidthSized(context, 26),
                        // color: AppColors.blueSky
                      ),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5.0)),
                          filled: true,
                          fillColor: AppColors.greyOpacity,
                          labelStyle: const TextStyle(
                              fontFamily: 'PoppinsRegular',
                              color: Colors.black),
                          contentPadding: const EdgeInsets.only(bottom: 0),
                          focusColor: AppColors.blue,
                          hintStyle: TextStyle(
                              fontSize: mediaWidthSized(context, 26),
                              fontFamily: 'PoppinsRegular',
                              color: Colors.black),
                          hintText: "020"),
                    ),
                    // child: Text,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: mediaWidthSized(context, 10),
                      child: TextFormField(
                        onChanged: onChanged,
                        controller: controller,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                        ],
                        style: TextStyle(
                          fontFamily: 'PoppinsRegular',
                          color: Colors.black,
                          fontSize: mediaWidthSized(context, 26),
                          // color: AppColors.blueSky
                        ),
                        maxLength: 8,
                        decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(5.0)),
                            filled: true,
                            fillColor: AppColors.greyWhite,
                            labelStyle: const TextStyle(
                                fontFamily: 'PoppinsRegular',
                                color: Colors.black),
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, top: 4, right: 35),
                            focusColor: AppColors.blue,
                            hintStyle: const TextStyle(
                                fontFamily: 'PoppinsRegular',
                                color: AppColors.greyOpacity),
                            hintText: "$hintText"),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(right: 17),
                child: const Text(
                  'mobile-android',
                  style: TextStyle(
                      fontSize: 18,
                      color: AppColors.greyOpacity,
                      fontFamily: 'FontAwesomeProSolid'),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class NormalTextField extends StatelessWidget {
  const NormalTextField({
    Key? key,
    this.autofocus,
    this.obscure,
    this.onTap,
    this.title,
    this.hintIcon,
    this.hintText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextEditingController? controller;
  final bool? obscure, autofocus;
  final GestureTapCallback? onTap;
  final String? title, hintIcon, hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '$title',
            style: TextStyle(
              fontFamily: 'PoppinsRegular',
              fontSize: mediaWidthSized(context, 28),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              SizedBox(
                height: mediaWidthSized(context, 10),
                child: TextField(
                  autofocus: autofocus ?? false,
                  onChanged: onChanged,
                  controller: controller,
                  obscureText: obscure ?? false,
                  onSubmitted: onSubmitted,
                  style: const TextStyle(
                    fontFamily: 'PoppinsRegular',
                    color: Colors.black,
                    fontSize: 17,
                    // color: AppColors.blueSky
                  ),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(5.0)),
                      filled: true,
                      fillColor: AppColors.greyWhite,
                      labelStyle: const TextStyle(
                          fontFamily: 'PoppinsRegular', color: Colors.black),
                      contentPadding:
                          const EdgeInsets.only(left: 14.0, top: 4, right: 45),
                      focusColor: AppColors.blue,
                      hintStyle: const TextStyle(
                          fontSize: 17,
                          fontFamily: 'PoppinsRegular',
                          color: AppColors.greyOpacity),
                      hintText: "$hintText"),
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(
                    right: mediaWidthSized(context, 30),
                  ),
                  width: mediaWidthSized(context, 9),
                  height: (mediaWidthSized(context, 10)) - 10,
                  color: AppColors.greyWhite,
                  child: Text(
                    '$hintIcon',
                    style: const TextStyle(
                        fontSize: 17,
                        color: AppColors.greyOpacity,
                        fontFamily: 'FontAwesomeProSolid'),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class TextTitle extends StatelessWidget {
  const TextTitle({Key? key, this.title, this.margin}) : super(key: key);
  final String? title;
  final double? margin;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: margin ?? 20,
        ),
        Text(
          '$title',
          style: TextStyle(
              fontFamily: 'PoppinsSemiBold',
              fontSize: indexL == 0
                  ? mediaWidthSized(context, 24)
                  : mediaWidthSized(context, 21),
              color: AppColors.blue),
        )
      ],
    );
  }
}

class OnlyTextField extends StatelessWidget {
  const OnlyTextField(
      {Key? key,
      this.hintIcon,
      this.hintText,
      this.onChanged,
      this.onTap,
      this.obscure,
      this.controller,
      this.autofocus,
      this.color})
      : super(key: key);
  final bool? obscure;
  final GestureTapCallback? onTap;
  final Function(String)? onChanged;
  final bool? autofocus;
  final Color? color;
  final String? hintIcon, hintText;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          SizedBox(
            height: mediaWidthSized(context, 10),
            child: TextField(
              autofocus: autofocus ?? false,
              onChanged: onChanged,
              controller: controller,
              obscureText: obscure ?? false,
              style: TextStyle(
                fontFamily: 'PoppinsRegular',
                color: Colors.black,
                fontSize: indexL == 0 ? 17 : 19.5,
                // color: AppColors.blueSky
              ),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(5.0)),
                  filled: true,
                  fillColor: AppColors.greyWhite,
                  labelStyle: const TextStyle(
                      fontFamily: 'PoppinsRegular', color: Colors.black),
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, top: 4, right: 45),
                  focusColor: AppColors.blue,
                  hintStyle: TextStyle(
                      fontSize: indexL == 0 ? 17 : 19.5,
                      fontFamily: 'PoppinsRegular',
                      color: AppColors.greyOpacity),
                  hintText: "$hintText"),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(
                right: mediaWidthSized(context, 30),
              ),
              width: mediaWidthSized(context, 9),
              height: (mediaWidthSized(context, 10)) - 10,
              color: AppColors.greyWhite,
              child: Text(
                '$hintIcon',
                style: TextStyle(
                    fontSize: 17,
                    color: color ?? AppColors.yellow,
                    fontFamily: 'FontAwesomeProRegular'),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DropdownTextField extends StatelessWidget {
  const DropdownTextField(
      {Key? key,
      this.autofocus,
      this.obscure,
      this.onChanged,
      this.controller,
      this.hintText,
      this.dropdownItems,
      this.dropdownValue,
      this.dropdownOnchanged,
      this.onTap,
      this.icon,
      this.color,
      this.dropdownHint})
      : super(key: key);

  final GestureTapCallback? onTap;
  final bool? autofocus, obscure;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final String? hintText, icon, dropdownHint;
  final List<DropdownMenuItem<dynamic>>? dropdownItems;
  final Object? dropdownValue;
  final Function(dynamic)? dropdownOnchanged;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextField(
                    autofocus: autofocus ?? false,
                    onChanged: onChanged,
                    controller: controller,
                    obscureText: obscure ?? false,
                    style: const TextStyle(
                      fontFamily: 'PoppinsRegular',
                      color: Colors.black,
                      fontSize: 17,
                      // color: AppColors.blueSky
                    ),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(5.0)),
                        filled: true,
                        fillColor: AppColors.greyWhite,
                        labelStyle: const TextStyle(
                            fontFamily: 'PoppinsRegular', color: Colors.black),
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, top: 4, right: 45),
                        focusColor: AppColors.blue,
                        hintStyle: TextStyle(
                            fontSize: indexL == 0 ? 17 : 19.5,
                            fontFamily: 'PoppinsRegular',
                            color: AppColors.greyOpacity),
                        hintText: hintText),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: AppColors.greyWhite,
                    ),

                    // width: ,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text(
                          '$dropdownHint',
                          style: TextStyle(
                              fontSize: indexL == 0 ? 17 : 19.5,
                              fontFamily: 'PoppinsRegular',
                              color: AppColors.greyOpacity),
                        ),
                        isExpanded: true,
                        // focusColor: AppColors.White,
                        // dropdownColor: AppColors.White,
                        value: dropdownValue,
                        items: dropdownItems,
                        onChanged: dropdownOnchanged,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.greyWhite,
                    borderRadius: BorderRadius.circular(5.0)),
                alignment: Alignment.center,
                height: 100,
                width: mediaWidthSized(context, 8),
                child: Text(
                  '$icon',
                  style: TextStyle(
                      fontSize: 17,
                      color: color ?? AppColors.yellow,
                      fontFamily: 'FontAwesomeProRegular'),
                ),
              ))
        ],
      ),
    );
  }
}

class SingleDropdown extends StatelessWidget {
  const SingleDropdown(
      {Key? key,
      this.dropdownItems,
      this.dropdownValue,
      this.dropdownOnchanged,
      this.onTap,
      this.icon,
      this.color,
      this.dropdownHint,
      this.width})
      : super(key: key);
  final GestureTapCallback? onTap;
  final double? width;

  final String? icon, dropdownHint;
  final List<DropdownMenuItem<dynamic>>? dropdownItems;
  final Object? dropdownValue;
  final Function(dynamic)? dropdownOnchanged;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: AppColors.greyWhite,
                    ),

                    // width: ,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text(
                          '$dropdownHint',
                          style: TextStyle(
                              fontSize: indexL == 0 ? 17 : 19.5,
                              fontFamily: 'PoppinsRegular',
                              color: AppColors.greyOpacity),
                        ),
                        isExpanded: true,
                        // focusColor: AppColors.White,
                        // dropdownColor: AppColors.White,
                        value: dropdownValue,
                        items: dropdownItems,
                        onChanged: dropdownOnchanged,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: width == null ? 5 : 0,
          ),
          GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.greyWhite,
                    borderRadius: BorderRadius.circular(5.0)),
                alignment: Alignment.center,
                height: 50,
                width: width ?? mediaWidthSized(context, 8),
                child: Text(
                  '$icon',
                  style: TextStyle(
                      fontSize: 17,
                      color: color ?? AppColors.yellow,
                      fontFamily: 'FontAwesomeProRegular'),
                ),
              ))
        ],
      ),
    );
  }
}

class MultiDropdown extends StatelessWidget {
  const MultiDropdown(
      {Key? key,
      this.topdropdownItems,
      this.topdropdownValue,
      this.topdropdownOnchanged,
      this.topdropdownHint,
      this.bottomdropdownItems,
      this.bottomdropdownValue,
      this.bottomdropdownOnchanged,
      this.onTap,
      this.icon,
      this.color,
      this.bottomdropdownHint})
      : super(key: key);

  final GestureTapCallback? onTap;

  final String? icon, bottomdropdownHint, topdropdownHint;
  final List<DropdownMenuItem<dynamic>>? bottomdropdownItems, topdropdownItems;
  final Object? bottomdropdownValue, topdropdownValue;
  final Function(dynamic)? bottomdropdownOnchanged, topdropdownOnchanged;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: AppColors.greyWhite,
                    ),

                    // width: ,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text(
                          '$topdropdownHint',
                          style: TextStyle(
                              fontSize: indexL == 0 ? 17 : 19.5,
                              fontFamily: 'PoppinsRegular',
                              color: AppColors.greyOpacity),
                        ),
                        isExpanded: true,
                        // focusColor: AppColors.White,
                        // dropdownColor: AppColors.White,
                        value: topdropdownValue,
                        items: topdropdownItems,
                        onChanged: topdropdownOnchanged,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: AppColors.greyWhite,
                    ),

                    // width: ,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text(
                          '$bottomdropdownHint',
                          style: TextStyle(
                              fontSize: indexL == 0 ? 17 : 19.5,
                              fontFamily: 'PoppinsRegular',
                              color: AppColors.greyOpacity),
                        ),
                        isExpanded: true,
                        // focusColor: AppColors.White,
                        // dropdownColor: AppColors.White,
                        value: bottomdropdownValue,
                        items: bottomdropdownItems,
                        onChanged: bottomdropdownOnchanged,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.greyWhite,
                    borderRadius: BorderRadius.circular(5.0)),
                alignment: Alignment.center,
                height: 100,
                width: mediaWidthSized(context, 8),
                child: Text(
                  '$icon',
                  style: TextStyle(
                      fontSize: 17,
                      color: color ?? AppColors.yellow,
                      fontFamily: 'FontAwesomeProRegular'),
                ),
              ))
        ],
      ),
    );
  }
}
