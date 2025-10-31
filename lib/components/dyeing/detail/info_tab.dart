import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/detail/list_info.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';

class InfoTab extends StatefulWidget {
  final data;
  final isLoading;
  final qty;
  final length;
  final width;
  final note;
  final form;
  final handleChangeInput;
  final handleSelectUnit;
  final handleSelectMachine;
  final handleUpdate;
  final refetch;
  final hasMore;
  final handleSelectLengthUnit;
  final handleSelectWidthUnit;

  const InfoTab(
      {super.key,
      this.data,
      this.isLoading,
      this.qty,
      this.length,
      this.width,
      this.note,
      this.form,
      this.handleChangeInput,
      this.handleSelectUnit,
      this.handleUpdate,
      this.refetch,
      this.hasMore,
      this.handleSelectMachine,
      this.handleSelectLengthUnit,
      this.handleSelectWidthUnit});

  @override
  State<InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);

  bool _isChanged = false;
  late String _initialQty;
  late String _initialLength;
  late String _initialNotes;
  late String _initialWidth;

  @override
  void initState() {
    super.initState();
    _initialQty = widget.data['qty']?.toString() ?? '';
    _initialLength = widget.data['length']?.toString() ?? '';
    _initialWidth = widget.data['width']?.toString() ?? '';
    _initialNotes = widget.data['notes']?.toString() ?? '';

    widget.qty.text = _initialQty;
    widget.note.text = _initialNotes;
    widget.length.text = _initialLength;
    widget.width.text = _initialWidth;
  }

  @override
  void didUpdateWidget(covariant InfoTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data && widget.data.isNotEmpty) {
      setState(() {
        _initialQty = widget.data['qty']?.toString() ?? '';
        _initialLength = widget.data['length']?.toString() ?? '';
        _initialWidth = widget.data['width']?.toString() ?? '';
        _initialNotes = widget.data['notes']?.toString() ?? '';

        widget.qty.text = _initialQty;
        widget.length.text = _initialLength;
        widget.width.text = _initialWidth;
        widget.note.text = _initialNotes;

        _isChanged = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final existing = (widget.data?['attachments'] ?? []) as List<dynamic>;

    if (widget.isLoading) {
      return Container(
        color: const Color(0xFFEBEBEB),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (widget.data.isEmpty) {
      return Container(
        color: const Color(0xFFEBEBEB),
        alignment: Alignment.center,
        child: const NoData(),
      );
    }

    return ListInfo(
      data: widget.data,
      form: widget.form,
      isSubmitting: _isSubmitting,
      existingAttachment: existing,
      handleUpdate: widget.handleUpdate,
      initialQty: _initialQty,
      initialLength: _initialLength,
      initialWidth: _initialWidth,
      initialNotes: _initialNotes,
      isChanged: _isChanged,
      length: widget.length,
      width: widget.width,
      qty: widget.qty,
      note: widget.note,
      handleSelectMachine: widget.handleSelectMachine,
      handleChangeInput: widget.handleChangeInput,
      handleSelectLengthUnit: widget.handleSelectLengthUnit,
      handleSelectUnit: widget.handleSelectUnit,
      handleSelectWidthUnit: widget.handleSelectWidthUnit,
    );
  }
}
