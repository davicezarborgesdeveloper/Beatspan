# Beatspan — Estado Atual do Código

> Levantamento feito lendo o código-fonte real em `C:\Projetos\mine\Beatspan` (Flutter, app separado — este documento vive em `guides/projects` apenas como referência/planejamento, não faz parte do repositório do app).

## O que é

Jogo de cartas de música no estilo **Hitster**: cada carta física tem um QR code; o jogador escaneia, o app resolve a faixa do Spotify e toca, e os jogadores tentam adivinhar música/artista/ano posicionando a carta numa linha do tempo. A tela inicial já traz a frase "O jogo de cartas de música" e um botão "Ler as regras".

## Stack confirmada (pubspec.yaml)

| Categoria | Pacote |
|---|---|
| DI | `get_it` |
| Either/Result | `dartz` |
| Persistência simples | `shared_preferences` |
| Rede | `http`, `connectivity_plus` |
| Spotify | `spotify_sdk` (App Remote + Auth) |
| QR Scan | `mobile_scanner` |
| Áudio local (preview) | `just_audio` — **importado no pubspec mas não usado em nenhuma view ainda** |
| Splash/ícone | `flutter_native_splash`, `flutter_launcher_icons` |

## Arquitetura

Clean Architecture simplificada, feature-first dentro de `presentation/`, com `data/` e `domain/` genéricos (não replicados por feature):

```
lib/
├── app/            → App widget, AppPreferences (shared_preferences), DI (get_it)
├── data/
│   ├── data_source/    → FaqLocalDataSource (lê assets/json/faq.json)
│   ├── network/         → SpotifyService (App Remote), SpotifyWebApi (REST), NetworkInfo
│   └── repository/      → FaqRepositoryImpl
├── domain/
│   ├── enum/            → FlowState, PlanType/CountryType/LanguageType
│   ├── model/           → Faqs
│   ├── repository/      → FaqRepository (abstract)
│   └── usecase/         → FaqsUsecase, BaseUseCase
└── presentation/
    ├── splash, home, game, rules, settings, faqs, contact,
    │   country, language, change_spotify, connect_spotify_premium
    └── resource/        → color/font/style/theme/screen/value/assets managers
```

Só a feature **FAQ** tem a stack completa (repository + usecase + datasource). O resto das telas (`game`, `home`, `settings` etc.) fala direto com `SpotifyService`/`AppPreferences` sem passar por usecase/repository — ou seja, o padrão Clean Architecture existe como intenção, mas está aplicado em 1 de ~10 features.

## Fluxo de jogo implementado

```
HomeView ("Começar um jogo")
  → GameView (abre câmera com mobile_scanner)
    → onDetect(qrValue)
      → GameViewModel.validate(value)
          aceita apenas URLs iniciando com
          "https://open.spotify.com/intl-pt/track/"
      → se inválido → GameErrorView
      → se válido:
          extractTrackId() pega o 3º segmento do path
          toSpotifyUri() vira "spotify:track:<id>"
          lê PlanType salvo em AppPreferences
          ├─ premium → PlayerMusicPremiumView(initialUri)
          │              conecta Spotify App Remote e chama SpotifySdk.play()
          │              mostra um botão circular play/pause com stream de PlayerState
          └─ free → busca token via SpotifyService.getAccessToken()
                     chama SpotifyWebApi.getTrackPreviewUrl(trackId)
                     (rota para PlayerMusicFreeView está COMENTADA — não navega a lugar nenhum)
```

## Gaps e pontos incompletos (achados diretamente no código)

- **`PlayMusicFreeView` existe como arquivo mas a navegação para ela está comentada** em `game_view.dart` (linha ~94) — o fluxo free não leva a lugar nenhum hoje, só busca a preview URL e para.
- **Credenciais do Spotify hardcoded como placeholder**: `PlayerMusicPremiumView._initSpotify()` usa `clientId: 'SEU_CLIENT_ID_AQUI'` e `redirectUrl: 'SEU_REDIRECT_URL_AQUI'` — não lê de `SpotifyService`/config real, é um TODO explícito no código.
- **Sem lógica de jogo**: não há modelo de jogador, rodada, pontuação, timeline ou vitória em lugar nenhum do código. O que existe é só "escaneia → toca a música". As regras ficam só na `RulesView` (tela estática, não temos o conteúdo revisado aqui).
- **Sem multiplayer/estado compartilhado**: tudo é local, um dispositivo, sem sincronização entre jogadores.
- **`just_audio` está no pubspec mas não é usado** — provável dependência para tocar a preview de 30s no plano free, ainda não conectada.
- **Sem testes** — pasta de testes padrão do Flutter não foi vista com conteúdo relevante além do boilerplate.
- **Rotas**: `RouteGenerator` não tem entrada para `GameView`, `RulesView`, `FaqsView` sendo navegado por rota nomeada em `home_view.dart` (usa `Navigator.push` direto com `MaterialPageRoute`, ignorando `RouteGenerator` em parte dos casos) — duas formas de navegação convivendo no mesmo app.

## O que já funciona ponta a ponta

- Splash → seleção de idioma/país → Home
- Scan de QR real (câmera) com validação de formato de URL do Spotify
- Extração de track ID e montagen de URI Spotify
- Reprodução via Spotify App Remote **quando** client ID/redirect estiverem configurados corretamente (hoje são placeholders)
- Leitura de FAQ a partir de JSON local (única feature com Clean Architecture completa)
- Persistência de plano (free/premium), idioma e país via SharedPreferences
