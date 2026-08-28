# Como gerar o SHA-1 / SHA-256 do keystore de debug

Esses fingerprints são necessários para configurar integrações como Firebase,
Google Sign-In, Facebook Login e Spotify em modo de desenvolvimento (debug build).

## Comando

```powershell
keytool -list -v -alias androiddebugkey -keystore "C:\Users\davi_\.android\debug.keystore" -storepass android -keypass android
```

### O que cada parte faz

- `-list -v` → lista os detalhes do certificado (modo verboso)
- `-alias androiddebugkey` → alias padrão usado no keystore de debug do Android
- `-keystore "..."` → caminho do keystore de debug, gerado automaticamente em
  `C:\Users\<seu-usuario>\.android\debug.keystore`
- `-storepass android -keypass android` → senha padrão do keystore de debug
  (sempre `android` — não é segredo, é igual em qualquer máquina/projeto)

## Resultado obtido (2026-08-27)

| Item | Valor |
|---|---|
| SHA1 | `4E:22:5C:84:97:29:4F:4E:98:0F:19:1D:B7:52:07:87:0E:09:01:3E` |
| SHA256 | `13:F8:03:03:76:64:1C:E0:3D:50:FC:54:F7:35:1C:70:22:BC:29:67:3A:7E:2F:BB:DF:A9:7C:92:77:05:0E:84` |
| Owner/Issuer | CN=Android Debug, O=Android, C=US |
| Validade | até 26/03/2053 |

> **Atenção:** isso é o keystore de **debug**, reaproveitado por qualquer projeto Android
> na mesma máquina — ele não identifica o Beatspan especificamente. Para o build de
> **release** (app publicado), é preciso gerar o SHA-1 a partir do keystore de release
> real do projeto, com o alias e a senha definidos na hora de criá-lo:
>
> ```powershell
> keytool -list -v -alias <alias-do-release> -keystore "<caminho>\release.keystore"
> ```
