# Beatspan — Proposta de Roadmap

> Baseado no gap real entre o que existe (ver [ESTADO-ATUAL.md](ESTADO-ATUAL.md)) e um app jogável ponta a ponta. Não repropõe stack — o app já está em Flutter com Clean Architecture parcial, `get_it`, `spotify_sdk`, `mobile_scanner`; a proposta é fechar os buracos e ordenar o que falta.
>
> Protótipo de UI: [beatspan-timeline.html](beatspan-timeline.html) — mockup da tela de jogo (linha do tempo de cartas) descrita na Prioridade 1, que ainda não existe no código.

## Prioridade 0 — Destravar o que já está quase pronto

1. **Configurar credenciais reais do Spotify** — `PlayerMusicPremiumView` usa placeholders (`SEU_CLIENT_ID_AQUI`). Mover para `SpotifyService` (que já recebe `clientId`/`redirectUrl` no construtor) e injetar via `get_it`/`.env`, nunca hardcoded na view.
2. **Reativar o fluxo free** — `PlayMusicFreeView` existe mas a navegação está comentada. Conectar `just_audio` (já no pubspec, não usado) para tocar a `previewUrl` de 30s retornada por `SpotifyWebApi.getTrackPreviewUrl`.
3. **Unificar navegação** — hoje convivem `RouteGenerator` (rotas nomeadas) e `Navigator.push` direto com `MaterialPageRoute`. Escolher um padrão só; `GameView`, `RulesView`, `FaqsView` deveriam entrar no `RouteGenerator` como as demais.

## Prioridade 1 — Lógica de jogo (hoje inexistente)

O código atual só resolve "escanear → tocar música". Falta tudo que faz isso ser um **jogo**:

- **Modelo de domínio**: `Player`, `Card` (ano + faixa + artista, vindo do Spotify), `Round`, `Timeline` (a sequência de cartas que cada jogador vai posicionando em ordem cronológica — mecânica central do Hitster).
- **Fluxo de rodada**: escanear carta → tocar prévia → jogador da vez decide a posição na timeline → revela o ano real → acerto/erro → próximo jogador.
- **Pontuação e condição de vitória** — regras específicas devem ser confirmadas com quem está definindo o design do jogo antes de implementar (ver seção "Perguntas em aberto" abaixo); o texto de `RulesView` deveria ser a fonte da verdade.
- **Persistência de partida em andamento** (Hive ou apenas SharedPreferences/estado em memória, dado que hoje é um único dispositivo passando de mão em mão — não precisa de backend para isso).

## Prioridade 2 — Robustez

- Testes unitários para `GameViewModel` (validação de QR e extração de track ID já são puros e fáceis de testar, e ainda não têm nenhum teste).
- Tratar erros de rede/Spotify de forma consistente (`GameErrorView` existe mas cobre só QR inválido — falta cobrir falha de conexão, token expirado, faixa sem preview disponível).
- Aplicar a mesma estrutura Clean Architecture da feature FAQ (repository + usecase) nas features que hoje pulam essa camada, à medida que crescem em complexidade — não é urgente para as telas simples de settings/idioma/país.

## Prioridade 3 — Além do MVP local

Só depois do jogo funcionar 100% localmente:

- **Geração/impressão das cartas físicas com QR** (companion tool — pode ser um HTML/script simples, não precisa ser parte do app Flutter).
- **Modo online/multiplayer** — hoje é tudo single-device; isso é uma mudança de arquitetura grande (precisaria de backend), avaliar se faz sentido antes de ter o modo local 100% redondo.

## Perguntas em aberto (decisão de produto, não técnica)

Antes de implementar a Prioridade 1, definir:

- Como a pontuação funciona exatamente (ponto por acerto de posição? bônus por acertar artista/título também, como no Hitster original?)
- Quantas cartas/pontos definem vitória?
- O app substitui totalmente as cartas físicas (mostra o QR na tela) ou sempre assume que existe um baralho físico impresso à parte?
