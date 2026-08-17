import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

/// Frequently asked questions screen.
///
/// A search field filters the FAQ list as the learner types; answers expand in
/// place so the page never leaves the current scroll position. Copy is static
/// product content — no backend endpoint is invented.
class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  static const List<({String question, String answer})> _faqs = [
    (
      question: 'Bagaimana cara mulai belajar?',
      answer:
          'Pilih course yang kamu minati dari halaman Explore, lalu tekan '
          'Mulai Course. Kamu bisa melanjutkan belajar kapan saja melalui '
          'tab Progress.',
    ),
    (
      question: 'Apakah course tersedia secara gratis?',
      answer:
          'Saat ini seluruh course dapat diakses untuk dipelajari. Ketentuan '
          'berbayar akan diumumkan melalui notifikasi resmi.',
    ),
    (
      question: 'Bagaimana cara mengubah tema aplikasi?',
      answer:
          'Buka Profil lalu pilih menu Tema. Kamu bisa memilih Terang, Gelap, '
          'atau Ikuti Sistem sesuai preferensi.',
    ),
    (
      question: 'Bagaimana cara memberikan masukan?',
      answer:
          'Kamu bisa mengirim masukan melalui menu Masukan & Saran di halaman '
          'Profil. Tim kami akan meninjaunya secara berkala.',
    ),
    (
      question: 'Apakah progress belajarku tersimpan?',
      answer:
          'Ya, progress dan riwayat belajarmu tersimpan di akun dan tampil di '
          'tab Progress setiap kali kamu membuka aplikasi.',
    ),
    (
      question: 'Bagaimana cara menghubungi mentor?',
      answer:
          'Gunakan menu Masukan & Saran dan pilih kategori Mentor. Tim kami '
          'akan menindaklanjuti pertanyaanmu.',
    ),
    (
      question: 'Apa yang harus dilakukan jika menemukan kendala teknis?',
      answer:
          'Tuliskan detail kendala melalui Masukan & Saran dengan kategori '
          'Aplikasi, atau hubungi kami melalui menu bantuan.',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final query = _query.trim().toLowerCase();
    final faqs = query.isEmpty
        ? _faqs
        : [
            for (final faq in _faqs)
              if (faq.question.toLowerCase().contains(query) ||
                  faq.answer.toLowerCase().contains(query))
                faq,
          ];

    return Scaffold(
      backgroundColor: ext.background,
      appBar: const AppAppBar(title: 'Pusat Bantuan'),
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
                'Temukan jawaban atas pertanyaan yang sering diajukan.',
                style: AppTypeScale.bodyMedium.copyWith(
                  color: ext.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppSearchField(
                controller: _searchController,
                hint: 'Cari pertanyaan...',
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (faqs.isEmpty)
                const AppEmptyState(
                  compact: true,
                  icon: Icons.search_off_rounded,
                  title: 'Tidak Ditemukan',
                  message:
                      'Belum ada pertanyaan yang cocok dengan pencarianmu.',
                )
              else
                AppBaseCard(
                  padding: EdgeInsets.zero,
                  elevation: AppElevation.flat,
                  radius: AppRadius.large,
                  borderSide: BorderSide(color: ext.border),
                  child: Column(
                    children: [
                      for (var i = 0; i < faqs.length; i++) ...[
                        if (i > 0) const AppDivider(height: 1),
                        _FaqTile(
                          question: faqs[i].question,
                          answer: faqs[i].answer,
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One expandable question and answer row.
class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        childrenPadding: const EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: AppSpacing.md,
        ),
        iconColor: ext.textSecondary,
        collapsedIconColor: ext.textSecondary,
        title: Text(
          question,
          style: AppTypeScale.bodyMedium.copyWith(
            color: ext.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: AppTypeScale.bodyMedium.copyWith(
                color: ext.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
