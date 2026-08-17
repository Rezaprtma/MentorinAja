import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/lesson/lesson.dart';
import 'package:frontend/shared/design_system/design_system.dart';

Widget _app(Widget child) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );
}

void _setSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  group('LessonContentBlockView', () {
    testWidgets('renders heading block with correct style', (tester) async {
      _setSurface(tester, const Size(390, 844));
      const block = LessonContentBlock(
        type: LessonContentBlockType.heading,
        text: 'Ini Judul',
      );

      await tester.pumpWidget(_app(const LessonContentBlockView(block: block)));
      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Ini Judul'));
      expect(text.style?.fontSize, AppTypeScale.titleLarge.fontSize);
      expect(text.style?.fontWeight, FontWeight.w700);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders subheading block with correct style', (tester) async {
      _setSurface(tester, const Size(390, 844));
      const block = LessonContentBlock(
        type: LessonContentBlockType.subheading,
        text: 'Ini Sub-Judul',
      );

      await tester.pumpWidget(_app(const LessonContentBlockView(block: block)));
      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Ini Sub-Judul'));
      expect(text.style?.fontSize, AppTypeScale.titleMedium.fontSize);
      expect(text.style?.fontWeight, FontWeight.w600);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders paragraph block with correct style', (tester) async {
      _setSurface(tester, const Size(390, 844));
      const block = LessonContentBlock(
        type: LessonContentBlockType.paragraph,
        text: 'Ini adalah paragraf.',
      );

      await tester.pumpWidget(_app(const LessonContentBlockView(block: block)));
      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Ini adalah paragraf.'));
      expect(text.style?.fontSize, AppTypeScale.bodyMedium.fontSize);
      expect(text.style?.height, 1.6);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders bullet list block correctly', (tester) async {
      _setSurface(tester, const Size(390, 844));
      const block = LessonContentBlock(
        type: LessonContentBlockType.bulletList,
        items: ['Poin 1', 'Poin 2'],
      );

      await tester.pumpWidget(_app(const LessonContentBlockView(block: block)));
      await tester.pumpAndSettle();

      expect(find.text('Poin 1'), findsOneWidget);
      expect(find.text('Poin 2'), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders numbered list block correctly', (tester) async {
      _setSurface(tester, const Size(390, 844));
      const block = LessonContentBlock(
        type: LessonContentBlockType.numberedList,
        items: ['Item 1', 'Item 2'],
      );

      await tester.pumpWidget(_app(const LessonContentBlockView(block: block)));
      await tester.pumpAndSettle();

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders checklist block correctly', (tester) async {
      _setSurface(tester, const Size(390, 844));
      const block = LessonContentBlock(
        type: LessonContentBlockType.checklist,
        items: ['Tugas 1', 'Tugas 2'],
      );

      await tester.pumpWidget(_app(const LessonContentBlockView(block: block)));
      await tester.pumpAndSettle();

      expect(find.text('Tugas 1'), findsOneWidget);
      expect(find.text('Tugas 2'), findsOneWidget);
      expect(
        find.byIcon(Icons.check_box_outline_blank_rounded),
        findsNWidgets(2),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders code block correctly', (tester) async {
      _setSurface(tester, const Size(390, 844));
      const block = LessonContentBlock(
        type: LessonContentBlockType.code,
        label: 'Dart',
        text: 'void main() {}',
      );

      await tester.pumpWidget(_app(const LessonContentBlockView(block: block)));
      await tester.pumpAndSettle();

      expect(find.byType(AppCodeBlock), findsOneWidget);
      expect(find.text('Dart'), findsOneWidget);
      expect(find.text('void main() {}'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders tip block correctly', (tester) async {
      _setSurface(tester, const Size(390, 844));
      const block = LessonContentBlock(
        type: LessonContentBlockType.tip,
        text: 'Ini adalah tip.',
      );

      await tester.pumpWidget(_app(const LessonContentBlockView(block: block)));
      await tester.pumpAndSettle();

      expect(find.text('Ini adalah tip.'), findsOneWidget);
      expect(find.byIcon(Icons.lightbulb_outline_rounded), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders warning block correctly', (tester) async {
      _setSurface(tester, const Size(390, 844));
      const block = LessonContentBlock(
        type: LessonContentBlockType.warning,
        text: 'Ini adalah peringatan.',
      );

      await tester.pumpWidget(_app(const LessonContentBlockView(block: block)));
      await tester.pumpAndSettle();

      expect(find.text('PERINGATAN'), findsOneWidget);
      expect(find.text('Ini adalah peringatan.'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders example block correctly', (tester) async {
      _setSurface(tester, const Size(390, 844));
      const block = LessonContentBlock(
        type: LessonContentBlockType.example,
        text: 'Ini adalah contoh.',
      );

      await tester.pumpWidget(_app(const LessonContentBlockView(block: block)));
      await tester.pumpAndSettle();

      expect(find.text('CONTOH'), findsOneWidget);
      expect(find.text('Ini adalah contoh.'), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome_outlined), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders summary block correctly', (tester) async {
      _setSurface(tester, const Size(390, 844));
      const block = LessonContentBlock(
        type: LessonContentBlockType.summary,
        text: 'Ini adalah rangkuman.',
      );

      await tester.pumpWidget(_app(const LessonContentBlockView(block: block)));
      await tester.pumpAndSettle();

      expect(find.text('RANGKUMAN'), findsOneWidget);
      expect(find.text('Ini adalah rangkuman.'), findsOneWidget);
      expect(find.byIcon(Icons.summarize_outlined), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders block with phase heading', (tester) async {
      _setSurface(tester, const Size(390, 844));
      const block = LessonContentBlock(
        type: LessonContentBlockType.paragraph,
        heading: 'FASE INI',
        text: 'Ini adalah paragraf.',
      );

      await tester.pumpWidget(_app(const LessonContentBlockView(block: block)));
      await tester.pumpAndSettle();

      expect(find.text('FASE INI'), findsOneWidget);
      expect(find.text('Ini adalah paragraf.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
