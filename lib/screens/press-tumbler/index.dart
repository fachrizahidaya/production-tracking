import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';

class PressTumbler extends StatefulWidget {
  const PressTumbler({super.key});

  @override
  State<PressTumbler> createState() => _PressTumblerState();
}

class _PressTumblerState extends State<PressTumbler> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Press Tumbler'),
    );
  }
}
