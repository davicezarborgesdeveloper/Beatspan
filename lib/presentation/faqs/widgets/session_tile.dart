import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../domain/model/faqs.dart';
import '../../resource/color_manager.dart';
import '../../resource/font_manager.dart';
import '../../resource/style_manager.dart';
import '../../resource/value_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class SessionTile extends StatefulWidget {
  final Session s;
  const SessionTile(this.s, {super.key});

  @override
  State<SessionTile> createState() => _SessionTileState();
}

class _SessionTileState extends State<SessionTile> {
  final isOpen = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppPadding.p32),
      child: ExpansionTile(
        shape: const Border(),
        iconColor: ColorManager.primary,
        trailing: ValueListenableBuilder(
          valueListenable: isOpen,
          builder: (context, isOpen, value) => AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) =>
                FadeTransition(opacity: anim, child: child),
            child: isOpen
                ? const Icon(Icons.remove_circle_outline)
                : const Icon(Icons.add_circle_outline),
          ),
        ),
        onExpansionChanged: (v) => isOpen.value = v,
        title: ValueListenableBuilder(
          valueListenable: isOpen,
          builder: (context, isOpen, value) => Text(
            widget.s.title ?? '',
            style: getMediumStyle(
              color: isOpen ? ColorManager.primary : ColorManager.white,
              fontSize: FontSize.s20,
            ),
          ),
        ),
        children: [
          getContent(
            widget.s.content ?? '',
          ),
        ],
      ),
    );
  }

  Widget getContent(String content) {
    // Novo padrão Markdown-like: [texto](alvo)
    final regex = RegExp(r'\[([^\]]*)\]\(([^)]+)\)');
    final spans = <TextSpan>[];
    int lastIndex = 0;

    for (final match in regex.allMatches(content)) {
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: content.substring(lastIndex, match.start),
            style: getRegularStyle(color: ColorManager.white, fontSize: 14),
          ),
        );
      }

      final linkText = match.group(1) ?? '';
      final target = match.group(2) ?? '';

      final displayText = linkText.isEmpty ? target : linkText;

      final isInternal = target.startsWith('@');
      final isExternal = target.startsWith('http');

      spans.add(
        TextSpan(
          text: displayText,
          style: getRegularStyle(
            color: ColorManager.yellowLink,
            fontSize: 14,
          ).copyWith(
            decoration:
                isExternal ? TextDecoration.underline : TextDecoration.none,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              if (isExternal) {
                final uri = Uri.parse(target);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              } else if (isInternal) {
                final route = target.substring(1);
                if (context.mounted) {
                  Navigator.pushNamed(context, '/$route');
                }
              } else {
                debugPrint('Formato de link não reconhecido: $target');
              }
            },
        ),
      );

      lastIndex = match.end;
    }

    // Texto final (sem links)
    if (lastIndex < content.length) {
      spans.add(
        TextSpan(
          text: content.substring(lastIndex),
          style: getRegularStyle(color: ColorManager.white, fontSize: 14),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: RichText(text: TextSpan(children: spans)),
    );
  }
}
