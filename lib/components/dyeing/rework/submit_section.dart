import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/margin_search.dart';
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
  late bool _isScannerStopped;

  @override
  void initState() {
    super.initState();
    _isScannerStopped = widget.isScannerStopped;
  }

  @override
  Widget build(BuildContext context) {
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
                      double scanSize = constraints.maxWidth * 0.7;
                      return SizedBox(
                        width: scanSize,
                        height: scanSize,
                        child: ClipRRect(
                            child: Stack(
                          children: [
                            MobileScanner(
                              controller: widget.controller,
                              onDetect: (BarcodeCapture capture) {
                                final List<Barcode> barcodes = capture.barcodes;
                                for (final barcode in barcodes) {
                                  final String code = barcode.rawValue ?? "---";

                                  if (int.tryParse(code) != null) {
                                    int id = int.parse(code);
                                    widget.controller.stop();
                                    setState(() {
                                      _isScannerStopped = true;
                                    });
                                    widget.handleScan(id);
                                  }

                                  break;
                                }
                              },
                            ),
                            if (widget.isScannerStopped)
                              Center(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.refresh,
                                    size: 48,
                                    color: CustomTheme().colors('secondary'),
                                  ),
                                  onPressed: () {
                                    widget.controller.start();
                                    setState(() {
                                      _isScannerStopped = false;
                                    });
                                  },
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
                      final result = await Navigator.of(context).push(
                          widget.handleRoute(widget.form, widget.handleSubmit,
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
            color: CustomTheme().buttonColor('In Progress'),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
