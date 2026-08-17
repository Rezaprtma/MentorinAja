import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../widgets/document_section_list.dart';

/// Privacy policy screen with structured, readable sections.
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static const List<DocumentSection> _sections = [
    (
      heading: 'Data yang Kami Kumpulkan',
      paragraphs: [
        'Kami mengumpulkan data yang kamu berikan saat mendaftar, seperti '
            'nama, alamat email, dan preferensi belajar.',
        'Data penggunaan aplikasi digunakan untuk menyesuaikan rekomendasi '
            'course dan meningkatkan kualitas layanan.',
      ],
    ),
    (
      heading: 'Penggunaan Data',
      paragraphs: [
        'Data kamu digunakan untuk menampilkan progress belajar, memberikan '
            'rekomendasi course, dan mengirimkan notifikasi yang relevan.',
        'Kami tidak menjual data pribadimu kepada pihak ketiga.',
      ],
    ),
    (
      heading: 'Keamanan Data',
      paragraphs: [
        'Data disimpan dengan standar keamanan yang memadai dan hanya diakses '
            'oleh pihak yang berwenang.',
        'Jika kamu menemukan celah keamanan, segera hubungi kami melalui '
            'menu Masukan & Saran.',
      ],
    ),
    (
      heading: 'Hak Pengguna',
      paragraphs: [
        'Kamu dapat meminta akses, perbaikan, atau penghapusan data pribadimu '
            'kapan saja.',
        'Perubahan kebijakan privasi akan diumumkan melalui notifikasi resmi.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Scaffold(
      backgroundColor: ext.background,
      appBar: const AppAppBar(title: 'Kebijakan Privasi'),
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
