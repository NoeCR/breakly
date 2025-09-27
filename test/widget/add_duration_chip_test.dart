import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breakly/widgets/add_duration_chip.dart';

void main() {
  group('AddDurationChip', () {
    testWidgets('should display add text', (WidgetTester tester) async {
      // Arrange
      Future<void> Function() onAdd = () async {};

      // Act
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: AddDurationChip(onAdd: onAdd))),
      );

      // Assert
      expect(find.text('Add'), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('should call onAdd when tapped', (WidgetTester tester) async {
      // Arrange
      bool onAddCalled = false;
      Future<void> Function() onAdd = () async {
        onAddCalled = true;
      };

      // Act
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: AddDurationChip(onAdd: onAdd))),
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Assert
      expect(onAddCalled, isTrue);
    });

    testWidgets('should have correct styling', (WidgetTester tester) async {
      // Arrange
      Future<void> Function() onAdd = () async {};

      // Act
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: AddDurationChip(onAdd: onAdd))),
      );

      // Assert
      expect(find.text('Add'), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });
  });
}
