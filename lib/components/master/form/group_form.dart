import 'package:flutter/material.dart';
import 'package:production_tracking/components/master/theme.dart';

class GroupForm extends StatelessWidget {
  final label;
  final formControl;
  final bool req;
  final bool? disabled;

  const GroupForm({
    super.key,
    this.label,
    this.formControl,
    this.req = false,
    this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = disabled ?? false;

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
                fontSize: 16,
              ),
            ),
            CustomTheme().hGap('sm'),
            if (req)
              Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        // SizedBox(height: 40, child: formControl),
        AbsorbPointer(
          absorbing: isDisabled, // Prevent interactions when disabled
          child: Opacity(
            opacity: isDisabled ? 0.5 : 1.0, // Adjust opacity if disabled
            child: formControl,
          ),
        ),
      ],
    );
  }
}
