# Beatspan

*[Read in English](README.en.md)*

Beatspan é um app em Flutter que acompanha um jogo de cartas de música no estilo **Hitster**: cada carta física traz um QR code, o jogador escaneia com o celular, o app resolve a faixa correspondente no Spotify e a toca, enquanto os jogadores tentam adivinhar música, artista e ano posicionando a carta numa linha do tempo.

## Funcionalidades

- **Splash, seleção de idioma e país** no primeiro acesso, com persistência local das preferências.
- **Leitura de QR code** via câmera (`mobile_scanner`), validando links de faixa do Spotify.
- **Reprodução da faixa via Spotify** — usuários Premium tocam a música completa pelo Spotify App Remote (`spotify_sdk`); usuários do plano Free buscam a prévia de 30s via Spotify Web API.
- **Tela de regras** do jogo com ilustrações.
- **FAQ** carregado de um JSON local (`assets/json/faq.json`), com repositório e use case dedicados.
- **Configurações**: troca de conta Spotify, upgrade para Premium, idioma, país, contato e compartilhamento do app.

## Stack técnica

| Categoria | Pacote |
|---|---|
| Injeção de dependência | `get_it` |
| Result/Either | `dartz` |
| Persistência local | `shared_preferences` |
| Rede / conectividade | `http`, `connectivity_plus` |
| Integração Spotify | `spotify_sdk` (App Remote + Auth), Web API via `http` |
| Leitura de QR code | `mobile_scanner` |
| Áudio (preview local) | `just_audio` |
| Splash / ícone do app | `flutter_native_splash`, `flutter_launcher_icons` |

## Arquitetura

Clean Architecture simplificada, com `presentation/` organizada por feature e `data/`/`domain/` genéricos:

```
lib/
├── app/            # App widget, AppPreferences (shared_preferences), configuração de DI (get_it)
├── data/
│   ├── data_source/    # ex.: FaqLocalDataSource (lê assets/json/faq.json)
│   ├── network/         # SpotifyService (App Remote), SpotifyWebApi (REST), NetworkInfo
│   └── repository/      # implementações dos repositórios
├── domain/
│   ├── enum/            # FlowState, PlanType, CountryType, LanguageType
│   ├── model/            # modelos de domínio (ex.: Faqs)
│   ├── repository/       # contratos abstratos
│   └── usecase/          # casos de uso (ex.: FaqsUsecase)
└── presentation/
    ├── splash, home, game, rules, settings, faqs, contact,
    │   country, language, change_spotify, connect_spotify_premium, share
    └── resource/         # gerenciadores de cor, fonte, estilo, tema, tela e assets
```

> Observação: hoje apenas a feature de FAQ implementa a stack completa (repository + usecase + datasource). As demais telas conversam diretamente com `SpotifyService`/`AppPreferences`.

## Fluxo principal do jogo

1. Na `HomeView`, o jogador toca em "Começar um jogo".
2. A `GameView` abre a câmera para escanear o QR code da carta.
3. O app valida se a URL escaneada é um link de faixa do Spotify e extrai o ID da faixa.
4. Conforme o plano salvo (`PlanType`):
   - **Premium**: conecta ao Spotify App Remote e reproduz a faixa completa.
   - **Free**: busca a URL de prévia (30s) via Spotify Web API.

## Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `^3.9.2`
- Conta de desenvolvedor no [Spotify for Developers](https://developer.spotify.com/) para obter `Client ID` e `Redirect URI`
- Aplicativo Spotify instalado no dispositivo de teste (necessário para o App Remote)
- Android Studio / Xcode configurados para rodar em emulador ou dispositivo físico

## Configuração do Spotify

O app precisa de credenciais do Spotify (Client ID e Redirect URI) para autenticar e tocar as faixas. Verifique os arquivos em `lib/data/network/` e nas telas de reprodução (`lib/presentation/game/player_music/`) para configurar essas credenciais antes de rodar o app — veja também [docs/TROUBLESHOOTING_SPOTIFY.md](docs/TROUBLESHOOTING_SPOTIFY.md) para dicas de configuração e problemas comuns.

## Como rodar

```bash
# instalar dependências
flutter pub get

# rodar em um dispositivo/emulador conectado
flutter run
```

### Gerar ícone e splash screen

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## Estrutura de documentação

A pasta [docs/](docs/) contém material de planejamento e acompanhamento do projeto:

- [ESTADO-ATUAL.md](docs/ESTADO-ATUAL.md) — levantamento do estado atual do código
- [PROPOSTA-ROADMAP.md](docs/PROPOSTA-ROADMAP.md) — proposta de roadmap
- [ROADMAP_CONCLUSAO.md](docs/ROADMAP_CONCLUSAO.md) — acompanhamento de conclusão do roadmap
- [PROMPT_ANALISE_ARQUITETURAL.md](docs/PROMPT_ANALISE_ARQUITETURAL.md) — prompt de análise arquitetural
- [TROUBLESHOOTING_SPOTIFY.md](docs/TROUBLESHOOTING_SPOTIFY.md) — solução de problemas de integração com o Spotify

## Status do projeto

Projeto em desenvolvimento ativo. Pontos conhecidos em aberto:

- Fluxo de reprodução para o plano Free ainda não navega para a tela de player correspondente.
- Ainda não há modelo de jogo (rodadas, pontuação, timeline, vitória) implementado — o app cobre hoje o fluxo de escanear e tocar a música.
- Sem suporte a multiplayer ou estado sincronizado entre dispositivos.
- Sem testes automatizados além do boilerplate padrão do Flutter.

Consulte [docs/ESTADO-ATUAL.md](docs/ESTADO-ATUAL.md) para o detalhamento completo.

# dart run flutter_launcher_icons:generate -f flutter_launcher_icons.yaml --overwrite
