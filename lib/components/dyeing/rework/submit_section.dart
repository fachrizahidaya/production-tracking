// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

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
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Stack(
          children: [
            Container(
              padding: CustomTheme().padding('content'),
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
                                AnimatedRotation(
                                  turns: orientation == Orientation.landscape
                                      ? -0.25
                                      : 0,
                                  duration: const Duration(milliseconds: 300),
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
                    ].separatedBy(CustomTheme().vGap('xl')),
                  )),
                ].separatedBy(CustomTheme().vGap('xl')),
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
