import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';

class CreateDyeing extends StatefulWidget {
  const CreateDyeing({super.key});

  @override
  State<CreateDyeing> createState() => _CreateDyeingState();
}

class _CreateDyeingState extends State<CreateDyeing> {
  String? _scannedCode;
  final MobileScannerController _controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      appBar: CustomAppBar(
        title: 'Create Dyeing',
        onReturn: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          // Camera view
          Expanded(
            flex: 3,
            child: MobileScanner(
              controller: _controller,
              onDetect: (BarcodeCapture capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  final String code = barcode.rawValue ?? "---";
                  setState(() {
                    _scannedCode = code;
                  });

                  // Stop scanner after first result (optional)
                  _controller.stop();

                  // If you want to auto-close:
                  // Navigator.pop(context, code);
                }
              },
            ),
          ),

          // Result display
          Expanded(
            flex: 1,
            child: Center(
              child: _scannedCode == null
                  ? const Text(
                      "Scan a QR Code",
                      style: TextStyle(fontSize: 18),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Scanned Code:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _scannedCode!,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, _scannedCode);
                          },
                          child: const Text("Use this code"),
                        )
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
