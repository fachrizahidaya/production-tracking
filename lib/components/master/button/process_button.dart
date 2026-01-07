import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ProcessButton extends StatefulWidget {
  final data;
  final form;
  final isSubmitting;
  final labelProcess;
  final processId;
  final formKey;
  final handleSubmit;

  const ProcessButton(
      {super.key,
      this.processId,
      this.data,
      this.form,
      this.labelProcess,
      this.isSubmitting,
      this.handleSubmit,
      this.formKey});

  @override
  State<ProcessButton> createState() => _ProcessButtonState();
}

class _ProcessButtonState extends State<ProcessButton> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: CustomTheme().padding('card'),
        child: ValueListenableBuilder<bool>(
          valueListenable: widget.isSubmitting,
          builder: (context, isSubmitting, _) {
            return Row(
              children: [
                Expanded(
                  child: CancelButton(
                    label: 'Batal',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                    child: FormButton(
                  label: widget.labelProcess,
                  isLoading: isSubmitting,
                  isDisabled: widget.form?['wo_id'] == null ? true : false,
                  onPressed: () async {
                    widget.isSubmitting.value = true;
                    try {
                      if (!widget.formKey.currentState!.validate()) {
                        return;
                      }

                      await widget.handleSubmit(widget.data['id'] != null
                          ? widget.data['id'].toString()
                          : widget.processId);
                    } finally {
                      widget.isSubmitting.value = false;
                    }
                  },
                ))
              ].separatedBy(CustomTheme().hGap('xl')),
            );
          },
        ),
      ),
    );
  }
}
