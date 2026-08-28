import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/rework/create_form.dart';
import 'package:textile_tracking/components/dyeing/rework/wo_item_tab.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/process/create/note_item.dart';
import 'package:textile_tracking/components/work-order/tab/info_tab.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ReworkInfoTab extends StatefulWidget {
  final id;
  final label;
  final data;
  final form;
  final formKey;
  final handleSelectMachine;
  final handleSelectWorkOrder;
  final handleSelectReworkCategory;
  final reworkCategoryOption;
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  final onFormChanged;
=======
>>>>>>> 11b79f06 (feat: option rework dyeing)
=======
  final onFormChanged;
>>>>>>> fc4fb8a2 (fix: kondisi button rework)
=======
>>>>>>> 55a0e7ec (feat: option rework dyeing)
  final isLoading;

  const ReworkInfoTab(
      {super.key,
      this.data,
      this.form,
      this.formKey,
      this.handleSelectMachine,
      this.handleSelectReworkCategory,
      this.handleSelectWorkOrder,
      this.id,
      this.isLoading,
      this.label,
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
      this.onFormChanged,
=======
>>>>>>> 11b79f06 (feat: option rework dyeing)
=======
      this.onFormChanged,
>>>>>>> fc4fb8a2 (fix: kondisi button rework)
=======
>>>>>>> 55a0e7ec (feat: option rework dyeing)
      this.reworkCategoryOption});

  @override
  State<ReworkInfoTab> createState() => _ReworkInfoTabState();
}

class _ReworkInfoTabState extends State<ReworkInfoTab> {
  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        return SingleChildScrollView(
          padding: CustomTheme().padding('content'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CreateForm(
                data: widget.data,
                form: widget.form,
                formKey: widget.formKey,
                selectWorkOrder: widget.handleSelectWorkOrder,
                selectMachine: widget.handleSelectMachine,
                selectReworkCategory: widget.handleSelectReworkCategory,
                reworkCategoryOption: widget.reworkCategoryOption,
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                onFormChanged: widget.onFormChanged,
=======
>>>>>>> 11b79f06 (feat: option rework dyeing)
=======
                onFormChanged: widget.onFormChanged,
>>>>>>> fc4fb8a2 (fix: kondisi button rework)
=======
>>>>>>> 55a0e7ec (feat: option rework dyeing)
                id: widget.id,
              ),
              if (widget.form?['wo_id'] != null)
                InfoTab(
                  data: widget.data,
                  label: widget.label,
                  isTablet: isTablet,
                ),
              if (widget.form?['wo_id'] != null)
                WoItemTab(
                  data: widget.data,
                ),
              if (widget.form?['wo_id'] != null)
                NoteItem(
                  data: widget.data,
                  label: widget.label,
                ),
            ].separatedBy(CustomTheme().vGap('xl')),
          ),
        );
      },
    );
  }
}
