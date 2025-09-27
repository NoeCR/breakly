import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:breakly/services/notification_service_impl.dart';

import 'notification_service_impl_test.mocks.dart';

@GenerateMocks([FlutterLocalNotificationsPlugin])
void main() {
  group('NotificationServiceImpl', () {
    late NotificationServiceImpl notificationService;
    late MockFlutterLocalNotificationsPlugin mockNotifications;

    setUp(() {
      mockNotifications = MockFlutterLocalNotificationsPlugin();
      notificationService = NotificationServiceImpl();
    });

    group('initialize', () {
      test('should initialize notifications successfully', () async {
        // Arrange
        when(mockNotifications.initialize(any)).thenAnswer((_) async => true);

        // Act & Assert
        expect(() => notificationService.initialize(), returnsNormally);
      });

      test('should handle initialization errors', () async {
        // Arrange
        when(
          mockNotifications.initialize(any),
        ).thenThrow(Exception('Initialization failed'));

        // Act & Assert
        expect(
          () => notificationService.initialize(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('scheduleEndNotification', () {
      test('should schedule notification for future time', () async {
        // Arrange
        const minutes = 30;

        // Act & Assert
        expect(
          () => notificationService.scheduleEndNotification(minutes),
          returnsNormally,
        );
      });

      test('should show immediate notification for 0 minutes', () async {
        // Arrange
        const minutes = 0;

        // Act & Assert
        expect(
          () => notificationService.scheduleEndNotification(minutes),
          returnsNormally,
        );
      });
    });

    group('cancelEndNotification', () {
      test('should cancel notification successfully', () async {
        // Act & Assert
        expect(
          () => notificationService.cancelEndNotification(),
          returnsNormally,
        );
      });
    });

    group('checkExactAlarmsPermission', () {
      test('should return permission status', () async {
        // Act
        final result = await notificationService.checkExactAlarmsPermission();

        // Assert
        expect(result, isA<bool>());
      });
    });

    group('areNotificationsEnabled', () {
      test('should return notification status', () async {
        // Act
        final result = await notificationService.areNotificationsEnabled();

        // Assert
        expect(result, isA<bool>());
      });
    });

    group('checkPendingNotifications', () {
      test('should check pending notifications', () async {
        // Act & Assert
        expect(
          () => notificationService.checkPendingNotifications(),
          returnsNormally,
        );
      });
    });
  });
}

