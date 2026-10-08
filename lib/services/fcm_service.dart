import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textile_tracking/screens/report/bs/bs_by_id.dart';
import 'package:textile_tracking/screens/report/gsm/gsm_by_id.dart';
import 'package:textile_tracking/screens/report/rework/rework_by_id.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('FCM background data: ${message.data}');

  // Notification display is handled by FCM when the app is backgrounded.
  // Data is processed when the user taps the notification.
}

class FcmService with WidgetsBindingObserver {
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
      WidgetsBinding.instance.addObserver(this);
      await clearNotifications();
    } catch (error) {
      // Firebase configuration is supplied per environment. Keep the app usable
      // on builds that do not yet contain the native Firebase config files.
      debugPrint('FCM initialization failed: $error');
    }
  }

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

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      'ic_stat_notification',
    );
    const iosSettings = DarwinInitializationSettings();
    await _localNotifications.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload == null || payload.isEmpty) return;
        final data = jsonDecode(payload);
        if (data is Map) {
          _handleMessageTap(
            RemoteMessage(data: Map<String, dynamic>.from(data)),
          );
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
    debugPrint('FCM foreground data: ${message.data}');
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
          icon: 'ic_stat_notification',
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

    if (response.statusCode >= 200 && response.statusCode < 300) {
      await prefs.setString('fcm_token', token);
      await prefs.setString('fcm_device_id', deviceId);
    } else {
      debugPrint('FCM token registration failed: ${response.statusCode}');
    }
  }

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

  /// Stable per-install id. Avoids Android Build.ID which collides across
  /// devices sharing the same OS build (common in debug / same Android version).
  Future<String> _getDeviceId() async {
    if (_deviceId != null) return _deviceId!;

    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('app_device_id');
    if (stored != null && stored.isNotEmpty) {
      _deviceId = stored;
      return _deviceId!;
    }

    final generated = _generateDeviceId();
    await prefs.setString('app_device_id', generated);
    _deviceId = generated;
    return _deviceId!;
  }

  String _generateDeviceId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20, 32)}';
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

  void clearPendingNavigation() {
    _pendingNavigation = null;
  }

  Future<void> _flushPendingNavigation() async {
    final navigation = _pendingNavigation;
    final navigator = appNavigatorKey.currentState;
    if (navigation == null || navigator == null) return;

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    // Keep pending while logged out so Login/AuthCheck can flush after auth.
    // Never push detail screens onto the Login stack.
    if (accessToken == null || accessToken.isEmpty) return;
    if (_pendingNavigation != navigation) return;

    _pendingNavigation = null;

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
  }
}
