import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:textile_tracking/components/dyeing/order_form.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/helpers/util/margin_search.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/master/work_order.dart';

class CreateDyeing extends StatefulWidget {
  const CreateDyeing({super.key});

  @override
  State<CreateDyeing> createState() => _CreateDyeingState();
}

class _CreateDyeingState extends State<CreateDyeing> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isLoading = false;
  int number = 0;

  final WorkOrderService _workOrderService = WorkOrderService();

  Future<void> _handleScan(int code) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final scannedId = code;
      setState(() {
        number = code;
      });

      await _workOrderService.getDataView(scannedId);

      final data = _workOrderService.dataView;

      setState(() {
        _isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderForm(
            id: scannedId,
            data: data, // pass full data here
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

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
        body: Stack(
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
                              child: MobileScanner(
                                controller: _controller,
                                onDetect: (BarcodeCapture capture) {
                                  final List<Barcode> barcodes =
                                      capture.barcodes;
                                  for (final barcode in barcodes) {
                                    final String code =
                                        barcode.rawValue ?? "---";

                                    if (int.tryParse(code) != null) {
                                      int id = int.parse(code);
                                      _handleScan(
                                          id); // pass int instead of string if your function expects an int
                                    } else {
                                      // Not a number, handle error or ignore
                                      debugPrint("QR is not a number: $code");
                                    }

                                    break;
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ))),
                  Expanded(
                      // flex: 1,
                      child: Column(
                    children: [
                      Text(
                        number.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "Scan QR Work Order",
                        style: TextStyle(fontSize: 18),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text("Fill Form"),
                        onPressed: () async {
                          final result =
                              await Navigator.of(context).push(_createRoute());

                          if (result != null && result.isNotEmpty) {
                            _handleScan(result);
                            // setState(() {
                            //   _scannedCode = result;
                            // });
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
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ));
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const OrderForm(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
