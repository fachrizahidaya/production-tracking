// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/rework/list_form.dart';

class CreateForm extends StatefulWidget {
  final formKey;
  final form;
  final handleSubmit;
  final data;
  final selectWorkOrder;
  final selectMachine;
  final selectReworkCategory;
  final reworkCategoryOption;
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> fc4fb8a2 (fix: kondisi button rework)
  final onFormChanged;
=======
>>>>>>> 55a0e7ec (feat: option rework dyeing)
  final id;
  final isLoading;

<<<<<<< HEAD
=======
  final id;

>>>>>>> 11b79f06 (feat: option rework dyeing)
  const CreateForm(
      {super.key,
      this.formKey,
      this.form,
<<<<<<< HEAD
<<<<<<< HEAD
      this.handleSubmit,
      this.data,
      this.selectWorkOrder,
      this.selectMachine,
      this.selectReworkCategory,
      this.reworkCategoryOption,
      this.onFormChanged,
      this.id,
      this.isLoading});
=======
  const CreateForm({
    super.key,
    this.formKey,
    this.form,
    this.selectWorkOrder,
    this.selectMachine,
    this.id,
  });
>>>>>>> dae9522 (fix: rework)
=======
      this.selectWorkOrder,
      this.selectMachine,
      this.id,
      this.reworkCategoryOption,
<<<<<<< HEAD
      this.selectReworkCategory});
>>>>>>> 11b79f06 (feat: option rework dyeing)
=======
      this.selectReworkCategory,
      this.onFormChanged});
>>>>>>> fc4fb8a2 (fix: kondisi button rework)
=======
      this.handleSubmit,
      this.data,
      this.selectWorkOrder,
      this.selectMachine,
      this.selectReworkCategory,
      this.reworkCategoryOption,
      this.id,
      this.isLoading});
>>>>>>> 55a0e7ec (feat: option rework dyeing)

  @override
  State<CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 55a0e7ec (feat: option rework dyeing)
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);

  bool get _isFormIncomplete {
    final woId = widget.form?['wo_id'];

<<<<<<< HEAD
=======
    final machines = widget.form?['machines'] as List? ?? [];

>>>>>>> 55a0e7ec (feat: option rework dyeing)
    final reworkCategory = widget.form?['rework_category'];

    final reworkType = widget.form?['rework_type'] as List? ?? [];

    final reworkMethod = widget.form?['rework_method'] as List? ?? [];

    final isPerbaikan = reworkCategory == 'perbaikan';

    final isPerbaikanWarna = reworkType.contains('perbaikan_warna');

    return woId == null ||
<<<<<<< HEAD
=======
        machines.isEmpty ||
>>>>>>> 55a0e7ec (feat: option rework dyeing)
        reworkCategory == null ||
        (isPerbaikan && reworkType.isEmpty) ||
        (isPerbaikanWarna && reworkMethod.isEmpty);
  }

  String? _getValidationMessage() {
    final woId = widget.form?['wo_id'];

<<<<<<< HEAD
=======
    final machines = widget.form?['machines'] as List? ?? [];

>>>>>>> 55a0e7ec (feat: option rework dyeing)
    final reworkCategory = widget.form?['rework_category'];

    final reworkType = widget.form?['rework_type'] as List? ?? [];

    final reworkMethod = widget.form?['rework_method'] as List? ?? [];

    final isPerbaikan = reworkCategory == 'perbaikan';

    final isPerbaikanWarna = reworkType.contains('perbaikan_warna');

    if (woId == null) {
      return 'Work Order wajib dipilih.';
    }

<<<<<<< HEAD
=======
    if (machines.isEmpty) {
      return 'Minimal pilih satu mesin.';
    }

>>>>>>> 55a0e7ec (feat: option rework dyeing)
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

<<<<<<< HEAD
=======
>>>>>>> dae9522 (fix: rework)
=======
>>>>>>> 55a0e7ec (feat: option rework dyeing)
  @override
  Widget build(BuildContext context) {
    return ListForm(
      formKey: widget.formKey,
      id: widget.id,
      form: widget.form,
<<<<<<< HEAD
      data: widget.data,
      selectWorkOrder: widget.selectWorkOrder,
      selectMachine: widget.selectMachine,
      selectReworkCategory: widget.selectReworkCategory,
      reworkCategoryOption: widget.reworkCategoryOption,
      isSubmitting: _isSubmitting,
      isFormIncomplete: _isFormIncomplete,
      handleSubmit: widget.handleSubmit,
      handlePickAttachments: null,
<<<<<<< HEAD
      onFormChanged: widget.onFormChanged,
=======
      selectWorkOrder: widget.selectWorkOrder,
      selectMachine: widget.selectMachine,
>>>>>>> dae9522 (fix: rework)
=======
>>>>>>> 55a0e7ec (feat: option rework dyeing)
    );
  }
}
