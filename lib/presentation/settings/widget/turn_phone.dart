import 'package:flutter/material.dart';

class TurnPhone extends StatefulWidget {
  const TurnPhone({super.key});

  @override
  State<TurnPhone> createState() => _TurnPhoneState();
}

class _TurnPhoneState extends State<TurnPhone> {
  ValueNotifier<bool> isTurnPhoneEnabled = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isTurnPhoneEnabled,
      builder: (context, turnPhoneEnabled, _) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color(0XFF110B1A),
                border: Border.all(
                  width: 1,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                borderRadius:turnPhoneEnabled? BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ):BorderRadius.all(Radius.circular(12.0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Usar Vire o Telefone',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Color(0XFFF8F7FC),
                          ),
                        ),
                        Text(
                          'Após escanear uma carta, coloque o dispositivo virado para baixo. Isso oculta detalhes da faixa e mantém o jogo justo.',
                          style: TextStyle(color: Color(0XFFA9A2B5)),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(value: isTurnPhoneEnabled.value, onChanged: (value) {
                    isTurnPhoneEnabled.value = value;
                  }),
                ],
              ),
            ),
            Visibility(
              visible: turnPhoneEnabled,
              child: Column(
                children: [
                  SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Color(0XFF110B1A),
                      border: Border.all(
                        width: 1,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Usar Giroscópio',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Color(0XFFF8F7FC),
                                ),
                              ),
                              Text(
                                'A faixa começa a tocar quando você vira o telefone.',
                                style: TextStyle(color: Color(0XFFA9A2B5)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Color(0XFF110B1A),
                      border: Border.all(
                        width: 1,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Usar Contagem Regressiva',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Color(0XFFF8F7FC),
                                ),
                              ),
                              Text(
                                'A faixa começa a tocar quando você vira o telefone.',
                                style: TextStyle(color: Color(0XFFA9A2B5)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
