// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/process/create/greige_form_info_tab.dart';
import 'package:textile_tracking/components/process/create/greige_info_tab.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class GreigeTabSection extends StatefulWidget {
  final id;
  final title;
  final label;
  final maklonName;
  final isMaklon;
  final form;
  final formKey;
  final greigeOrderData;
  final processData;
  final withMaklonOrMachine;
  final withNoMaklonOrMachine;
  final withOnlyMaklon;
  final handleSubmit;
  final firstLoading;
  final isSubmitting;
  final selectMachine;
  final selectGreigeOrder;
  final spkDocuments;
  final handleChangeInput;
  final note;
  final yarnQty;
  final beamQty;
  final section;

  const GreigeTabSection(
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
      this.selectGreigeOrder,
      this.withMaklonOrMachine,
      this.withNoMaklonOrMachine,
      this.withOnlyMaklon,
      this.greigeOrderData,
      this.processData,
      this.isMaklon,
      this.spkDocuments,
      this.handleChangeInput,
      this.note,
      this.yarnQty,
      this.beamQty,
      this.section});

  @override
  State<GreigeTabSection> createState() => _GreigeTabSectionState();
}

class _GreigeTabSectionState extends State<GreigeTabSection> {
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  Future<void> _handleCancel(BuildContext context) async {
    Widget buildBoldMessage(String orderNo) {
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
              text: orderNo,
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
      if (widget.form?['order_greige_id'] != null) {
        showConfirmationDialog(
          context: context,
          isLoading: _isLoading,
          onConfirm: () async {
            await Future.delayed(Duration(milliseconds: 200));
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          },
          title: 'Batal ${widget.label}',
          buttonBackground: CustomTheme().buttonColor('danger'),
          child: buildBoldMessage(
            widget.greigeOrderData['wo_no'] ??
                widget.greigeOrderData['og_no'] ??
                '-',
          ),
        );
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
  }

  Future<void> _handleSubmit(BuildContext context) async {
    Widget buildBoldMessage(String orderNo) {
      return RichText(
        text: TextSpan(
          style: TextStyle(
              fontSize: CustomTheme().fontSize('xl'),
              color: Colors.black,
              height: 1.5),
          children: [
            TextSpan(
              text: 'Anda yakin ingin memulai proses ${widget.label} untuk ',
            ),
            TextSpan(
              text: orderNo,
              style: TextStyle(
                fontWeight: CustomTheme().fontWeight('bold'),
              ),
            ),
            TextSpan(
              text: '? Pastikan semua data sudah benar!',
            ),
          ],
        ),
      );
    }

    if (context.mounted) {
      if (widget.form?['order_greige_id'] != null) {
        showConfirmationDialog(
          context: context,
          isLoading: widget.isSubmitting,
          onConfirm: () async {
            await Future.delayed(Duration(milliseconds: 200));
            widget.isSubmitting.value = true;
            try {
              await widget.handleSubmit();
            } finally {
              widget.isSubmitting.value = false;
            }
          },
          title: 'Mulai ${widget.label}',
          buttonBackground: CustomTheme().buttonColor('primary'),
          child: buildBoldMessage(
            widget.greigeOrderData['wo_no'] ??
                widget.greigeOrderData['og_no'] ??
                '-',
          ),
        );
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDisabled;

    final List<Map<String, dynamic>> machines = List<Map<String, dynamic>>.from(
      widget.form?['machines'] ?? [],
    );
    final yarnQty = widget.form?['yarn_qty']?.toString().trim() ?? '';
    final warpingValueKey = widget.form?['warping_type'] == 'single_warping'
        ? 'beam_qty'
        : 'section';
    final warpingValue = widget.form?[warpingValueKey]?.toString().trim() ?? '';

    if (widget.withOnlyMaklon == true) {
      isDisabled = widget.form?['order_greige_id'] == null;
    } else if (widget.withNoMaklonOrMachine == true) {
      isDisabled = widget.form?['order_greige_id'] == null;
    } else if (widget.label == 'Long Hemming' ||
        widget.label == 'Cross Cutting' ||
        widget.label == 'Sewing') {
      isDisabled = widget.form?['order_greige_id'] == null || machines.isEmpty;
    } else {
      isDisabled = widget.form?['order_greige_id'] == null ||
          widget.form?['machine_id'] == null ||
          (widget.label == 'Warping' &&
              (yarnQty.isEmpty || warpingValue.isEmpty));
    }

    return DefaultTabController(
      length: 2,
      child: GestureDetector(
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
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: const TabBar(
                    tabs: [
                      Tab(text: 'Form'),
                      Tab(text: 'Greige Order'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      GreigeFormInfoTab(
                        data: widget.greigeOrderData,
                        processData: widget.processData,
                        id: widget.id,
                        isLoading: widget.firstLoading,
                        label: widget.label,
                        form: widget.form,
                        formKey: widget.formKey,
                        handleSelectMachine: widget.selectMachine,
                        handleSelectGreigeOrder: widget.selectGreigeOrder,
                        maklonName: widget.maklonName,
                        withMaklonOrMachine: widget.withMaklonOrMachine,
                        withOnlyMaklon: widget.withOnlyMaklon,
                        withNoMaklonOrMachine: widget.withNoMaklonOrMachine,
                        isMaklon: widget.isMaklon,
                        handleChangeInput: widget.handleChangeInput,
                        note: widget.note,
                        yarnQty: widget.yarnQty,
                        beamQty: widget.beamQty,
                        section: widget.section,
                      ),
                      GreigeInfoTab(data: widget.greigeOrderData)
                    ],
                  ),
                ),
              ],
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
                            onPressed: () {
                              _handleSubmit(context);
                            },
                            customHeight: 56.0,
                            fontSize: CustomTheme().fontSize('xl'),
                          ),
                        ),
                      ].separatedBy(
                        CustomTheme().hGap('xl'),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
