import 'package:intl/intl.dart';

extension StringExtensions on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');

  String removeLeadingZeroAfterDecimal() => replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '');
}

extension DoubleExtensions on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

extension IntExtensions on int {
  String toHumanReadable() => NumberFormat.compact().format(this);
}
