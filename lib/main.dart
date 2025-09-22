import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:production_tracking/helpers/auth/auth_check.dart';
import 'package:production_tracking/models/master/unit.dart';
import 'package:production_tracking/models/option/option_machine.dart';
import 'package:production_tracking/models/option/option_operator.dart';
import 'package:production_tracking/models/option/option_unit.dart';
import 'package:production_tracking/models/process/dyeing.dart';
import 'package:production_tracking/providers/user_provider.dart';
import 'package:production_tracking/screens/dyeing/index.dart';
import 'package:production_tracking/screens/home/index.dart';
import 'package:production_tracking/screens/notification/index.dart';
import 'package:production_tracking/screens/press-tumbler/index.dart';
import 'package:production_tracking/screens/profile/index.dart';
import 'package:production_tracking/screens/stenter/index.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => DyeingService()),
    ChangeNotifierProvider(create: (_) => UnitService()),
    ChangeNotifierProvider(create: (_) => OptionUnitService()),
    ChangeNotifierProvider(create: (_) => OptionMachineService()),
    ChangeNotifierProvider(create: (_) => OptionOperatorService()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Production Tracking',
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
        cardTheme: const CardTheme(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
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
        '/press-tumblers': (context) => const PressTumbler(),
        '/stenters': (context) => const Stenter(),
        // '/long-sittings': (context) => const (),
        // '/long-hemmings': (context) => const (),
        // '/cross-cuttings': (context) => const (),
        // '/sewings': (context) => const (),
        // '/embroideries': (context) => const (),
        // '/sortings': (context) => const (),
        // '/packings': (context) => const (),
      },
    );
  }
}
