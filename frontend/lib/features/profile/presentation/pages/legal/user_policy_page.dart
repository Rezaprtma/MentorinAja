import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../widgets/document_section_list.dart';

/// User terms screen with structured, readable sections.
class UserPolicyPage extends StatelessWidget {
  const UserPolicyPage({super.key});

  static const List<DocumentSection> _sections = [
    (
      heading: 'Akun dan Penggunaan',
      paragraphs: [
        'Kamu bertanggung jawab menjaga kerahasiaan data akunmu dan seluruh '
            'aktivitas yang terjadi di dalamnya.',
        'Akun digunakan oleh satu orang pengguna dan tidak boleh dipindahtangankan.',
      ],
    ),
    (
      heading: 'Konten Course',
      paragraphs: [
        'Seluruh materi course adalah hak cipta MentorinAja dan mitra penyedia '
            'kontennya.',
        'Materi course hanya boleh digunakan untuk kepentingan belajar pribadi.',
      ],
    ),
    (
      heading: 'Perilaku Pengguna',
      paragraphs: [
        'Dilarang menyalahgunakan layanan, termasuk menyebarkan konten yang '
            'melanggar hukum atau merugikan pengguna lain.',
        'Pelanggaran dapat mengakibatkan penangguhan atau penghapusan akun.',
      ],
    ),
    (
      heading: 'Perubahan Ketentuan',
      paragraphs: [
        'Ketentuan pengguna dapat diperbarui seiring perkembangan layanan.',
        'Pemberitahuan perubahan akan disampaikan melalui notifikasi resmi.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Scaffold(
      backgroundColor: ext.background,
      appBar: const AppAppBar(title: 'Kebijakan Pengguna'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: AppSpacing.md,
          bottom: AppSpacing.xl,
        ),
        child: ResponsiveContainer(
          maxWidth: 640,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsivePadding.horizontal(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Terakhir diperbarui: Januari 2026',
                style: AppTypeScale.bodySmall.copyWith(color: ext.textDisabled),
              ),
              const SizedBox(height: AppSpacing.md),
              const DocumentSectionList(sections: _sections),
            ],
          ),
        ),
      ),
    );
  }
}
