import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/dasboard_card.dart';
import 'package:textile_tracking/components/master/form/group_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';

class WorkOrderProcess extends StatefulWidget {
  final List<dynamic> data;
  final onHandleFilter;
  final dariTanggal;
  final sampaiTanggal;
  final filterWidget;

  const WorkOrderProcess(
      {super.key,
      this.dariTanggal,
      required this.data,
      this.onHandleFilter,
      this.sampaiTanggal,
      this.filterWidget});

  @override
  State<WorkOrderProcess> createState() => _WorkOrderProcessState();
}

class _WorkOrderProcessState extends State<WorkOrderProcess> {
  final double width = 14;
  double maxY = 0;
  int? touchedIndex;

  final TextEditingController dariTanggalInput = TextEditingController();
  final TextEditingController sampaiTanggalInput = TextEditingController();

  @override
  void initState() {
    super.initState();

    dariTanggalInput.text = widget.dariTanggal;
    sampaiTanggalInput.text = widget.sampaiTanggal;
  }

  @override
  void didUpdateWidget(covariant WorkOrderProcess oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dariTanggal != dariTanggalInput.text) {
      dariTanggalInput.text = widget.dariTanggal;
    }
    if (widget.sampaiTanggal != sampaiTanggalInput.text) {
      sampaiTanggalInput.text = widget.sampaiTanggal;
    }
  }

  Future<void> _pickDate({
    required TextEditingController controller,
    required String type,
  }) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.text.isNotEmpty
          ? DateTime.tryParse(controller.text) ?? DateTime.now()
          : DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: CustomTheme().colors('base'),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        controller.text = formattedDate;
      });
      widget.onHandleFilter(type, formattedDate);
    }
  }

  void _openFilter() {
    if (widget.filterWidget != null) {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        enableDrag: true,
        isDismissible: true,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return widget.filterWidget!;
        },
      );
    }
  }

  @override
  void dispose() {
    dariTanggalInput.dispose();
    sampaiTanggalInput.dispose();
    super.dispose();
  }

  Widget _buildDateFilterRow() {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return SizedBox(
      width: 400,
      child: Row(
        children: [
          Expanded(
            child: GroupForm(
              label: 'Dari Tanggal',
              formControl: TextFormField(
                controller: dariTanggalInput,
                style: const TextStyle(fontSize: 14),
                decoration: CustomTheme().inputDateDecoration(
                  hintTextString: 'Pilih tanggal',
                ),
                keyboardType: TextInputType.datetime,
                readOnly: true,
                onTap: () => _pickDate(
                  controller: dariTanggalInput,
                  type: 'dari_tanggal',
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GroupForm(
              label: 'Sampai Tanggal',
              formControl: TextFormField(
                controller: sampaiTanggalInput,
                style: const TextStyle(fontSize: 14),
                decoration: CustomTheme().inputDateDecoration(
                  hintTextString: 'Pilih tanggal',
                ),
                keyboardType: TextInputType.datetime,
                readOnly: true,
                onTap: () => _pickDate(
                  controller: sampaiTanggalInput,
                  type: 'sampai_tanggal',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DasboardCard(
      child: Padding(
        padding: PaddingColumn.screen,
        child: SizedBox(
          width: 400,
        ),
      ),
    );
  }
}
