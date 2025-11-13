import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:textile_tracking/helpers/util/margin_search.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'dart:math' as math;

class CreateSubmitSection extends StatefulWidget {
  final form;
  final controller;
  final bool isScannerStopped;
  final handleScan;
  final handleSubmit;
  final handleRoute;
  final isLoading;

  const CreateSubmitSection(
      {super.key,
      this.controller,
      required this.isScannerStopped,
      this.handleScan,
      this.form,
      this.handleSubmit,
      this.handleRoute,
      this.isLoading});

  @override
  State<CreateSubmitSection> createState() => _CreateSubmitSectionState();
}

class _CreateSubmitSectionState extends State<CreateSubmitSection> {
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
              padding: MarginSearch.screen,
              child: Column(
                children: [
                  Expanded(
                      flex: 2,
                      child: Center(child: LayoutBuilder(
                        builder: (context, constraints) {
                          double scanSize = constraints.maxWidth * 0.4;
                          return SizedBox(
                            width: scanSize,
                            height: scanSize,
                            child: ClipRRect(
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
                                    onPressed: () => controller.switchCamera(),
                                  ),
                                )
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
