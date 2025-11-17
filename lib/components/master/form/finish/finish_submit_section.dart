import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/margin_search.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'dart:math' as math;

class FinishSubmitSection extends StatefulWidget {
  final form;
  final controller;
  final bool isScannerStopped;
  final handleScan;
  final handleSubmit;
  final handleRoute;
  final handleChangeInput;
  final isLoading;

  const FinishSubmitSection(
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
  State<FinishSubmitSection> createState() => _FinishSubmitSectionState();
}

class _FinishSubmitSectionState extends State<FinishSubmitSection> {
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
    return OrientationBuilder(
      builder: (context, orientation) {
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
                          final isLandscape =
                              MediaQuery.of(context).orientation ==
                                  Orientation.landscape;
                          double scanWidth = isLandscape
                              ? constraints
                                  .maxHeight // full height in landscape
                              : constraints.maxWidth *
                                  0.9; // proportional in portrait
                          double scanHeight = isLandscape
                              ? constraints.maxWidth // full width in landscape
                              : constraints.maxWidth * 0.9;
                          return ClipRRect(
                              child: SizedBox(
                            width: scanWidth,
                            height: scanHeight,
                            child: Stack(
                              children: [
                                Transform.rotate(
                                  angle: orientation == Orientation.landscape
                                      ? math.pi / 2
                                      : 0,
                                  child: MobileScanner(
                                    controller: controller,
                                    onDetect: (capture) {
                                      final List<Barcode> barcodes =
                                          capture.barcodes;

                                      for (final barcode in barcodes) {
                                        final String? code = barcode.rawValue;

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
                                      icon: Icon(
                                        Icons.refresh,
                                        size: 48,
                                        color:
                                            CustomTheme().colors('secondary'),
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
                                    onPressed: () => controller.switchCamera(),
                                  ),
                                ),
                              ],
                            ),
                          ));
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
                          controller.stop();
                          setState(() {
                            _isScannerStopped = true;
                          });

                          final result = await Navigator.of(context).push(
                              widget.handleRoute(
                                  widget.form,
                                  widget.handleSubmit,
                                  widget.handleChangeInput));
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
                color: Color(0xFFf9fafc),
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
