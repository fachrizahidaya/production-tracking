import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/custom_form.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController username;
  final TextEditingController password;
  final VoidCallback handlePress;
  final bool isDisabled;
  final bool isLoading;

  const LoginForm(
      {super.key,
      required this.username,
      required this.password,
      required this.handlePress,
      this.isDisabled = false,
      this.isLoading = false});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
      padding: PaddingColumn.screen,
      child: Form(
          child: Column(
        children: [
          Image.asset(
            'assets/images/login_logo.png',
            height: 100,
            width: 100,
            fit: BoxFit.contain,
          ),
          Text(
            'Textile Tracking',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          CustomForm(hintText: 'Username', controller: widget.username),
          CustomForm(
            hintText: 'Password',
            controller: widget.password,
            isPassword: true,
          ),
          FormButton(
            label: 'LOG IN',
            onPressed: widget.handlePress,
            isDisabled: widget.isDisabled,
            isLoading: widget.isLoading,
          )
        ].separatedBy(SizedBox(
          height: 16,
        )),
      )),
    ));
  }
}
