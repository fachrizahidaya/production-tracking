import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/finish/create_form.dart';
import 'package:textile_tracking/components/master/theme.dart';

class InfoTab extends StatefulWidget {
  final id;
  final data;
  final woData;
  final form;
  final formKey;
  final handleSubmit;
  final handleSelectMachine;
  final handleSelectWorkOrder;
  final isLoading;
  final handleSelectUnit;
  final handleChangeInput;
  final handleSelectLengthUnit;
  final handleSelectWidthUnit;
  final note;
  final qty;
  final width;
  final length;
  final dyeingId;
  final dyeingData;
  final processId;

  const InfoTab(
      {super.key,
      this.data,
      this.form,
      this.formKey,
      this.handleSelectMachine,
      this.handleSelectWorkOrder,
      this.handleSubmit,
      this.id,
      this.isLoading,
      this.dyeingData,
      this.dyeingId,
      this.handleChangeInput,
      this.handleSelectLengthUnit,
      this.handleSelectUnit,
      this.handleSelectWidthUnit,
      this.length,
      this.note,
      this.qty,
      this.width,
      this.processId,
      this.woData});

  @override
  State<InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> with AutomaticKeepAliveClientMixin {
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
            CreateForm(
              form: widget.form,
              formKey: widget.formKey,
              handleSubmit: widget.handleSubmit,
              data: widget.data,
              handleSelectWo: widget.handleSelectWorkOrder,
              id: widget.id,
              isLoading: widget.isLoading,
              handleChangeInput: widget.handleChangeInput,
              handleSelectLengthUnit: widget.handleSelectLengthUnit,
              handleSelectUnit: widget.handleSelectUnit,
              handleSelectWidthUnit: widget.handleSelectWidthUnit,
              note: widget.note,
              qty: widget.qty,
              width: widget.width,
              length: widget.length,
              dyeingData: widget.dyeingData,
              dyeingId: widget.dyeingId,
              woData: widget.woData,
            ),
          ],
        ),
      ),
    );
  }
}
