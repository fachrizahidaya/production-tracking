// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/detail/greige_process_edit_layout.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/result/show_select_dialog.dart';
import 'package:textile_tracking/models/option/option_machine.dart';
import 'package:textile_tracking/screens/shearing/model/shearing.dart';
import 'package:textile_tracking/screens/update/process/machine.dart';

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

  bool _isLoading = true;
  bool _isFetchingMachine = false;
  String? _errorMessage;

  Map<String, dynamic> _data = {};
  final Map<String, dynamic> _form = {};
  List<dynamic> _machineOption = [];
  final List<Map<String, dynamic>> _newMachines = [];

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

      final orderGreige = _mapValue(detail['order_greige']);
      final machines = _normalizeMachines(detail['machines']);

      _form
        ..clear()
        ..addAll({
          'order_greige_id': detail['order_greige_id']?.toString(),
          'no_greige_order': orderGreige['og_no']?.toString() ?? '',

          // tambahkan ini
          'notes': detail['notes']?.toString() ?? '',
          'machines': machines,
          'machine_ids': List<dynamic>.from(detail['machine_ids'] ?? []),
        });

      setState(() {
        _data = detail;
        _data['machines'] = machines;
      });

      await _fetchMachine(_machineIds(machines));
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _fetchMachine(List<dynamic> currentMachineIds) async {
    setState(() => _isFetchingMachine = true);

    try {
      final service = Provider.of<OptionMachineService>(context, listen: false);
      await service.fetchOptionsShearing(
        currentMachineIds: currentMachineIds,
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

  Future<Map<String, dynamic>?> _selectMachine() async {
    Map<String, dynamic>? result;

    await showSelectDialog(
      context: context,
      title: 'Mesin',
      isFetching: _isFetchingMachine,
      option: _machineOption,
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
  }

  Future<void> _handleSubmit() async {
    if (_isFormInvalid) return;

    final shearing = Shearing(
      orderGreigeId: int.tryParse(_form['order_greige_id']?.toString() ?? ''),
      notes: _form['notes']?.toString(),
      machines: List<Map<String, dynamic>>.from(_data['machines'] ?? []),
      machine_ids: _newMachines
          .map((item) => item['machine']?['id'])
          .where((id) => id != null)
          .toList(),
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
        _buildMachineCard(),
      ],
      submitSection: _buildSubmitSection(),
      greigeOrderData: _mapValue(_data['order_greige']),
    );
  }

  Widget _buildMachineCard() {
    return TemplateCard(
      title: 'Mesin',
      icon: Icons.local_laundry_service_outlined,
      child: MachineEditSection(
        data: _data,
        form: _form,
        handleSelectMachine: _selectMachine,
        getMachineStatus: _getMachineStatus,
        newMachines: _newMachines,
      ),
    );
  }

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
                customHeight: 56.0,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FormButton(
                label: 'Simpan',
                isLoading: isSubmitting,
                isDisabled: _isFormInvalid,
                customHeight: 56.0,
                onPressed: _handleSubmit,
              ),
            ),
          ],
        );
      },
    );
  }
}

Map<String, dynamic> _mapValue(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}
