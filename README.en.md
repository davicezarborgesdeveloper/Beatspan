# Beatspan

*[Leia em português](README.md)*

Beatspan is a Flutter app that companions a **Hitster**-style music card game: each physical card has a QR code, the player scans it with their phone, the app resolves the corresponding Spotify track and plays it, while players try to guess the song, artist and year by placing the card on a timeline.

## Features

- **Splash screen, language and country selection** on first launch, with local persistence of preferences.
- **QR code scanning** via camera (`mobile_scanner`), validating Spotify track links.
- **Track playback via Spotify** — Premium users play the full track through Spotify App Remote (`spotify_sdk`); Free plan users fetch the 30s preview via the Spotify Web API.
- **Rules screen** with illustrations.
- **FAQ** loaded from a local JSON file (`assets/json/faq.json`), with a dedicated repository and use case.
- **Settings**: switch Spotify account, upgrade to Premium, language, country, contact, and app sharing.

## Tech stack

| Category | Package |
|---|---|
| Dependency injection | `get_it` |
| Result/Either | `dartz` |
| Local persistence | `shared_preferences` |
| Network / connectivity | `http`, `connectivity_plus` |
| Spotify integration | `spotify_sdk` (App Remote + Auth), Web API via `http` |
| QR code scanning | `mobile_scanner` |
| Audio (local preview) | `just_audio` |
| App splash / icon | `flutter_native_splash`, `flutter_launcher_icons` |

## Architecture

Simplified Clean Architecture, with `presentation/` organized by feature and generic `data/`/`domain/` layers:

```
lib/
├── app/            # App widget, AppPreferences (shared_preferences), DI setup (get_it)
├── data/
│   ├── data_source/    # e.g. FaqLocalDataSource (reads assets/json/faq.json)
│   ├── network/         # SpotifyService (App Remote), SpotifyWebApi (REST), NetworkInfo
│   └── repository/      # repository implementations
├── domain/
│   ├── enum/            # FlowState, PlanType, CountryType, LanguageType
│   ├── model/            # domain models (e.g. Faqs)
│   ├── repository/       # abstract contracts
│   └── usecase/          # use cases (e.g. FaqsUsecase)
└── presentation/
    ├── splash, home, game, rules, settings, faqs, contact,
    │   country, language, change_spotify, connect_spotify_premium, share
    └── resource/         # color, font, style, theme, screen and asset managers
```

> Note: today only the FAQ feature implements the full stack (repository + usecase + datasource). The other screens talk directly to `SpotifyService`/`AppPreferences`.

## Main game flow

1. From `HomeView`, the player taps "Start a game".
2. `GameView` opens the camera to scan the card's QR code.
3. The app validates that the scanned URL is a Spotify track link and extracts the track ID.
4. Based on the saved plan (`PlanType`):
   - **Premium**: connects to Spotify App Remote and plays the full track.
   - **Free**: fetches the 30s preview URL via the Spotify Web API.

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `^3.9.2`
- A developer account on [Spotify for Developers](https://developer.spotify.com/) to obtain a `Client ID` and `Redirect URI`
- Spotify app installed on the test device (required for App Remote)
- Android Studio / Xcode configured to run on an emulator or physical device

## Spotify setup

The app needs Spotify credentials (Client ID and Redirect URI) to authenticate and play tracks. Check the files under `lib/data/network/` and the playback screens (`lib/presentation/game/player_music/`) to configure these credentials before running the app — see also [docs/TROUBLESHOOTING_SPOTIFY.md](docs/TROUBLESHOOTING_SPOTIFY.md) for setup tips and common issues.

## Getting started

```bash
# install dependencies
flutter pub get

# run on a connected device/emulator
flutter run
```

### Generate app icon and splash screen

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## Documentation

The [docs/](docs/) folder contains planning and tracking material for the project:

- [ESTADO-ATUAL.md](docs/ESTADO-ATUAL.md) — current state of the codebase (Portuguese)
- [PROPOSTA-ROADMAP.md](docs/PROPOSTA-ROADMAP.md) — proposed roadmap (Portuguese)
- [ROADMAP_CONCLUSAO.md](docs/ROADMAP_CONCLUSAO.md) — roadmap completion tracking (Portuguese)
- [PROMPT_ANALISE_ARQUITETURAL.md](docs/PROMPT_ANALISE_ARQUITETURAL.md) — architectural analysis prompt (Portuguese)
- [TROUBLESHOOTING_SPOTIFY.md](docs/TROUBLESHOOTING_SPOTIFY.md) — Spotify integration troubleshooting (Portuguese)

## Project status

Actively under development. Known open points:

- The Free plan playback flow does not yet navigate to its corresponding player screen.
- No game logic yet (rounds, scoring, timeline, winning) — the app currently covers the scan-and-play flow only.
- No multiplayer or state sync across devices.
- No automated tests beyond the default Flutter boilerplate.

See [docs/ESTADO-ATUAL.md](docs/ESTADO-ATUAL.md) (Portuguese) for the full breakdown.
