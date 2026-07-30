// ignore_for_file: use_build_context_synchronously, unused_element, unused_element_parameter

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/detail/greige_process_detail_list.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/screens/weaving/detail/edit_weaving.dart';
import 'package:textile_tracking/screens/weaving/model/weaving.dart';

class WeavingDetailScreen extends StatefulWidget {
  final id;
  final no;
  final canDelete;
  final canUpdate;
  final bool openUpdateOnStart;

  const WeavingDetailScreen({
    super.key,
    this.id,
    this.no,
    this.canDelete,
    this.canUpdate,
    this.openUpdateOnStart = false,
  });

  @override
  State<WeavingDetailScreen> createState() => _WeavingDetailScreenState();
}

class _WeavingDetailScreenState extends State<WeavingDetailScreen> {
  final ValueNotifier<bool> _deleteLoading = ValueNotifier(false);
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  @override
  void dispose() {
    _deleteLoading.dispose();
    super.dispose();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await Provider.of<WeavingService>(context, listen: false)
          .getDataView(context, widget.id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Map<String, dynamic> _detailData(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map<String, dynamic>) return data;
    return response;
  }

  Future<void> _handleDelete(Map<String, dynamic> data) async {
    final hasDeletePermission = widget.canDelete == true;
    final canDeleteItem = data['can_delete'] != false;

    if (!hasDeletePermission || !canDeleteItem) {
      await showAlertDialog(
        context: context,
        title: 'Tidak Bisa Hapus',
        message:
            'Proses tidak bisa dihapus karena sudah diproses di proses selanjutnya.',
      );
      return;
    }

    showConfirmationDialog(
      context: context,
      title: 'Hapus Data',
      message: 'Apakah Anda yakin ingin menghapus proses weaving?',
      isLoading: _deleteLoading,
      buttonBackground: CustomTheme().buttonColor('danger'),
      onConfirm: () async {
        try {
          final message =
              await Provider.of<WeavingService>(context, listen: false)
                  .deleteItem(context, widget.id.toString(), _deleteLoading);

          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          await showAlertDialog(
            context: context,
            title: 'Weaving Dihapus',
            message: message,
          );

          if (mounted) {
            Navigator.pop(context, true);
          }
        } catch (e) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          await showAlertDialog(
            context: context,
            title: 'Error',
            message: e.toString(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Consumer<WeavingService>(
          builder: (context, service, _) {
            if (_isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_errorMessage != null) {
              return _ErrorView(
                message: _errorMessage!,
                onRetry: _fetchDetail,
              );
            }

            final data = _detailData(service.dataView);

            return GreigeProcessDetailList(
              data: data,
              processName: 'Weaving',
              processNoKey: 'weaving_no',
              onRefresh: _fetchDetail,
              canDelete: widget.canDelete,
              canUpdate: widget.canUpdate,
              onDelete: () => _handleDelete(data),
              onEdit: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditWeavingScreen(
                      id: widget.id,
                    ),
                  ),
                );

                if (!mounted) return;

                if (result == true) {
                  Navigator.pop(context, true);
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class _WarpingDetailHeader extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool canDelete;
  final VoidCallback onDelete;

  const _WarpingDetailHeader({
    required this.data,
    required this.canDelete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 640;
        final deleteButton = canDelete && data['can_delete'] != false
            ? ElevatedButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: Colors.white),
                label: const Text('Hapus Weaving'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomTheme().buttonColor('danger'),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )
            : null;

        final titleContent = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              tooltip: 'Kembali',
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, size: 28),
              color: Colors.grey.shade700,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detail Proses Weaving',
                    style: TextStyle(
                      fontSize: isCompact ? 24 : 28,
                      height: 1.15,
                      color: Colors.grey.shade900,
                      fontWeight: CustomTheme().fontWeight('bold'),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Lihat ringkasan proses Weaving dan item Persiapan Produksi.',
                    style: TextStyle(
                      fontSize: CustomTheme().fontSize('md'),
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (!isCompact && deleteButton != null) ...[
              const SizedBox(width: 16),
              deleteButton,
            ],
          ],
        );

        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 16, 18),
          child: isCompact && deleteButton != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    titleContent,
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.only(left: 48),
                      child: deleteButton,
                    ),
                  ],
                )
              : titleContent,
        );
      },
    );
  }
}

class _WarpingDetailBody extends StatelessWidget {
  final Map<String, dynamic> data;

  const _WarpingDetailBody({required this.data});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 920;
        final left = Column(
          children: [
            _ProcessSummaryCard(data: data),
            _DetailCard(
              icon: Icons.account_tree_outlined,
              title: 'Hasil Weaving',
              child: _ResultSection(data: data),
            ),
            _DetailCard(
              icon: Icons.event_note_outlined,
              title: 'Catatan Weaving',
              child: _NoteBox(text: _display(data['notes'])),
            ),
          ].separatedBy(const SizedBox(height: 14)),
        );

        final orderGreige = _mapValue(data['order_greige']);
        final right = Column(
          children: [
            _GreigeOrderCard(data: orderGreige),
            _DetailCard(
              icon: Icons.event_note_outlined,
              title: 'Catatan Order Greige',
              child: _NoteBox(text: _display(orderGreige['notes'])),
            ),
          ].separatedBy(const SizedBox(height: 14)),
        );

        if (!isWide) {
          return Column(
            children: [
              left,
              right,
            ].separatedBy(const SizedBox(height: 14)),
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: left),
            const SizedBox(width: 14),
            Expanded(child: right),
          ],
        );
      },
    );
  }
}

class _ProcessSummaryCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _ProcessSummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final machine = _mapValue(data['machine']);
    final status = _display(data['status']);
    final isDone = status.toLowerCase().contains('selesai');

    return _PlainCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _display(data['weaving_no']),
                      style: TextStyle(
                        fontSize: 26,
                        height: 1.2,
                        color: Colors.grey.shade900,
                        fontWeight: CustomTheme().fontWeight('bold'),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Dibuat pada ${_formatDateTime(data['created_at'] ?? data['start_time'])}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: CustomTheme().fontSize('md'),
                      ),
                    ),
                  ],
                ),
              ),
              _StatusChip(
                text: status,
                color: isDone ? const Color(0xFF059669) : Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 28),
          _SectionTitle(
            icon: Icons.factory_outlined,
            title: 'Informasi Mesin',
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F1F4),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _CompactInfo(
                    label: 'MESIN',
                    value:
                        '${_display(machine['code'])} - ${_display(machine['name'])}',
                  ),
                ),
                Container(
                  width: 1,
                  height: 48,
                  color: Colors.grey.shade300,
                ),
                Expanded(
                  child: _CompactInfo(
                    label: 'LOKASI',
                    value: _display(machine['location']),
                    icon: Icons.location_on_outlined,
                  ),
                ),
              ].separatedBy(const SizedBox(width: 24)),
            ),
          ),
          const SizedBox(height: 28),
          _SectionTitle(
            icon: Icons.access_time_outlined,
            title: 'Timeline Proses',
          ),
          const SizedBox(height: 18),
          _TimelineItem(
            color: Colors.lightBlue,
            title: 'Mulai Proses',
            user: _mapValue(data['start_by'])['name'],
            date: data['start_time'] ?? data['created_at'],
          ),
          const SizedBox(height: 18),
          _TimelineItem(
            color: const Color(0xFF22C55E),
            title: 'Selesai Proses',
            user: _mapValue(data['end_by'])['name'],
            date: data['end_time'] ?? data['updated_at'],
          ),
        ],
      ),
    );
  }
}

class _ResultSection extends StatelessWidget {
  final Map<String, dynamic> data;

  const _ResultSection({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoRow('Qty', _withUnit(data['qty'], 'PCS')),
        _InfoRow('Berat ', _withUnit(data['weight'], 'KG')),
        _InfoRow('Waste', _withUnit(data['waste'], 'KG')),
      ].separatedBy(Divider(height: 18, color: Colors.grey.shade200)),
    );
  }
}

class _GreigeOrderCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _GreigeOrderCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final yarnItems = _listValue(data['yarn_items']);
    final loomBeams = _listValue(data['loom_beams']);

    return _PlainCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 680;
              final width = isWide
                  ? (constraints.maxWidth - 24) / 3
                  : constraints.maxWidth;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _SummaryBox(
                    width: width,
                    label: 'NO. OG',
                    value: _display(data['og_no'] ?? data['pp_no']),
                    isPrimary: true,
                  ),
                  _SummaryBox(
                    width: width,
                    label: 'TANGGAL OG',
                    value: _formatDate(data['og_date']),
                  ),
                  _SummaryBox(
                    width: width,
                    label: 'JUMLAH ORDER',
                    value: _withUnit(data['order_qty'], 'KG'),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          _SectionTitle(
            icon: Icons.layers_outlined,
            title: 'Kebutuhan Benang',
          ),
          const SizedBox(height: 12),
          if (yarnItems.isEmpty)
            const _EmptyText()
          else
            Column(
              children: yarnItems
                  .map((item) => _YarnNeedBox(data: item, orderGreige: data))
                  .toList()
                  .separatedBy(const SizedBox(height: 10)),
            ),
          const SizedBox(height: 24),
          _SectionTitle(
            icon: Icons.inventory_2_outlined,
            title: 'Kebutuhan Loom Beam',
          ),
          const SizedBox(height: 12),
          if (loomBeams.isEmpty)
            const _EmptyText()
          else
            Column(
              children: loomBeams
                  .map((item) => _LoomBeamBox(data: item))
                  .toList()
                  .separatedBy(const SizedBox(height: 10)),
            ),
        ],
      ),
    );
  }
}

class _YarnNeedBox extends StatelessWidget {
  final Map<String, dynamic> data;
  final Map<String, dynamic> orderGreige;

  const _YarnNeedBox({
    required this.data,
    required this.orderGreige,
  });

  @override
  Widget build(BuildContext context) {
    return _BorderBox(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: _InfoRow('Kode Warna', _display(data['color_code']))),
              Expanded(
                  child:
                      _InfoRow('Jml. Bng', _withUnit(data['yarn_qty'], 'PCS'))),
            ],
          ),
          Divider(height: 18, color: Colors.grey.shade200),
        ],
      ),
    );
  }
}

class _LoomBeamBox extends StatelessWidget {
  final Map<String, dynamic> data;

  const _LoomBeamBox({required this.data});

  @override
  Widget build(BuildContext context) {
    final left = Column(
      children: [
        _InfoRow('Benang', _withUnit(data['yarn_qty'], 'PCS')),
        _InfoRow('Lebar Beam', _withUnit(data['beam_width'], 'M')),
        _InfoRow('Beam A/B', _display(data['beam_ab'])),
        _InfoRow('Beam', _withUnit(data['beam'], 'KG')),
        _InfoRow('Gempor', _withUnit(data['gempor'], 'CNS')),
      ].separatedBy(Divider(height: 18, color: Colors.grey.shade200)),
    );

    final right = Column(
      children: [
        _InfoRow('Panjang', _withUnit(data['length'], 'M')),
        _InfoRow('No. MC', _display(data['machine_no'])),
        _InfoRow('Berat', _withUnit(data['weight'], 'KG')),
        _InfoRow('Majun', _withUnit(data['majun'], 'KG')),
      ].separatedBy(Divider(height: 18, color: Colors.grey.shade200)),
    );

    return _BorderBox(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 560) {
            return Column(
              children: [
                left,
                Divider(height: 18, color: Colors.grey.shade200),
                right,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: left),
              Container(width: 1, color: Colors.grey.shade200),
              Expanded(child: right),
            ].separatedBy(const SizedBox(width: 18)),
          );
        },
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _DetailCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return _PlainCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(icon: icon, title: title),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _PlainCard extends StatelessWidget {
  final Widget child;

  const _PlainCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _BorderBox extends StatelessWidget {
  final Widget child;

  const _BorderBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final double width;
  final String label;
  final String value;
  final bool isPrimary;

  const _SummaryBox({
    required this.width,
    required this.label,
    required this.value,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: CustomTheme().fontSize('xs'),
              fontWeight: CustomTheme().fontWeight('bold'),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isPrimary
                  ? CustomTheme().buttonColor('primary')
                  : Colors.grey.shade800,
              fontSize: CustomTheme().fontSize('lg'),
              fontWeight: CustomTheme().fontWeight('bold'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade800),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade900,
              fontSize: CustomTheme().fontSize('lg'),
              fontWeight: CustomTheme().fontWeight('bold'),
            ),
          ),
        ),
      ],
    );
  }
}

class _CompactInfo extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const _CompactInfo({
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: CustomTheme().fontSize('xs'),
            fontWeight: CustomTheme().fontWeight('bold'),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: Colors.grey.shade700),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: CustomTheme().fontSize('lg'),
                  fontWeight: CustomTheme().fontWeight('bold'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final Color color;
  final String title;
  final dynamic user;
  final dynamic date;

  const _TimelineItem({
    required this.color,
    required this.title,
    this.user,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: CustomTheme().fontSize('md'),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person_outline,
                      size: 20, color: Colors.grey.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Oleh: ${_display(user)},  ${_formatDateTime(date)}',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: CustomTheme().fontSize('md'),
                        fontWeight: CustomTheme().fontWeight('bold'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;

  const _InfoRow(this.label, this.value, {this.trailing});

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: CustomTheme().fontSize('md'),
                    fontWeight: CustomTheme().fontWeight('bold'),
                  ),
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _NoteBox extends StatelessWidget {
  final String text;

  const _NoteBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FC),
        borderRadius: BorderRadius.circular(4),
        border: Border(
          left: BorderSide(
            width: 4,
            color: CustomTheme().buttonColor('primary').withValues(alpha: 0.8),
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade800,
          fontSize: CustomTheme().fontSize('md'),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusChip({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: CustomTheme().fontSize('sm'),
              fontWeight: CustomTheme().fontWeight('bold'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallChip extends StatelessWidget {
  final String text;

  const _SmallChip(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: CustomTheme().fontSize('xs'),
          fontWeight: CustomTheme().fontWeight('bold'),
        ),
      ),
    );
  }
}

class _EmptyText extends StatelessWidget {
  const _EmptyText();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Data tidak tersedia',
      style: TextStyle(
        color: Colors.grey.shade500,
        fontSize: CustomTheme().fontSize('md'),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 42, color: Colors.red.shade400),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

extension _SeparatedWidgets on List<Widget> {
  List<Widget> separatedBy(Widget separator) {
    if (isEmpty) return this;

    final widgets = <Widget>[];
    for (var i = 0; i < length; i++) {
      widgets.add(this[i]);
      if (i != length - 1) widgets.add(separator);
    }
    return widgets;
  }
}

Map<String, dynamic> _mapValue(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

List<Map<String, dynamic>> _listValue(dynamic value) {
  if (value is List) {
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
  return <Map<String, dynamic>>[];
}

String _display(dynamic value) {
  if (value == null || value.toString().isEmpty) return '-';
  return value.toString();
}

String _withUnit(dynamic value, String unit) {
  if (value == null || value.toString().isEmpty) return '-';
  final formatted = formatNumber(value);
  if (unit.isEmpty) return formatted;
  return '$formatted $unit';
}

String _formatDate(dynamic value) {
  if (value == null || value.toString().isEmpty) return '-';

  try {
    return DateFormat('dd MMM yyyy').format(DateTime.parse(value.toString()));
  } catch (_) {
    return value.toString();
  }
}

String _formatDateTime(dynamic value) {
  if (value == null || value.toString().isEmpty) return '-';

  try {
    return DateFormat('dd MMM yyyy, HH.mm')
        .format(DateTime.parse(value.toString()));
  } catch (_) {
    return value.toString();
  }
}

String _formatType(dynamic value) {
  if (value == null || value.toString().isEmpty) return '-';

  return value
      .toString()
      .split('_')
      .map((word) =>
          word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}
