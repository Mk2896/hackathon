import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

Widget loaderOverlay({required Widget child}) {
  return LoaderOverlay(
    useDefaultLoading: false,
    disableBackButton: true,
    overlayWholeScreen: true,
    overlayColor: Colors.black,
    overlayOpacity: 0.8,
    child: child,
  );
}
