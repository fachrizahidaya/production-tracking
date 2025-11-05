import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/helpers/auth/auth_check.dart';
import 'package:textile_tracking/models/master/unit.dart';
import 'package:textile_tracking/models/master/work_order_chart.dart';
import 'package:textile_tracking/models/master/work_order_stats.dart';
import 'package:textile_tracking/models/option/option_dyeing.dart';
import 'package:textile_tracking/models/option/option_item_grade.dart';
import 'package:textile_tracking/models/option/option_machine.dart';
import 'package:textile_tracking/models/option/option_operator.dart';
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
import 'package:textile_tracking/providers/user_provider.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // final store = Store(appReducer, initialState: AppState.initial());
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DyeingService()),
        ChangeNotifierProvider(create: (_) => PressTumblerService()),
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
        ChangeNotifierProvider(create: (_) => OptionOperatorService()),
        ChangeNotifierProvider(create: (_) => OptionWorkOrderService()),
        ChangeNotifierProvider(create: (_) => OptionItemGradeService()),
        ChangeNotifierProvider(create: (_) => OptionDyeingService()),
        ChangeNotifierProvider(create: (_) => WorkOrderStatsService()),
        ChangeNotifierProvider(create: (_) => WorkOrderChartService()),
      ],
      child: MyApp(
          // store: store
          )));
}

class MyApp extends StatelessWidget {
  // final Store<AppState> store;

  const MyApp({
    super.key,
    // required this.store
  });

  @override
  Widget build(BuildContext context) {
    return
        // StoreProvider<AppState>(
        //     store: store,
        //     child:
        MaterialApp(
      title: 'Textile Tracking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            titleTextStyle: TextStyle(color: Colors.black, fontSize: 18)),
        drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: Colors.white),
        scaffoldBackgroundColor: Colors.white,
        cardTheme: const CardThemeData(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4))),
          margin: EdgeInsets.all(0),
          elevation: 0,
        ),
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        // useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthCheck(),
        '/dashboard': (context) => const Home(),
        '/profile': (context) => const Profile(),
        '/notification': (context) => const NotificationList(),
        '/dyeings': (context) => const DyeingScreen(),
        '/press-tumblers': (context) => const PressTumblerScreen(),
        '/stenters': (context) => const StenterScreen(),
        '/long-sittings': (context) => const LongSittingScreen(),
        '/long-hemmings': (context) => const LongHemmingScreen(),
        '/cross-cuttings': (context) => const CrossCuttingScreen(),
        '/sewings': (context) => const SewingScreen(),
        '/embroideries': (context) => const EmbroideryScreen(),
        '/sortings': (context) => const SortingScreen(),
        '/packings': (context) => const PackingScreen(),
        '/printings': (context) => const PrintingScreen(),
      },
    );
    // );
  }
}
