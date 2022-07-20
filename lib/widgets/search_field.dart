import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/widgets/custom_text.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
    this.autofocus,
    this.topMargin,
    this.bottomMargin,
    this.height,
    this.isEnabled,
    this.isPassword,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.textAlignment,
    this.textCapitalization,
    required this.textController,
    this.textDirection,
    this.width,
    this.prefix,
    this.suffix,
    this.errorText,
    this.labelPosition,
    this.labelStyle,
    this.helperText,
    this.hintText,
    this.labelText,
    this.bottomPadding,
    this.leftPadding,
    this.rightPadding,
    this.topPadding,
    this.borderRadius,
    required this.onSuggestionSelect,
    required this.suggestionCallback,
  }) : super(key: key);

  final double? topMargin;
  final double? bottomMargin;
  final double? leftPadding;
  final double? rightPadding;
  final double? topPadding;
  final double? bottomPadding;
  final double? width;
  final double? height;
  final bool? autofocus;
  final TextEditingController textController;
  final bool? isEnabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final bool? isPassword;
  final TextAlign? textAlignment;
  final TextCapitalization? textCapitalization;
  final TextDirection? textDirection;
  final Widget? prefix;
  final Widget? suffix;
  final String? errorText;
  final FloatingLabelBehavior? labelStyle;
  final FloatingLabelAlignment? labelPosition;
  final String? helperText;
  final String? labelText;
  final String? hintText;
  final double? borderRadius;

  final Future<Iterable<dynamic>> Function(String) suggestionCallback;
  final void Function(dynamic) onSuggestionSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: topMargin ?? 0,
        bottom: bottomMargin ?? 0,
      ),
      padding: EdgeInsets.only(
        left: leftPadding ?? 0,
        right: rightPadding ?? 0,
        top: topPadding ?? 0,
        bottom: bottomPadding ?? 0,
      ),
      width: width ?? MediaQuery.of(context).size.width,
      height: height,
      child: TypeAheadField(
        suggestionsCallback: suggestionCallback,
        itemBuilder: (BuildContext context, suggestion) {
          return ListTile(
            title: CustomText(
              text: suggestion.toString(),
              textColor: const Color(primaryFontColor),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          );
        },
        hideOnEmpty: true,
        hideOnLoading: true,
        noItemsFoundBuilder: (_) => Center(),
        onSuggestionSelected: onSuggestionSelect,
        textFieldConfiguration: TextFieldConfiguration(
          autofocus: autofocus ?? false,
          controller: textController,
          cursorColor: Colors.black,
          cursorRadius: const Radius.circular(5),
          enabled: isEnabled ?? true,
          keyboardType: keyboardType ?? TextInputType.text,
          textInputAction: textInputAction,
          maxLength: maxLength,
          obscureText: isPassword ?? false,
          textAlign: textAlignment ?? TextAlign.start,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          textDirection: textDirection,
          decoration: InputDecoration(
            border: textFieldBorder(borderRadius: borderRadius),
            enabledBorder: textFieldBorder(borderRadius: borderRadius),
            disabledBorder: textFieldBorder(borderRadius: borderRadius),
            errorBorder: textFieldBorder(
                noBorder: false,
                borderColor: const Color(errorColor),
                borderRadius: borderRadius),
            focusedBorder: textFieldBorder(
                noBorder: false,
                borderColor: const Color(secondaryFontColor),
                borderRadius: borderRadius),
            prefixIcon: prefix,
            suffixIcon: suffix,
            errorText: errorText,
            filled: true,
            fillColor: const Color(0XFFF0F0F0),
            floatingLabelBehavior: labelStyle,
            floatingLabelAlignment: labelPosition,
            helperText: helperText,
            hintText: hintText,
            hintStyle: textStyle(
              textColor: const Color(secondaryFontColor),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            labelText: labelText,
            labelStyle: textStyle(
              textColor: const Color(secondaryFontColor),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

OutlineInputBorder textFieldBorder({
  bool noBorder = true,
  Color? borderColor,
  double borderWidth = 1.0,
  double? borderRadius,
}) {
  assert(noBorder || borderColor != null,
      "borderColor is required when noBorder is false");

  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius ?? 40),
    borderSide: noBorder
        ? const BorderSide(style: BorderStyle.none)
        : BorderSide(color: borderColor!, width: borderWidth),
  );
}
