import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/helpers/service/eula_service.dart';
import 'package:textile_tracking/models/auth/eula_model.dart';

class Eula extends StatefulWidget {
  const Eula({super.key});

  @override
  State<Eula> createState() => _EulaState();
}

class _EulaState extends State<Eula> {
  EulaModel? eula;

  @override
  void initState() {
    super.initState();
    EulaService.loadEula().then((value) {
      setState(() => eula = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (eula == null) {
      return Scaffold(
        appBar: CustomAppBar(title: 'EULA'),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
          title: 'EULA',
          onReturn: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/dashboard');
            }
          }),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          Text(
            eula!.title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            eula!.date,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(eula!.description),
          SizedBox(height: 24),
          ...eula!.data.map((section) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(section.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(section.description),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
