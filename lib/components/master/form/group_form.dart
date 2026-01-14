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

  const GroupForm(
      {super.key,
      this.label,
      this.formControl,
      this.req = false,
      this.disabled,
      this.errorText,
      this.errorMinHeight = 20});

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
