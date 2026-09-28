import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final message;
  final child;

  const CustomAlertDialog(
      {super.key, required this.title, this.message, this.child});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).shortestSide < 600;

    return Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 40,
          vertical: isMobile ? 24 : 40,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth:
                MediaQuery.sizeOf(context).width * (isMobile ? 0.86 : 0.5),
            maxHeight:
                MediaQuery.sizeOf(context).height * (isMobile ? 0.7 : 0.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 14 : 16,
                            horizontal: isMobile ? 16 : 24),
                        child: Text(
                          title,
                          style: TextStyle(
                              fontSize: CustomTheme()
                                  .fontSize(isMobile ? 'xl' : '2xl'),
                              fontWeight: CustomTheme().fontWeight('bold'),
                              height: 1),
                        ),
                      ),
                      Divider(),
                      // SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 14 : 16,
                            horizontal: isMobile ? 16 : 24),
                        child: message != null
                            ? Text(
                                message,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: CustomTheme()
                                        .fontSize(isMobile ? 'md' : 'xl')),
                              )
                            : child,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: isMobile ? 12 : 16,
                    horizontal: isMobile ? 16 : 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12)),
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Expanded(
                    child: SizedBox(
                      height: isMobile ? 48 : 56,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                CustomTheme().buttonColor('primary'),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: Text(
                          'OK',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: CustomTheme()
                                  .fontSize(isMobile ? 'md' : 'xl')),
                        ),
                      ),
                    ),
                  ),
                ]),
              )
            ],
          ),
        ));
  }
}
