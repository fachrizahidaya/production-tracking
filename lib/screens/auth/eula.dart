import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/service/eula_service.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
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
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eula!.title,
                style: TextStyle(
                    fontSize: CustomTheme().fontSize('lg'),
                    fontWeight: CustomTheme().fontWeight('bold')),
              ),
              Text(
                eula!.date,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          Text(eula!.description),
          ...eula!.data.map((section) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(section.name,
                    style: TextStyle(
                        fontSize: CustomTheme().fontSize('xl'),
                        fontWeight: CustomTheme().fontWeight('bold'))),
                Text(section.description),
              ].separatedBy(CustomTheme().vGap('lg')),
            );
          }),
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }
}
