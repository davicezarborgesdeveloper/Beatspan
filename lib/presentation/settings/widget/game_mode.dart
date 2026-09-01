import 'package:flutter/material.dart';

class GameMode extends StatefulWidget {
  const GameMode({super.key, required this.isPremium,required this.onTap});
  final Function(int)? onTap;
  final bool isPremium;

  @override
  State<GameMode> createState() => _GameModeState();
}

class _GameModeState extends State<GameMode> {
  ValueNotifier<int> isTrackMode = ValueNotifier<int>(1);

  static const _selectedGradient = LinearGradient(
    colors: [Color(0XFF6C2BFF), Color(0XFFFF469E)],
    begin: AlignmentDirectional.bottomStart,
    end: AlignmentDirectional.topEnd,
  );

  Widget _cardBorder({required bool selected, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        gradient: selected ? _selectedGradient : null,
        color: selected ? null : Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0XFF110B1A),
          borderRadius: BorderRadius.circular(11.0),
        ),
        child: child,
      ),
    );
  }

  Widget buttonGameMode(bool selected) {
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
                gradient: _selectedGradient,
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
                  onTap: widget.isPremium?() {
                    isTrackMode.value = 0;
                    widget.onTap?.call(0);
                  }:null,
                  child: _cardBorder(
                    selected: trackMode == 0,
                    child: Container(
                      padding: EdgeInsets.all(24),
                      child: Row(
                        crossAxisAlignment:widget.isPremium ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                        // crossAxisAlignment: widget.isPremium?CrossAxisAlignment.center:CrossAxisAlignment.start,
                        children: [
                          widget.isPremium
                              ? buttonGameMode(trackMode == 0)
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
                    widget.onTap?.call(1);
                  },
                  child: _cardBorder(
                    selected: trackMode == 1,
                    child: Container(
                      padding: EdgeInsets.all(24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buttonGameMode(trackMode == 1),
                          SizedBox(width: 24),
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
