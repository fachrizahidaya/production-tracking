// ignore_for_file: use_build_context_synchronously, unused_element, unused_element_parameter

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/detail/dyeing_preparation_detail_list.dart';
import 'package:textile_tracking/components/detail/greige_process_detail_list.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/models/option/option_greige_order.dart';
import 'package:textile_tracking/screens/dyeing-preparation/detail/edit_dyeing_preparation.dart';
import 'package:textile_tracking/screens/dyeing-preparation/model/dyeing_preparation.dart';

class DyeingPreparationDetailScreen extends StatefulWidget {
  final id;
  final no;
  final canDelete;
  final canUpdate;
  final bool openUpdateOnStart;

  const DyeingPreparationDetailScreen({
    super.key,
    this.id,
    this.no,
    this.canDelete,
    this.canUpdate,
    this.openUpdateOnStart = false,
  });

  @override
  State<DyeingPreparationDetailScreen> createState() =>
      _DyeingPreparationDetailScreenState();
}

class _DyeingPreparationDetailScreenState
    extends State<DyeingPreparationDetailScreen> {
  final ValueNotifier<bool> _deleteLoading = ValueNotifier(false);
  bool _isLoading = true;
  String? _errorMessage;
  final OptionGreigeOrderService _greigeOrderService =
      OptionGreigeOrderService();

  Map<String, dynamic> _greigeOrder = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDetail();
    });
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
      final service =
          Provider.of<DyeingPreparationService>(context, listen: false);

      await service.getDataView(context, widget.id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
      message: 'Apakah Anda yakin ingin menghapus proses persiapan dyeing?',
      isLoading: _deleteLoading,
      buttonBackground: CustomTheme().buttonColor('danger'),
      onConfirm: () async {
        try {
          final message = await Provider.of<DyeingPreparationService>(context,
                  listen: false)
              .deleteItem(context, widget.id.toString(), _deleteLoading);

          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          await showAlertDialog(
            context: context,
            title: 'Persiapan Dyeing Dihapus',
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
        child: Consumer<DyeingPreparationService>(
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

            final data = Map<String, dynamic>.from(
              _detailData(service.dataView),
            );

            return DyeingPreparationDetailList(
              data: data,
              onRefresh: _fetchDetail,
              canDelete: widget.canDelete,
              canUpdate: widget.canUpdate,
              onDelete: () => _handleDelete(data),
              onEdit: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditDyeingPreparationScreen(
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
