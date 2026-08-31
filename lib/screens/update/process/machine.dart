// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/master/machine.dart';

class MachineEditSection extends StatefulWidget {
  final dynamic data;
  final dynamic form;
  final handleSelectMachine;
  final getMachineStatus;
  final newMachines;
  final withAddMachine;
  final onMachineChanged;

  const MachineEditSection(
      {super.key,
      this.data,
      this.form,
      this.handleSelectMachine,
      this.getMachineStatus,
      this.newMachines,
      this.withAddMachine = true,
      this.onMachineChanged});

  @override
  State<MachineEditSection> createState() => _MachineEditSectionState();
}

class _MachineEditSectionState extends State<MachineEditSection> {
  @override
  Widget build(BuildContext context) {
    return _buildMultiMesinUpdate();
  }

  Widget _buildMultiMesinUpdate() {
    final machines = List<Map<String, dynamic>>.from(
      widget.data['machines'] ?? [],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - 24) / 4;

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: machines.asMap().entries.map((entry) {
                final index = entry.key;
                final machine = entry.value;

                final machineData = machine['machine'] as Map<String, dynamic>?;

                final machineId = machineData?['id'];

                /// status final
                final status = machine['status'] ??
                    (machineId != null
                        ? widget.getMachineStatus(machineId)
                        : null);

                /// cek apakah mesin baru
                final isNewMachine = widget.newMachines.any(
                  (m) => m['machine']?['id'].toString() == machineId.toString(),
                );

                /// disable klik jika:
                /// - selesai
                /// - mesin baru
                final disableTap = status == 'Selesai' || isNewMachine;

                return SizedBox(
                  width: itemWidth,
                  child: GestureDetector(
                    onTap: disableTap
                        ? null
                        : () {
                            final isSubmitting = ValueNotifier<bool>(false);

                            showConfirmationDialog(
                              context: context,
                              title: 'Selesaikan Mesin',
                              message:
                                  'Anda yakin ingin mengubah ${machine['machine']['name'] ?? '-'} menjadi selesai?',
                              isLoading: isSubmitting,
                              buttonBackground:
                                  CustomTheme().buttonColor('primary'),
                              onConfirm: () async {
                                try {
                                  if (machineId == null) return;

                                  await context
                                      .read<MachineMasterService>()
                                      .updateStatus(
                                        machineId.toString(),
                                        'Selesai',
                                        isSubmitting,
                                      );

                                  setState(() {
                                    machine['status'] = 'Selesai';
                                  });
                                  widget.onMachineChanged?.call();

                                  Navigator.pop(context);
                                } catch (e) {
                                  Navigator.pop(context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Gagal update status',
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              machineData == null
                                  ? (machine['name'] ?? '-')
                                  : (machineData['code'] == null
                                      ? (machineData['name'] ?? '-')
                                      : '${machineData['code']} - ${machineData['name'] ?? '-'}'),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          /// BADGE
                          if (status != 'Tersedia')
                            CustomBadge(
                              status:
                                  status == 'Selesai' ? 'Selesai' : 'Diproses',
                              title: status ?? '',
                            ),

                          /// DELETE BUTTON
                          if (isNewMachine && status != 'Selesai')
                            GestureDetector(
                              onTap: () {
                                final isSubmitting = ValueNotifier<bool>(false);
                                showConfirmationDialog(
                                  isLoading: isSubmitting,
                                  context: context,
                                  title: 'Hapus Mesin',
                                  message:
                                      'Anda yakin ingin menghapus mesin ini?',
                                  buttonBackground: Colors.red,
                                  onConfirm: () {
                                    setState(() {
                                      machines.removeAt(index);

                                      widget.newMachines.removeWhere(
                                        (m) =>
                                            m['machine']?['id'].toString() ==
                                            machineId.toString(),
                                      );

                                      widget.data['machines'] = machines;

                                      widget.form['machines'] = machines;
                                    });
                                    widget.onMachineChanged?.call();

                                    Navigator.pop(context);
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  Icons.close_outlined,
                                  color: Colors.red,
                                  size: 18,
                                ),
                              ),
                            ),
                        ].separatedBy(
                          CustomTheme().hGap('md'),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),

        /// TAMBAH MESIN
        if (widget.withAddMachine == true)
          GestureDetector(
            onTap: () async {
              final newMachine = await widget.handleSelectMachine();

              if (newMachine == null) return;

              setState(() {
                final current = List<Map<String, dynamic>>.from(
                  widget.data['machines'] ?? [],
                );

                final isDuplicate = current.any((m) {
                  final existingId = m['machine']?['id'];

                  final existingStatus = m['status'] ?? 'Tersedia';

                  return existingId.toString() == newMachine['id'].toString() &&
                      existingStatus != 'Selesai';
                });

                if (!isDuplicate) {
                  final newItem = {
                    'machine': newMachine,
                    'status': 'Tersedia',
                  };

                  current.add(newItem);

                  widget.newMachines.add(newItem);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Mesin ini sudah ada dalam daftar',
                      ),
                      backgroundColor: Colors.orange,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }

                widget.data['machines'] = current;
                widget.form['machines'] = current;
              });
              widget.onMachineChanged?.call();
            },
            child: Container(
              height: 48,
              margin: EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text('+ Tambah Mesin'),
              ),
            ),
          ),
      ].separatedBy(CustomTheme().vGap('lg')),
    );
  }
}
