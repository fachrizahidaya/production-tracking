// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/process/create/form_info_tab.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class TabSection extends StatefulWidget {
  final id;
  final title;
  final label;
  final maklonName;
  final isMaklon;
  final form;
  final formKey;
  final woData;
  final processData;
  final withMaklonOrMachine;
  final withNoMaklonOrMachine;
  final withOnlyMaklon;
  final handleSubmit;
  final firstLoading;
  final isSubmitting;
  final selectMachine;
  final selectWorkOrder;

  const TabSection(
      {super.key,
      this.title,
      this.label,
      this.firstLoading,
      this.form,
      this.formKey,
      this.handleSubmit,
      this.id,
      this.isSubmitting,
      this.maklonName,
      this.selectMachine,
      this.selectWorkOrder,
      this.withMaklonOrMachine,
      this.withNoMaklonOrMachine,
      this.withOnlyMaklon,
      this.woData,
      this.processData,
      this.isMaklon});

  @override
  State<TabSection> createState() => _TabSectionState();
}

class _TabSectionState extends State<TabSection> {
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  Future<void> _handleCancel(BuildContext context) async {
    Widget buildBoldMessage(String woNo) {
      return RichText(
        text: TextSpan(
          style: TextStyle(
              fontSize: CustomTheme().fontSize('xl'),
              color: Colors.black,
              height: 1.5),
          children: [
            TextSpan(
              text: 'Anda yakin ingin kembali? ',
            ),
            TextSpan(
              text: woNo,
              style: TextStyle(
                fontWeight: CustomTheme().fontWeight('bold'),
              ),
            ),
            TextSpan(
              text: ' tidak dimulai dan semua perubahan tidak disimpan!',
            ),
          ],
        ),
      );
    }

    if (context.mounted) {
      if (widget.form?['wo_id'] != null) {
        showConfirmationDialog(
            context: context,
            isLoading: _isLoading,
            onConfirm: () async {
              await Future.delayed(const Duration(milliseconds: 200));
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            title: 'Batal ${widget.label}',
            buttonBackground: CustomTheme().buttonColor('danger'),
            child: buildBoldMessage(widget.woData['wo_no']));
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
  }

  Future<void> _handleSubmit(BuildContext context) async {
    Widget buildBoldMessage(String woNo) {
      return RichText(
        text: TextSpan(
          style: TextStyle(
              fontSize: CustomTheme().fontSize('lg'),
              color: Colors.black,
              height: 1.5),
          children: [
            TextSpan(
              text: 'Anda yakin ingin memulai proses ${widget.label} untuk ',
              style: TextStyle(fontSize: CustomTheme().fontSize('lg')),
            ),
            TextSpan(
              text: woNo,
              style: TextStyle(
                  fontWeight: CustomTheme().fontWeight('bold'),
                  fontSize: CustomTheme().fontSize('lg')),
            ),
            TextSpan(
              text: '? Pastikan semua data sudah benar!',
              style: TextStyle(fontSize: CustomTheme().fontSize('lg')),
            ),
          ],
        ),
      );
    }

    if (context.mounted) {
      if (widget.form?['wo_id'] != null) {
        showConfirmationDialog(
            context: context,
            isLoading: widget.isSubmitting,
            onConfirm: () async {
              await Future.delayed(const Duration(milliseconds: 200));
              widget.isSubmitting.value = true;
              try {
                await widget.handleSubmit();
              } finally {
                widget.isSubmitting.value = false;
              }
            },
            title: 'Mulai ${widget.label}',
            buttonBackground: CustomTheme().buttonColor('primary'),
            child: buildBoldMessage(widget.woData['wo_no']));
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDisabled;

    if (widget.withOnlyMaklon == true) {
      isDisabled = widget.form?['wo_id'] == null;
    } else if (widget.withNoMaklonOrMachine == true) {
      isDisabled = widget.form?['wo_id'] == null;
    } else if (widget.withMaklonOrMachine == true) {
      isDisabled = widget.form?['wo_id'] == null;
    } else {
      isDisabled =
          widget.form?['wo_id'] == null || widget.form?['machine_id'] == null;
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFf9fafc),
        appBar: CustomAppBar(
          title: widget.title,
          onReturn: () => _handleCancel(context),
        ),
        body: SafeArea(
          child: FormInfoTab(
            data: widget.woData,
            processData: widget.processData,
            id: widget.id,
            isLoading: widget.firstLoading,
            label: widget.label,
            form: widget.form,
            formKey: widget.formKey,
            handleSelectMachine: widget.selectMachine,
            handleSelectWorkOrder: widget.selectWorkOrder,
            maklonName: widget.maklonName,
            withMaklonOrMachine: widget.withMaklonOrMachine,
            withOnlyMaklon: widget.withOnlyMaklon,
            withNoMaklonOrMachine: widget.withNoMaklonOrMachine,
            isMaklon: widget.isMaklon,
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              color: Colors.white,
              child: ValueListenableBuilder<bool>(
                valueListenable: widget.isSubmitting,
                builder: (context, isSubmitting, _) {
                  return Row(
                    children: [
                      Expanded(
                        child: CancelButton(
                          label: 'Batal',
                          onPressed: () => _handleCancel(context),
                          customHeight: 56.0,
                          fontSize: CustomTheme().fontSize('xl'),
                        ),
                      ),
                      Expanded(
                          child: FormButton(
                        label: 'Mulai',
                        isDisabled: isDisabled,
                        onPressed: () {
                          _handleSubmit(context);
                        },
                        customHeight: 56.0,
                        fontSize: CustomTheme().fontSize('xl'),
                      ))
                    ].separatedBy(CustomTheme().hGap('xl')),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
