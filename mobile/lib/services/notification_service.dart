import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for iOS
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final platform = _notificationsPlugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    
    if (platform != null) {
      await platform.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    final androidPlatform = _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlatform != null) {
      await androidPlatform.requestNotificationsPermission();
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    // Navigate to appropriate screen based on payload
    if (response.payload != null) {
      final data = json.decode(response.payload!);
      // TODO: Navigate to harvest confirmation screen
      print('Notification tapped: $data');
    }
  }

  Future<void> showHarvestNotification({
    required String plantingFormId,
    required String farmName,
    required String lotNumber,
    required String variety,
    required DateTime expectedHarvestDate,
    required int daysUntilHarvest,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'harvest_notifications',
      'Harvest Notifications',
      channelDescription: 'Notifications for upcoming harvests',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final payload = json.encode({
      'type': 'HARVEST_REMINDER',
      'plantingFormId': plantingFormId,
      'farmName': farmName,
      'lotNumber': lotNumber,
      'variety': variety,
      'expectedHarvestDate': expectedHarvestDate.toIso8601String(),
    });

    await _notificationsPlugin.show(
      plantingFormId.hashCode,
      '🌾 Próxima Cosecha',
      'La cosecha de $variety en $farmName - Lote $lotNumber está programada para $daysUntilHarvest días. Por favor confirme la fecha.',
      details,
      payload: payload,
    );

    // Save notification to local storage
    await _saveNotification({
      'id': plantingFormId,
      'title': 'Próxima Cosecha',
      'message': 'La cosecha de $variety en $farmName - Lote $lotNumber está programada para $daysUntilHarvest días.',
      'timestamp': DateTime.now().toIso8601String(),
      'data': {
        'plantingFormId': plantingFormId,
        'farmName': farmName,
        'lotNumber': lotNumber,
        'variety': variety,
        'expectedHarvestDate': expectedHarvestDate.toIso8601String(),
        'daysUntilHarvest': daysUntilHarvest,
      },
    });
  }

  Future<void> _saveNotification(Map<String, dynamic> notification) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = await getNotifications();
    notifications.insert(0, notification);
    
    // Keep only last 50 notifications
    if (notifications.length > 50) {
      notifications.removeRange(50, notifications.length);
    }
    
    await prefs.setString('notifications', json.encode(notifications));
  }

  Future<List<Map<String, dynamic>>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getString('notifications');
    
    if (notificationsJson == null) {
      return [];
    }
    
    final List<dynamic> decoded = json.decode(notificationsJson);
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notifications');
  }

  // Schedule daily check for harvest notifications
  // In a production app, this would be handled by a background service
  Future<void> checkUpcomingHarvests(List<dynamic> plantingForms) async {
    final now = DateTime.now();
    final oneWeekFromNow = now.add(const Duration(days: 7));

    for (var form in plantingForms) {
      if (form['status'] != 'harvested' && form['expectedHarvestDate'] != null) {
        final expectedDate = DateTime.parse(form['expectedHarvestDate']);
        
        if (expectedDate.isAfter(now) && expectedDate.isBefore(oneWeekFromNow)) {
          final daysUntilHarvest = expectedDate.difference(now).inDays;
          
          await showHarvestNotification(
            plantingFormId: form['_id'],
            farmName: form['farmName'],
            lotNumber: form['lotNumber'],
            variety: form['variety']['name'],
            expectedHarvestDate: expectedDate,
            daysUntilHarvest: daysUntilHarvest,
          );
        }
      }
    }
  }
}
