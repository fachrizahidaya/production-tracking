import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/service/terms_conditions_service.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/auth/terms_conditions_model.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({super.key});

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  TermsConditionsModel? termsConditions;

  @override
  void initState() {
    super.initState();
    TermsConditionsService.loadTermsConditions().then((value) {
      setState(() => termsConditions = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (termsConditions == null) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Terms Conditions'),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
          title: 'Terms Conditions',
          onReturn: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/dashboard');
            }
          }),
      body: ListView(
        padding: CustomTheme().padding('content'),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                termsConditions!.title,
                style: TextStyle(
                    fontSize: CustomTheme().fontSize('lg'),
                    fontWeight: CustomTheme().fontWeight('bold')),
              ),
              Text(
                termsConditions!.date,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          Text(termsConditions!.description),
          ...termsConditions!.data.map((section) {
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
