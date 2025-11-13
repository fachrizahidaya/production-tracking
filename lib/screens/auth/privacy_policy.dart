import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/helpers/service/privacy_policy_service.dart';
import 'package:textile_tracking/models/master/privacy_policy_model.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  PrivacyPolicyModel? privacyPolicy;

  @override
  void initState() {
    super.initState();
    PrivacyPolicyService.loadPrivacyPolicy().then((value) {
      setState(() => privacyPolicy = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (privacyPolicy == null) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Privacy Policy'),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
          title: 'Privacy Policy',
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
            privacyPolicy!.title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            privacyPolicy!.date,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(privacyPolicy!.description),
          SizedBox(height: 24),
          ...privacyPolicy!.data.map((section) {
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
          }).toList(),
        ],
      ),
    );
  }
}
