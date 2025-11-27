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
  final isLoading;

  const SubmitSection({
    super.key,
    this.controller,
    required this.isScannerStopped,
    this.handleScan,
    this.form,
    this.handleSubmit,
    this.handleRoute,
    this.isLoading,
  });

  @override
  State<SubmitSection> createState() => _SubmitSectionState();
}

class _SubmitSectionState extends State<SubmitSection> {
  late MobileScannerController controller;
  bool _isScannerStopped = false;

  @override
  void initState() {
    super.initState();
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

  /// Convert NativeDeviceOrientation to angle in radians
  double _angleForOrientation(NativeDeviceOrientation orientation) {
    switch (orientation) {
      case NativeDeviceOrientation.landscapeLeft:
        return -math.pi / 2;
      case NativeDeviceOrientation.landscapeRight:
        return math.pi / 2;
      case NativeDeviceOrientation.portraitDown:
        return math.pi;
      case NativeDeviceOrientation.portraitUp:
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NativeDeviceOrientationReader(
      builder: (context) {
        final orientation = NativeDeviceOrientationReader.orientation(context);

        final angle = _angleForOrientation(orientation);

        return Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isLandscape = orientation ==
                                NativeDeviceOrientation.landscapeLeft ||
                            orientation ==
                                NativeDeviceOrientation.landscapeRight;

                        double scanWidth = isLandscape
                            ? constraints.maxHeight
                            : constraints.maxWidth * 0.9;

                        double scanHeight = isLandscape
                            ? constraints.maxWidth
                            : constraints.maxWidth * 0.9;

                        return Center(
                          child: ClipRRect(
                            child: SizedBox(
                              width: scanWidth,
                              height: scanHeight,
                              child: Stack(
                                children: [
                                  /// → Rotate the scanner preview with real device movement
                                  Transform.rotate(
                                    angle: angle,
                                    child: MobileScanner(
                                      controller: controller,
                                      onDetect: (capture) {
                                        for (final barcode
                                            in capture.barcodes) {
                                          final code = barcode.rawValue;
                                          if (code != null && code.isNotEmpty) {
                                            controller.stop();
                                            setState(() {
                                              _isScannerStopped = true;
                                            });
                                            widget.handleScan(code);
                                            break;
                                          }
                                        }
                                      },
                                    ),
                                  ),

                                  if (_isScannerStopped)
                                    Center(
                                      child: IconButton(
                                        icon:
                                            const Icon(Icons.refresh, size: 48),
                                        onPressed: () {
                                          controller.start();
                                          setState(() {
                                            _isScannerStopped = false;
                                          });
                                        },
                                      ),
                                    ),

                                  Positioned(
                                    top: 16,
                                    right: 16,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.cameraswitch,
                                        color: Colors.white,
                                      ),
                                      onPressed: () =>
                                          controller.switchCamera(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Bottom Section
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          "Scan QR Work Order",
                          style: TextStyle(fontSize: 18),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text("Isi Manual"),
                          onPressed: () async {
                            controller.stop();
                            setState(() => _isScannerStopped = true);

                            final result = await Navigator.of(context).push(
                              widget.handleRoute(
                                widget.form,
                                widget.handleSubmit,
                              ),
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
            if (widget.isLoading)
              Container(
                color: Colors.white.withOpacity(0.8),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      },
    );
  }
}
