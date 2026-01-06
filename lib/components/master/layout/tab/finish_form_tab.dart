import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/section/finish/finish_section.dart';
import 'package:textile_tracking/components/master/theme.dart';

class FinishFormTab extends StatefulWidget {
  final id;
  final data;
  final form;
  final formKey;
  final handleSelectMachine;
  final handleSelectWorkOrder;
  final isLoading;
  final maklon;
  final isMaklon;
  final withMaklonOrMachine;
  final withOnlyMaklon;
  final withNoMaklonOrMachine;
  final handleSelectUnit;
  final handleSelectLengthUnit;
  final handleSelectWidthUnit;
  final handleChangeInput;
  final processId;
  final length;
  final width;
  final weight;
  final note;
  final qty;
  final qtyItem;
  final notes;
  final handleSelectWo;
  final handleSelectQtyUnit;
  final handleSelectQtyUnitItem;
  final handleSelectQtyUnitDyeing;

  final isSubmitting;
  final isFormIncomplete;
  final isChanged;
  final initialQty;
  final initialWeight;
  final initialLength;
  final initialWidth;
  final initialNotes;
  final allAttachments;
  final handlePickAttachments;
  final processData;
  final withItemGrade;
  final itemGradeOption;
  final withQtyAndWeight;
  final label;
  final forDyeing;

  const FinishFormTab(
      {super.key,
      this.data,
      this.form,
      this.formKey,
      this.handleSelectMachine,
      this.handleSelectWorkOrder,
      this.id,
      this.isLoading,
      this.isMaklon,
      this.maklon,
      this.withMaklonOrMachine,
      this.withNoMaklonOrMachine,
      this.withOnlyMaklon,
      this.handleChangeInput,
      this.handleSelectLengthUnit,
      this.handleSelectUnit,
      this.handleSelectWidthUnit,
      this.allAttachments,
      this.handlePickAttachments,
      this.handleSelectQtyUnit,
      this.handleSelectQtyUnitItem,
      this.handleSelectQtyUnitDyeing,
      this.handleSelectWo,
      this.initialLength,
      this.initialNotes,
      this.initialQty,
      this.initialWeight,
      this.initialWidth,
      this.isChanged,
      this.isFormIncomplete,
      this.isSubmitting,
      this.itemGradeOption,
      this.length,
      this.note,
      this.notes,
      this.processData,
      this.processId,
      this.qty,
      this.qtyItem,
      this.weight,
      this.width,
      this.withItemGrade,
      this.withQtyAndWeight,
      this.label,
      this.forDyeing});

  @override
  State<FinishFormTab> createState() => _FinishFormTabState();
}

class _FinishFormTabState extends State<FinishFormTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      child: Container(
        padding: CustomTheme().padding('content'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FinishSection(
              formKey: widget.formKey,
              form: widget.form,
              note: widget.note,
              weight: widget.weight,
              width: widget.width,
              length: widget.length,
              handleSelectWo: widget.handleSelectWo,
              handleSelectUnit: widget.handleSelectUnit,
              handleChangeInput: widget.handleChangeInput,
              handleSelectQtyUnitItem: widget.handleSelectQtyUnitItem,
              handleSelectQtyUnitDyeing: widget.handleSelectQtyUnitDyeing,
              id: widget.id,
              data: widget.data,
              processId: widget.processId,
              processData: widget.processData,
              isLoading: widget.isLoading,
              handleSelectLengthUnit: widget.handleSelectLengthUnit,
              handleSelectWidthUnit: widget.handleSelectWidthUnit,
              withItemGrade: widget.withItemGrade,
              itemGradeOption: widget.itemGradeOption,
              handleSelectQtyUnit: widget.handleSelectQtyUnit,
              notes: widget.notes,
              qty: widget.qty,
              withQtyAndWeight: widget.withQtyAndWeight,
              qtyItem: widget.qtyItem,
              label: widget.label,
              forDyeing: widget.forDyeing,
            ),
          ],
        ),
      ),
    );
  }
}
