# 🎵 Beatspan - Spotify QR Music Game

[![CI](https://img.shields.io/badge/CI-Configured-blue)](https://github.com/davicezarborgesdeveloper/beatspan/actions)
[![Flutter](https://img.shields.io/badge/Flutter-3.27.2-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Aplicativo Flutter para jogar música via QR codes do Spotify.

---

## 📋 Índice

- [Sobre o Projeto](#-sobre-o-projeto)
- [Features](#-features)
- [Pré-requisitos](#-pré-requisitos)
- [Setup Rápido](#-setup-rápido)
- [Documentação](#-documentação)
- [Arquitetura](#-arquitetura)
- [Melhorias Implementadas](#-melhorias-implementadas)
- [Roadmap](#-roadmap)
- [Contribuindo](#-contribuindo)
- [Licença](#-licença)

---

## 🎯 Sobre o Projeto

Beatspan é um aplicativo Flutter que permite escanear QR codes do Spotify e reproduzir músicas instantaneamente. Desenvolvido seguindo Clean Architecture com foco em segurança e boas práticas.

### 🏆 Destaques

- ✅ Clean Architecture
- ✅ Segurança aprimorada (variáveis de ambiente)
- ✅ Integração completa com Spotify SDK
- ✅ Scanner QR nativo
- ✅ Design System consistente
- ✅ Documentação completa

---

## ✨ Features

### Implementadas

- ✅ **QR Scanner:** Escaneia QR codes do Spotify
- ✅ **Player Premium:** Reprodução de músicas com Spotify Premium
- ✅ **FAQs:** Perguntas frequentes integradas
- ✅ **Configurações:** Idioma e país (em desenvolvimento)
- ✅ **Splash Screen:** Animação de entrada
- ✅ **Design Responsivo:** Adapta-se a diferentes telas

### Em Desenvolvimento

- 🚧 **Player Free:** Reprodução para contas gratuitas
- 🚧 **Rules:** Conteúdo de regras do jogo
- 🚧 **Contact:** Formulário de contato

---

## 📋 Pré-requisitos

- **Flutter SDK:** 3.27.2+
- **Dart:** 3.9.2+
- **Spotify Developer Account:** [Criar conta](https://developer.spotify.com/dashboard)
- **IDE:** VS Code ou Android Studio

### Testado em

- ✅ Android 14 (API 34)
- ✅ Emuladores Android
- ⚠️ iOS (parcialmente testado)

---

## 🚀 Setup Rápido

### 1. Clone o repositório

```bash
git clone https://github.com/davicezarborgesdeveloper/beatspan.git
cd beatspan
```

### 2. Instale dependências

```bash
flutter pub get
```

### 3. Configure credenciais Spotify

```bash
# Copie o template
cp .env.example .env

# Edite .env e adicione suas credenciais
# SPOTIFY_CLIENT_ID=seu_client_id_aqui
# SPOTIFY_REDIRECT_URL=seu_redirect_url_aqui
```

📖 **Guia detalhado:** [SETUP.md](SETUP.md)

### 4. Execute

```bash
flutter run
```

---

## 📚 Documentação

| Documento | Descrição |
|-----------|-----------|
| [SETUP.md](SETUP.md) | Guia completo de configuração |
| [ANALISE_ARQUITETURAL.md](ANALISE_ARQUITETURAL.md) | Análise técnica detalhada (66 páginas) |
| [CHANGELOG_MELHORIAS.md](CHANGELOG_MELHORIAS.md) | Histórico de melhorias implementadas |
| [docs/melhorias/](docs/melhorias/) | Documentação de cada melhoria |

---

## 🏗️ Arquitetura

### Clean Architecture

```
lib/
├── app/                # Configuração, DI, Preferences
├── data/              # Data sources, Network, Repositories
│   ├── data_source/
│   ├── network/
│   └── repository/
├── domain/            # Models, UseCases, Repository contracts
│   ├── model/
│   ├── repository/
│   └── usecase/
└── presentation/      # Views, ViewModels, Design System
    ├── game/
    ├── home/
    ├── resource/      # Design System
    └── ...
```

### Padrões Utilizados

- **MVVM** com ValueNotifier
- **Dependency Injection** (GetIt)
- **Either/Result Pattern** (Dartz)
- **Repository Pattern**
- **UseCase Pattern**

### Fluxo de Dados

```
UI → ViewModel → UseCase → Repository → DataSource
```

📖 **Detalhes:** [ANALISE_ARQUITETURAL.md#fundamentos](ANALISE_ARQUITETURAL.md#1%EF%B8%8F⃣-fundamentos--7510-)

---

## 🎨 Design System

### Cores Principais

- **Primary:** #2CCBF5 (Cyan)
- **Secondary:** #624595 (Roxo)
- **Ternary:** #29107D (Roxo escuro)
- **Quaternary:** #DE436B (Rosa)

### Tipografia

- **Fonte:** Montserrat (9 pesos)
- **Tamanhos:** 12, 14, 16, 20, 24, 32

### Componentes

- ScaffoldHitster (Layout base)
- BubbleBlur (Efeito de fundo)
- FaqTile (Item de FAQ)
- Botões customizados

---

## ✅ Melhorias Implementadas

### 🔴 Segurança

#### ✅ #001 - Credenciais em Variáveis de Ambiente
- **Status:** CONCLUÍDO (2025-12-31)
- **Impacto:** CVSS 9.1 → 2.0
- **Documentação:** [docs/melhorias/curto-prazo/001-credenciais-env.md](docs/melhorias/curto-prazo/001-credenciais-env.md)

**Antes:**
```dart
final clientId = '8e1f4c38cf5543f5929e19c1d503205c'; // ❌ EXPOSTO
```

**Depois:**
```dart
final clientId = dotenv.env['SPOTIFY_CLIENT_ID']; // ✅ SEGURO
```

📊 **Todas as melhorias:** [CHANGELOG_MELHORIAS.md](CHANGELOG_MELHORIAS.md)

---

## 🗺️ Roadmap

### 🔴 Curto Prazo (1-2 semanas) - Progresso: 11%

- [x] ~~Remover credenciais hardcodeadas~~ ✅
- [ ] Configurar release signing
- [ ] Implementar flutter_secure_storage
- [ ] Adicionar testes unitários (20+)
- [ ] Configurar CI/CD

### ⚠️ Médio Prazo (1-2 meses) - Progresso: 0%

- [ ] Migrar para Riverpod
- [ ] Integrar Sentry
- [ ] Implementar Player Free
- [ ] SSL Pinning
- [ ] Cobertura de testes 60%+

### 🎯 Longo Prazo (3-6 meses) - Progresso: 0%

- [ ] Cache de imagens
- [ ] LGPD/GDPR compliance
- [ ] Multiplataforma (iOS, Web)
- [ ] Performance otimizada
- [ ] Testes E2E

📋 **Roadmap completo:** [ANALISE_ARQUITETURAL.md#roadmap](ANALISE_ARQUITETURAL.md#-roadmap-de-melhorias)

---

## 🧪 Testes

```bash
# Rodar testes
flutter test

# Com cobertura
flutter test --coverage

# Análise estática
flutter analyze
```

**Status Atual:**
- ⚠️ Cobertura: 0% (testes em desenvolvimento)
- ✅ Análise estática: Aprovada

---

## 📦 Build

### Debug

```bash
flutter build apk --debug
```

### Release

⚠️ **IMPORTANTE:** Configure o keystore antes de buildar para release!

```bash
flutter build apk --release
```

📖 **Guia de release signing:** [docs/melhorias/curto-prazo/002-release-signing.md](docs/melhorias/curto-prazo/002-release-signing.md)

---

## 🤝 Contribuindo

### Como Contribuir

1. **Fork** o projeto
2. **Clone** seu fork
3. **Crie uma branch:** `git checkout -b feature/MinhaFeature`
4. **Commit:** `git commit -m 'Add: Minha feature'`
5. **Push:** `git push origin feature/MinhaFeature`
6. **Pull Request:** Abra um PR descrevendo as mudanças

### Padrões de Commit

```
Add: Nova funcionalidade
Update: Atualização de funcionalidade existente
Fix: Correção de bug
Refactor: Refatoração de código
Docs: Atualização de documentação
Test: Adição/atualização de testes
```

### Antes de Contribuir

- [ ] Leia [ANALISE_ARQUITETURAL.md](ANALISE_ARQUITETURAL.md)
- [ ] Siga os padrões do projeto
- [ ] Adicione testes (quando aplicável)
- [ ] Atualize documentação
- [ ] Execute `flutter analyze`

---

## 📊 Status do Projeto

| Aspecto | Status | Score |
|---------|--------|-------|
| **Arquitetura** | ⭐⭐⭐⭐ | 7.5/10 |
| **Segurança** | ⚠️ Melhorando | 4.0/10 |
| **Qualidade** | ⚠️ Em progresso | 3.5/10 |
| **Performance** | ⭐⭐⭐ | 6.5/10 |
| **Documentação** | ⭐⭐⭐⭐ | 8.0/10 |

**Score Geral:** 5.8/10 → 🎯 Meta: 8.0/10

📊 **Análise completa:** [ANALISE_ARQUITETURAL.md](ANALISE_ARQUITETURAL.md)

---

## 🔒 Segurança

### Vulnerabilidades Conhecidas

- ⚠️ Release signing com debug keys (em correção)
- ⚠️ SharedPreferences para dados sensíveis (planejado)
- ⚠️ Sem SSL pinning (planejado)

### Boas Práticas Implementadas

- ✅ Credenciais em variáveis de ambiente
- ✅ `.env` no .gitignore
- ✅ Validação de credenciais
- ✅ HTTPS enforced

📋 **Report de segurança:** [ANALISE_ARQUITETURAL.md#segurança](ANALISE_ARQUITETURAL.md#2%EF%B8%8F⃣-segurança-e-compliance--2010-)

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 👥 Autores

- **Davi Cezar Borges** - [@davicezarborgesdeveloper](https://github.com/davicezarborgesdeveloper)

---

## 🙏 Agradecimentos

- [Spotify SDK Flutter](https://pub.dev/packages/spotify_sdk)
- [Flutter Community](https://flutter.dev/community)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

## 📞 Suporte

- **Issues:** [GitHub Issues](https://github.com/davicezarborgesdeveloper/beatspan/issues)
- **Email:** [Contato](mailto:davicezarborgesdeveloper@email.com)
- **Documentação:** [docs/](docs/)

---

## 📈 Estatísticas

- **Linhas de Código:** 2.773
- **Arquivos Dart:** 47
- **Dependências:** 13
- **Melhorias Implementadas:** 1/39
- **Progresso Roadmap:** 2.56%

---

**Desenvolvido com ❤️ usando Flutter**

**Última Atualização:** 2025-12-31
