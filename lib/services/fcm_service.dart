import 'dart:convert';
import 'dart:io' show Platform;

<<<<<<< HEAD
import 'package:android_id/android_id.dart';
=======
>>>>>>> 16778356 (feat: fcm notification)
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:textile_tracking/screens/report/bs/bs_by_id.dart';
import 'package:textile_tracking/screens/report/gsm/gsm_by_id.dart';
<<<<<<< HEAD
=======
import 'package:textile_tracking/screens/report/bs/bs_by_id.dart';
>>>>>>> 58857212 (feat: notifikasi evaluasi bs)
=======
>>>>>>> b77e0195 (fix: bs, gsm, rework)
import 'package:textile_tracking/screens/report/rework/rework_by_id.dart';
=======
import 'package:textile_tracking/screens/report/rework/rework_notification.dart';
>>>>>>> 16778356 (feat: fcm notification)
=======
import 'package:textile_tracking/screens/report/rework/rework_by_id.dart';
>>>>>>> e4d7831b (fix: handle firebase notification)

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
<<<<<<< HEAD
<<<<<<< HEAD
  debugPrint('FCM background data: ${message.data}');

=======
>>>>>>> 16778356 (feat: fcm notification)
=======
  debugPrint('FCM background data: ${message.data}');

>>>>>>> e4d7831b (fix: handle firebase notification)
  // Notification display is handled by FCM when the app is backgrounded.
  // Data is processed when the user taps the notification.
}

<<<<<<< HEAD
<<<<<<< HEAD
class FcmService with WidgetsBindingObserver {
=======
class FcmService {
>>>>>>> 16778356 (feat: fcm notification)
=======
class FcmService with WidgetsBindingObserver {
>>>>>>> 64eaac94 (fix: firebase messaging)
  static final FcmService instance = FcmService._();
  FcmService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  String? _deviceId;
  bool _initialized = false;
  Map<String, dynamic>? _pendingNavigation;

  Future<void> initialize() async {
    if (_initialized || kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      return;
    }

    try {
      await _messaging.requestPermission(alert: true, badge: true, sound: true);
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      await _initializeLocalNotifications();

      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);
      FirebaseMessaging.onMessage.listen(_showForegroundNotification);
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageTap(initialMessage);
      }

      _messaging.onTokenRefresh.listen((_) => registerForCurrentUser());
      _initialized = true;
<<<<<<< HEAD
<<<<<<< HEAD
      WidgetsBinding.instance.addObserver(this);
      await clearNotifications();
=======
>>>>>>> 16778356 (feat: fcm notification)
=======
      WidgetsBinding.instance.addObserver(this);
      await clearNotifications();
>>>>>>> 64eaac94 (fix: firebase messaging)
    } catch (error) {
      // Firebase configuration is supplied per environment. Keep the app usable
      // on builds that do not yet contain the native Firebase config files.
      debugPrint('FCM initialization failed: $error');
    }
  }

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 64eaac94 (fix: firebase messaging)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      clearNotifications();
    }
  }

  Future<void> clearNotifications() async {
    if (!_initialized) return;
    await _localNotifications.cancelAll();
  }

<<<<<<< HEAD
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      'ic_stat_notification',
    );
    const iosSettings = DarwinInitializationSettings();
    await _localNotifications.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
=======
=======
>>>>>>> 64eaac94 (fix: firebase messaging)
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      'ic_stat_notification',
    );
    const iosSettings = DarwinInitializationSettings();
    await _localNotifications.initialize(
<<<<<<< HEAD
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
>>>>>>> 16778356 (feat: fcm notification)
=======
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
>>>>>>> a758f4e3 (fix: service)
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload == null || payload.isEmpty) return;
        final data = jsonDecode(payload);
        if (data is Map) {
          _handleMessageTap(
<<<<<<< HEAD
<<<<<<< HEAD
            RemoteMessage(data: Map<String, dynamic>.from(data)),
          );
=======
              RemoteMessage(data: Map<String, dynamic>.from(data)));
>>>>>>> 16778356 (feat: fcm notification)
=======
            RemoteMessage(data: Map<String, dynamic>.from(data)),
          );
>>>>>>> a758f4e3 (fix: service)
        }
      },
    );

    final androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        'default_notifications',
        'Default notifications',
        description: 'Notifications from TexTrack',
        importance: Importance.high,
      ),
    );
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
<<<<<<< HEAD
<<<<<<< HEAD
    debugPrint('FCM foreground data: ${message.data}');
=======
>>>>>>> 16778356 (feat: fcm notification)
=======
    debugPrint('FCM foreground data: ${message.data}');
>>>>>>> e4d7831b (fix: handle firebase notification)
    final title =
        message.notification?.title ?? message.data['title']?.toString();
    final body = message.notification?.body ?? message.data['body']?.toString();
    if ((title == null || title.isEmpty) && (body == null || body.isEmpty)) {
      return;
    }

    await _localNotifications.show(
      message.hashCode,
      title ?? 'TexTrack',
      body ?? '',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'default_notifications',
          'Default notifications',
          channelDescription: 'Notifications from TexTrack',
          importance: Importance.high,
          priority: Priority.high,
<<<<<<< HEAD
<<<<<<< HEAD
          icon: 'ic_stat_notification',
=======
          icon: '@mipmap/ic_launcher',
>>>>>>> 16778356 (feat: fcm notification)
=======
          icon: 'ic_stat_notification',
>>>>>>> 38fd9bd2 (fix: logout)
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  Future<void> registerForCurrentUser() async {
    if (!_initialized) return;

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    if (accessToken == null || accessToken.isEmpty) return;

    final token = await _messaging.getToken();
<<<<<<< HEAD
<<<<<<< HEAD
=======
    print('token: $token');
    debugPrint('FCM token received: ${token == null ? 'null' : 'available'}');
>>>>>>> 16778356 (feat: fcm notification)
=======
>>>>>>> 64eaac94 (fix: firebase messaging)
    if (token == null || token.isEmpty) return;

    final deviceId = await _getDeviceId();
    final platform = Platform.isIOS ? 'ios' : 'android';
    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/device-tokens'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'token': token,
        'platform': platform,
        'device_id': deviceId,
      }),
    );
<<<<<<< HEAD
<<<<<<< HEAD
=======
    debugPrint('FCM registration response: ${response.statusCode}');
>>>>>>> 16778356 (feat: fcm notification)
=======
>>>>>>> 64eaac94 (fix: firebase messaging)

    if (response.statusCode >= 200 && response.statusCode < 300) {
      await prefs.setString('fcm_token', token);
      await prefs.setString('fcm_device_id', deviceId);
    } else {
      debugPrint('FCM token registration failed: ${response.statusCode}');
    }
  }

<<<<<<< HEAD
<<<<<<< HEAD
  Future<Map<String, String?>> getCurrentDeviceData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('fcm_token');
    final deviceId = await _getDeviceId();

    return {'token': token, 'device_id': deviceId};
  }

  Future<void> clearCurrentDeviceData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('fcm_token');
    await prefs.remove('fcm_device_id');
  }

  /// Stable across uninstall/reinstall (not SharedPreferences).
  /// Android: Settings.Secure.ANDROID_ID (unique per device + signing key).
  /// iOS: identifierForVendor.
  /// Avoids Build.ID which collides across devices with the same OS build.
  Future<String> _getDeviceId() async {
    if (_deviceId != null) return _deviceId!;

    if (Platform.isAndroid) {
      final androidId = await const AndroidId().getId();
      _deviceId = (androidId != null && androidId.isNotEmpty)
          ? androidId
          : 'android-device';
    } else {
      final info = DeviceInfoPlugin();
=======
  Future<void> unregisterCurrentDevice() async {
=======
  Future<Map<String, String?>> getCurrentDeviceData() async {
>>>>>>> 38fd9bd2 (fix: logout)
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('fcm_token');
    final deviceId = prefs.getString('fcm_device_id') ?? await _getDeviceId();

    return {'token': token, 'device_id': deviceId};
  }

  Future<void> clearCurrentDeviceData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('fcm_token');
    await prefs.remove('fcm_device_id');
  }

  Future<String> _getDeviceId() async {
    if (_deviceId != null) return _deviceId!;
    final info = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      _deviceId = (await info.androidInfo).id;
    } else {
>>>>>>> 16778356 (feat: fcm notification)
      _deviceId = (await info.iosInfo).identifierForVendor ?? 'ios-device';
    }
    return _deviceId!;
  }

  void _handleMessageTap(RemoteMessage message) {
    final data = message.data;
    final route = data['route']?.toString();
    final type = data['type']?.toString();
    final id = data['id']?.toString();
    if (route == null && type == null) return;

    _pendingNavigation = {'route': route, 'type': type, 'id': id};
    _flushPendingNavigation();
  }

  void flushPendingNavigation() => _flushPendingNavigation();

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 58857212 (feat: notifikasi evaluasi bs)
  void clearPendingNavigation() {
    _pendingNavigation = null;
  }

  Future<void> _flushPendingNavigation() async {
<<<<<<< HEAD
=======
  void _flushPendingNavigation() {
>>>>>>> 16778356 (feat: fcm notification)
=======
>>>>>>> 58857212 (feat: notifikasi evaluasi bs)
    final navigation = _pendingNavigation;
    final navigator = appNavigatorKey.currentState;
    if (navigation == null || navigator == null) return;

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 58857212 (feat: notifikasi evaluasi bs)
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    // Keep pending while logged out so Login/AuthCheck can flush after auth.
    // Never push detail screens onto the Login stack.
    if (accessToken == null || accessToken.isEmpty) return;
    if (_pendingNavigation != navigation) return;

    _pendingNavigation = null;

<<<<<<< HEAD
    final route = navigation['route'] as String?;
    final type = navigation['type'] as String?;
    final id = navigation['id'] as String?;
    if (type == 'dyeing_rework_reminder') {
      navigator.pushNamed('/dyeing-rework-evaluations');
    } else if (type == 'bs_evaluation_reminder') {
      navigator.pushNamed('/bs-evaluations');
    } else if (type == 'gsm_evaluation_reminder') {
      navigator.pushNamed('/gsm-evaluations');
    } else if (type == 'dyeing_rework_evaluation' && id != null) {
      navigator.push(
        MaterialPageRoute(
          builder: (_) => ReworkDetailLoadingScreen(id: id, returnToList: true),
        ),
      );
    } else if (type == 'bs_evaluation' && id != null) {
      navigator.push(
        MaterialPageRoute(
          builder: (_) => BsDetailLoadingScreen(id: id, returnToList: true),
        ),
      );
    } else if (type == 'gsm_evaluation' && id != null) {
      navigator.push(
        MaterialPageRoute(
          builder: (_) => GsmDetailLoadingScreen(id: id, returnToList: true),
        ),
      );
    } else if (route != null &&
        route.startsWith('/dyeing-rework-evaluations/')) {
      final segments = route.split('/');
      final routeId = segments.length > 2 ? segments[2] : null;
      if (routeId != null && routeId.isNotEmpty) {
        navigator.push(
          MaterialPageRoute(
            builder: (_) =>
                ReworkDetailLoadingScreen(id: routeId, returnToList: true),
          ),
        );
      } else {
        navigator.pushNamed('/dyeing-rework-evaluations');
      }
    } else if (route != null && route.startsWith('/bs-evaluations/')) {
      final segments = route.split('/');
      final routeId = segments.length > 2 ? segments[2] : null;
      if (routeId != null && routeId.isNotEmpty) {
        navigator.push(
          MaterialPageRoute(
            builder: (_) =>
                BsDetailLoadingScreen(id: routeId, returnToList: true),
          ),
        );
      } else {
        navigator.pushNamed('/bs-evaluations');
      }
    } else if (route != null && route.startsWith('/gsm-evaluations/')) {
      final segments = route.split('/');
      final routeId = segments.length > 2 ? segments[2] : null;
      if (routeId != null && routeId.isNotEmpty) {
        navigator.push(
          MaterialPageRoute(
            builder: (_) =>
                GsmDetailLoadingScreen(id: routeId, returnToList: true),
          ),
        );
      } else {
        navigator.pushNamed('/gsm-evaluations');
      }
    } else {
      navigator.pushNamed(
        route ?? '/notification',
        arguments: {'id': id, 'type': type},
      );
    }
=======
=======
>>>>>>> 58857212 (feat: notifikasi evaluasi bs)
    final route = navigation['route'] as String?;
    final type = navigation['type'] as String?;
    final id = navigation['id'] as String?;
    if (type == 'dyeing_rework_reminder') {
      navigator.pushNamed('/dyeing-rework-evaluations');
    } else if (type == 'bs_evaluation_reminder') {
      navigator.pushNamed('/bs-evaluations');
    } else if (type == 'gsm_evaluation_reminder') {
      navigator.pushNamed('/gsm-evaluations');
    } else if (type == 'dyeing_rework_evaluation' && id != null) {
      navigator.push(
        MaterialPageRoute(
          builder: (_) => ReworkDetailLoadingScreen(id: id, returnToList: true),
        ),
      );
    } else if (type == 'bs_evaluation' && id != null) {
      navigator.push(
        MaterialPageRoute(
          builder: (_) => BsDetailLoadingScreen(id: id, returnToList: true),
        ),
      );
    } else if (type == 'gsm_evaluation' && id != null) {
      navigator.push(
        MaterialPageRoute(
          builder: (_) => GsmDetailLoadingScreen(id: id, returnToList: true),
        ),
      );
    } else if (route != null &&
        route.startsWith('/dyeing-rework-evaluations/')) {
      final segments = route.split('/');
      final routeId = segments.length > 2 ? segments[2] : null;
      if (routeId != null && routeId.isNotEmpty) {
        navigator.push(
          MaterialPageRoute(
            builder: (_) =>
                ReworkDetailLoadingScreen(id: routeId, returnToList: true),
          ),
        );
      } else {
        navigator.pushNamed('/dyeing-rework-evaluations');
      }
    } else if (route != null && route.startsWith('/bs-evaluations/')) {
      final segments = route.split('/');
      final routeId = segments.length > 2 ? segments[2] : null;
      if (routeId != null && routeId.isNotEmpty) {
        navigator.push(
          MaterialPageRoute(
            builder: (_) =>
                BsDetailLoadingScreen(id: routeId, returnToList: true),
          ),
        );
      } else {
        navigator.pushNamed('/bs-evaluations');
      }
    } else if (route != null && route.startsWith('/gsm-evaluations/')) {
      final segments = route.split('/');
      final routeId = segments.length > 2 ? segments[2] : null;
      if (routeId != null && routeId.isNotEmpty) {
        navigator.push(
          MaterialPageRoute(
            builder: (_) =>
                GsmDetailLoadingScreen(id: routeId, returnToList: true),
          ),
        );
      } else {
        navigator.pushNamed('/gsm-evaluations');
      }
    } else {
      navigator.pushNamed(
        route ?? '/notification',
        arguments: {'id': id, 'type': type},
      );
    }
<<<<<<< HEAD
    _pendingNavigation = null;
>>>>>>> 16778356 (feat: fcm notification)
=======
>>>>>>> 58857212 (feat: notifikasi evaluasi bs)
  }
}
