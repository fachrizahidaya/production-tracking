import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/process/finish/finish_section.dart';

class FinishFormTab extends StatefulWidget {
  final id;
  final form;
  final formKey;
  final isLoading;
  final maklon;
  final handleChangeInput;
  final length;
  final width;
  final weight;
  final note;
  final qty;
  final qtyItem;
  final handleSelectWo;
  final data;
  final gsm;
  final totalWeight;
  final woData;

  final processData;
  final withItemGrade;
  final itemGradeOption;
  final withQtyAndWeight;
  final label;
  final forDyeing;
  final validateWeight;
  final weightWarning;
  final validateQty;
  final qtyWarning;
  final weightGood;
  final weightDefect;
  final packingQty;
  final combing;
  final spraying;
  final itemTypeOption;
  final defects;
  final defectQty;
  final weightGradeA;
  final finishedItem;
  final dyeingQty;
  final finishedItemGrb;
  final isInitializing;

  const FinishFormTab(
      {super.key,
      this.form,
      this.formKey,
      this.id,
      this.isLoading,
      this.maklon,
      this.handleChangeInput,
      this.handleSelectWo,
      this.itemGradeOption,
      this.length,
      this.note,
      this.processData,
      this.qty,
      this.qtyItem,
      this.weight,
      this.width,
      this.withItemGrade,
      this.withQtyAndWeight,
      this.label,
      this.forDyeing,
      this.data,
      this.gsm,
      this.totalWeight,
      this.validateWeight,
      this.weightWarning,
      this.qtyWarning,
      this.validateQty,
      this.weightDefect,
      this.weightGood,
      this.woData,
      this.packingQty,
      this.combing,
      this.spraying,
      this.itemTypeOption,
      this.defects,
      this.defectQty,
      this.weightGradeA,
      this.finishedItem,
      this.dyeingQty,
      this.finishedItemGrb,
      this.isInitializing});

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

    // if (widget.isLoading) {
    //   return Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }

    return LayoutBuilder(
      builder: (context, constraints) {
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
                  handleChangeInput: widget.handleChangeInput,
                  id: widget.id,
                  processData: widget.processData,
                  isLoading: widget.isLoading,
                  withItemGrade: widget.withItemGrade,
                  itemGradeOption: widget.itemGradeOption,
                  qty: widget.qty,
                  withQtyAndWeight: widget.withQtyAndWeight,
                  qtyItem: widget.qtyItem,
                  label: widget.label,
                  forDyeing: widget.forDyeing,
                  data: widget.data,
                  gsm: widget.gsm,
                  totalWeight: widget.totalWeight,
                  validateWeight: widget.validateWeight,
                  weightWarning: widget.weightWarning,
                  validateQty: widget.validateQty,
                  qtyWarning: widget.qtyWarning,
                  weightDefect: widget.weightDefect,
                  weightGood: widget.weightGood,
                  woData: widget.woData,
                  packingQty: widget.packingQty,
                  combing: widget.combing,
                  spraying: widget.spraying,
                  itemTypeOption: widget.itemTypeOption,
                  defects: widget.defects,
                  defectQty: widget.defectQty,
                  weightGradeA: widget.weightGradeA,
                  finishedItem: widget.finishedItem,
                  dyeingQty: widget.dyeingQty,
                  finishedItemGrb: widget.finishedItemGrb,
                  isInitializing: widget.isInitializing,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
