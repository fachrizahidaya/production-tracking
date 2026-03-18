import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/auth/auth_check.dart';
import 'package:textile_tracking/models/dashboard/machine.dart';
import 'package:textile_tracking/models/dashboard/work_order_summary.dart';
import 'package:textile_tracking/models/master/unit.dart';
import 'package:textile_tracking/models/dashboard/work_order_chart.dart';
import 'package:textile_tracking/models/dashboard/work_order_process.dart';
import 'package:textile_tracking/models/dashboard/work_order_stats.dart';
import 'package:textile_tracking/models/option/option_dyeing.dart';
import 'package:textile_tracking/models/option/option_item.dart';
import 'package:textile_tracking/models/option/option_item_grade.dart';
import 'package:textile_tracking/models/option/option_machine.dart';
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
import 'package:textile_tracking/screens/sorting/index.dart';
import 'package:textile_tracking/screens/stenter/index.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/screens/tumbler/index.dart';

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
    ChangeNotifierProvider(create: (_) => UnitService()),
    ChangeNotifierProvider(create: (_) => OptionUnitService()),
    ChangeNotifierProvider(create: (_) => OptionMachineService()),
    ChangeNotifierProvider(create: (_) => OptionWorkOrderService()),
    ChangeNotifierProvider(create: (_) => OptionItemGradeService()),
    ChangeNotifierProvider(create: (_) => OptionDyeingService()),
    ChangeNotifierProvider(create: (_) => OptionItemService()),
    ChangeNotifierProvider(create: (_) => WorkOrderStatsService()),
    ChangeNotifierProvider(create: (_) => WorkOrderChartService()),
    ChangeNotifierProvider(create: (_) => WorkOrderProcessService()),
    ChangeNotifierProvider(create: (_) => WorkOrderSummaryService()),
    ChangeNotifierProvider(create: (_) => MachineService()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        '/account': (context) => Account(),
        '/eula': (context) => Eula(),
        '/privacy-policy': (context) => PrivacyPolicy(),
        '/terms-conditions': (context) => TermsConditions(),
      },
    );
  }
}
