// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/detail/greige_process_edit_layout.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/container/template.dart';
<<<<<<< HEAD
<<<<<<< HEAD
=======
import 'package:textile_tracking/components/master/form/select_form.dart';
>>>>>>> 95d1a035 (fix: weaving, shearing)
=======
>>>>>>> 80dec51b (fix: edit warping-shearing)
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/result/show_select_dialog.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:textile_tracking/models/option/option_machine.dart';
import 'package:textile_tracking/screens/update/process/machine.dart';
=======
import 'package:textile_tracking/helpers/util/note_editor.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/option/option_machine.dart';
>>>>>>> 95d1a035 (fix: weaving, shearing)
=======
import 'package:textile_tracking/models/option/option_machine.dart';
import 'package:textile_tracking/screens/update/process/machine.dart';
>>>>>>> 80dec51b (fix: edit warping-shearing)
import 'package:textile_tracking/screens/weaving/model/weaving.dart';

class EditWeavingScreen extends StatefulWidget {
  final dynamic id;

  const EditWeavingScreen({
    super.key,
    required this.id,
  });

  @override
  State<EditWeavingScreen> createState() => _EditWeavingScreenState();
}

class _EditWeavingScreenState extends State<EditWeavingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);
<<<<<<< HEAD
<<<<<<< HEAD
=======
  final TextEditingController _notesController = TextEditingController();
>>>>>>> 95d1a035 (fix: weaving, shearing)
=======
>>>>>>> 80dec51b (fix: edit warping-shearing)

  bool _isLoading = true;
  bool _isFetchingMachine = false;
  String? _errorMessage;

  Map<String, dynamic> _data = {};
  final Map<String, dynamic> _form = {};
  List<dynamic> _machineOption = [];
<<<<<<< HEAD
<<<<<<< HEAD
  final List<Map<String, dynamic>> _newMachines = [];
=======
>>>>>>> 95d1a035 (fix: weaving, shearing)
=======
  final List<Map<String, dynamic>> _newMachines = [];
>>>>>>> 80dec51b (fix: edit warping-shearing)

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _isSubmitting.dispose();
<<<<<<< HEAD
<<<<<<< HEAD
=======
    _notesController.dispose();
>>>>>>> 95d1a035 (fix: weaving, shearing)
=======
>>>>>>> 80dec51b (fix: edit warping-shearing)
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final service = Provider.of<WeavingService>(context, listen: false);
      await service.getDataView(context, widget.id);

      final response = service.dataView;
      final detail = response['data'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(response['data'])
          : Map<String, dynamic>.from(response);

<<<<<<< HEAD
<<<<<<< HEAD
      final orderGreige = _mapValue(detail['order_greige']);
      final machines = _normalizeMachines(detail['machines']);
=======
      final machine = _mapValue(detail['machine']);
      final orderGreige = _mapValue(detail['order_greige']);
>>>>>>> 95d1a035 (fix: weaving, shearing)
=======
      final orderGreige = _mapValue(detail['order_greige']);
      final machines = _normalizeMachines(detail['machines']);
>>>>>>> 80dec51b (fix: edit warping-shearing)

      _form
        ..clear()
        ..addAll({
<<<<<<< HEAD
<<<<<<< HEAD
=======
          'machine_id': detail['machine_id']?.toString(),
          'nama_mesin': _machineLabel(machine),
>>>>>>> 95d1a035 (fix: weaving, shearing)
=======
>>>>>>> 80dec51b (fix: edit warping-shearing)
          'order_greige_id': detail['order_greige_id']?.toString(),
          'no_greige_order': orderGreige['og_no']?.toString() ?? '',

          // tambahkan ini
          'notes': detail['notes']?.toString() ?? '',
          'skip_shearing': detail['skip_shearing'] ?? false,
<<<<<<< HEAD
<<<<<<< HEAD
          'machines': machines,
          'machine_ids': List<dynamic>.from(detail['machine_ids'] ?? []),
        });

      setState(() {
        _data = detail;
        _data['machines'] = machines;
      });

      await _fetchMachine(_machineIds(machines));
=======
=======
          'machines': machines,
          'machine_ids': List<dynamic>.from(detail['machine_ids'] ?? []),
>>>>>>> 80dec51b (fix: edit warping-shearing)
        });

      setState(() {
        _data = detail;
        _data['machines'] = machines;
      });

<<<<<<< HEAD
      await _fetchMachine(detail['machine_id']);
>>>>>>> 95d1a035 (fix: weaving, shearing)
=======
      await _fetchMachine(_machineIds(machines));
>>>>>>> 80dec51b (fix: edit warping-shearing)
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

<<<<<<< HEAD
<<<<<<< HEAD
  Future<void> _fetchMachine(List<dynamic> currentMachineIds) async {
=======
  Future<void> _fetchMachine(dynamic currentMachineId) async {
>>>>>>> 95d1a035 (fix: weaving, shearing)
=======
  Future<void> _fetchMachine(List<dynamic> currentMachineIds) async {
>>>>>>> 80dec51b (fix: edit warping-shearing)
    setState(() => _isFetchingMachine = true);

    try {
      final service = Provider.of<OptionMachineService>(context, listen: false);
      await service.fetchOptionsWeaving(
<<<<<<< HEAD
<<<<<<< HEAD
        currentMachineIds: currentMachineIds,
=======
        currentMachineIds:
            currentMachineId == null ? null : [currentMachineId.toString()],
>>>>>>> 95d1a035 (fix: weaving, shearing)
=======
        currentMachineIds: currentMachineIds,
>>>>>>> 80dec51b (fix: edit warping-shearing)
      );

      setState(() {
        _machineOption = service.dataListOption;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isFetchingMachine = false);
      }
    }
  }

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 80dec51b (fix: edit warping-shearing)
  Future<Map<String, dynamic>?> _selectMachine() async {
    Map<String, dynamic>? result;

    await showSelectDialog(
<<<<<<< HEAD
=======
  Future<void> _selectMachine() async {
    showSelectDialog(
>>>>>>> 95d1a035 (fix: weaving, shearing)
=======
>>>>>>> 80dec51b (fix: edit warping-shearing)
      context: context,
      title: 'Mesin',
      isFetching: _isFetchingMachine,
      option: _machineOption,
<<<<<<< HEAD
<<<<<<< HEAD
      selected: '',
      handleChangeValue: (selected) {
        result = {
          'id': selected['value'],
          'name': selected['label'],
          'code': selected['code'],
          'status': selected['status'] ?? 'Tersedia',
        };
      },
    );

    return result;
  }

  bool get _isFormInvalid {
    return (_data['machines'] as List? ?? []).isEmpty;
=======
      selected: _form['machine_id']?.toString() ?? '',
=======
      selected: '',
>>>>>>> 80dec51b (fix: edit warping-shearing)
      handleChangeValue: (selected) {
        result = {
          'id': selected['value'],
          'name': selected['label'],
          'code': selected['code'],
          'status': selected['status'] ?? 'Tersedia',
        };
      },
    );

    return result;
  }

  bool get _isFormInvalid {
<<<<<<< HEAD
    return (_form['machine_id'] == null ||
        _form['machine_id'].toString().isEmpty);
>>>>>>> 95d1a035 (fix: weaving, shearing)
=======
    return (_data['machines'] as List? ?? []).isEmpty;
>>>>>>> 80dec51b (fix: edit warping-shearing)
  }

  Future<void> _handleSubmit() async {
    if (_isFormInvalid) return;

    final weaving = Weaving(
<<<<<<< HEAD
<<<<<<< HEAD
        orderGreigeId: int.tryParse(_form['order_greige_id']?.toString() ?? ''),
        notes: _form['notes']?.toString(),
        skipShearing: _form['skip_shearing'],
        machines: List<Map<String, dynamic>>.from(_data['machines'] ?? []),
        machine_ids: _newMachines
            .map((item) => item['machine']?['id'])
            .where((id) => id != null)
            .toList());
=======
        machineId: int.tryParse(_form['machine_id']?.toString() ?? ''),
        orderGreigeId: int.tryParse(_form['order_greige_id']?.toString() ?? ''),
        notes: _form['notes']?.toString(),
        skipShearing: _form['skip_shearing']);
>>>>>>> 95d1a035 (fix: weaving, shearing)
=======
        orderGreigeId: int.tryParse(_form['order_greige_id']?.toString() ?? ''),
        notes: _form['notes']?.toString(),
        skipShearing: _form['skip_shearing'],
        machines: List<Map<String, dynamic>>.from(_data['machines'] ?? []),
        machine_ids: _newMachines
            .map((item) => item['machine']?['id'])
            .where((id) => id != null)
            .toList());
>>>>>>> 80dec51b (fix: edit warping-shearing)

    try {
      final message = await Provider.of<WeavingService>(context, listen: false)
          .updateItem(context, widget.id.toString(), weaving, _isSubmitting);

      await showAlertDialog(
        context: context,
        title: 'Weaving Diubah',
        message: message,
      );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  Future<void> _handleCancel() async {
    showConfirmationDialog(
      context: context,
      isLoading: _isSubmitting,
      onConfirm: () async {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      title: 'Batal Edit Proses Weaving',
      message: 'Anda yakin ingin kembali? Semua perubahan tidak disimpan',
      buttonBackground: CustomTheme().buttonColor('danger'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GreigeProcessEditLayout(
      title: 'Edit Weaving',
      id: widget.id,
      isLoading: _isLoading,
      errorMessage: _errorMessage,
      onRetry: _loadData,
      onCancel: _handleCancel,
      formKey: _formKey,
      formSections: [
<<<<<<< HEAD
<<<<<<< HEAD
        _buildMachineCard(),
=======
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildSummaryCard()),
            Expanded(child: _buildGreigeCard()),
          ].separatedBy(CustomTheme().hGap('xl')),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildMachineCard()),
            Expanded(child: _buildAdditionalCard()),
          ].separatedBy(CustomTheme().hGap('xl')),
        ),
        _buildNoteCard()
>>>>>>> 95d1a035 (fix: weaving, shearing)
=======
        _buildMachineCard(),
>>>>>>> 80dec51b (fix: edit warping-shearing)
      ],
      submitSection: _buildSubmitSection(),
      greigeOrderData: _mapValue(_data['order_greige']),
    );
  }

<<<<<<< HEAD
<<<<<<< HEAD
=======
  Widget _buildSummaryCard() {
    final orderGreige = _mapValue(_data['order_greige']);

    return TemplateCard(
      title: 'Informasi Weaving',
      icon: Icons.assignment_outlined,
      child: Column(
        children: [
          _InfoLine('No. Weaving', _display(_data['weaving_no'])),
          // _InfoLine('Status', _display(_data['status'])),
          // _InfoLine('Greige Order', _display(orderGreige['og_no'])),
        ].separatedBy(Divider(height: 18, color: Colors.grey.shade200)),
      ),
    );
  }

  Widget _buildGreigeCard() {
    return TemplateCard(
      title: 'Greige Order',
      icon: Icons.assessment_outlined,
      child: SelectForm(
        label: 'Greige Order',
        onTap: () {},
        selectedLabel: _form['no_greige_order']?.toString() ?? '',
        selectedValue: _form['order_greige_id']?.toString() ?? '',
        required: true,
        isDisabled: true,
      ),
    );
  }

>>>>>>> 95d1a035 (fix: weaving, shearing)
=======
>>>>>>> 80dec51b (fix: edit warping-shearing)
  Widget _buildMachineCard() {
    return TemplateCard(
      title: 'Mesin',
      icon: Icons.local_laundry_service_outlined,
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 80dec51b (fix: edit warping-shearing)
      child: MachineEditSection(
        data: _data,
        form: _form,
        handleSelectMachine: _selectMachine,
        getMachineStatus: _getMachineStatus,
        newMachines: _newMachines,
<<<<<<< HEAD
=======
      child: SelectForm(
        label: 'Mesin',
        onTap: _selectMachine,
        selectedLabel: _form['nama_mesin']?.toString() ?? '',
        selectedValue: _form['machine_id']?.toString() ?? '',
        required: true,
>>>>>>> 95d1a035 (fix: weaving, shearing)
=======
>>>>>>> 80dec51b (fix: edit warping-shearing)
      ),
    );
  }

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 80dec51b (fix: edit warping-shearing)
  String _getMachineStatus(dynamic machineId) {
    final option = _machineOption.firstWhere(
      (item) => item['value'].toString() == machineId.toString(),
      orElse: () => null,
<<<<<<< HEAD
    );
    return option?['status']?.toString() ?? 'Tersedia';
  }

  List<dynamic> _machineIds(List<Map<String, dynamic>> machines) {
    return machines
        .map((item) => item['machine']?['id'] ?? item['id'])
        .where((id) => id != null)
        .toList();
  }

  List<Map<String, dynamic>> _normalizeMachines(dynamic value) {
    return (value as List? ?? []).map<Map<String, dynamic>>((item) {
      final machine = Map<String, dynamic>.from(item);
      if (machine['machine'] is Map) return machine;

      return {
        'machine': machine,
        'status': machine['status'] ?? 'Tersedia',
      };
    }).toList();
=======
  Widget _buildAdditionalCard() {
    return TemplateCard(
      title: 'Informasi Tambahan',
      icon: Icons.description_outlined,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: const Text('Skip Shearing'),
              subtitle: Text(
                _form['skip_shearing'] == true
                    ? 'Shearing akan dilewati'
                    : 'Shearing akan diproses',
              ),
              value: _form['skip_shearing'] ?? false,
              onChanged: (value) {
                setState(() {
                  _form['skip_shearing'] = value;
                });
              },
            ),
          ),
        ],
      ),
=======
>>>>>>> 80dec51b (fix: edit warping-shearing)
    );
    return option?['status']?.toString() ?? 'Tersedia';
  }

<<<<<<< HEAD
  Widget _buildNoteCard() {
    return Column(
      children: [
        NoteEditor(
          controller: _notesController,
          form: _form,
          formKey: 'notes',
          label: 'Catatan',
          onChanged: (value) {
            _handleChangeInput('notes', value);
          },
        ),
      ],
    );
>>>>>>> 95d1a035 (fix: weaving, shearing)
=======
  List<dynamic> _machineIds(List<Map<String, dynamic>> machines) {
    return machines
        .map((item) => item['machine']?['id'] ?? item['id'])
        .where((id) => id != null)
        .toList();
  }

  List<Map<String, dynamic>> _normalizeMachines(dynamic value) {
    return (value as List? ?? []).map<Map<String, dynamic>>((item) {
      final machine = Map<String, dynamic>.from(item);
      if (machine['machine'] is Map) return machine;

      return {
        'machine': machine,
        'status': machine['status'] ?? 'Tersedia',
      };
    }).toList();
>>>>>>> 80dec51b (fix: edit warping-shearing)
  }

  Widget _buildSubmitSection() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isSubmitting,
      builder: (context, isSubmitting, _) {
        return Row(
          children: [
            Expanded(
              child: CancelButton(
                label: 'Batal',
                onPressed: () => Navigator.pop(context),
<<<<<<< HEAD
<<<<<<< HEAD
                customHeight: 56.0,
=======
                customHeight: 50.0,
>>>>>>> 95d1a035 (fix: weaving, shearing)
=======
                customHeight: 56.0,
>>>>>>> 80dec51b (fix: edit warping-shearing)
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FormButton(
                label: 'Simpan',
                isLoading: isSubmitting,
                isDisabled: _isFormInvalid,
<<<<<<< HEAD
<<<<<<< HEAD
                customHeight: 56.0,
=======
                customHeight: 50.0,
>>>>>>> 95d1a035 (fix: weaving, shearing)
=======
                customHeight: 56.0,
>>>>>>> 80dec51b (fix: edit warping-shearing)
                onPressed: _handleSubmit,
              ),
            ),
          ],
        );
      },
    );
  }
}

<<<<<<< HEAD
<<<<<<< HEAD
=======
class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: CustomTheme().fontSize('md'),
              fontWeight: CustomTheme().fontWeight('semibold'),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: CustomTheme().fontSize('md'),
              fontWeight: CustomTheme().fontWeight('bold'),
            ),
          ),
        ),
      ],
    );
  }
}

>>>>>>> 95d1a035 (fix: weaving, shearing)
=======
>>>>>>> 80dec51b (fix: edit warping-shearing)
Map<String, dynamic> _mapValue(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}
<<<<<<< HEAD
<<<<<<< HEAD
=======

String _machineLabel(Map<String, dynamic> machine) {
  final code = machine['code']?.toString() ?? '';
  final name = machine['name']?.toString() ?? '';

  if (code.isEmpty && name.isEmpty) return '';
  if (code.isEmpty) return name;
  if (name.isEmpty) return code;
  return '$code - $name';
}

String _display(dynamic value) {
  if (value == null || value.toString().isEmpty) return '-';
  return value.toString();
}
>>>>>>> 95d1a035 (fix: weaving, shearing)
=======
>>>>>>> 80dec51b (fix: edit warping-shearing)
