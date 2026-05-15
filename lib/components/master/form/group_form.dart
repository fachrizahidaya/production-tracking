// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class GroupForm extends StatefulWidget {
  final dynamic label;
  final dynamic formControl;
  final bool req;
  final bool? disabled;
  final dynamic errorText;
  final dynamic errorMinHeight;
  final dynamic isGrade;

  const GroupForm({
    super.key,
    this.label,
    this.formControl,
    this.req = false,
    this.disabled,
    this.errorText,
    this.errorMinHeight = 20,
    this.isGrade = false,
  });

  @override
  State<GroupForm> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.disabled ?? false;
    final bool hasError =
        widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontSize: widget.isGrade == true
                    ? CustomTheme().fontSize('sm')
                    : CustomTheme().fontSize('md'),
                color: isDisabled
                    ? Colors.black.withOpacity(0.85)
                    : widget.isGrade == true
                        ? Colors.grey.shade600
                        : Colors.black,
                fontWeight: widget.isGrade == true
                    ? CustomTheme().fontWeight('semibold')
                    : null,
              ),
            ),
            if (widget.req)
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
            child: widget.formControl,
          ),
        ),
        if (hasError)
          Text(
            widget.errorText!,
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
