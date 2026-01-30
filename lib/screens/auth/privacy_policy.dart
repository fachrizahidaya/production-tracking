import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/service/privacy_policy_service.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/auth/privacy_policy_model.dart';

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
        padding: CustomTheme().padding('content'),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                privacyPolicy!.title,
                style: TextStyle(
                    fontSize: CustomTheme().fontSize('lg'),
                    fontWeight: CustomTheme().fontWeight('bold')),
              ),
              Text(
                privacyPolicy!.date,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          Text(privacyPolicy!.description),
          ...privacyPolicy!.data.map((section) {
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
