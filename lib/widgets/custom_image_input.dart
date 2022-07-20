import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hackatron/global_constants.dart';
import 'package:hackatron/widgets/custom_button.dart';
import 'package:hackatron/widgets/custom_text.dart';
import 'package:image_picker/image_picker.dart';

class CustomImageInput extends StatefulWidget {
  const CustomImageInput({
    Key? key,
    required this.temporaryImagePath,
    required this.errorText,
    required this.pickImageMethod,
  }) : super(key: key);

  final String? errorText;
  final File? temporaryImagePath;
  final Future<void> Function(ImageSource source) pickImageMethod;
  @override
  State<CustomImageInput> createState() => _CustomImageInputState();
}

class _CustomImageInputState extends State<CustomImageInput> {
  void openBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: const Color(0XFF737373),
          child: SizedBox(
            height: 240,
            child: Column(
              children: [
                Container(
                  height: 60,
                  margin: const EdgeInsets.only(bottom: 20),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: const BoxDecoration(
                    color: Color(secondaryColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: ListTile(
                      onTap: () => widget.pickImageMethod(ImageSource.gallery),
                      title: const Center(
                        child: CustomText(
                          text: "From Gallery",
                          textColor: Color(primaryFontColor),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          fontFamily: "AbrilFatFace",
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  margin: const EdgeInsets.only(bottom: 20),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: const BoxDecoration(
                    color: Color(secondaryColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: ListTile(
                      onTap: () => widget.pickImageMethod(ImageSource.camera),
                      title: const Center(
                        child: CustomText(
                          text: "From Camera",
                          textColor: Color(primaryFontColor),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          fontFamily: "AbrilFatFace",
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  margin: const EdgeInsets.only(bottom: 20),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: const BoxDecoration(
                    color: Color(primaryColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: ListTile(
                      onTap: () => Navigator.pop(context),
                      title: const Center(
                        child: CustomText(
                          text: "Cancel",
                          textColor: Color(secondaryColor),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          fontFamily: "AbrilFatFace",
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.temporaryImagePath != null) ...[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            padding: const EdgeInsets.only(bottom: 20),
            child: Image(
                image: FileImage(widget.temporaryImagePath!),
                fit: BoxFit.contain),
          ),
        ],
        Center(
          child: CustomButton(
            buttonText: "Upload Image",
            buttonType: ButtonType.other,
            buttonMethod: () => openBottomSheet(),
            width: MediaQuery.of(context).size.width * 0.7,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        if (widget.errorText != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: CustomText(
              text: widget.errorText!,
              textColor: const Color(errorColor),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}
