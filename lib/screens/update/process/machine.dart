// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/master/machine.dart';

class MachineEditSection extends StatefulWidget {
  final data;
  final form;
  final handleSelectMachine;
  final getMachineStatus;
  final newMachines;

  const MachineEditSection(
      {super.key,
      this.data,
      this.form,
      this.handleSelectMachine,
      this.getMachineStatus,
      this.newMachines});

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
              children: machines.map((machine) {
                final machineData = machine['machine'] as Map<String, dynamic>?;
                final machineId = machineData?['id'];
                final status = machine['status'] ??
                    (machineId != null
                        ? widget.getMachineStatus(machineId)
                        : null);

                return SizedBox(
                  width: itemWidth,
                  child: GestureDetector(
                    onTap: () {
                      if (status == 'Selesai') return;
                      final isSubmitting = ValueNotifier<bool>(false);

                      showConfirmationDialog(
                        context: context,
                        title: 'Selesaikan Mesin',
                        message:
                            'Anda yakin ingin mengubah ${machine['machine']['name'] ?? '-'} menjadi selesai?',
                        isLoading: isSubmitting,
                        buttonBackground: CustomTheme().buttonColor('primary'),
                        onConfirm: () async {
                          try {
                            if (machineId == null) return;
                            await context
                                .read<MachineMasterService>()
                                .updateStatus(
                                  machine['machine']['id'].toString(),
                                  'Selesai',
                                  isSubmitting,
                                );

                            setState(() {
                              machine['status'] = 'Selesai';
                            });

                            Navigator.pop(context);
                          } catch (e) {
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Gagal update status'),
                              ),
                            );
                          }
                        },
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              machineData == null
                                  ? (machine['name'] ?? '-')
                                  : (machineData['code'] == null
                                      ? (machineData['name'] ?? '-')
                                      : '${machineData['code']} - ${machineData['name'] ?? '-'}'),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          status == 'Tersedia'
                              ? SizedBox(
                                  height: 48,
                                )
                              : CustomBadge(
                                  status: status == 'Selesai'
                                      ? 'Selesai'
                                      : status == 'Tersedia'
                                          ? 'Menunggu Diproses'
                                          : 'Diproses',
                                  title: status ?? '',
                                ),
                        ].separatedBy(CustomTheme().vGap('md')),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),

        // TAMBAH
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
                      'Mesin ini sudah ada dalam daftar dan masih dalam proses',
                    ),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 2),
                  ),
                );
              }

              widget.data['machines'] = current;
              widget.form['machines'] = current;
            });
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
