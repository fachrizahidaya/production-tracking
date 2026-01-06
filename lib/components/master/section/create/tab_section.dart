import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/layout/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/layout/tab/form_info_tab.dart';
import 'package:textile_tracking/components/master/layout/tab/work_order_item_tab.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class TabSection extends StatefulWidget {
  final id;
  final title;
  final label;
  final maklon;
  final form;
  final formKey;
  final woData;
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
      this.maklon,
      this.selectMachine,
      this.selectWorkOrder,
      this.withMaklonOrMachine,
      this.withNoMaklonOrMachine,
      this.withOnlyMaklon,
      this.woData});

  @override
  State<TabSection> createState() => _TabSectionState();
}

class _TabSectionState extends State<TabSection> {
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
          onReturn: () => Navigator.pop(context),
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(tabs: [
                Tab(
                  text: 'Form',
                ),
                Tab(
                  text: 'Material',
                ),
              ]),
            ),
            Expanded(
              child: TabBarView(children: [
                FormInfoTab(
                  data: widget.woData,
                  id: widget.id,
                  isLoading: widget.firstLoading,
                  label: widget.label,
                  form: widget.form,
                  formKey: widget.formKey,
                  handleSubmit: widget.handleSubmit,
                  handleSelectMachine: widget.selectMachine,
                  handleSelectWorkOrder: widget.selectWorkOrder,
                  maklon: widget.maklon,
                  withMaklonOrMachine: widget.withMaklonOrMachine,
                  withOnlyMaklon: widget.withOnlyMaklon,
                  withNoMaklonOrMachine: widget.withNoMaklonOrMachine,
                ),
                WorkOrderItemTab(data: widget.woData),
              ]),
            )
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: CustomTheme().padding('card'),
            color: Colors.white,
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
                      label: 'Mulai',
                      isLoading: isSubmitting,
                      isDisabled: isDisabled,
                      onPressed: () async {
                        widget.isSubmitting.value = true;
                        try {
                          await widget.handleSubmit();
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
        ),
      ),
    );
  }
}
