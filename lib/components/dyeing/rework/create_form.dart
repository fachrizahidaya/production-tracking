// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/rework/list_form.dart';

class CreateForm extends StatefulWidget {
  final formKey;
  final form;
  final selectWorkOrder;
  final selectMachine;
  final selectReworkCategory;
  final reworkCategoryOption;
  final onFormChanged;
  final id;

  const CreateForm(
      {super.key,
      this.formKey,
      this.form,
      this.handleSubmit,
      this.data,
      this.selectWorkOrder,
      this.selectMachine,
      this.selectReworkCategory,
      this.reworkCategoryOption,
      this.onFormChanged,
      this.id,
      this.isLoading});

  @override
  State<CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);

  bool get _isFormIncomplete {
    final woId = widget.form?['wo_id'];

    final reworkCategory = widget.form?['rework_category'];

    final reworkType = widget.form?['rework_type'] as List? ?? [];

    final reworkMethod = widget.form?['rework_method'] as List? ?? [];

    final isPerbaikan = reworkCategory == 'perbaikan';

    final isPerbaikanWarna = reworkType.contains('perbaikan_warna');

    return woId == null ||
        reworkCategory == null ||
        (isPerbaikan && reworkType.isEmpty) ||
        (isPerbaikanWarna && reworkMethod.isEmpty);
  }

  String? _getValidationMessage() {
    final woId = widget.form?['wo_id'];

    final reworkCategory = widget.form?['rework_category'];

    final reworkType = widget.form?['rework_type'] as List? ?? [];

    final reworkMethod = widget.form?['rework_method'] as List? ?? [];

    final isPerbaikan = reworkCategory == 'perbaikan';

    final isPerbaikanWarna = reworkType.contains('perbaikan_warna');

    if (woId == null) {
      return 'Work Order wajib dipilih.';
    }

    if (reworkCategory == null || reworkCategory.toString().isEmpty) {
      return 'Kategori Rework wajib dipilih.';
    }

    if (isPerbaikan && reworkType.isEmpty) {
      return 'Minimal pilih satu jenis perbaikan.';
    }

    if (isPerbaikanWarna && reworkMethod.isEmpty) {
      return 'Metode Perbaikan Warna wajib dipilih minimal satu.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ListForm(
      formKey: widget.formKey,
      id: widget.id,
      form: widget.form,
      selectWorkOrder: widget.selectWorkOrder,
      selectMachine: widget.selectMachine,
      selectReworkCategory: widget.selectReworkCategory,
      reworkCategoryOption: widget.reworkCategoryOption,
      isSubmitting: _isSubmitting,
      isFormIncomplete: _isFormIncomplete,
      handleSubmit: widget.handleSubmit,
      handlePickAttachments: null,
      onFormChanged: widget.onFormChanged,
    );
  }
}
