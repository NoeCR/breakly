import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breakly/widgets/duration_chip.dart';

void main() {
  group('DurationChip', () {
    testWidgets('should display duration correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      const label = '30 min';
      bool selected = false;
      VoidCallback onTap = () {};

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DurationChip(label: label, selected: selected, onTap: onTap),
          ),
        ),
      );

      // Assert
      expect(find.text('30 min'), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('should show selected state', (WidgetTester tester) async {
      // Arrange
      const label = '60 min';
      bool selected = true;
      VoidCallback onTap = () {};

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DurationChip(label: label, selected: selected, onTap: onTap),
          ),
        ),
      );

      // Assert
      expect(find.text('60 min'), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (WidgetTester tester) async {
      // Arrange
      const label = '90 min';
      bool selected = false;
      bool onTapCalled = false;
      VoidCallback onTap = () {
        onTapCalled = true;
      };

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DurationChip(label: label, selected: selected, onTap: onTap),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Assert
      expect(onTapCalled, isTrue);
    });

    testWidgets('should handle different labels', (WidgetTester tester) async {
      // Test various labels
      final labels = ['15 min', '30 min', '60 min', '90 min', '120 min'];

      for (final label in labels) {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DurationChip(label: label, selected: false, onTap: () {}),
            ),
          ),
        );

        // Assert
        expect(find.text(label), findsOneWidget);
        await tester.pumpWidget(const SizedBox.shrink());
      }
    });
  });
}
