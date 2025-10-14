import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/create/info_tab.dart';
import 'package:textile_tracking/components/dyeing/create/item_tab.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ListForm extends StatefulWidget {
  final formKey;
  final form;
  final data;
  final id;
  final dyeingId;
  final length;
  final width;
  final qty;
  final note;
  final handleSelectWo;
  final handleChangeInput;
  final handleSelectUnit;
  final handleSelectMachine;
  final isSubmitting;
  final handleSubmit;
  final isFormIncomplete;
  final isChanged;
  final initialQty;
  final initialLength;
  final initialWidth;
  final initialNotes;
  final allAttachments;
  final handlePickAttachments;

  const ListForm(
      {super.key,
      this.formKey,
      this.id,
      this.handleSelectWo,
      this.form,
      this.data,
      this.length,
      this.width,
      this.qty,
      this.note,
      this.handleChangeInput,
      this.handleSelectUnit,
      this.isSubmitting,
      this.handleSelectMachine,
      this.handleSubmit,
      this.isFormIncomplete,
      this.dyeingId,
      this.isChanged,
      this.initialQty,
      this.initialLength,
      this.initialWidth,
      this.initialNotes,
      this.allAttachments,
      this.handlePickAttachments});

  @override
  State<ListForm> createState() => _ListFormState();
}

class _ListFormState extends State<ListForm> {
  late String _initialQty;
  late String _initialLength;
  late String _initialWidth;
  late String _initialNotes;
  late bool _isChanged;

  @override
  void initState() {
    _initialQty = widget.initialQty ?? '';
    _initialLength = widget.initialLength ?? '';
    _initialWidth = widget.initialWidth ?? '';
    _initialNotes = widget.initialNotes ?? '';
    _isChanged = widget.isChanged ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        padding: PaddingColumn.screen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (widget.id == null)
              SelectForm(
                  label: 'Work Order',
                  onTap: () => widget.handleSelectWo(),
                  selectedLabel: widget.form['no_wo'] ?? '',
                  selectedValue: widget.form['wo_id']?.toString() ?? '',
                  required: false),
            if (widget.form?['wo_id'] != null)
              DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(tabs: [
                        Tab(
                          text: 'Informasi',
                        ),
                        Tab(
                          text: 'Barang',
                        ),
                      ]),
                      SizedBox(
                          height: 400,
                          child: TabBarView(children: [
                            InfoTab(
                              data: widget.data,
                            ),
                            ItemTab(
                              data: widget.data,
                            )
                          ]))
                    ],
                  )),
            SelectForm(
              label: 'Mesin',
              onTap: () => widget.handleSelectMachine(),
              selectedLabel: widget.form['nama_mesin'] ?? '',
              selectedValue: widget.form['machine_id'].toString(),
              required: false,
            ),
            ValueListenableBuilder<bool>(
              valueListenable: widget.isSubmitting,
              builder: (context, isSubmitting, _) {
                return Align(
                    alignment: Alignment.center,
                    child: FormButton(
                      label: 'Submit',
                      onPressed: () async {
                        widget.isSubmitting.value = true;
                        try {
                          await widget.handleSubmit(widget.dyeingId);
                          setState(() {
                            _initialQty = widget.qty.text;
                            _initialLength = widget.length.text;
                            _initialWidth = widget.width.text;
                            _initialNotes = widget.note.text;
                            _isChanged = false;
                          });
                        } finally {
                          widget.isSubmitting.value = false;
                        }
                      },
                      isLoading: isSubmitting,
                      isDisabled: widget.isFormIncomplete,
                    ));
              },
            )
          ].separatedBy(SizedBox(
            height: 16,
          )),
        ),
      ),
    );
  }
}
