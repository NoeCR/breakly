import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:breakly/notifiers/breakly_notifier.dart';
import 'package:breakly/interfaces/preferences_repository.dart';
import 'package:breakly/interfaces/notification_service.dart';
import 'package:breakly/interfaces/device_mode_service.dart';
import 'package:breakly/services/session_sync_service.dart';
import 'package:breakly/interfaces/remote_session_repository.dart';

import 'breakly_notifier_test.mocks.dart';

@GenerateMocks([
  PreferencesRepository,
  NotificationService,
  DeviceModeService,
  SessionSyncService,
])
void main() {
  group('BreaklyNotifier', () {
    late BreaklyNotifier notifier;
    late MockPreferencesRepository mockPreferencesRepository;
    late MockNotificationService mockNotificationService;
    late MockDeviceModeService mockDeviceModeService;
    late MockSessionSyncService mockSessionSyncService;

    setUp(() {
      mockPreferencesRepository = MockPreferencesRepository();
      mockNotificationService = MockNotificationService();
      mockDeviceModeService = MockDeviceModeService();
      mockSessionSyncService = MockSessionSyncService();

      notifier = BreaklyNotifier(
        preferencesRepository: mockPreferencesRepository,
        notificationService: mockNotificationService,
        deviceModeService: mockDeviceModeService,
        sessionSyncService: mockSessionSyncService,
      );
    });

    tearDown(() {
      notifier.dispose();
    });

    group('updateMinutesTarget', () {
      test('should update minutes target and persist', () async {
        // Arrange
        const newMinutes = 60;
        when(
          mockPreferencesRepository.setMinutesTarget(newMinutes),
        ).thenAnswer((_) async {});

        // Act
        await notifier.updateMinutesTarget(newMinutes);

        // Assert
        expect(notifier.state.session.minutesTarget, equals(newMinutes));
        verify(
          mockPreferencesRepository.setMinutesTarget(newMinutes),
        ).called(1);
      });

      test('should reschedule notification if session is active', () async {
        // Arrange
        const newMinutes = 90;
        when(
          mockPreferencesRepository.setMinutesTarget(newMinutes),
        ).thenAnswer((_) async {});
        when(
          mockNotificationService.cancelEndNotification(),
        ).thenAnswer((_) async {});
        when(
          mockNotificationService.scheduleEndNotification(any),
        ).thenAnswer((_) async {});

        // Simular sesión activa
        notifier.state = notifier.state.copyWith(
          session: notifier.state.session.copyWith(activatedAt: DateTime.now()),
        );

        // Act
        await notifier.updateMinutesTarget(newMinutes);

        // Assert
        verify(mockNotificationService.cancelEndNotification()).called(1);
        verify(
          mockNotificationService.scheduleEndNotification(newMinutes),
        ).called(1);
      });
    });

    group('disableAllModes', () {
      test('should disable DND and set ringer to normal', () async {
        // Arrange
        when(
          mockDeviceModeService.hasDoNotDisturbAccess(),
        ).thenAnswer((_) async => true);
        when(
          mockDeviceModeService.setDoNotDisturb(false),
        ).thenAnswer((_) async {});
        when(
          mockDeviceModeService.toggleRinger('normal'),
        ).thenAnswer((_) async {});

        // Act
        await notifier.disableAllModes();

        // Assert
        verify(mockDeviceModeService.hasDoNotDisturbAccess()).called(1);
        verify(mockDeviceModeService.setDoNotDisturb(false)).called(1);
        verify(mockDeviceModeService.toggleRinger('normal')).called(1);
      });

      test('should only toggle ringer if no DND access', () async {
        // Arrange
        when(
          mockDeviceModeService.hasDoNotDisturbAccess(),
        ).thenAnswer((_) async => false);
        when(
          mockDeviceModeService.toggleRinger('normal'),
        ).thenAnswer((_) async {});

        // Act
        await notifier.disableAllModes();

        // Assert
        verify(mockDeviceModeService.hasDoNotDisturbAccess()).called(1);
        verifyNever(mockDeviceModeService.setDoNotDisturb(any));
        verify(mockDeviceModeService.toggleRinger('normal')).called(1);
      });
    });

    group('enablePreferredMode', () {
      test('should enable DND if access available', () async {
        // Arrange
        when(
          mockDeviceModeService.hasDoNotDisturbAccess(),
        ).thenAnswer((_) async => true);
        when(
          mockDeviceModeService.setDoNotDisturb(true),
        ).thenAnswer((_) async {});

        // Act
        await notifier.enablePreferredMode();

        // Assert
        verify(mockDeviceModeService.hasDoNotDisturbAccess()).called(1);
        verify(mockDeviceModeService.setDoNotDisturb(true)).called(1);
      });

      test(
        'should fallback to silent mode and open settings if no DND access',
        () async {
          // Arrange
          when(
            mockDeviceModeService.hasDoNotDisturbAccess(),
          ).thenAnswer((_) async => false);
          when(
            mockDeviceModeService.toggleRinger('silent'),
          ).thenAnswer((_) async {});
          when(
            mockDeviceModeService.openDoNotDisturbSettings(),
          ).thenAnswer((_) async {});

          // Act
          await notifier.enablePreferredMode();

          // Assert
          verify(mockDeviceModeService.hasDoNotDisturbAccess()).called(1);
          verifyNever(mockDeviceModeService.setDoNotDisturb(any));
          verify(mockDeviceModeService.toggleRinger('silent')).called(1);
          verify(mockDeviceModeService.openDoNotDisturbSettings()).called(1);
        },
      );
    });

    group('setVideoInitialized', () {
      test('should update video initialization state', () {
        // Act
        notifier.setVideoInitialized(true);

        // Assert
        expect(notifier.state.isVideoInitialized, isTrue);
      });
    });

    group('checkExactAlarmsPermission', () {
      test('should delegate to notification service', () async {
        // Arrange
        when(
          mockNotificationService.checkExactAlarmsPermission(),
        ).thenAnswer((_) async => true);

        // Act
        final result = await notifier.checkExactAlarmsPermission();

        // Assert
        expect(result, isTrue);
        verify(mockNotificationService.checkExactAlarmsPermission()).called(1);
      });
    });

    group('areNotificationsEnabled', () {
      test('should delegate to notification service', () async {
        // Arrange
        when(
          mockNotificationService.areNotificationsEnabled(),
        ).thenAnswer((_) async => false);

        // Act
        final result = await notifier.areNotificationsEnabled();

        // Assert
        expect(result, isFalse);
        verify(mockNotificationService.areNotificationsEnabled()).called(1);
      });
    });

    group('checkPendingNotifications', () {
      test('should delegate to notification service', () async {
        // Arrange
        when(
          mockNotificationService.checkPendingNotifications(),
        ).thenAnswer((_) async {});

        // Act
        await notifier.checkPendingNotifications();

        // Assert
        verify(mockNotificationService.checkPendingNotifications()).called(1);
      });
    });

    group('getSyncStatus', () {
      test('should delegate to session sync service', () async {
        // Arrange
        when(
          mockSessionSyncService.getSyncStatus(),
        ).thenAnswer((_) async => SyncStatus.synced);

        // Act
        final result = await notifier.getSyncStatus();

        // Assert
        expect(result, equals(SyncStatus.synced));
        verify(mockSessionSyncService.getSyncStatus()).called(1);
      });
    });

    group('isConnected', () {
      test('should delegate to session sync service', () async {
        // Arrange
        when(
          mockSessionSyncService.isConnected(),
        ).thenAnswer((_) async => true);

        // Act
        final result = await notifier.isConnected();

        // Assert
        expect(result, isTrue);
        verify(mockSessionSyncService.isConnected()).called(1);
      });
    });

    group('forceSync', () {
      test('should delegate to session sync service', () async {
        // Arrange
        when(mockSessionSyncService.forceSync()).thenAnswer((_) async {});

        // Act
        await notifier.forceSync();

        // Assert
        verify(mockSessionSyncService.forceSync()).called(1);
      });
    });
  });
}
