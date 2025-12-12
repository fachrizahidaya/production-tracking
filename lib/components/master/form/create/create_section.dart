import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/components/master/layout/tab/finish_info_tab.dart';
import 'package:textile_tracking/components/master/layout/tab/finish_item_tab.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class CreateSection extends StatefulWidget {
  final id;
  final title;
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

  const CreateSection(
      {super.key,
      this.title,
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
  State<CreateSection> createState() => _CreateSectionState();
}

class _CreateSectionState extends State<CreateSection> {
  @override
  Widget build(BuildContext context) {
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
                  text: 'Barang',
                ),
              ]),
            ),
            Expanded(
              child: TabBarView(children: [
                FinishInfoTab(
                  data: widget.woData,
                  id: widget.id,
                  isLoading: widget.firstLoading,
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
                FinishItemTab(data: widget.woData),
              ]),
            )
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: PaddingColumn.screen,
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
                      isDisabled: widget.form?['wo_id'] == null ? true : false,
                      onPressed: () async {
                        widget.isSubmitting.value = true;
                        try {
                          await widget.handleSubmit();
                        } finally {
                          widget.isSubmitting.value = false;
                        }
                      },
                    ))
                  ].separatedBy(SizedBox(
                    width: 16,
                  )),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
