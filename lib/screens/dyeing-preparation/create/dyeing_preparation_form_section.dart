// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/process/create/note_item.dart';
import 'package:textile_tracking/components/work-order/tab/attachment_tab.dart';
import 'package:textile_tracking/components/work-order/tab/info_tab.dart';
import 'package:textile_tracking/components/work-order/tab/item_tab.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class DyeingPreparationFormSection extends StatefulWidget {
  final dynamic id;
  final String title;
  final Map<String, dynamic>? form;
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> woData;
  final Future<void> Function() handleSubmit;
  final ValueNotifier<bool> isSubmitting;
  final VoidCallback selectWorkOrder;
  final bool firstLoading;

  const DyeingPreparationFormSection({
    super.key,
    this.id,
    required this.title,
    required this.form,
    required this.formKey,
    required this.woData,
    required this.handleSubmit,
    required this.isSubmitting,
    required this.selectWorkOrder,
    required this.firstLoading,
  });

  @override
  State<DyeingPreparationFormSection> createState() =>
      _DyeingPreparationFormSectionState();
}

class _DyeingPreparationFormSectionState
    extends State<DyeingPreparationFormSection> {
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  Future<void> _handleCancel(BuildContext context) async {
    Widget buildBoldMessage(String woNo) {
      return RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: CustomTheme().fontSize('xl'),
            color: Colors.black,
            height: 1.5,
          ),
          children: [
            const TextSpan(text: 'Anda yakin ingin kembali? '),
            TextSpan(
              text: woNo,
              style: TextStyle(
                fontWeight: CustomTheme().fontWeight('bold'),
              ),
            ),
            const TextSpan(
              text: ' tidak dimulai dan semua perubahan tidak disimpan!',
            ),
          ],
        ),
      );
    }

    if (!context.mounted) return;

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
        title: 'Batal Persiapan Dyeing',
        buttonBackground: CustomTheme().buttonColor('danger'),
        child: buildBoldMessage(widget.woData['wo_no']?.toString() ?? '-'),
      );
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  Future<void> _handleSubmit(BuildContext context) async {
    Widget buildBoldMessage(String woNo) {
      return RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: CustomTheme().fontSize('xl'),
            color: Colors.black,
            height: 1.5,
          ),
          children: [
            const TextSpan(
              text: 'Anda yakin ingin memulai Persiapan Dyeing untuk ',
            ),
            TextSpan(
              text: woNo,
              style: TextStyle(
                fontWeight: CustomTheme().fontWeight('bold'),
              ),
            ),
            const TextSpan(text: '? Pastikan semua data sudah benar!'),
          ],
        ),
      );
    }

    if (!context.mounted) return;

    if (widget.form?['wo_id'] == null) {
      Navigator.pop(context);
      return;
    }

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
      title: 'Mulai Persiapan Dyeing',
      buttonBackground: CustomTheme().buttonColor('primary'),
      child: buildBoldMessage(widget.woData['wo_no']?.toString() ?? '-'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.form?['wo_id'] == null;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFf9fafc),
        appBar: CustomAppBar(
          title: widget.title,
          onReturn: () => _handleCancel(context),
        ),
        body: SafeArea(
          child: widget.firstLoading
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final isTablet = constraints.maxWidth > 600;

                    return SingleChildScrollView(
                      padding: CustomTheme().padding('content'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildWorkOrderForm(),
                          // if (widget.form?['wo_id'] != null) ...[
                          // InfoTab(
                          //   data: widget.woData,
                          //   label: 'Persiapan Dyeing',
                          //   isTablet: isTablet,
                          // ),
                          // ItemTab(
                          //   data: widget.woData,
                          //   label: 'Persiapan Dyeing',
                          //   withSpk: false,
                          // ),
                          // NoteItem(
                          //   data: widget.woData,
                          //   label: 'Persiapan Dyeing',
                          // ),
                          // AttachmentTab(
                          //   existingAttachment:
                          //       widget.woData['attachments'] ?? [],
                          // ),
                          // ],
                        ].separatedBy(CustomTheme().vGap('2xl')),
                      ),
                    );
                  },
                ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 24,
              ),
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
                          onPressed: () => _handleSubmit(context),
                          customHeight: 56.0,
                          fontSize: CustomTheme().fontSize('xl'),
                        ),
                      ),
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

  Widget _buildWorkOrderForm() {
    return Form(
      key: widget.formKey,
      child: TemplateCard(
        icon: Icons.assignment_outlined,
        title: 'Work Order',
        child: SelectForm(
          label: 'Work Order',
          onTap: widget.selectWorkOrder,
          selectedLabel: widget.form?['no_wo'] ?? '',
          selectedValue: widget.form?['wo_id']?.toString() ?? '',
          required: true,
        ),
      ),
    );
  }
}
