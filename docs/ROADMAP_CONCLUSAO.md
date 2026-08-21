# Roadmap de Conclusão — Beatspan

**Projeto:** Beatspan (`br.com.dcbsys.beatspan`)
**Data:** 2026-08-21
**Versão do documento:** 1.0
**Escopo:** destravar o que já existe (P0) + implementar a lógica de jogo que hoje não existe (P1), até ter um jogo local jogável ponta a ponta.

> Consolida [ESTADO-ATUAL.md](ESTADO-ATUAL.md), [PROPOSTA-ROADMAP.md](PROPOSTA-ROADMAP.md) e os achados técnicos de [ARCHITECTURAL_REVIEW.md](ARCHITECTURAL_REVIEW.md) / [ACTION_PLAN.md](ACTION_PLAN.md) em uma sequência única de execução. Não repropõe stack nem redefine severidade — apenas ordena o trabalho.

---

## Como ler este roadmap

Cada fase tem um objetivo claro e uma condição de saída (o que precisa estar verdadeiro para passar pra próxima). Fases são sequenciais porque cada uma reduz o risco da seguinte — não pule a Fase 0 para "ir direto pro jogo", porque hoje o app trava antes de você conseguir testar qualquer mecânica nova (ver `SEC-002`/`ARQ-001` em `ARCHITECTURAL_REVIEW.md`).

Há **uma decisão de produto pendente e bloqueante** para a Fase 2 (lógica de jogo) — sinalizada explicitamente onde entra.

---

## Fase 0 — Destravar o que já existe

**Objetivo:** ter "escanear QR → tocar música" funcionando de ponta a ponta, em ambos os planos (Free e Premium), num dispositivo real, com um único padrão de navegação.

- [ ] **Configurar credenciais reais do Spotify** — remover os literais `'SEU_CLIENT_ID_AQUI'`/`'SEU_REDIRECT_URL_AQUI'` de `player_music_premium_view.dart` (achado `ARQ-001`) e fazer essa tela reusar a sessão já conectada via `SpotifyService`/DI, em vez de reconectar do zero.
- [ ] **Corrigir o redirect URI do Spotify** — hoje o código Dart usa `https://hitster-d8ac4.firebaseapp.com/` enquanto o `AndroidManifest.xml`/`build.gradle.kts` só capturam `spotify-sdk://auth` (achado `SEC-002`). Testar em dispositivo físico e alinhar os dois lados. **Isso é pré-requisito para testar qualquer coisa do plano Premium daqui pra frente.**
- [ ] **Reativar o fluxo Free** — `PlayerMusicFreeView` existe mas a navegação está comentada em `game_view.dart` (achado `ARQ-002`). Descomentar, conectar `just_audio` (já no pubspec, não usado) à `previewUrl` retornada por `SpotifyWebApi.getTrackPreviewUrl`.
- [ ] **Unificar navegação** — hoje `RouteGenerator` convive com `Navigator.push(MaterialPageRoute(...))` direto (usado em `home_view.dart` para `GameView`/`RulesView`, e em `scaffold_hitster.dart` para FAQ/settings via rota nomeada). Escolher um padrão só e migrar `GameView`, `RulesView`, `FaqsView` para entrar em `RouteGenerator` como as demais telas.
- [ ] **Corrigir bug de persistência** — `AppPreferences.setAppCountry` grava na chave errada (achado `ARQ-004`), uma linha, mas vale corrigir agora antes de esquecer.

**Condição de saída:** em um celular físico, dá pra abrir o app, escanear um QR real do Spotify, e ouvir a música tocando — testando os dois planos (Free com preview de 30s, Premium com o app Spotify) — sem cair em tela de erro por credencial ou navegação quebrada.

---

## ⚠️ Decisão de produto pendente (bloqueia a Fase 2)

Antes de escrever qualquer código de lógica de jogo, as seguintes perguntas precisam de resposta sua (não são technicamente resolvíveis por conta própria):

1. **Pontuação:** como funciona? Ponto por acertar a posição na timeline? Bônus por acertar também artista/título, como no Hitster físico original?
2. **Condição de vitória:** quantas cartas corretas (ou pontos) encerram a partida?
3. **Cartas físicas vs. digitais:** o app substitui totalmente o baralho físico (mostra o próprio QR na tela para ser escaneado por outro dispositivo, ou dispensa QR e já sabe a faixa) — ou sempre assume que existe um baralho impresso à parte que só o app "interpreta"?

`RulesView` (`lib/presentation/rules/rules_view.dart`) hoje está com o corpo de texto vazio (`const Column(children: [])` na linha 66) — as regras nunca foram escritas ali. Ela deveria virar a fonte da verdade assim que essas respostas existirem.

**Enquanto isso não é decidido, a Fase 2 abaixo não pode começar** — dá pra adiantar a Fase 1 (robustez) em paralelo, que não depende dessa decisão.

---

## Fase 1 — Robustez (pode rodar em paralelo à decisão acima)

**Objetivo:** ter uma rede de segurança mínima antes de adicionar a complexidade de um motor de jogo por cima do fluxo atual.

- [ ] **Testes unitários para `GameViewModel`** — `validate`, `extractTrackId`, `toSpotifyUri`, `isValidSpotifyLink` são funções puras, fáceis de testar e hoje sem nenhum teste (achado `OPS-001`).
- [ ] **Cobrir mais casos de erro em `GameErrorView`** — hoje só cobre QR inválido; faltam estados para falha de conexão, token expirado, faixa sem preview disponível.
- [ ] **Tratar o `catch` silencioso em `disconnect()`** (achado `OPS-002`) e adicionar timeout às chamadas HTTP (achado `OPS-003`/`SEC-004`).
- [ ] **Observabilidade mínima** — capturar exceptions não tratadas em uma ferramenta central (Crashlytics/Sentry), achado `OPS-004`. Importante porque a Fase 2 vai introduzir estado novo (timeline, rodadas) que é mais fácil de depurar com isso já no lugar.

**Condição de saída:** `GameViewModel` tem cobertura de teste; erros de rede/Spotify têm tela/feedback tratado, não só o caminho feliz.

---

## Fase 2 — Lógica de jogo (hoje inexistente)

> **Bloqueada até a decisão de produto da seção acima estar resolvida.**

**Objetivo:** transformar "escanear → tocar música" em um jogo de verdade, com posicionamento cronológico de cartas — a mecânica central do Hitster.

- [ ] **Modelo de domínio:** `Player`, `Card` (ano + faixa + artista, resolvido a partir da faixa do Spotify), `Round`, `Timeline` (sequência de cartas que cada jogador posiciona em ordem cronológica).
  - Onde a metadata de ano/artista vem: a Web API do Spotify (`SpotifyWebApi`, hoje só usada para `getTrackPreviewUrl`) provavelmente precisa de uma chamada adicional a `GET /tracks/{id}` (já parcialmente usada) e possivelmente `GET /albums/{id}` para o ano de lançamento — confirmar se o payload atual já traz isso ou se precisa de endpoint extra.
- [ ] **Fluxo de rodada:** escanear carta → tocar prévia → jogador da vez decide a posição na timeline → revela o ano real → acerto/erro → passa a vez.
- [ ] **Implementar a tela de timeline** — já existe um protótipo visual em [beatspan-timeline.html](beatspan-timeline.html) (mockup HTML da UI, ainda não implementado em Flutter); usar como referência de layout ao construir a `TimelineView` real.
- [ ] **Pontuação e condição de vitória** — implementar conforme a decisão de produto tomada acima.
- [ ] **Persistência de partida em andamento** — estado em memória ou `SharedPreferences` é suficiente (single-device, passando de mão em mão); não precisa de backend nem Hive para isso.
- [ ] **Escrever o conteúdo real de `RulesView`** — hoje a tela é só um cabeçalho decorativo sem texto de regras (`rules_view.dart:66`).

**Condição de saída:** uma partida completa é jogável — vários jogadores, várias cartas, timeline se constrói ao longo do jogo, o app declara um vencedor.

---

## Fase 3 — Além do MVP local (só depois da Fase 2 redonda)

Não detalhado em tarefas aqui porque depende do que a Fase 2 revelar em uso real. Direção já mapeada em `PROPOSTA-ROADMAP.md`:

- Geração/impressão de cartas físicas com QR (ferramenta separada, não precisa ser parte do app Flutter).
- Modo online/multiplayer — mudança de arquitetura grande (precisa de backend); só avaliar depois do modo local estar 100% redondo e testado com jogadores reais.

Nesta fase também é o momento de considerar os itens de médio/longo prazo do [ACTION_PLAN.md](ACTION_PLAN.md) que não bloqueiam jogabilidade: CI/CD, padronização arquitetural das demais features, ADRs, versionamento semântico.

---

## Resumo visual

```
Fase 0 (destravar)  ──┬──►  Fase 1 (robustez, paralelo)
   SEC-002, ARQ-001,   │
   ARQ-002, ARQ-004    │
                        │
   [decisão de produto: pontuação / vitória / cartas físicas]
                        │
                        ▼
                    Fase 2 (lógica de jogo)
                    modelo de domínio, timeline,
                    pontuação, RulesView real
                        │
                        ▼
                    Fase 3 (além do MVP)
                    impressão de cartas, multiplayer
```

**Próximo passo imediato sugerido:** começar pela Fase 0 (é puramente técnico, sem decisão de produto pendente) enquanto você resolve as três perguntas da seção de decisão pendente — assim a Fase 2 pode começar sem atraso assim que a resposta chegar.
