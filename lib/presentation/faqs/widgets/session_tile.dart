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

  /// Lista de esquemas permitidos para URLs externas (whitelist)
  static const _allowedSchemes = ['http', 'https'];

  /// Valida se uma URL é segura para ser aberta
  bool _isSafeUrl(String urlString) {
    try {
      final uri = Uri.parse(urlString);

      // 1. Verifica se o esquema é permitido (http/https apenas)
      if (!_allowedSchemes.contains(uri.scheme.toLowerCase())) {
        debugPrint('⚠️ URL rejeitada: esquema não permitido "${uri.scheme}"');
        return false;
      }

      // 2. Verifica se tem um host válido
      if (uri.host.isEmpty) {
        debugPrint('⚠️ URL rejeitada: host vazio');
        return false;
      }

      // 3. Bloqueia IPs privados (localhost, LAN)
      if (_isPrivateIp(uri.host)) {
        debugPrint('⚠️ URL rejeitada: IP privado/localhost "${uri.host}"');
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('⚠️ URL rejeitada: erro ao parsear "$urlString" - $e');
      return false;
    }
  }

  /// Verifica se é um IP privado ou localhost
  bool _isPrivateIp(String host) {
    // Localhost
    if (host == 'localhost' || host == '127.0.0.1' || host == '::1') {
      return true;
    }

    // IPs privados comuns
    final privateRanges = [
      RegExp(r'^10\.'),           // 10.0.0.0/8
      RegExp(r'^172\.(1[6-9]|2[0-9]|3[0-1])\.'), // 172.16.0.0/12
      RegExp(r'^192\.168\.'),     // 192.168.0.0/16
      RegExp(r'^169\.254\.'),     // Link-local
      RegExp(r'^fc00:'),          // IPv6 unique local
      RegExp(r'^fe80:'),          // IPv6 link-local
    ];

    return privateRanges.any((regex) => regex.hasMatch(host));
  }

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
                // ✅ Sanitização de URL: valida antes de abrir
                if (!_isSafeUrl(target)) {
                  debugPrint('🚫 URL bloqueada por segurança: $target');
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Link não permitido por motivos de segurança'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                  return;
                }

                try {
                  final uri = Uri.parse(target);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    debugPrint('⚠️ Não foi possível abrir o link: $target');
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Não foi possível abrir o link'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                } catch (e) {
                  debugPrint('❌ Erro ao abrir link: $target - $e');
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Erro ao abrir o link'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              } else if (isInternal) {
                final route = target.substring(1);
                if (mounted) {
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
