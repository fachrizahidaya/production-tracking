// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/detail/greige_process_edit_layout.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/container/template.dart';
<<<<<<< HEAD
=======
import 'package:textile_tracking/components/master/form/select_form.dart';
>>>>>>> 95d1a035 (fix: weaving, shearing)
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/result/show_select_dialog.dart';
<<<<<<< HEAD
import 'package:textile_tracking/models/option/option_machine.dart';
import 'package:textile_tracking/screens/shearing/model/shearing.dart';
import 'package:textile_tracking/screens/update/process/machine.dart';
=======
import 'package:textile_tracking/helpers/util/note_editor.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/option/option_machine.dart';
import 'package:textile_tracking/screens/shearing/model/shearing.dart';
>>>>>>> 95d1a035 (fix: weaving, shearing)

class EditShearingScreen extends StatefulWidget {
  final dynamic id;

  const EditShearingScreen({
    super.key,
    required this.id,
  });

  @override
  State<EditShearingScreen> createState() => _EditShearingScreenState();
}

class _EditShearingScreenState extends State<EditShearingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);
<<<<<<< HEAD
=======
  final TextEditingController _notesController = TextEditingController();
>>>>>>> 95d1a035 (fix: weaving, shearing)

  bool _isLoading = true;
  bool _isFetchingMachine = false;
  String? _errorMessage;

  Map<String, dynamic> _data = {};
  final Map<String, dynamic> _form = {};
  List<dynamic> _machineOption = [];
<<<<<<< HEAD
  final List<Map<String, dynamic>> _newMachines = [];
=======
>>>>>>> 95d1a035 (fix: weaving, shearing)

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
=======
    _notesController.dispose();
>>>>>>> 95d1a035 (fix: weaving, shearing)
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final service = Provider.of<ShearingService>(context, listen: false);
      await service.getDataView(context, widget.id);

      final response = service.dataView;
      final detail = response['data'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(response['data'])
          : Map<String, dynamic>.from(response);

<<<<<<< HEAD
      final orderGreige = _mapValue(detail['order_greige']);
      final machines = _normalizeMachines(detail['machines']);
=======
      final machine = _mapValue(detail['machine']);
      final orderGreige = _mapValue(detail['order_greige']);
>>>>>>> 95d1a035 (fix: weaving, shearing)

      _form
        ..clear()
        ..addAll({
<<<<<<< HEAD
=======
          'machine_id': detail['machine_id']?.toString(),
          'nama_mesin': _machineLabel(machine),
>>>>>>> 95d1a035 (fix: weaving, shearing)
          'order_greige_id': detail['order_greige_id']?.toString(),
          'no_greige_order': orderGreige['og_no']?.toString() ?? '',

          // tambahkan ini
          'notes': detail['notes']?.toString() ?? '',
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
        });

      _notesController.text = detail['notes']?.toString() ?? '';

      setState(() {
        _data = detail;
      });

      await _fetchMachine(detail['machine_id']);
>>>>>>> 95d1a035 (fix: weaving, shearing)
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

<<<<<<< HEAD
  Future<void> _fetchMachine(List<dynamic> currentMachineIds) async {
=======
  Future<void> _fetchMachine(dynamic currentMachineId) async {
>>>>>>> 95d1a035 (fix: weaving, shearing)
    setState(() => _isFetchingMachine = true);

    try {
      final service = Provider.of<OptionMachineService>(context, listen: false);
      await service.fetchOptionsShearing(
<<<<<<< HEAD
        currentMachineIds: currentMachineIds,
=======
        currentMachineIds:
            currentMachineId == null ? null : [currentMachineId.toString()],
>>>>>>> 95d1a035 (fix: weaving, shearing)
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
  Future<Map<String, dynamic>?> _selectMachine() async {
    Map<String, dynamic>? result;

    await showSelectDialog(
=======
  Future<void> _selectMachine() async {
    showSelectDialog(
>>>>>>> 95d1a035 (fix: weaving, shearing)
      context: context,
      title: 'Mesin',
      isFetching: _isFetchingMachine,
      option: _machineOption,
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
      handleChangeValue: (selected) {
        setState(() {
          _form['machine_id'] = selected['value']?.toString();
          _form['nama_mesin'] = selected['label']?.toString() ?? '';
        });
      },
    );
  }

  void _handleChangeInput(String key, dynamic value) {
    setState(() {
      _form[key] = value;
    });
  }

  bool get _isFormInvalid {
    return (_form['machine_id'] == null ||
            _form['machine_id'].toString().isEmpty) ||
        (_form['yarn_qty'] == null || _form['yarn_qty'].toString().isEmpty);
>>>>>>> 95d1a035 (fix: weaving, shearing)
  }

  Future<void> _handleSubmit() async {
    if (_isFormInvalid) return;

    final shearing = Shearing(
<<<<<<< HEAD
      orderGreigeId: int.tryParse(_form['order_greige_id']?.toString() ?? ''),
      notes: _form['notes']?.toString(),
      machines: List<Map<String, dynamic>>.from(_data['machines'] ?? []),
      machine_ids: _newMachines
          .map((item) => item['machine']?['id'])
          .where((id) => id != null)
          .toList(),
=======
      machineId: int.tryParse(_form['machine_id']?.toString() ?? ''),
      orderGreigeId: int.tryParse(_form['order_greige_id']?.toString() ?? ''),
      notes: _form['notes']?.toString(),
>>>>>>> 95d1a035 (fix: weaving, shearing)
    );

    try {
      final message = await Provider.of<ShearingService>(context, listen: false)
          .updateItem(context, widget.id.toString(), shearing, _isSubmitting);

      await showAlertDialog(
        context: context,
        title: 'Shearing Diubah',
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
      title: 'Batal Edit Proses Shearing',
      message: 'Anda yakin ingin kembali? Semua perubahan tidak disimpan',
      buttonBackground: CustomTheme().buttonColor('danger'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GreigeProcessEditLayout(
      title: 'Edit Shearing',
      id: widget.id,
      isLoading: _isLoading,
      errorMessage: _errorMessage,
      onRetry: _loadData,
      onCancel: _handleCancel,
      formKey: _formKey,
      formSections: [
<<<<<<< HEAD
        _buildMachineCard(),
=======
        _buildSummaryCard(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildGreigeCard()),
            Expanded(child: _buildMachineCard()),
          ].separatedBy(CustomTheme().hGap('xl')),
        ),
        _buildAdditionalCard(),
>>>>>>> 95d1a035 (fix: weaving, shearing)
      ],
      submitSection: _buildSubmitSection(),
      greigeOrderData: _mapValue(_data['order_greige']),
    );
  }

<<<<<<< HEAD
=======
  Widget _buildSummaryCard() {
    final orderGreige = _mapValue(_data['order_greige']);

    return TemplateCard(
      title: 'Informasi Shearing',
      icon: Icons.assignment_outlined,
      child: Column(
        children: [
          _InfoLine('No. Shearing', _display(_data['shearing_no'])),
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
  Widget _buildMachineCard() {
    return TemplateCard(
      title: 'Mesin',
      icon: Icons.local_laundry_service_outlined,
<<<<<<< HEAD
      child: MachineEditSection(
        data: _data,
        form: _form,
        handleSelectMachine: _selectMachine,
        getMachineStatus: _getMachineStatus,
        newMachines: _newMachines,
=======
      child: SelectForm(
        label: 'Mesin',
        onTap: _selectMachine,
        selectedLabel: _form['nama_mesin']?.toString() ?? '',
        selectedValue: _form['machine_id']?.toString() ?? '',
        required: true,
>>>>>>> 95d1a035 (fix: weaving, shearing)
      ),
    );
  }

<<<<<<< HEAD
  String _getMachineStatus(dynamic machineId) {
    final option = _machineOption.firstWhere(
      (item) => item['value'].toString() == machineId.toString(),
      orElse: () => null,
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
                customHeight: 56.0,
=======
                customHeight: 50.0,
>>>>>>> 95d1a035 (fix: weaving, shearing)
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FormButton(
                label: 'Simpan',
                isLoading: isSubmitting,
                isDisabled: _isFormInvalid,
<<<<<<< HEAD
                customHeight: 56.0,
=======
                customHeight: 50.0,
>>>>>>> 95d1a035 (fix: weaving, shearing)
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
Map<String, dynamic> _mapValue(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}
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
