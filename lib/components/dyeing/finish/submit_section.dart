import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'dart:math' as math;

class SubmitSection extends StatefulWidget {
  final form;
  final controller;
  final bool isScannerStopped;
  final handleScan;
  final handleSubmit;
  final handleRoute;
  final handleChangeInput;
  final isLoading;

  const SubmitSection(
      {super.key,
      this.controller,
      required this.isScannerStopped,
      this.handleScan,
      this.form,
      this.handleSubmit,
      this.handleRoute,
      this.isLoading,
      this.handleChangeInput});

  @override
  State<SubmitSection> createState() => _SubmitSectionState();
}

class _SubmitSectionState extends State<SubmitSection> {
  late MobileScannerController controller;
  late bool _isScannerStopped;

  @override
  void initState() {
    super.initState();
    _isScannerStopped = widget.isScannerStopped;
    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.front,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  double _angleForOrientation(NativeDeviceOrientation orientation) {
    switch (orientation) {
      case NativeDeviceOrientation.landscapeLeft:
        // device rotated so top goes to the left -> rotate preview -90deg
        return -math.pi / 2;
      case NativeDeviceOrientation.landscapeRight:
        // device rotated so top goes to the right -> rotate preview +90deg
        return math.pi / 2;
      case NativeDeviceOrientation.portraitDown:
        // upside-down portrait
        return math.pi;
      case NativeDeviceOrientation.portraitUp:
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NativeDeviceOrientationReader(
      useSensor: true,
      builder: (context) {
        final deviceOrientation =
            NativeDeviceOrientationReader.orientation(context);
        final angle = _angleForOrientation(deviceOrientation);

        return Stack(
          children: [
            // ✅ Fullscreen camera preview
            Positioned.fill(
              child: Transform.rotate(
                angle: angle,
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: MobileScanner(
                      controller: controller,
                      onDetect: (capture) {
                        final barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          final String? code = barcode.rawValue;
                          if (code != null && code.isNotEmpty) {
                            controller.stop();
                            setState(() => _isScannerStopped = true);
                            widget.handleScan(code);
                            break;
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),

            // ✅ Overlay for UI controls (keeps upright)
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top-right camera switch
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.cameraswitch,
                              color: Colors.white),
                          onPressed: () => controller.switchCamera(),
                        ),
                      ),
                    ),
                  ),

                  // Bottom text and button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      children: [
                        const Text(
                          "Scan QR Work Order",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                  color: Colors.black,
                                  offset: Offset(1, 1),
                                  blurRadius: 3)
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text("Isi Manual"),
                          onPressed: () async {
                            final result = await Navigator.of(context).push(
                              widget.handleRoute(
                                  widget.form, widget.handleSubmit),
                            );
                            if (result != null &&
                                result is String &&
                                result.isNotEmpty) {
                              widget.handleScan(result);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Refresh button overlay (when stopped)
            if (_isScannerStopped)
              Center(
                child: IconButton(
                  icon:
                      const Icon(Icons.refresh, size: 60, color: Colors.white),
                  onPressed: () {
                    controller.start();
                    setState(() => _isScannerStopped = false);
                  },
                ),
              ),

            // ✅ Loading overlay
            if (widget.isLoading)
              Container(
                color: Colors.black.withOpacity(0.6),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}
