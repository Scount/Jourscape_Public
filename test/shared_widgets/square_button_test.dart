import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jourscape/core/design/shadow.dart';
import 'package:jourscape/shared_widgets/square_button.dart';

void main() {
  group('SquareButton', () {
    testWidgets('renders with icon and triggers onTap callback', (
      WidgetTester tester,
    ) async {
      bool tapped = false;
      final testIcon = Icons.add;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SquareButton(
              icon: testIcon,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      final squareButtonFinder = find.byType(SquareButton);
      final iconFinder = find.byIcon(testIcon);

      expect(iconFinder, findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.maxHeight, 50.0);
      expect(container.constraints?.maxWidth, 50.0);

      final boxDecoration = container.decoration as BoxDecoration;
      expect(boxDecoration.boxShadow, isNotEmpty);
      expect(boxDecoration.boxShadow, equals(shadow));

      expect(
        boxDecoration.borderRadius,
        const BorderRadius.all(Radius.circular(20)),
      );

      await tester.tap(squareButtonFinder);
      await tester.pumpAndSettle();

      expect(tapped, isTrue);

      final iconWidget = tester.widget<Icon>(iconFinder);
      expect(iconWidget.color, const Color(0xff064a59));
    });

    testWidgets('renders without an icon when icon is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: SquareButton(onTap: () {})),
        ),
      );

      final iconFinder = find.byType(Icon);

      expect(iconFinder, findsNothing);
      expect(find.byType(SquareButton), findsOneWidget);
    });

    testWidgets(
      'button is disabled when onTap is null (does not respond to taps)',
      (WidgetTester tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: SquareButton(icon: Icons.info)),
          ),
        );

        final squareButtonFinder = find.byType(SquareButton);

        await tester.tap(squareButtonFinder);
        await tester.pumpAndSettle();

        expect(tapped, isFalse);

        final inkWell = tester.widget<InkWell>(find.byType(InkWell));
        expect(inkWell.onTap, isNull);
      },
    );
  });
}
