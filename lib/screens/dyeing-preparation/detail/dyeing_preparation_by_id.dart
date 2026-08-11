// ignore_for_file: use_build_context_synchronously, unused_element, unused_element_parameter

<<<<<<< HEAD
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/detail/dyeing_preparation_detail_list.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/result/show_image_dialog.dart';
import 'package:textile_tracking/helpers/util/format_bytes.dart';
import 'package:textile_tracking/screens/dyeing-preparation/detail/edit_dyeing_preparation.dart';
import 'package:textile_tracking/screens/dyeing-preparation/model/dyeing_preparation.dart';
import 'package:textile_tracking/screens/pdf/pdf_viewer_screen.dart';
import 'package:url_launcher/url_launcher.dart';
=======
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/detail/dyeing_preparation_detail_list.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/screens/dyeing-preparation/detail/edit_dyeing_preparation.dart';
import 'package:textile_tracking/screens/dyeing-preparation/model/dyeing_preparation.dart';
>>>>>>> 57f45d55 (feat: persiapan dyeing)

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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  Map<String, dynamic> _data = {};
=======
  final OptionGreigeOrderService _greigeOrderService =
      OptionGreigeOrderService();

  Map<String, dynamic> _greigeOrder = {};
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
=======
  Map<String, dynamic> _data = {};
>>>>>>> 27570e76 (fix: detail persiapan dyeing)

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

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
      await dyeingPreparationService.fetchPreparationDetail(
        context,
        widget.id,
      );

      final detail = _detailData(dyeingPreparationService.dataView);
=======
      await warpingService.getDataView(context, widget.id);

      final detail = _detailData(warpingService.dataView);
>>>>>>> 27570e76 (fix: detail persiapan dyeing)

      setState(() {
        _data = detail;

        _isLoading = false;
      });
<<<<<<< HEAD
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      if (mounted && _isLoading) {
=======
      await dyeingPreparationService.getDataView(context, widget.id);

      final detail = _detailData(dyeingPreparationService.dataView);

      final orderGreige = detail['order_greige'] is Map
          ? Map<String, dynamic>.from(detail['order_greige'])
          : <String, dynamic>{};

      final orderGreigeId = orderGreige['id'];

      if (orderGreigeId != null) {
        await _greigeOrderService.getDataView(orderGreigeId.toString());

        final response = _greigeOrderService.dataView;

        _greigeOrder = response['data'] is Map<String, dynamic>
            ? Map<String, dynamic>.from(response['data'])
            : Map<String, dynamic>.from(response);
      } else {
        _greigeOrder = {};
      }
=======
      await service.getDataView(context, widget.id);
>>>>>>> 252dc540 (feat: persiapan dyeing detail)
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      if (mounted) {
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      if (mounted && _isLoading) {
>>>>>>> 27570e76 (fix: detail persiapan dyeing)
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

<<<<<<< HEAD
<<<<<<< HEAD
  int _fileSize(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;

    return 0;
  }

  List<Widget> _buildAttachmentList(BuildContext context) {
    final existingAttachments = (_data['attachments'] ?? []) as List<dynamic>;
    final baseUrl = dotenv.env['IMAGE_URL'] ?? '';

    return existingAttachments.map<Widget>((item) {
      final attachment = Map<String, dynamic>.from(item);
      final bool isNew = attachment.containsKey('path');
      final String? filePath =
          isNew ? attachment['path'] : attachment['file_path'];
      final String fileName = isNew
          ? attachment['name']
          : (attachment['file_name'] ?? filePath?.split('/').last ?? '');
      final String extension = fileName.split('.').last.toLowerCase();
      final bool isPdf = extension == 'pdf';
      final bool isImage =
          ['png', 'jpg', 'jpeg', 'gif', 'webp'].contains(extension);

      String fileSizeText = '';

      if (isNew && filePath != null) {
        final file = File(filePath);

        if (file.existsSync()) {
          final bytes = file.lengthSync();
          fileSizeText = formatBytes(bytes);
        }
      } else {
        if (attachment['file_size'] != null) {
          fileSizeText = formatBytes(_fileSize(attachment['file_size']));
        } else {
          fileSizeText = 'Unknown size';
        }
      }

      Widget preview;

      if (isImage && isNew && filePath != null) {
        preview = Image.file(
          File(filePath),
          fit: BoxFit.cover,
        );
      } else if (isImage && filePath != null) {
        preview = Image.network(
          '$baseUrl$filePath',
          fit: BoxFit.cover,
          errorBuilder: (context, _, __) =>
              const Icon(Icons.broken_image, size: 40),
        );
      } else {
        preview = Icon(
          Icons.description_outlined,
          size: 40,
          color: Colors.grey.shade700,
        );
      }

      return GestureDetector(
        onTap: filePath == null
            ? null
            : () async {
                if (isImage) {
                  showImageDialog(
                    context: context,
                    isNew: isNew,
                    filePath: isNew ? filePath : '$baseUrl$filePath',
                  );

                  return;
                }

                if (isPdf) {
                  final url = '$baseUrl$filePath';

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PdfViewerScreen(
                        url: url,
                        fileName: fileName,
                      ),
                    ),
                  );

                  return;
                }

                final url = '$baseUrl$filePath';

                await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication,
                );
              },
        child: Container(
          padding: CustomTheme().padding('card'),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey.shade100,
                ),
                clipBehavior: Clip.antiAlias,
                child: preview,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fileSizeText,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Future _handleDelete(dynamic _) async {
    final data = _data;

=======
  Future<void> _handleDelete(Map<String, dynamic> data) async {
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
  Future _handleDelete(dynamic _) async {
    final data = _data;

>>>>>>> 27570e76 (fix: detail persiapan dyeing)
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
<<<<<<< HEAD
<<<<<<< HEAD
      message: 'Apakah Anda yakin ingin menghapus proses Persiapan Dyeing?',
=======
      message: 'Apakah Anda yakin ingin menghapus proses persiapan dyeing?',
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
      message: 'Apakah Anda yakin ingin menghapus proses Persiapan Dyeing?',
>>>>>>> 27570e76 (fix: detail persiapan dyeing)
      isLoading: _deleteLoading,
      buttonBackground: CustomTheme().buttonColor('danger'),
      onConfirm: () async {
        try {
          final message = await Provider.of<DyeingPreparationService>(context,
                  listen: false)
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 27570e76 (fix: detail persiapan dyeing)
              .deleteItem(
            context,
            widget.id.toString(),
            _deleteLoading,
          );
<<<<<<< HEAD
=======
              .deleteItem(context, widget.id.toString(), _deleteLoading);
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
>>>>>>> 27570e76 (fix: detail persiapan dyeing)

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
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 27570e76 (fix: detail persiapan dyeing)
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
<<<<<<< HEAD
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

              return Column(
                children: [
                  Expanded(
                    child: DyeingPreparationDetailList(
                      data: data,
                      processName: 'Persiapan Dyeing',
                      processNoKey: 'prep_no',
                      onRefresh: _fetchDetail,
                      canDelete: widget.canDelete,
                      canUpdate: widget.canUpdate,
                      onDelete: () => _handleDelete(data),
                      handleBuildAttachment: _buildAttachmentList,
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
                    ),
                  ),
                ],
              );
            },
          ),
=======
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
=======
>>>>>>> 27570e76 (fix: detail persiapan dyeing)
            );

            if (!mounted) return;

            if (result == true) {
              Navigator.pop(context, true);
            }
          },
<<<<<<< HEAD
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
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
>>>>>>> 27570e76 (fix: detail persiapan dyeing)
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
