import 'package:flutter/material.dart';
import 'package:practice/provider/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:practice/l10n/l10n.dart';

class LanguagePickerWidget extends StatelessWidget {
  const LanguagePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context);
    final locale = provider.locale;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Locale>(
            value: locale,
            icon: const Icon(Icons.language, color: Colors.blue),
            items: L10n.all.map((locale) {
              final flag = _getFlag(locale.languageCode);
              final name = L10n.getCountry(locale.languageCode);

              return DropdownMenuItem(
                value: locale,
                child: Row(
                  children: [
                    Text(flag, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    Text(name, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              );
            }).toList(),
            onChanged: (locale) {
              if (locale != null) {
                provider.setLocale(locale); // 🔥 đổi ngôn ngữ ngay
              }
            },
          ),
        ),
      ),
    );
  }

  String _getFlag(String code) {
    switch (code) {
      case 'en':
        return '🇺🇸';
      case 'fr':
        return '🇫🇷';
      case 'ja':
        return '🇯🇵';
      case 'ch':
        return '🇨🇳';
      case 'vi':
        return '🇻🇳';
      default:
        return '🌐';
    }
  }
}
