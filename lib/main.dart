import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/auth/auth_check.dart';
import 'package:textile_tracking/models/dashboard/machine.dart';
import 'package:textile_tracking/models/dashboard/work_order_summary.dart';
import 'package:textile_tracking/models/master/machine.dart';
import 'package:textile_tracking/models/master/unit.dart';
import 'package:textile_tracking/models/dashboard/work_order_chart.dart';
import 'package:textile_tracking/models/dashboard/work_order_process.dart';
import 'package:textile_tracking/models/dashboard/work_order_stats.dart';
import 'package:textile_tracking/models/option/option_dyeing.dart';
import 'package:textile_tracking/models/option/option_item.dart';
import 'package:textile_tracking/models/option/option_item_grade.dart';
import 'package:textile_tracking/models/option/option_item_semi_finished.dart';
import 'package:textile_tracking/models/option/option_item_type.dart';
import 'package:textile_tracking/models/option/option_machine.dart';
import 'package:textile_tracking/models/option/option_master_item_grade.dart';
import 'package:textile_tracking/models/option/option_unit.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';
import 'package:textile_tracking/models/process/cross_cutting.dart';
import 'package:textile_tracking/models/process/dyeing.dart';
import 'package:textile_tracking/models/process/embroidery.dart';
import 'package:textile_tracking/models/process/long_hemming.dart';
import 'package:textile_tracking/models/process/long_sitting.dart';
import 'package:textile_tracking/models/process/packing.dart';
import 'package:textile_tracking/models/process/press_tumbler.dart';
import 'package:textile_tracking/models/process/printing.dart';
import 'package:textile_tracking/models/process/sewing.dart';
import 'package:textile_tracking/models/process/sorting.dart';
import 'package:textile_tracking/models/process/stenter.dart';
import 'package:textile_tracking/models/process/tumbler.dart';
import 'package:textile_tracking/providers/user_provider.dart';
import 'package:textile_tracking/screens/account/index.dart';
import 'package:textile_tracking/screens/account/eula.dart';
import 'package:textile_tracking/screens/account/privacy_policy.dart';
import 'package:textile_tracking/screens/account/terms_conditions.dart';
import 'package:textile_tracking/screens/cross-cutting/index.dart';
import 'package:textile_tracking/screens/dyeing/index.dart';
import 'package:textile_tracking/screens/embroidery/index.dart';
import 'package:textile_tracking/screens/home/index.dart';
import 'package:textile_tracking/screens/long-hemming/index.dart';
import 'package:textile_tracking/screens/long-sitting/index.dart';
import 'package:textile_tracking/screens/notification/index.dart';
import 'package:textile_tracking/screens/packing/index.dart';
import 'package:textile_tracking/screens/press-tumbler/index.dart';
import 'package:textile_tracking/screens/printing/index.dart';
import 'package:textile_tracking/screens/profile/index.dart';
import 'package:textile_tracking/screens/sewing/index.dart';
import 'package:textile_tracking/screens/shearing/list/index.dart';
import 'package:textile_tracking/screens/shearing/model/shearing.dart';
import 'package:textile_tracking/screens/sizing/list/index.dart';
import 'package:textile_tracking/screens/sizing/model/sizing.dart';
import 'package:textile_tracking/screens/sorting/index.dart';
import 'package:textile_tracking/screens/stenter/index.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/screens/tumbler/index.dart';
import 'package:textile_tracking/screens/warping/list/index.dart';
import 'package:textile_tracking/screens/warping/model/warping.dart';
import 'package:textile_tracking/screens/weaving/list/index.dart';
import 'package:textile_tracking/screens/weaving/model/weaving.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => DyeingService()),
    ChangeNotifierProvider(create: (_) => PressTumblerService()),
    ChangeNotifierProvider(create: (_) => TumblerService()),
    ChangeNotifierProvider(create: (_) => StenterService()),
    ChangeNotifierProvider(create: (_) => LongSittingService()),
    ChangeNotifierProvider(create: (_) => LongHemmingService()),
    ChangeNotifierProvider(create: (_) => CrossCuttingService()),
    ChangeNotifierProvider(create: (_) => SewingService()),
    ChangeNotifierProvider(create: (_) => EmbroideryService()),
    ChangeNotifierProvider(create: (_) => PrintingService()),
    ChangeNotifierProvider(create: (_) => SortingService()),
    ChangeNotifierProvider(create: (_) => PackingService()),
    ChangeNotifierProvider(create: (_) => WeavingService()),
    ChangeNotifierProvider(create: (_) => SizingService()),
    ChangeNotifierProvider(create: (_) => WarpingService()),
    ChangeNotifierProvider(create: (_) => ShearingService()),
    ChangeNotifierProvider(create: (_) => UnitService()),
    ChangeNotifierProvider(create: (_) => OptionUnitService()),
    ChangeNotifierProvider(create: (_) => OptionMachineService()),
    ChangeNotifierProvider(create: (_) => OptionItemTypeService()),
    ChangeNotifierProvider(create: (_) => OptionWorkOrderService()),
    ChangeNotifierProvider(create: (_) => OptionItemGradeService()),
    ChangeNotifierProvider(create: (_) => OptionMasterItemGradeService()),
    ChangeNotifierProvider(create: (_) => OptionDyeingService()),
    ChangeNotifierProvider(create: (_) => OptionItemService()),
    ChangeNotifierProvider(create: (_) => OptionItemSemiFinishedService()),
    ChangeNotifierProvider(create: (_) => WorkOrderStatsService()),
    ChangeNotifierProvider(create: (_) => WorkOrderChartService()),
    ChangeNotifierProvider(create: (_) => WorkOrderProcessService()),
    ChangeNotifierProvider(create: (_) => WorkOrderSummaryService()),
    ChangeNotifierProvider(create: (_) => MachineService()),
    ChangeNotifierProvider(create: (_) => MachineMasterService()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InternetListener(
      child: MaterialApp(
        title: 'TexTrack',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              titleTextStyle: TextStyle(
                  color: CustomTheme().colors('text-primary'),
                  fontSize: CustomTheme().fontSize('xl'))),
          drawerTheme: DrawerThemeData(backgroundColor: Colors.white),
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
          scaffoldBackgroundColor: Colors.white,
          cardTheme: CardThemeData(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            margin: EdgeInsets.all(0),
            elevation: 0,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => AuthCheck(),
          '/dashboard': (context) => Home(),
          '/profile': (context) => Profile(),
          '/notification': (context) => NotificationList(),
          '/dyeings': (context) => DyeingScreen(),
          '/press': (context) => PressTumblerScreen(),
          '/tumblers': (context) => TumblerScreen(),
          '/stenters': (context) => StenterScreen(),
          '/long-slittings': (context) => LongSittingScreen(),
          '/long-hemmings': (context) => LongHemmingScreen(),
          '/cross-cuttings': (context) => CrossCuttingScreen(),
          '/sewings': (context) => SewingScreen(),
          '/embroideries': (context) => EmbroideryScreen(),
          '/sortings': (context) => SortingScreen(),
          '/packings': (context) => PackingScreen(),
          '/printings': (context) => PrintingScreen(),
          '/weaving': (context) => WeavingScreen(),
          '/sizing': (context) => SizingScreen(),
          '/warping': (context) => WarpingScreen(),
          '/shearing': (context) => ShearingScreen(),
          '/account': (context) => Account(),
          '/eula': (context) => Eula(),
          '/privacy-policy': (context) => PrivacyPolicy(),
          '/terms-conditions': (context) => TermsConditions(),
        },
      ),
    );
  }
}

class InternetListener extends StatefulWidget {
  final Widget child;

  const InternetListener({
    super.key,
    required this.child,
  });

  @override
  State<InternetListener> createState() => _InternetListenerState();
}

class _InternetListenerState extends State<InternetListener> {
  StreamSubscription? _subscription;
  bool _dialogShowing = false;

  @override
  void initState() {
    super.initState();

    _subscription = InternetConnection().onStatusChange.listen((status) {
      if (!mounted) return;

      if (status == InternetStatus.disconnected) {
        _showNoInternetDialog();
      } else {
        if (_dialogShowing && Navigator.canPop(context)) {
          Navigator.pop(context);
          _dialogShowing = false;
        }
      }
    });
  }

  void _showNoInternetDialog() {
    if (_dialogShowing) return;

    _dialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Tidak ada koneksi"),
        content: const Text(
          "Pastikan perangkat terhubung ke internet.",
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("Menunggu..."),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
