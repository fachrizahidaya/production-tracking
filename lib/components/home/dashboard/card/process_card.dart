import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

class ProcessCard extends StatelessWidget {
  final child;
  final status;
  final forMachine;

  const ProcessCard(
      {super.key, this.child, this.status, this.forMachine = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 120),
      decoration: forMachine == true
          ? CustomTheme().machineStatusCardTheme(
              status == 'Diproses' ? Color(0xFFfffbea) : Color(0xfff0fdf4))
          : CustomTheme().processCardTheme(status == 'Menunggu Diproses'
              ? Color(0xFFfafafa)
              : status == 'Diproses'
                  ? Color(0xFFfffbea)
                  : Color(0xfff0fdf4)),
      padding: CustomTheme().padding('card'),
      child: child,
    );
  }
}
