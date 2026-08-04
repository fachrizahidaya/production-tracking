import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/components/master/form/login/custom_form.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController username;
  final TextEditingController password;
  final VoidCallback handlePress;
  final bool isDisabled;
  final bool isLoading;

  const LoginForm({
    super.key,
    required this.username,
    required this.password,
    required this.handlePress,
    this.isDisabled = false,
    this.isLoading = false,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;

        return Container(
          width: isMobile ? double.infinity : 480,
          constraints: BoxConstraints(
            maxWidth: 480,
            minHeight: isMobile ? 0 : 480,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 0,
            vertical: isMobile ? 24 : 0,
          ),
          padding: EdgeInsets.all(isMobile ? 24 : 32),
          decoration: CustomTheme().containerCardDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/ic_launcher.png',
                width: isMobile ? 80 : 100,
                height: isMobile ? 80 : 100,
              ),
              SizedBox(height: isMobile ? 20 : 32),
              Text(
                'Textile Automation Tracking',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile
                      ? CustomTheme().fontSize('lg')
                      : CustomTheme().fontSize('xl'),
                  color: CustomTheme().colors('text-primary'),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: isMobile ? 28 : 40),
              CustomForm(
                hintText: 'Username',
                controller: widget.username,
              ),
              SizedBox(height: 16),
              CustomForm(
                hintText: 'Password',
                controller: widget.password,
                isPassword: true,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FormButton(
                  label: 'LOG IN',
                  onPressed: widget.handlePress,
                  isDisabled: widget.isDisabled,
                  isLoading: widget.isLoading,
                  backgroundColor: CustomTheme().buttonColor('primary'),
                  customHeight: isMobile ? null : 56,
                  fontSize: isMobile
                      ? CustomTheme().fontSize('lg')
                      : CustomTheme().fontSize('xl'),
                ),
              ),
              SizedBox(height: isMobile ? 24 : 40),
              Text(
                'Version ${dotenv.env['APP_VERSION']!}',
                style: TextStyle(
                  fontSize: isMobile
                      ? CustomTheme().fontSize('sm')
                      : CustomTheme().fontSize('lg'),
                  color: CustomTheme().colors('text-secondary'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
