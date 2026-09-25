import 'package:flutter/material.dart';

class ReasonOptionDialog extends StatefulWidget {
  const ReasonOptionDialog({super.key});

  @override
  State<ReasonOptionDialog> createState() => _ReasonOptionDialogState();
}

class _ReasonOptionDialogState extends State<ReasonOptionDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Alasan'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Masukkan alasan rework'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('Tambah'),
        ),
      ],
    );
  }
}
