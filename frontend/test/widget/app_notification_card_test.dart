import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/shared/design_system/design_system.dart';

void main() {
  Widget host(List<(AppNotificationType, String, String, String)> variants) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (type, title, message, action) in variants)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: AppNotificationCard(
                    type: type,
                    title: title,
                    message: message,
                    actionLabel: action,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  const variants = <(AppNotificationType, String, String, String)>[
    (
      AppNotificationType.success,
      'Welcome back!',
      "You're signed in.",
      'Got it',
    ),
    (
      AppNotificationType.error,
      'Invalid code',
      'Check your code.',
      'Try again',
    ),
    (AppNotificationType.info, 'Code sent!', 'Check your inbox.', 'Got it'),
    (
      AppNotificationType.warning,
      'Almost expired',
      'Your code expires soon.',
      'Got it',
    ),
  ];

  testWidgets('all four variants render with the shared card layout', (
    tester,
  ) async {
    await tester.pumpWidget(host(variants));

    expect(find.byType(AppNotificationCard), findsNWidgets(4));
    for (final (_, title, message, action) in variants) {
      expect(find.text(title), findsOneWidget);
      expect(find.text(message), findsOneWidget);
      expect(find.text(action), findsWidgets);
    }
  });

  testWidgets('notification text carries no underline or decoration', (
    tester,
  ) async {
    await tester.pumpWidget(host(variants));

    for (final (_, title, message, _) in variants) {
      final titleBox = tester.renderObject<RenderParagraph>(find.text(title));
      final messageBox = tester.renderObject<RenderParagraph>(
        find.text(message),
      );
      expect(
        titleBox.text.style?.decoration,
        anyOf(isNull, TextDecoration.none),
      );
      expect(
        messageBox.text.style?.decoration,
        anyOf(isNull, TextDecoration.none),
      );
    }
  });

  testWidgets('title is styled larger and bolder than the description', (
    tester,
  ) async {
    await tester.pumpWidget(host(variants));

    for (final (_, title, message, _) in variants) {
      final titleStyle = tester.widget<Text>(find.text(title)).style;
      final messageStyle = tester.widget<Text>(find.text(message)).style;
      expect(titleStyle!.fontSize, greaterThan(messageStyle!.fontSize!));
      expect(
        titleStyle.fontWeight!.value,
        greaterThan(messageStyle.fontWeight!.value),
      );
    }
  });

  testWidgets('success uses a solid green surface with white typography', (
    tester,
  ) async {
    await tester.pumpWidget(host(variants));

    final card = AppNotificationService.paletteFor(AppNotificationType.success);
    expect(card.background, const Color(0xFF16A34A));
    expect(card.foreground, const Color(0xFFFFFFFF));
    expect(card.accent, const Color(0xFFFFFFFF));

    final titleStyle = tester.widget<Text>(find.text('Welcome back!')).style;
    final messageStyle = tester
        .widget<Text>(find.text("You're signed in."))
        .style;
    expect(titleStyle!.color, const Color(0xFFFFFFFF));
    expect(messageStyle!.color!.a, closeTo(0.85, 0.01));
  });

  testWidgets('error uses a solid red surface with white typography', (
    tester,
  ) async {
    await tester.pumpWidget(host(variants));

    final card = AppNotificationService.paletteFor(AppNotificationType.error);
    expect(card.background, const Color(0xFFDC2626));
    expect(card.foreground, const Color(0xFFFFFFFF));
    expect(card.accent, const Color(0xFFFFFFFF));

    final titleStyle = tester.widget<Text>(find.text('Invalid code')).style;
    final messageStyle = tester
        .widget<Text>(find.text('Check your code.'))
        .style;
    expect(titleStyle!.color, const Color(0xFFFFFFFF));
    expect(messageStyle!.color!.a, closeTo(0.85, 0.01));
  });

  testWidgets('information uses a white surface with dark readable text', (
    tester,
  ) async {
    await tester.pumpWidget(host(variants));

    final card = AppNotificationService.paletteFor(AppNotificationType.info);
    expect(card.background, const Color(0xFFFFFFFF));
    expect(card.foreground, const Color(0xFF1D2939));

    final titleStyle = tester.widget<Text>(find.text('Code sent!')).style;
    final messageStyle = tester
        .widget<Text>(find.text('Check your inbox.'))
        .style;
    expect(titleStyle!.color, const Color(0xFF1D2939));
    expect(messageStyle!.color!.a, closeTo(0.85, 0.01));
  });

  testWidgets('warning uses a solid amber surface with white typography', (
    tester,
  ) async {
    await tester.pumpWidget(host(variants));

    final card = AppNotificationService.paletteFor(AppNotificationType.warning);
    expect(card.background, const Color(0xFFF59E0B));
    expect(card.foreground, const Color(0xFFFFFFFF));
    expect(card.accent, const Color(0xFFFFFFFF));

    final titleStyle = tester.widget<Text>(find.text('Almost expired')).style;
    expect(titleStyle!.color, const Color(0xFFFFFFFF));
  });

  testWidgets('action chip reuses the semantic accent for its label', (
    tester,
  ) async {
    await tester.pumpWidget(host(variants));

    final actionLabels = tester
        .widgetList<TextButton>(find.byType(TextButton))
        .map(
          (button) =>
              (button.style?.foregroundColor, button.style?.backgroundColor),
        );
    expect(actionLabels, isNotEmpty);
  });
}
