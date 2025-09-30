import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';

class Stenter extends StatefulWidget {
  const Stenter({super.key});

  @override
  State<Stenter> createState() => _StenterState();
}

class _StenterState extends State<Stenter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Stenter'),
    );
  }
}
