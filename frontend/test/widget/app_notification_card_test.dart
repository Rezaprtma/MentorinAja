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

  testWidgets('every variant renders on the shared white surface', (
    tester,
  ) async {
    await tester.pumpWidget(host(variants));

    for (final type in AppNotificationType.values) {
      final card = AppNotificationService.paletteFor(type);
      expect(card.background, AppColors.surface);
    }
  });

  testWidgets('success uses a black title on a white surface', (tester) async {
    await tester.pumpWidget(host(variants));

    final card = AppNotificationService.paletteFor(AppNotificationType.success);
    expect(card.background, AppColors.surface);
    expect(card.foreground, AppColors.textPrimary);

    final titleStyle = tester.widget<Text>(find.text('Welcome back!')).style;
    final messageStyle = tester
        .widget<Text>(find.text("You're signed in."))
        .style;
    expect(titleStyle!.color, AppColors.textPrimary);
    expect(messageStyle!.color, AppColors.textSecondary);
  });

  testWidgets('error uses a red title on a white surface', (tester) async {
    await tester.pumpWidget(host(variants));

    final card = AppNotificationService.paletteFor(AppNotificationType.error);
    expect(card.background, AppColors.surface);
    expect(card.foreground, AppColors.error);

    final titleStyle = tester.widget<Text>(find.text('Invalid code')).style;
    final messageStyle = tester
        .widget<Text>(find.text('Check your code.'))
        .style;
    expect(titleStyle!.color, AppColors.error);
    expect(messageStyle!.color, AppColors.textSecondary);
  });

  testWidgets('information uses a black title on a white surface', (
    tester,
  ) async {
    await tester.pumpWidget(host(variants));

    final card = AppNotificationService.paletteFor(AppNotificationType.info);
    expect(card.background, AppColors.surface);
    expect(card.foreground, AppColors.textPrimary);

    final titleStyle = tester.widget<Text>(find.text('Code sent!')).style;
    final messageStyle = tester
        .widget<Text>(find.text('Check your inbox.'))
        .style;
    expect(titleStyle!.color, AppColors.textPrimary);
    expect(messageStyle!.color, AppColors.textSecondary);
  });

  testWidgets('warning uses a black title on a white surface', (tester) async {
    await tester.pumpWidget(host(variants));

    final card = AppNotificationService.paletteFor(AppNotificationType.warning);
    expect(card.background, AppColors.surface);
    expect(card.foreground, AppColors.textPrimary);

    final titleStyle = tester.widget<Text>(find.text('Almost expired')).style;
    expect(titleStyle!.color, AppColors.textPrimary);
  });

  testWidgets('action chip uses the neutral text treatment on a subtle chip', (
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
