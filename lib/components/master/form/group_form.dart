// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class GroupForm extends StatelessWidget {
  final label;
  final formControl;
  final bool req;
  final bool? disabled;
  final errorText;
  final errorMinHeight;
  final isGrade;

  const GroupForm(
      {super.key,
      this.label,
      this.formControl,
      this.req = false,
      this.disabled,
      this.errorText,
      this.errorMinHeight = 20,
      this.isGrade = false});

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = disabled ?? false;
    final bool hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                  fontSize: isGrade == true
                      ? CustomTheme().fontSize('sm')
                      : CustomTheme().fontSize('md'),
                  color: isDisabled
                      ? Colors.black.withOpacity(0.85)
                      : isGrade == true
                          ? Colors.grey.shade600
                          : Colors.black,
                  fontWeight: isGrade == true
                      ? CustomTheme().fontWeight('semibold')
                      : null),
            ),
            if (req)
              Text(
                '*',
                style: TextStyle(
                  color: CustomTheme().colors('danger'),
                  fontSize: CustomTheme().fontSize('lg'),
                ),
              ),
          ].separatedBy(
            CustomTheme().hGap('sm'),
          ),
        ),
        AbsorbPointer(
          absorbing: isDisabled,
          child: Opacity(
            opacity: isDisabled ? 0.5 : 1.0,
            child: formControl,
          ),
        ),
        if (hasError)
          Text(
            errorText!,
            style: TextStyle(
              color: CustomTheme().colors('danger'),
              fontSize: CustomTheme().fontSize('sm'),
            ),
          ),
      ].separatedBy(
        CustomTheme().vGap('lg'),
      ),
    );
  }
}
