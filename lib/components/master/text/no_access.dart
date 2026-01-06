import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

class NoAccess extends StatelessWidget {
  const NoAccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: CustomTheme().padding('content'),
        child: Text(
          'No Data',
          style: TextStyle(
              fontSize: CustomTheme().fontSize('lg'),
              color: CustomTheme().colors('text-primary')),
        ),
      ),
    );
  }
}
