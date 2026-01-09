import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/rework/info_tab.dart';
import 'package:textile_tracking/components/dyeing/rework/item_tab.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/layout/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class CreateSection extends StatefulWidget {
  final woData;
  final id;
  final formKey;
  final form;
  final handleSubmit;
  final isSubmitting;
  final firstLoading;
  final selectMachine;
  final selectWorkOrder;

  const CreateSection(
      {super.key,
      this.woData,
      this.id,
      this.handleSubmit,
      this.formKey,
      this.form,
      this.isSubmitting,
      this.firstLoading,
      this.selectMachine,
      this.selectWorkOrder});

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
            title: 'Mulai Dyeing',
            onReturn: () {
              Navigator.pop(context);
            },
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
                  InfoTab(
                    data: widget.woData,
                    id: widget.id,
                    isLoading: widget.firstLoading,
                    form: widget.form,
                    formKey: widget.formKey,
                    handleSubmit: widget.handleSubmit,
                    handleSelectMachine: widget.selectMachine,
                    handleSelectWorkOrder: widget.selectWorkOrder,
                  ),
                  ItemTab(
                    data: widget.woData,
                  ),
                ]),
              )
            ],
          ),
          bottomNavigationBar: SafeArea(
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
                        label: 'Mulai',
                        isLoading: isSubmitting,
                        isDisabled: widget.form?['wo_id'] == null ||
                                widget.form?['machine_id'] == null
                            ? true
                            : false,
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
          )),
    );
  }
}
