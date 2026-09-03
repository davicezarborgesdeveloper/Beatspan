import 'package:flutter/material.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/enum/settings_enum.dart';
import 'card_border.dart';

class GameMode extends StatefulWidget {
  const GameMode({super.key, required this.isPremium, required this.onTap});
  final Function(int)? onTap;
  final bool isPremium;

  @override
  State<GameMode> createState() => _GameModeState();
}

class _GameModeState extends State<GameMode> {
  final AppPreferences _appPreferences = instance<AppPreferences>();

  late final ValueNotifier<int> isTrackMode = ValueNotifier<int>(
    _appPreferences.getGameMode() == GameModeType.fullTrack ? 0 : 1,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onTap?.call(isTrackMode.value);
    });
  }

  Widget buttonRadio(bool selected) {
    return Container(
      width: 24,
      height: 24,

      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 2, color: Color(0X80CDBDFF)),
      ),
      child: selected
          ? Container(
              margin: EdgeInsets.all(4),
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: kSelectedGradient,
              ),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Modo de jogo',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0XFFA9A2B5),
          ),
        ),
        SizedBox(height: 12),
        ValueListenableBuilder(
          valueListenable: isTrackMode,
          builder: (context, trackMode, child) {
            return Column(
              children: [
                GestureDetector(
                  onTap: widget.isPremium
                      ? () {
                          isTrackMode.value = 0;
                          _appPreferences.setGameMode(GameModeType.fullTrack);
                          widget.onTap?.call(0);
                        }
                      : null,
                  child: CardBorder(
                    selected: trackMode == 0,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: widget.isPremium
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.center,
                        // crossAxisAlignment: widget.isPremium?CrossAxisAlignment.center:CrossAxisAlignment.start,
                        children: [
                          widget.isPremium
                              ? buttonRadio(trackMode == 0)
                              : Text(
                                  'Indisponível',
                                  style: TextStyle(color: Color(0XFFA9A2B5)),
                                ),
                          SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Faixas Completas',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Color(0XFFF8F7FC),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Reproduza a faixa inteira desde o início. Requer Spotify Premium.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0XFFA9A2B5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    isTrackMode.value = 1;
                    _appPreferences.setGameMode(GameModeType.preview);
                    widget.onTap?.call(1);
                  },
                  child: CardBorder(
                    selected: trackMode == 1,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buttonRadio(trackMode == 1),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Pré-escuta de 30s',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Color(0XFFF8F7FC),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Reproduza pré-escutas de 30 segundos. Não requer Spotify Premium.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0XFFA9A2B5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
