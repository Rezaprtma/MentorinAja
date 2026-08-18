//**
// frontend/features/notifications/presentation/pages/notification_page.dart
//
// frontend:
// Screen/page. Menampilkan UI dan menerima user interactions.
//
// backend:
// Future: akan membutuhkan backend data dan API calls.
//
// api:
// Future: akan melakukan API calls melalui controllers/repositories.
//
// qa:
// QA perlu memvalidasi UI rendering, user interactions, dan navigation.
//**
import 'package:flutter/material.dart';

import 'package:frontend/routing/route_names.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../domain/entities/app_notification.dart';
import '../../application/notification_controller.dart';
import '../widgets/notification_list_item.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key, this.controller});

  final NotificationController? controller;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NotificationController get _notifications =>
      widget.controller ?? NotificationController.instance;

  NotificationCategory? _filter;
  bool _onlyUnread = false;

  @override
  void initState() {
    super.initState();
    _notifications.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final notifications = _notifications;

    return Scaffold(
      backgroundColor: ext.background,
      appBar: AppAppBar(
        title: 'Notifikasi',
        actions: [
          AppIconButton(
            icon: Icons.tune_rounded,
            tooltip: 'Filter Notifikasi',
            onPressed: () => _showNotificationActions(context),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: notifications,
        builder: (context, _) {
          final items = notifications.items;
          if (items.isEmpty) {
            return const AppEmptyState(
              icon: Icons.notifications_none_rounded,
              title: 'Belum Ada Notifikasi',
              message:
                  'Notifikasi tentang course, progress dan kabar terbaru akan '
                  'muncul di sini.',
            );
          }

          final filtered = _filtered(items);

          return filtered.isEmpty
              ? AppEmptyState(
                  compact: true,
                  icon: Icons.filter_alt_off_outlined,
                  title: 'Tidak Ada Notifikasi',
                  message: _emptyFilterMessage,
                )
              : Scrollbar(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                    children: [
                      ResponsiveContainer(
                        maxWidth: 640,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsivePadding.horizontal(context),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final group in _group(filtered)) ...[
                              AppSectionHeader(
                                title: group.label,
                                padding: const EdgeInsets.only(
                                  top: AppSpacing.lg,
                                  bottom: AppSpacing.xs,
                                ),
                              ),
                              AppBaseCard(
                                padding: EdgeInsets.zero,
                                elevation: AppElevation.flat,
                                radius: AppRadius.large,
                                borderSide: BorderSide(color: ext.border),
                                child: Column(
                                  children: [
                                    for (var i = 0; i < group.items.length; i++)
                                      NotificationListItem(
                                        notification: group.items[i],
                                        isLast: i == group.items.length - 1,
                                        onTap: () =>
                                            _onTap(context, group.items[i]),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  List<AppNotification> _filtered(List<AppNotification> items) {
    return items.where((item) {
      final categoryMatch = _filter == null || item.kind.category == _filter;
      final unreadMatch = !_onlyUnread || !item.isRead;
      return categoryMatch && unreadMatch;
    }).toList();
  }

  String get _emptyFilterMessage {
    if (_onlyUnread && _filter == null) {
      return 'Semua notifikasi sudah dibaca.';
    }
    final label = _filter?.label.toLowerCase() ?? 'yang sesuai filter';
    return 'Belum ada notifikasi $label untuk kamu.';
  }

  void _showNotificationActions(BuildContext context) {
    AppBottomSheet.show<void>(
      context,
      title: 'Atur Notifikasi',
      subtitle: 'Pilih kategori dan tindakan feed.',
      child: _NotificationActionSheet(
        selected: _filter,
        onlyUnread: _onlyUnread,
        hasUnread: _notifications.unreadCount > 0,
        onSelected: (category) {
          setState(() => _filter = category);
          Navigator.of(context).maybePop();
        },
        onOnlyUnreadChanged: (value) {
          setState(() => _onlyUnread = value);
        },
        onMarkAllRead: () {
          _notifications.markAllRead();
          Navigator.of(context).maybePop();
        },
      ),
    );
  }

  void _onTap(BuildContext context, AppNotification notification) {
    final controller = _notifications;
    if (!notification.isRead) controller.markRead(notification.id);

    final courseId = notification.courseId;
    if (courseId == null) return;

    Navigator.of(context).pushNamed(
      AppRoutes.resolve(AppRoutes.courseDetail, {'courseId': courseId}),
    );
  }

  static List<_NotificationGroup> _group(List<AppNotification> items) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final buckets = <String, List<AppNotification>>{
      'Hari Ini': [],
      'Kemarin': [],
      'Minggu Ini': [],
      'Sebelumnya': [],
    };

    for (final item in items) {
      final created = item.createdAt;
      final day = DateTime(created.year, created.month, created.day);

      if (day == today) {
        buckets['Hari Ini']!.add(item);
      } else if (day == yesterday) {
        buckets['Kemarin']!.add(item);
      } else if (now.difference(created).inDays < 7) {
        buckets['Minggu Ini']!.add(item);
      } else {
        buckets['Sebelumnya']!.add(item);
      }
    }

    return [
      for (final entry in buckets.entries)
        if (entry.value.isNotEmpty)
          _NotificationGroup(label: entry.key, items: entry.value),
    ];
  }
}

class _NotificationGroup {
  const _NotificationGroup({required this.label, required this.items});

  final String label;
  final List<AppNotification> items;
}

class _NotificationActionSheet extends StatefulWidget {
  const _NotificationActionSheet({
    required this.selected,
    required this.onlyUnread,
    required this.hasUnread,
    required this.onSelected,
    required this.onOnlyUnreadChanged,
    required this.onMarkAllRead,
  });

  final NotificationCategory? selected;
  final bool onlyUnread;
  final bool hasUnread;
  final ValueChanged<NotificationCategory?> onSelected;
  final ValueChanged<bool> onOnlyUnreadChanged;
  final VoidCallback onMarkAllRead;

  @override
  State<_NotificationActionSheet> createState() =>
      _NotificationActionSheetState();
}

class _NotificationActionSheetState extends State<_NotificationActionSheet> {
  late bool _onlyUnread;

  @override
  void initState() {
    super.initState();
    _onlyUnread = widget.onlyUnread;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FilterOption(
            label: 'Semua',
            icon: Icons.notifications_none_rounded,
            selected: widget.selected == null,
            onTap: () => widget.onSelected(null),
          ),
          for (final category in NotificationCategory.values)
            _FilterOption(
              label: category.label,
              icon: _iconFor(category),
              selected: widget.selected == category,
              onTap: () => widget.onSelected(category),
            ),
          const AppDivider(height: AppSpacing.lg),
          SwitchListTile.adaptive(
            value: _onlyUnread,
            onChanged: (value) {
              setState(() => _onlyUnread = value);
              widget.onOnlyUnreadChanged(value);
            },
            title: const Text('Hanya Belum Dibaca'),
            contentPadding: EdgeInsets.zero,
          ),
          ListTile(
            enabled: widget.hasUnread,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.done_all_rounded),
            title: const Text('Tandai Semua Dibaca'),
            onTap: widget.hasUnread ? widget.onMarkAllRead : null,
          ),
        ],
      ),
    );
  }

  IconData _iconFor(NotificationCategory category) => switch (category) {
    NotificationCategory.belajar => Icons.school_rounded,
    NotificationCategory.course => Icons.menu_book_rounded,
    NotificationCategory.pengingat => Icons.notifications_active_rounded,
  };
}

class _FilterOption extends StatelessWidget {
  const _FilterOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: selected ? scheme.primary : ext.textSecondary),
      title: Text(label),
      trailing: selected
          ? Icon(Icons.check_circle_rounded, color: scheme.primary)
          : null,
      onTap: onTap,
    );
  }
}
