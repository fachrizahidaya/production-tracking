import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/margin_search.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'dart:math' as math;

class SubmitSection extends StatefulWidget {
  final form;
  final controller;
  final bool isScannerStopped;
  final handleScan;
  final handleSubmit;
  final handleRoute;
  final isLoading;

  const SubmitSection(
      {super.key,
      this.controller,
      required this.isScannerStopped,
      this.handleScan,
      this.form,
      this.handleSubmit,
      this.handleRoute,
      this.isLoading});

  @override
  State<SubmitSection> createState() => _SubmitSectionState();
}

class _SubmitSectionState extends State<SubmitSection> {
  late MobileScannerController controller;
  late bool _isScannerStopped;

  @override
  void initState() {
    super.initState();
    _isScannerStopped = false;
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
            Container(
              padding: MarginSearch.screen,
              child: Column(
                children: [
                  Expanded(
                      flex: 2,
                      child: Center(child: LayoutBuilder(
                        builder: (context, constraints) {
                          final maxSide = math.min(
                              constraints.maxWidth, constraints.maxHeight);
                          final scanSize = maxSide * 0.8;
                          return SizedBox(
                            width: scanSize,
                            height: scanSize,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Stack(
                                  children: [
                                    Transform.rotate(
                                      angle: angle,
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        width: scanSize,
                                        height: scanSize,
                                        child: FittedBox(
                                          fit: BoxFit.cover,
                                          clipBehavior: Clip.hardEdge,
                                          child: SizedBox(
                                            width: scanSize,
                                            height: scanSize,
                                            child: MobileScanner(
                                              controller: controller,
                                              onDetect: (capture) {
                                                final List<Barcode> barcodes =
                                                    capture.barcodes;

                                                for (final barcode
                                                    in barcodes) {
                                                  final String? code =
                                                      barcode.rawValue;

                                                  if (code != null &&
                                                      code.isNotEmpty) {
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
                                        ),
                                      ),
                                    ),
                                    if (_isScannerStopped)
                                      Center(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.refresh,
                                            size: 48,
                                            color: Colors.black,
                                          ),
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
                                        icon: const Icon(Icons.cameraswitch,
                                            color: Colors.white),
                                        onPressed: () =>
                                            controller.switchCamera(),
                                      ),
                                    ),
                                  ],
                                )),
                          );
                        },
                      ))),
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        "Scan QR Work Order",
                        style: TextStyle(fontSize: 18),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text("Isi Manual"),
                        onPressed: () async {
                          final result = await Navigator.of(context).push(widget
                              .handleRoute(widget.form, widget.handleSubmit));

                          if (result != null &&
                              result is String &&
                              result.isNotEmpty) {
                            widget.handleScan(result);
                          }
                        },
                      ),
                    ].separatedBy(SizedBox(
                      height: 16,
                    )),
                  )),
                ].separatedBy(SizedBox(
                  height: 16,
                )),
              ),
            ),
            if (widget.isLoading)
              Container(
                color: CustomTheme().buttonColor('In Progress'),
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
