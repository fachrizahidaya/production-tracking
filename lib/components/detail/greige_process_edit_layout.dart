import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/process/create/greige_info_tab.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class GreigeProcessEditLayout extends StatelessWidget {
  final String title;
  final dynamic id;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;
  final VoidCallback onCancel;
  final GlobalKey<FormState> formKey;
  final List<Widget> formSections;
  final Widget submitSection;
  final Map<String, dynamic> greigeOrderData;

  const GreigeProcessEditLayout({
    super.key,
    required this.title,
    required this.id,
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
    required this.onCancel,
    required this.formKey,
    required this.formSections,
    required this.submitSection,
    required this.greigeOrderData,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: const Color(0xFFf9fafc),
          appBar: CustomAppBar(
            title: title,
            onReturn: onCancel,
            id: id,
          ),
          body: SafeArea(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? _ErrorView(
                        message: errorMessage!,
                        onRetry: onRetry,
                      )
                    : Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: const TabBar(
                              tabs: [
                                Tab(text: 'Form Edit'),
                                Tab(text: 'Info Greige Order'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                SingleChildScrollView(
                                  padding: EdgeInsets.only(
                                    left: 24,
                                    right: 24,
                                    top: 24,
                                    bottom: 110, // supaya tidak ketutup button
                                  ),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: formSections.separatedBy(
                                        CustomTheme().vGap('2xl'),
                                      ),
                                    ),
                                  ),
                                ),
                                greigeOrderData.isEmpty
                                    ? NoData()
                                    : GreigeInfoTab(
                                        data: greigeOrderData,
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
          ),
          bottomNavigationBar: isLoading || errorMessage != null
              ? null
              : SafeArea(
                  top: false,
                  child: Container(
                    padding: CustomTheme().padding('content'),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: submitSection,
                  ),
                ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 42, color: Colors.red.shade400),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
