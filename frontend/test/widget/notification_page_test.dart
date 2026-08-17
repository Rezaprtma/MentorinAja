import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/course/course.dart';
import 'package:frontend/features/notifications/notifications.dart';
import 'package:frontend/shared/design_system/design_system.dart';

/// Repository returning an empty feed, used to exercise the empty state.
class _EmptyNotificationRepository implements NotificationRepository {
  @override
  List<AppNotification> fetch() => const [];
}

/// Repository returning only study reminders, used to exercise the per-filter
/// empty state when a non-matching category is selected.
class _ReminderOnlyRepository implements NotificationRepository {
  @override
  List<AppNotification> fetch() => [
    AppNotification(
      id: 'reminder-1',
      kind: AppNotificationKind.reminder,
      title: 'Jangan lupa lanjutkan belajar hari ini',
      message: 'Satu sesi belajar singkat membuat kamu makin konsisten.',
      createdAt: DateTime.now(),
      isRead: false,
    ),
  ];
}

Widget _buildApp({NotificationController? controller}) {
  return MaterialApp(
    theme: AppTheme.light(),
    onGenerateRoute: (settings) {
      final name = settings.name ?? '';
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => name.startsWith('/course/')
            ? const CourseDetailPage(courseId: 'dasar-python')
            : const SizedBox.shrink(),
      );
    },
    home: NotificationPage(controller: controller),
  );
}

void _setSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('renders grouped feed with unread and read items', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    final controller = NotificationController();
    await tester.pumpWidget(_buildApp(controller: controller));
    await tester.pump();

    expect(find.text('Notifikasi'), findsOneWidget);
    expect(find.text('Hari Ini'), findsOneWidget);
    expect(find.text('Course Python Dasar diperbarui'), findsOneWidget);
    expect(find.text('Pelajaran berikutnya sudah siap'), findsOneWidget);
    expect(find.text('Kemarin'), findsWidgets);
    expect(find.text('Progress belajar kamu mencapai 75%'), findsOneWidget);
    expect(find.text('Minggu Ini'), findsOneWidget);
    expect(find.text('Sebelumnya'), findsOneWidget);
    expect(controller.unreadCount, 3);
    expect(tester.takeException(), isNull);
  });

  testWidgets('mark all read clears the unread badge and disables the action', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    final controller = NotificationController();
    await tester.pumpWidget(_buildApp(controller: controller));
    await tester.pump();

    await tester.tap(find.byTooltip('Filter Notifikasi'));
    await tester.pumpAndSettle();

    await tester.drag(
      find.byType(SingleChildScrollView).last,
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tandai Semua Dibaca'));
    await tester.pumpAndSettle();

    expect(controller.unreadCount, 0);

    await tester.tap(find.byTooltip('Filter Notifikasi'));
    await tester.pumpAndSettle();
    final tile = tester.widget<ListTile>(
      find.ancestor(
        of: find.text('Tandai Semua Dibaca'),
        matching: find.byType(ListTile),
      ),
    );
    expect(tile.enabled, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping an unread notification marks it read', (tester) async {
    _setSurface(tester, const Size(390, 844));
    final controller = NotificationController();
    await tester.pumpWidget(_buildApp(controller: controller));
    await tester.pump();

    await tester.tap(find.text('Course Python Dasar diperbarui'));
    await tester.pumpAndSettle();

    expect(controller.unreadCount, 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping an actionable notification opens the course page', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    final controller = NotificationController();
    await tester.pumpWidget(_buildApp(controller: controller));
    await tester.pump();

    await tester.tap(find.text('Course Python Dasar diperbarui'));
    await tester.pumpAndSettle();

    expect(find.byType(CourseDetailPage), findsOneWidget);
    expect(find.text('Dasar Python'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders the empty state when there are no notifications', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    final controller = NotificationController(
      repository: _EmptyNotificationRepository(),
    );
    await tester.pumpWidget(_buildApp(controller: controller));
    await tester.pump();

    expect(find.text('Belum Ada Notifikasi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens the notification filter action sheet', (tester) async {
    _setSurface(tester, const Size(390, 844));
    final controller = NotificationController();
    await tester.pumpWidget(_buildApp(controller: controller));
    await tester.pump();

    expect(find.byTooltip('Filter Notifikasi'), findsOneWidget);

    await tester.tap(find.byTooltip('Filter Notifikasi'));
    await tester.pumpAndSettle();

    expect(find.text('Atur Notifikasi'), findsOneWidget);
    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Belajar'), findsOneWidget);
    expect(find.text('Course'), findsOneWidget);
    expect(find.text('Pengingat'), findsOneWidget);
    expect(find.text('Hanya Belum Dibaca'), findsOneWidget);
    expect(find.text('Tandai Semua Dibaca'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('filtering by Belajar shows only study notifications', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    final controller = NotificationController();
    await tester.pumpWidget(_buildApp(controller: controller));
    await tester.pump();

    await tester.tap(find.byTooltip('Filter Notifikasi'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Belajar'));
    await tester.pumpAndSettle();

    expect(find.text('Pelajaran berikutnya sudah siap'), findsOneWidget);
    expect(find.text('Progress belajar kamu mencapai 75%'), findsOneWidget);
    expect(find.text('Progress belajar kamu mencapai 50%'), findsOneWidget);
    expect(find.text('Course Python Dasar diperbarui'), findsNothing);
    expect(find.text('Course baru tersedia'), findsNothing);
    expect(find.text('Jangan lupa lanjutkan belajar hari ini'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('filtering by Course shows only catalog notifications', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    final controller = NotificationController();
    await tester.pumpWidget(_buildApp(controller: controller));
    await tester.pump();

    await tester.tap(find.byTooltip('Filter Notifikasi'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Course'));
    await tester.pumpAndSettle();

    expect(find.text('Course Python Dasar diperbarui'), findsOneWidget);
    expect(find.text('Laravel untuk Pemula diperbarui'), findsOneWidget);
    expect(find.text('Course baru tersedia'), findsNWidgets(2));
    expect(find.text('Pelajaran berikutnya sudah siap'), findsNothing);
    expect(find.text('Jangan lupa lanjutkan belajar hari ini'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a filter with no matches shows its own empty state', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    final controller = NotificationController(
      repository: _ReminderOnlyRepository(),
    );
    await tester.pumpWidget(_buildApp(controller: controller));
    await tester.pump();

    expect(find.text('Jangan lupa lanjutkan belajar hari ini'), findsOneWidget);

    await tester.tap(find.byTooltip('Filter Notifikasi'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Course'));
    await tester.pumpAndSettle();

    expect(find.text('Tidak Ada Notifikasi'), findsOneWidget);
    expect(find.text('Jangan lupa lanjutkan belajar hari ini'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adapts to narrow phones and tablets without overflow', (
    tester,
  ) async {
    _setSurface(tester, const Size(320, 640));
    await tester.pumpWidget(_buildApp());
    await tester.pump();
    expect(find.text('Notifikasi'), findsOneWidget);
    expect(tester.takeException(), isNull);

    _setSurface(tester, const Size(1024, 1366));
    await tester.pumpWidget(_buildApp());
    await tester.pump();
    expect(find.text('Notifikasi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adapts to 360 and 430 widths without overflow', (tester) async {
    _setSurface(tester, const Size(360, 800));
    await tester.pumpWidget(_buildApp());
    await tester.pump();
    expect(find.text('Notifikasi'), findsOneWidget);
    expect(tester.takeException(), isNull);

    _setSurface(tester, const Size(430, 932));
    await tester.pumpWidget(_buildApp());
    await tester.pump();
    expect(find.text('Notifikasi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('supports large text scale without overflow', (tester) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2.0)),
          child: child!,
        ),
        home: const NotificationPage(),
      ),
    );
    await tester.pump();

    expect(find.text('Notifikasi'), findsOneWidget);
    expect(find.byTooltip('Filter Notifikasi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
