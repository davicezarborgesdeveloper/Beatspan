# 🔐 Guia de Configuração do Keystore de Release

## ⚡ Setup Rápido

### 1. Gerar Keystore

**Windows:**
```bash
cd android
setup-keystore.bat
```

Siga as instruções e anote as senhas!

### 2. Configurar key.properties

```bash
# Copiar template
cp key.properties.example key.properties

# Editar e preencher com suas senhas
notepad key.properties
```

**Conteúdo do `key.properties`:**
```properties
storePassword=SUA_SENHA_DO_KEYSTORE
keyPassword=SUA_SENHA_DA_KEY
keyAlias=beatspan
storeFile=../beatspan-release.keystore
```

### 3. Build de Release

```bash
flutter build apk --release
```

**APK gerado em:** `build/app/outputs/flutter-apk/app-release.apk`

---

## ⚠️ IMPORTANTE

### ✅ Faça Backup

1. **Arquivo:** `android/beatspan-release.keystore`
2. **Senhas:** Store em gerenciador de senhas
3. **Locais:** 3+ lugares seguros diferentes

**Sem backup = Impossível atualizar o app!**

### ❌ Nunca Commite

- `key.properties`
- `beatspan-release.keystore`
- Senhas em texto plano

---

## 🔍 Verificar Configuração

```bash
# Ver informações do keystore
keytool -list -v -keystore beatspan-release.keystore

# Verificar assinatura do APK
keytool -printcert -jarfile ../build/app/outputs/flutter-apk/app-release.apk
```

---

## 🐛 Troubleshooting

### Erro: "key.properties não encontrado"

**Sintoma:** Avisos durante o build

**Solução:**
1. Verifique se `key.properties` existe em `android/`
2. Verifique se está preenchido corretamente
3. Execute `flutter clean` e tente novamente

### Erro: "Incorrect keystore password"

**Sintoma:** Build falha com erro de senha

**Solução:**
1. Verifique as senhas em `key.properties`
2. Certifique-se de que são as mesmas do keystore
3. Tente gerar novo keystore se esqueceu a senha

### Erro: "Keystore was tampered with"

**Sintoma:** Keystore corrompido

**Solução:**
1. Restaure de backup
2. Se sem backup, gere novo keystore
3. **Nota:** Novo keystore = impossível atualizar app publicado

---

## 📚 Documentação Completa

Ver: [docs/melhorias/curto-prazo/002-release-signing.md](../docs/melhorias/curto-prazo/002-release-signing.md)

---

**Mantido por:** [@davicezarborgesdeveloper](https://github.com/davicezarborgesdeveloper)
