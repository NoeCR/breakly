import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:breakly/services/preferences_repository_impl.dart';

import 'preferences_repository_impl_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  group('PreferencesRepositoryImpl', () {
    late PreferencesRepositoryImpl repository;
    late MockSharedPreferences mockPreferences;

    setUp(() {
      mockPreferences = MockSharedPreferences();
      repository = PreferencesRepositoryImpl();
    });

    group('getMinutesTarget', () {
      test('should return stored minutes target', () async {
        // Arrange
        const expectedMinutes = 60;
        when(
          mockPreferences.getInt('minutes_target'),
        ).thenReturn(expectedMinutes);

        // Act
        final result = await repository.getMinutesTarget();

        // Assert
        expect(result, equals(expectedMinutes));
        verify(mockPreferences.getInt('minutes_target')).called(1);
      });

      test('should return null when no value stored', () async {
        // Arrange
        when(mockPreferences.getInt('minutes_target')).thenReturn(null);

        // Act
        final result = await repository.getMinutesTarget();

        // Assert
        expect(result, isNull);
        verify(mockPreferences.getInt('minutes_target')).called(1);
      });
    });

    group('setMinutesTarget', () {
      test('should store minutes target', () async {
        // Arrange
        const minutes = 90;
        when(
          mockPreferences.setInt('minutes_target', minutes),
        ).thenAnswer((_) async => true);

        // Act
        await repository.setMinutesTarget(minutes);

        // Assert
        verify(mockPreferences.setInt('minutes_target', minutes)).called(1);
      });
    });

    group('getActiveSessionStartedAt', () {
      test('should return stored session start time', () async {
        // Arrange
        const expectedTime = 1234567890;
        when(
          mockPreferences.getInt('active_session_started_at'),
        ).thenReturn(expectedTime);

        // Act
        final result = await repository.getActiveSessionStartedAt();

        // Assert
        expect(result, equals(expectedTime));
        verify(mockPreferences.getInt('active_session_started_at')).called(1);
      });

      test('should return null when no session stored', () async {
        // Arrange
        when(
          mockPreferences.getInt('active_session_started_at'),
        ).thenReturn(null);

        // Act
        final result = await repository.getActiveSessionStartedAt();

        // Assert
        expect(result, isNull);
        verify(mockPreferences.getInt('active_session_started_at')).called(1);
      });
    });

    group('setActiveSessionStartedAt', () {
      test('should store session start time', () async {
        // Arrange
        const time = 1234567890;
        when(
          mockPreferences.setInt('active_session_started_at', time),
        ).thenAnswer((_) async => true);

        // Act
        await repository.setActiveSessionStartedAt(time);

        // Assert
        verify(
          mockPreferences.setInt('active_session_started_at', time),
        ).called(1);
      });
    });

    group('clearActiveSessionStartedAt', () {
      test('should remove session start time', () async {
        // Arrange
        when(
          mockPreferences.remove('active_session_started_at'),
        ).thenAnswer((_) async => true);

        // Act
        await repository.clearActiveSessionStartedAt();

        // Assert
        verify(mockPreferences.remove('active_session_started_at')).called(1);
      });
    });
  });
}
