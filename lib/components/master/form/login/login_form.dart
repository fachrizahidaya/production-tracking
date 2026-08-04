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
  final bool isMobile;
  final bool isSmallMobile;

<<<<<<< HEAD
  const LoginForm(
      {super.key,
      required this.username,
      required this.password,
      required this.handlePress,
      this.isDisabled = false,
      this.isLoading = false,
      this.isMobile = false,
      this.isSmallMobile = false});
=======
  const LoginForm({
    super.key,
    required this.username,
    required this.password,
    required this.handlePress,
    this.isDisabled = false,
    this.isLoading = false,
  });
>>>>>>> 0b551530 (fix: login form)

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final isMobile = widget.isMobile;
    final isSmallMobile = widget.isSmallMobile;

    final horizontalPadding = isMobile ? 24.0 : 40.0;

    final logoSize = isMobile ? (isSmallMobile ? 70.0 : 80.0) : 100.0;

    final titleSize = isMobile ? 18.0 : 20.0;

    final formSpacing = isMobile ? 16.0 : 20.0;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 480,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: isMobile ? 28 : 32,
        ),
        decoration: CustomTheme().containerCardDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // =========================
            // LOGO + TITLE
            // =========================
            Column(
              children: [
                Image.asset(
                  'assets/images/ic_launcher.png',
                  height: logoSize,
                  width: logoSize,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: isMobile ? 16 : 20,
                ),
                Text(
                  'Textile Automation Tracking',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w600,
                    color: CustomTheme().colors('text-primary'),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: isMobile ? 32 : 40,
            ),

            // =========================
            // FORM
            // =========================
            Column(
              children: [
                CustomForm(
                  hintText: 'Username',
                  controller: widget.username,
                ),
                CustomForm(
                  hintText: 'Password',
                  controller: widget.password,
                  isPassword: true,
                ),
                SizedBox(
                  height: isMobile ? 4 : 8,
                ),
                SizedBox(
                  width: double.infinity,
                  child: FormButton(
                    label: 'LOG IN',
                    onPressed: widget.handlePress,
                    isDisabled: widget.isDisabled,
                    isLoading: widget.isLoading,
                    backgroundColor: CustomTheme().buttonColor('primary'),
                    customHeight: isMobile ? 50.0 : 56.0,
                    fontSize: isMobile ? 16.0 : 18.0,
                  ),
                ),
              ].separatedBy(CustomTheme().vGap('xl')),
            ),

            SizedBox(
              height: isMobile ? 32 : 40,
            ),

            // =========================
            // VERSION
            // =========================
            Text(
              'Version ${dotenv.env['APP_VERSION'] ?? '-'}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 13.0 : 15.0,
                color: CustomTheme().colors('text-secondary'),
              ),
            ),
          ],
        ),
      ),
=======
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
>>>>>>> 0b551530 (fix: login form)
    );
  }
}
