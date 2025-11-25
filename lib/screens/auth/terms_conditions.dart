import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/helpers/service/terms_conditions_service.dart';
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
        padding: EdgeInsets.all(24),
        children: [
          Text(
            termsConditions!.title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            termsConditions!.date,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(termsConditions!.description),
          SizedBox(height: 24),
          ...termsConditions!.data.map((section) {
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
