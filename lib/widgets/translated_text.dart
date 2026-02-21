import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/language_provider.dart';

class TranslatedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TranslatedText(
      this.text, {
        Key? key,
        this.style,
        this.textAlign,
        this.maxLines,
        this.overflow,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().currentLanguageCode;

    // English = show as-is, no API call
    if (lang == 'en') {
      return Text(text, style: style, textAlign: textAlign,
          maxLines: maxLines, overflow: overflow);
    }

    return FutureBuilder<String>(
      future: context.read<LanguageProvider>().translate(text),
      builder: (context, snapshot) {
        return Text(
          snapshot.data ?? text, // shows English while loading
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
}