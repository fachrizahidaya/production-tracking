import 'package:flutter/material.dart';
import 'package:production_tracking/components/master/layout/custom_app_bar.dart';

class CreateDyeing extends StatefulWidget {
  const CreateDyeing({super.key});

  @override
  State<CreateDyeing> createState() => _CreateDyeingState();
}

class _CreateDyeingState extends State<CreateDyeing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      appBar: CustomAppBar(
        title: 'Create Dyeing',
        onReturn: () {
          Navigator.pop(context);
        },
      ),
      body: null,
    );
  }
}
