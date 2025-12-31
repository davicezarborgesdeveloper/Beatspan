# 🚀 Setup do Projeto Beatspan

## ✅ Pré-requisitos

- Flutter SDK 3.27.2+
- Dart 3.9.2+
- Spotify Developer Account
- Android Studio / VS Code

## 📦 Instalação

### 1. Clone o repositório

```bash
git clone https://github.com/davicezarborgesdeveloper/beatspan.git
cd beatspan
```

### 2. Instale as dependências

```bash
flutter pub get
```

### 3. Configure as credenciais do Spotify

#### 3.1 Obtenha as credenciais

1. Acesse [Spotify Developer Dashboard](https://developer.spotify.com/dashboard)
2. Faça login com sua conta Spotify
3. Clique em "Create app"
4. Preencha:
   - **App name**: Beatspan (ou o nome que preferir)
   - **App description**: Aplicativo de música com QR codes
   - **Redirect URI**: `https://hitster-d8ac4.firebaseapp.com/`
5. Aceite os termos e clique em "Save"
6. Na página do app criado, copie o **Client ID**

#### 3.2 Configure o arquivo .env

1. Copie o arquivo de exemplo:
   ```bash
   cp .env.example .env
   ```

2. Edite o arquivo `.env` e cole suas credenciais:
   ```env
   SPOTIFY_CLIENT_ID=seu_client_id_aqui
   SPOTIFY_REDIRECT_URL=https://hitster-d8ac4.firebaseapp.com/
   ```

⚠️ **IMPORTANTE:** Nunca versione o arquivo `.env` no Git! Ele já está no `.gitignore`.

### 4. Execute o projeto

```bash
flutter run
```

## 🔒 Segurança

### ✅ O que foi corrigido

- ✅ Credenciais agora são carregadas de variáveis de ambiente (`.env`)
- ✅ Arquivo `.env` está no `.gitignore`
- ✅ Template `.env.example` versionado para referência
- ✅ Validação de credenciais na inicialização

### ⚠️ Nunca faça

- ❌ Não commite o arquivo `.env`
- ❌ Não compartilhe suas credenciais publicamente
- ❌ Não hardcode credenciais no código

## 🛠️ Troubleshooting

### Erro: "SPOTIFY_CLIENT_ID e SPOTIFY_REDIRECT_URL devem estar definidos"

**Causa:** Arquivo `.env` não encontrado ou variáveis não definidas.

**Solução:**
1. Verifique se o arquivo `.env` existe na raiz do projeto
2. Verifique se as variáveis estão preenchidas corretamente
3. Execute `flutter clean` e `flutter pub get`

### Erro: "Failed to load asset: .env"

**Causa:** Arquivo `.env` não está nos assets do `pubspec.yaml`.

**Solução:**
Verifique se `pubspec.yaml` contém:
```yaml
flutter:
  assets:
    - .env
```

## 📝 Variáveis de Ambiente Disponíveis

| Variável | Descrição | Obrigatória |
|----------|-----------|-------------|
| `SPOTIFY_CLIENT_ID` | Client ID do Spotify Developer | ✓ Sim |
| `SPOTIFY_REDIRECT_URL` | URL de redirecionamento OAuth | ✓ Sim |

## 🔄 Atualizando Credenciais

Se precisar atualizar suas credenciais:

1. Edite o arquivo `.env`
2. Execute `flutter clean`
3. Execute `flutter pub get`
4. Execute `flutter run`

## 🤝 Contribuindo

Ao contribuir com o projeto:

1. **Nunca** commite o arquivo `.env`
2. Sempre use o `.env.example` como referência
3. Documente novas variáveis de ambiente no `README.md`

## 📚 Documentação Adicional

- [Spotify Web API](https://developer.spotify.com/documentation/web-api/)
- [Spotify SDK Flutter](https://pub.dev/packages/spotify_sdk)
- [Flutter DotEnv](https://pub.dev/packages/flutter_dotenv)

## ✅ Checklist de Setup

- [ ] Flutter instalado e configurado
- [ ] Projeto clonado
- [ ] Dependências instaladas (`flutter pub get`)
- [ ] Conta Spotify Developer criada
- [ ] App criado no Spotify Dashboard
- [ ] Client ID copiado
- [ ] Arquivo `.env` criado a partir do `.env.example`
- [ ] Credenciais preenchidas no `.env`
- [ ] Projeto executando sem erros

---

**Desenvolvido por:** [@davicezarborgesdeveloper](https://github.com/davicezarborgesdeveloper)
