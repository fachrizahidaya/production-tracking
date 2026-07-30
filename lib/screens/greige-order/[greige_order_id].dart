// ignore_for_file: file_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/process/create/greige_info_tab.dart';
import 'package:textile_tracking/helpers/util/format_html.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/option/option_greige_order.dart';

class GreigeOrderDetail extends StatefulWidget {
  final String id;

  const GreigeOrderDetail({
    super.key,
    required this.id,
  });

  @override
  State<GreigeOrderDetail> createState() => _GreigeOrderDetailState();
}

class _GreigeOrderDetailState extends State<GreigeOrderDetail> {
  final OptionGreigeOrderService _greigeOrderService =
      OptionGreigeOrderService();
  bool _firstLoading = true;
  String? _errorMessage;
  Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();
    _getDataView();
  }

  Future<void> _getDataView() async {
    setState(() {
      _firstLoading = true;
      _errorMessage = null;
    });

    try {
      await _greigeOrderService.getDataView(widget.id);

      if (!mounted) return;
      setState(() {
        data = _greigeOrderService.dataView;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _firstLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFf9fafc),
        appBar: CustomAppBar(
          title: 'Greige Order Detail',
          onReturn: () {
            Navigator.pop(context);
          },
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: const TabBar(
                  isScrollable: false,
                  tabs: [
                    Tab(text: 'Informasi'),
                    Tab(text: 'Proses Produksi'),
                    Tab(text: 'Catatan'),
                  ],
                ),
              ),
              Expanded(
                child: _errorMessage != null
                    ? _ErrorView(
                        message: _errorMessage!,
                        onRetry: _getDataView,
                      )
                    : TabBarView(
                        children: [
                          _GreigeOrderInfoTab(
                            data: data,
                            isLoading: _firstLoading,
                          ),
                          _GreigeOrderProcessTab(
                            data: data,
                            isLoading: _firstLoading,
                          ),
                          _GreigeOrderNoteTab(
                            data: data,
                            isLoading: _firstLoading,
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GreigeOrderInfoTab extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isLoading;

  const _GreigeOrderInfoTab({
    required this.data,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (data.isEmpty) {
      return NoData();
    }

    return GreigeInfoTab(data: data);
  }
}

class _GreigeOrderProcessTab extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isLoading;

  const _GreigeOrderProcessTab({
    required this.data,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final processes = _buildProcessItems(data);

    if (processes.isEmpty) {
      return NoData();
    }

    return GridView.builder(
      padding: CustomTheme().padding('content'),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 520,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.25,
      ),
      itemCount: processes.length,
      itemBuilder: (context, index) {
        return _GreigeProcessCard(item: processes[index]);
      },
    );
  }

  List<Map<String, dynamic>> _buildProcessItems(Map<String, dynamic> source) {
    final rawProcesses = source['processes'];
    if (rawProcesses is List) {
      return rawProcesses
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    const processKeys = {
      'warping': 'Warping',
      'sizing': 'Sizing',
      'weaving': 'Weaving',
      'shearing': 'Shearing',
    };

    return processKeys.entries
        .map((entry) {
          final value = source[entry.key] ?? source['${entry.key}s'];
          final items = _listValue(value);
          final direct =
              value is Map ? [Map<String, dynamic>.from(value)] : items;

          return {
            'key': entry.key,
            'label': entry.value,
            'data': direct,
          };
        })
        .where((item) => (item['data'] as List).isNotEmpty)
        .toList();
  }
}

class _GreigeProcessCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const _GreigeProcessCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final data = _listValue(item['data']);
    final first = data.isNotEmpty ? data.first : <String, dynamic>{};
    final label = item['label']?.toString() ?? _formatType(item['key']);
    final status = first['status']?.toString() ?? '-';
    final number = first['${item['key']}_no'] ??
        first['process_no'] ??
        first['no'] ??
        first['code'] ??
        '-';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: CustomTheme()
                        .buttonColor('primary')
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _processIcon(label),
                    color: CustomTheme().buttonColor('primary'),
                  ),
                ),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: CustomTheme().fontSize('lg'),
                      fontWeight: CustomTheme().fontWeight('bold'),
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                _StatusPill(status: status),
              ].separatedBy(CustomTheme().hGap('md')),
            ),
            const Divider(height: 28),
            _InfoLine('No. Proses', number.toString()),
            _InfoLine('Mulai', _formatDateTime(first['start_time'])),
            _InfoLine('Selesai', _formatDateTime(first['end_time'])),
            if (first['machine'] != null)
              _InfoLine('Mesin', _machineName(first['machine'])),
          ].separatedBy(CustomTheme().vGap('md')),
        ),
      ),
    );
  }

  IconData _processIcon(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('warping')) return Icons.account_tree_outlined;
    if (lower.contains('sizing')) return Icons.straighten_outlined;
    if (lower.contains('weaving')) return Icons.grid_on_outlined;
    if (lower.contains('shearing')) return Icons.cut_outlined;
    return Icons.settings_outlined;
  }
}

class _GreigeOrderNoteTab extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isLoading;

  const _GreigeOrderNoteTab({
    required this.data,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final notes = _noteItems(data);

    if (notes.isEmpty) {
      return NoData();
    }

    return ListView.separated(
      padding: CustomTheme().padding('content'),
      separatorBuilder: (context, index) => CustomTheme().vGap('2xl'),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final item = notes[index];
        return TemplateCard(
          title: item['label']?.toString() ?? 'Catatan',
          icon: Icons.note_alt_outlined,
          child: Text(
            htmlToPlainText(item['content']?.toString() ?? '-'),
            style: TextStyle(
              fontSize: CustomTheme().fontSize('lg'),
              color: Colors.grey.shade800,
              height: 1.5,
            ),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _noteItems(Map<String, dynamic> source) {
    final rawNotes = source['notes'];
    if (rawNotes is List) {
      return rawNotes
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .where((item) => item['content']?.toString().isNotEmpty == true)
          .toList();
    }

    if (rawNotes != null && rawNotes.toString().isNotEmpty) {
      return [
        {
          'label': 'Catatan Order Greige',
          'content': rawNotes.toString(),
        }
      ];
    }

    return [];
  }
}

class _StatusPill extends StatelessWidget {
  final String status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final isDone = status.toLowerCase().contains('selesai');
    final color = isDone ? Colors.green : CustomTheme().buttonColor('primary');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: CustomTheme().fontSize('xs'),
          fontWeight: CustomTheme().fontWeight('bold'),
        ),
      ),
    );
  }
}

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
              fontSize: CustomTheme().fontSize('sm'),
              fontWeight: CustomTheme().fontWeight('semibold'),
            ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: CustomTheme().fontSize('sm'),
              fontWeight: CustomTheme().fontWeight('bold'),
            ),
          ),
        ),
      ].separatedBy(CustomTheme().hGap('md')),
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

List<Map<String, dynamic>> _listValue(dynamic value) {
  if (value is List) {
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  return <Map<String, dynamic>>[];
}

String _formatDateTime(dynamic value) {
  if (value == null || value.toString().isEmpty) return '-';

  try {
    return DateFormat('dd MMM yyyy, HH.mm')
        .format(DateTime.parse(value.toString()).toLocal());
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

String _machineName(dynamic value) {
  if (value is! Map) return '-';

  final machine = Map<String, dynamic>.from(value);
  final code = machine['code']?.toString();
  final name = machine['name']?.toString();

  if ((code == null || code.isEmpty) && (name == null || name.isEmpty)) {
    return '-';
  }

  return [
    if (code != null && code.isNotEmpty) code,
    if (name != null && name.isNotEmpty) name,
  ].join(' - ');
}
