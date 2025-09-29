import 'package:flutter/material.dart';
import 'package:production_tracking/components/master/button/form_button.dart';
import 'package:production_tracking/components/master/form/multiline_form.dart';
import 'package:production_tracking/components/master/form/select_form.dart';
import 'package:production_tracking/components/master/form/text_form.dart';
import 'package:production_tracking/components/master/layout/custom_card.dart';
import 'package:production_tracking/helpers/util/margin_search.dart';
import 'package:production_tracking/helpers/util/padding_column.dart';
import 'package:production_tracking/helpers/util/separated_column.dart';

class CreateForm extends StatefulWidget {
  final formKey;
  final form;
  final note;
  final qty;
  final width;
  final length;
  final handleSelectWo;
  final handleSelectDyeing;
  final handleSelectUnit;
  final handleSelectMachine;
  final handleChangeInput;
  final handleSubmit;

  const CreateForm(
      {super.key,
      this.formKey,
      this.form,
      this.note,
      this.qty,
      this.length,
      this.width,
      this.handleSelectWo,
      this.handleSelectDyeing,
      this.handleSelectUnit,
      this.handleSelectMachine,
      this.handleChangeInput,
      this.handleSubmit});

  @override
  State<CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: MarginSearch.screen,
        child: CustomCard(
          child: Form(
            key: widget.formKey,
            child: SingleChildScrollView(
              padding: PaddingColumn.screen,
              child: Column(
                children: [
                  SelectForm(
                      label: 'Work Order',
                      onTap: () => widget.handleSelectWo(),
                      selectedLabel: widget.form['no_wo'].toString(),
                      selectedValue: widget.form['wo_id'].toString(),
                      required: false),
                  SelectForm(
                      label: 'Dyeing',
                      onTap: () => widget.handleSelectDyeing(),
                      selectedLabel: widget.form['no_wo'].toString(),
                      selectedValue: widget.form['wo_id'].toString(),
                      required: false),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextForm(
                          label: 'Panjang',
                          req: false,
                          controller: widget.length,
                          handleChange: (value) {
                            setState(() {
                              widget.length.text = value.toString();
                              widget.handleChangeInput('length', value);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextForm(
                          label: 'Lebar',
                          req: false,
                          controller: widget.width,
                          handleChange: (value) {
                            setState(() {
                              widget.width.text = value.toString();
                              widget.handleChangeInput('width', value);
                            });
                          },
                        ),
                      ),
                    ].separatedBy(SizedBox(
                      width: 16,
                    )),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextForm(
                          label: 'Jumlah',
                          req: false,
                          controller: widget.qty,
                          handleChange: (value) {
                            setState(() {
                              widget.qty.text = value.toString();
                              widget.handleChangeInput('qty', value);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SelectForm(
                            label: 'Satuan',
                            onTap: () => widget.handleSelectUnit(),
                            selectedLabel:
                                widget.form['nama_satuan'].toString(),
                            selectedValue: widget.form['unit_id'].toString(),
                            required: false),
                      )
                    ].separatedBy(SizedBox(
                      width: 16,
                    )),
                  ),
                  SelectForm(
                      label: 'Mesin',
                      onTap: () => widget.handleSelectMachine(),
                      selectedLabel: widget.form['nama_mesin'].toString(),
                      selectedValue: widget.form['machine_id'].toString(),
                      required: false),
                  MultilineForm(
                    label: 'Catatan',
                    req: false,
                    controller: widget.note,
                    handleChange: (value) {
                      setState(() {
                        widget.note.text = value.toString();
                        widget.handleChangeInput('notes', value);
                      });
                    },
                  ),
                  FormButton(
                    label: 'Submit',
                    onPressed: () => widget.handleSubmit,
                  )
                ].separatedBy(SizedBox(
                  height: 16,
                )),
              ),
            ),
          ),
        ));
  }
}
