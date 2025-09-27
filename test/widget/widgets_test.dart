import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:breakly/widgets/duration_chip.dart';
import 'package:breakly/widgets/add_duration_chip.dart';
import 'package:breakly/widgets/clear_chip.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('DurationChip debería mostrar duración correctamente', (
      WidgetTester tester,
    ) async {
      // Arrange
      const label = '30m';
      bool isSelected = false;
      void onTap() => isSelected = true;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DurationChip(
              label: label,
              selected: isSelected,
              onTap: onTap,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('30m'), findsOneWidget);
      expect(find.byType(DurationChip), findsOneWidget);
    });

    testWidgets('DurationChip debería responder al tap', (
      WidgetTester tester,
    ) async {
      // Arrange
      const label = '60m';
      bool isSelected = false;
      void onTap() => isSelected = true;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DurationChip(
              label: label,
              selected: isSelected,
              onTap: onTap,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DurationChip));
      await tester.pump();

      // Assert
      expect(find.text('60m'), findsOneWidget);
    });

    testWidgets('AddDurationChip debería renderizarse correctamente', (
      WidgetTester tester,
    ) async {
      // Arrange
      Future<void> onAdd() async {}

      // Act
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: AddDurationChip(onAdd: onAdd))),
      );

      // Assert
      expect(find.byType(AddDurationChip), findsOneWidget);
    });

    testWidgets('ClearChip debería renderizarse correctamente', (
      WidgetTester tester,
    ) async {
      // Arrange
      Future<void> onClear() async {}

      // Act
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ClearChip(onClear: onClear))),
      );

      // Assert
      expect(find.byType(ClearChip), findsOneWidget);
    });
  });
}
