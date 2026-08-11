// ignore_for_file: use_build_context_synchronously, unused_element, unused_element_parameter

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/detail/dyeing_preparation_detail_list.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
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
  Map<String, dynamic> _data = {};

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
      final warpingService =
          Provider.of<DyeingPreparationService>(context, listen: false);

      await warpingService.getDataView(context, widget.id);

      final detail = _detailData(warpingService.dataView);

      setState(() {
        _data = detail;

        _isLoading = false;
      });
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      if (mounted && _isLoading) {
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

  Future _handleDelete(dynamic _) async {
    final data = _data;

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
      message: 'Apakah Anda yakin ingin menghapus proses Persiapan Dyeing?',
      isLoading: _deleteLoading,
      buttonBackground: CustomTheme().buttonColor('danger'),
      onConfirm: () async {
        try {
          final message = await Provider.of<DyeingPreparationService>(context,
                  listen: false)
              .deleteItem(
            context,
            widget.id.toString(),
            _deleteLoading,
          );

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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Detail Proses Persiapan Dyeing',
          onReturn: () => Navigator.pop(context),
          handleDelete: _handleDelete,
          handleUpdate: () async {
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
          id: widget.id,
          updateStatus:
              widget.canUpdate == true && (_data['can_update'] != false),
          deleteStatus:
              widget.canDelete == true && (_data['can_delete'] != false),
          label: 'Persiapan Dyeing',
        ),
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
                processName: 'Persiapan Dyeing',
                processNoKey: 'prep_no',
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
