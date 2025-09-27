import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breakly/widgets/clear_chip.dart';

void main() {
  group('ClearChip', () {
    testWidgets('should display clear icon', (WidgetTester tester) async {
      // Arrange
      Future<void> Function() onClear = () async {};

      // Act
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ClearChip(onClear: onClear))),
      );

      // Assert
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('should call onClear when tapped', (WidgetTester tester) async {
      // Arrange
      bool onClearCalled = false;
      Future<void> Function() onClear = () async {
        onClearCalled = true;
      };

      // Act
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ClearChip(onClear: onClear))),
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Assert
      expect(onClearCalled, isTrue);
    });

    testWidgets('should have correct styling', (WidgetTester tester) async {
      // Arrange
      Future<void> Function() onClear = () async {};

      // Act
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ClearChip(onClear: onClear))),
      );

      // Assert
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });
  });
}
