# Troubleshooting — Integração Spotify (Beatspan)

**Projeto:** Beatspan (`br.com.dcbsys.beatspan`)
**Última atualização:** 2026-08-21

> Registro dos problemas reais encontrados ao testar a integração com o Spotify e como resolvê-los. Atualize este arquivo conforme novos problemas aparecerem — é o histórico vivo de "já vi isso antes".

---

## Problema 1 — App travava/falhava ao conectar ao Spotify Premium

### Sintoma
Ao tentar conectar o app ao Spotify Premium, a autorização não completava — o app ficava preso na tela de conexão ou retornava erro.

### Causa raiz (revisada — ver nota de correção abaixo)
Inicialmente diagnosticado como mismatch entre o `redirectUrl` do código Dart e o `intent-filter` do Android Manifest, e o `redirectUrl` foi trocado para `spotify-sdk://auth`. Essa mudança sozinha **causou uma regressão** (ver Problema 6) porque o Spotify recusa o `redirect_uri` na chamada de `authorize` se ele não estiver cadastrado no Dashboard.

A causa raiz completa só ficou clara depois de capturar o log nativo (`adb`/`flutter logs`) mostrando a URL exata enviada ao Spotify:
```
https://accounts.spotify.com/authorize?client_id=...&redirect_uri=spotify-sdk%3A%2F%2Fauth&...
```
O Spotify comparou esse `redirect_uri` com os cadastrados no Dashboard, não achou correspondência (só `https://hitster-d8ac4.firebaseapp.com/` estava lá) e recusou com `AUTHENTICATION_SERVICE_UNKNOWN_ERROR`.

**Conclusão correta:** o `redirectUrl` usado no código Dart precisa estar cadastrado como Redirect URI no Spotify Dashboard — o Android Manifest (`intent-filter`) só cuida de capturar o retorno *depois* que o Spotify já aceitou o `redirect_uri` na etapa de autorização. Os dois lados (Dashboard e Manifest) precisam concordar com o mesmo valor.

### Resolução
1. Código (`lib/app/di.dart`) usa `redirectUrl = 'spotify-sdk://auth'`.
2. Esse mesmo valor foi **adicionado como Redirect URI adicional** no Spotify Dashboard (Settings → Redirect URIs → Add URI), mantendo `https://hitster-d8ac4.firebaseapp.com/` já cadastrado (não removido, pois pode ser usado por outro fluxo/versão do app).
3. `android/app/build.gradle.kts` já tinha `redirectSchemeName = spotify-sdk`, `redirectHostName = auth`, batendo com o `intent-filter` do manifest — não precisou de alteração.

### Status
✅ Corrigido — ver Problema 6 para o log que confirmou a causa raiz completa.

---

## Problema 2 — `PlayerMusicPremiumView` usava credenciais placeholder

### Sintoma
A tela de reprodução Premium (`player_music_premium_view.dart`) sempre falhava ao tocar uma faixa.

### Causa raiz
O código chamava `SpotifySdk.connectToSpotifyRemote` com literais placeholder nunca preenchidos:
```dart
clientId: 'SEU_CLIENT_ID_AQUI',
redirectUrl: 'SEU_REDIRECT_URL_AQUI',
```
Além disso, essa tela reconectava do zero em vez de reaproveitar a sessão já autenticada em `ConnectSpotifyPremiumView`.

### Resolução
A tela agora usa `SpotifyService` (via `get_it`) para garantir a conexão com as credenciais reais antes de chamar `SpotifySdk.play()`.

### Status
✅ Corrigido em código (commit desta sessão).

---

## Problema 3 — Fluxo Spotify Free não navegava a lugar nenhum

### Sintoma
Ao escanear um QR com o plano Free selecionado, o app buscava a prévia da faixa e não fazia nada — não travava, só não seguia.

### Causa raiz
A navegação para `PlayerMusicFreeView` estava comentada em `game_view.dart`, junto com o `import` da tela.

### Resolução
Import e chamada de navegação reativados. Também foi adicionado um tratamento específico: quando o Spotify não retorna `preview_url` para a faixa (ver Problema 5), o app agora mostra uma mensagem clara ("Prévia indisponível") em vez de cair na tela genérica de "QR desconhecido".

### Status
✅ Corrigido em código (commit desta sessão).

---

## Problema 4 — QR code de faixas reais do Spotify não era reconhecido

### Sintoma
Ao escanear um QR gerado a partir de um link "Copiar link da música" do próprio app do Spotify, o Beatspan mostrava "QR CODE DESCONHECIDO" mesmo sendo um link de faixa válido.

### Causa raiz
`GameViewModel` só aceitava links no formato exato `https://open.spotify.com/intl-pt/track/<id>` (com o prefixo de idioma `intl-pt` obrigatório). O link padrão copiado do Spotify normalmente vem sem esse prefixo (`https://open.spotify.com/track/<id>`), ou com outro locale.

### Resolução
Reescrita a validação em `game_viewmodel.dart` para aceitar qualquer host `open.spotify.com` com `/track/<id>` no caminho, com ou sem prefixo de locale — o ID é extraído a partir do segmento que vem logo depois de `track`, não de um índice fixo no path.

### Status
✅ Corrigido em código (commit desta sessão).

---

## Problema 5 — `AUTHENTICATION_SERVICE_UNKNOWN_ERROR` ao tentar obter token — causa 1 de 2: SHA1 desatualizado

### Sintoma
Log no app:
```
⛔ getAccessToken failed with: Authentication went wrong
⛔ AUTHENTICATION_SERVICE_UNKNOWN_ERROR
```

> Este mesmo código de erro genérico do Spotify teve **duas causas raiz diferentes** nesta investigação — esta seção cobre a primeira encontrada; ver Problema 6 para a segunda, que só apareceu depois desta estar corrigida.

### Causa raiz
O SHA1 do certificado que assina o APK instalado no celular de teste não batia com o SHA1 cadastrado no Spotify Developer Dashboard, na seção **Android packages** do app Beatspan.

O app do Spotify oficial usa esse SHA1 para verificar se quem está pedindo autorização é realmente o app registrado — se não bate, ele recusa com um erro genérico (não diz "SHA1 errado" explicitamente).

Confirmado: SHA1 real do `debug.keystore` local (`F7:BC:A7:33:79:5D:BF:77:BA:46:57:10:32:4D:C3:A7:7D:66:AE:09`) era diferente do que estava cadastrado no Dashboard (`4E225C8497294F4E980F191DB75207870E09013E`).

### Resolução — passo a passo

**1. Obtenha o SHA1 do keystore de debug local:**

No PowerShell:
```powershell
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

Procure a linha `SHA1:` na saída. Vai ser algo como:
```
SHA1: F7:BC:A7:33:79:5D:BF:77:BA:46:57:10:32:4D:C3:A7:7D:66:AE:09
```

> Nota: `~/.android/debug.keystore` não funciona direto no PowerShell (o `~` não expande como no Bash) — por isso usar `$env:USERPROFILE`.

**2. Remova os dois-pontos** (o Dashboard do Spotify espera o valor sem `:`):
```
F7BCA733795DBF77BA465710324DC3A77D66AE09
```

**3. Atualize no Spotify Developer Dashboard:**
1. Acesse [developer.spotify.com/dashboard](https://developer.spotify.com/dashboard)
2. Abra o app **Beatspan**
3. Vá em **Settings**
4. Na seção **Android packages**, edite a entrada `br.com.dcbsys.beatspan`
5. Substitua o SHA1 pelo valor obtido no passo 2 (mantenha o package name igual)
6. Salve

**4. Teste novamente** no celular — não precisa reinstalar o app, a mudança é só do lado do Spotify.

### Observação importante para o futuro
O SHA1 de debug é **específico desta máquina** — se você (ou outro desenvolvedor) rodar o app a partir de outro computador, o `debug.keystore` será diferente e vai gerar um SHA1 diferente, exigindo cadastrar outro valor no Dashboard (o Spotify aceita múltiplos SHA1 por package, então dá pra ter debug de várias máquinas cadastrados ao mesmo tempo).

Quando for gerar o **keystore de produção** para publicar na loja (ver `SEC-003` em `ARCHITECTURAL_REVIEW.md` — hoje o release ainda está assinado com debug), o SHA1 daquele keystore também precisa ser cadastrado separadamente no Dashboard antes do app funcionar em produção.

### Status
✅ Corrigido — SHA1 atualizado no Dashboard. Mas o mesmo erro genérico voltou a aparecer por uma causa diferente — ver Problema 6.

---

## Problema 6 — `AUTHENTICATION_SERVICE_UNKNOWN_ERROR` — causa 2 de 2: `redirect_uri` não cadastrado no Dashboard

### Sintoma
Mesmo com o SHA1 corrigido (Problema 5) e o usuário na allowlist de Development mode, o erro persistia:
```
PlatformException(authenticationTokenError, Authentication went wrong, AUTHENTICATION_SERVICE_UNKNOWN_ERROR, null)
```
Comportamento observado no celular: loading do Spotify → tela de login abre → erro rápido ilegível → volta para tela de login manual.

### Diagnóstico
Testes feitos para isolar a causa, em ordem:
1. Confirmado usuário na allowlist de Development mode (não era isso).
2. Testado com scope reduzido (só `user-read-playback-state`, sem `app-remote-control`) para descartar problema de permissão de App Remote — erro persistiu, então não era scope.
3. Capturado o log nativo completo via `flutter run` (sem filtro), que revelou a URL exata enviada ao Spotify:
   ```
   D/com.spotify.sdk.android.auth.LoginActivity: Spotify Auth starting with the request
   [https://accounts.spotify.com/authorize?client_id=...&response_type=token&redirect_uri=spotify-sdk%3A%2F%2Fauth&...]
   ```

### Causa raiz
O `redirect_uri=spotify-sdk://auth` estava sendo enviado corretamente na requisição de autorização, mas **não estava cadastrado como Redirect URI no Spotify Dashboard** — só `https://hitster-d8ac4.firebaseapp.com/` estava lá (ver Problema 1, que originalmente tinha o diagnóstico invertido).

O Spotify valida o `redirect_uri` do lado do servidor antes de completar a autorização — se o valor não estiver na lista de Redirect URIs cadastrados do app, ele recusa com esse erro genérico, mesmo com SHA1 e usuário corretos.

### Resolução
No Spotify Dashboard → app Beatspan → Settings → seção **Redirect URIs**:
1. Manter `https://hitster-d8ac4.firebaseapp.com/` (já cadastrado, não remover)
2. Clicar em **Add URI** (ou equivalente) e adicionar: `spotify-sdk://auth`
3. Salvar

### Status
🔲 Aguardando confirmação de teste após adicionar o Redirect URI no Dashboard.

---

## Checklist rápido para reproduzir/verificar tudo

- [ ] `redirectUrl` em `di.dart` é `spotify-sdk://auth` (Problema 1/6)
- [ ] `spotify-sdk://auth` está cadastrado em **Redirect URIs** no Spotify Dashboard, além do valor HTTPS já existente (Problema 6)
- [ ] SHA1 do keystore usado no build bate com o cadastrado em **Android packages** no Spotify Dashboard (Problema 5)
- [ ] App do Spotify oficial instalado e logado no dispositivo de teste
- [ ] Testar fluxo Premium: Settings → Alterar modo Spotify → Premium → conectar
- [ ] Testar fluxo Free: escanear QR de faixa real → deve tocar prévia de 30s ou mostrar "prévia indisponível" (não erro genérico)
- [ ] Testar QR com link padrão do Spotify (sem prefixo de locale) — deve ser reconhecido

---

## Referência: exportar o próprio QR de teste

Use [gerador-qr-teste.html](gerador-qr-teste.html) — abra no navegador, cole o link de uma faixa do Spotify (copiado via "Compartilhar → Copiar link da música"), gera o QR na tela para escanear com o celular.
