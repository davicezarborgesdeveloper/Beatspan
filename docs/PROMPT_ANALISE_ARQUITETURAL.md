Atue como um **Arquiteto de Software Sênior / Principal Engineer** com experiência em sistemas de grande escala, segurança, cloud, compliance e engenharia de produto.

Realize uma **ANÁLISE ARQUITETURAL COMPLETA, PROFUNDA E CRÍTICA** do projeto no repositório atual — técnica, objetiva e acionável. A análise deve ser crítica mesmo que o projeto esteja bem estruturado: não existe nota 10 "por gentileza". Se algo estiver realmente bom, diga isso com evidência; se estiver mediano, diga isso também, sem suavizar para soar mais agradável. Calibre a profundidade conforme o tamanho e maturidade do projeto. Quando houver lacunas de informação, sinalize explicitamente ao invés de assumir.

---

## Regras de execução (leia antes de começar)

1. **Não modifique o código-fonte do projeto.** Sua única saída em arquivos é a criação dos documentos descritos abaixo, dentro de `docs/`. Não corrija bugs, não aplique patches, não rode ferramentas que alterem arquivos (`npm audit fix`, `pub upgrade`, formatadores automáticos, etc.) — apenas ferramentas de leitura/diagnóstico.
2. **Nunca copie segredos reais para os relatórios.** Se encontrar chaves de API, tokens, senhas ou credenciais no código, **não reproduza o valor** em nenhum arquivo `.md`. Reporte apenas: que existe, o tipo de segredo, e o caminho do arquivo (ex: "credencial de API exposta em `config/firebase.json:12`"). Isso vale mesmo dentro de blocos de código de exemplo.
3. **Evidência antes de afirmação.** Toda vulnerabilidade, débito técnico ou ponto crítico citado deve referenciar arquivo/trecho real encontrado no projeto. Não é permitido apontar CVEs específicos de dependências a menos que tenham sido de fato confirmados (ex: via `package-lock.json`/`pubspec.lock` cruzado com uma base conhecida, ou uma ferramenta de auditoria que você realmente executou). Se não for possível confirmar, escreva "requer verificação com scanner de dependências (ex: `npm audit`, `pip-audit`, `dart pub outdated --mode=null-safety`, Dependabot)" em vez de inventar um identificador.
4. **Escale o esforço de leitura ao tamanho do repo.** Não é necessário ler cada arquivo linha a linha — priorize arquivos de configuração, pontos de entrada, camadas centrais (auth, dados, API) e uma amostragem representativa do restante. Se pular uma área por tamanho/tempo, diga isso no relatório em vez de fingir cobertura total.
5. **Uma única fonte de verdade.** Calcule as notas e a lista de problemas uma vez; os 5 arquivos abaixo devem ser visões diferentes dos *mesmos* achados, nunca análises independentes que podem divergir entre si. Use os IDs definidos na seção de output para referenciar o mesmo item em múltiplos arquivos em vez de redigi-lo de novo com detalhes diferentes.
6. **Use TodoWrite para rastrear o trabalho.** Registre como tarefas os 6 eixos de investigação e os 5 arquivos finais a gerar, marcando cada um como concluído conforme avança. Isso evita perder o fio em análises longas e permite retomar caso a sessão seja interrompida.
7. **Delegue a sub-agentes quando o repositório for grande.** Se o projeto tiver múltiplos módulos/apps ou muitos arquivos, considere investigar cada eixo (ou cada módulo) via tasks paralelas, e só depois consolidar os achados em uma lista única de IDs antes de escrever os arquivos finais — isso evita estourar a janela de contexto lendo tudo sequencialmente.

---

## Eixos de avaliação

### 1. Fundamentos
- Organização, coesão e acoplamento entre módulos
- Padrões de design aplicados e anti-patterns identificados
- Qualidade e complexidade ciclomática do código
- Débito técnico acumulado e áreas de maior risco estrutural

### 2. Segurança e Compliance
- Vulnerabilidades identificadas (OWASP Top 10, injeções, exposição de dados)
- Gestão de segredos, credenciais e dados sensíveis (ver regra 2 acima)
- LGPD / GDPR: coleta, retenção e consentimento
- Supply chain de dependências (versões desatualizadas; CVEs apenas se confirmados — ver regra 3)

### 3. Experiência
- UX: usabilidade, acessibilidade (WCAG), responsividade e design system/tokens
- DX (Developer Experience): onboarding, ergonomia de APIs e convenções internas
- Performance percebida pelo usuário final

### 4. Operações e Confiabilidade
- Testabilidade: cobertura, tipos de teste (unit, integration, e2e) e qualidade dos casos
- CI/CD: pipeline, automações e estratégia de branching
- Observabilidade: logs estruturados, métricas, rastreamento distribuído e alertas
- Resiliência: tratamento de erros, retries, fallbacks e degradação graciosa
- Gestão de custos em cloud (quando aplicável)

### 5. Documentação e Governança
- Documentação técnica: README, ADRs, diagramas arquiteturais
- Gestão de dependências e política de atualizações
- Versionamento semântico, changelogs e estratégia de releases

### 6. Performance e Escalabilidade
- Otimizações de runtime (algoritmos, queries, I/O)
- Estratégias de cache, CDN e assets
- Capacidade de escala horizontal/vertical e pontos de contenção

---

## OUTPUT — ETAPA 1: RESUMO NO CHAT

Antes de criar qualquer arquivo, apresente no chat:

**Escore geral:** X/10 — justificativa em 1-2 linhas

**Pontuação por eixo:**
| Eixo | Nota | Síntese |
|------|------|---------|
| Fundamentos | X/10 | ... |
| Segurança | X/10 | ... |
| Experiência | X/10 | ... |
| Operações | X/10 | ... |
| Documentação | X/10 | ... |
| Performance | X/10 | ... |

**Pontos fortes** — o que está bem e deve ser preservado (com evidência)
**Atenções** — problemas relevantes, mas não bloqueantes
**Críticos** — riscos que exigem ação imediata

**Cobertura da análise:** liste explicitamente qualquer área do projeto que não foi investigada em profundidade e por quê (ex: "módulo de pagamentos não foi auditado em detalhe por escopo/tempo").

---

## OUTPUT — ETAPA 2: ARQUIVOS MARKDOWN

Depois do resumo, gere os arquivos abaixo em `docs/` (crie a pasta se não existir). Todo achado relevante recebe um ID único e estável na primeira vez que aparece (ex: `SEC-001`, `DEBT-001`, `ARQ-001`); os outros arquivos referenciam esse ID em vez de redescrever o item do zero.

Cada arquivo começa com um cabeçalho: nome do projeto, data da análise, versão do documento.

### 📄 `docs/ARCHITECTURAL_REVIEW.md`
Relatório técnico completo — a fonte primária de achados, cada um com ID.
- Visão geral do projeto e stack identificada
- Análise por eixo (todos os 6), com exemplos de código/configuração problemáticos (trechos curtos, sem segredos reais — ver regra 2)
- Tabela de pontuações com justificativas completas
- Pontos fortes, atenções e críticos, cada um com ID, evidência (arquivo/trecho) e contexto

### 📄 `docs/SECURITY_REPORT.md`
Relatório dedicado de segurança, referenciando IDs `SEC-xxx` já levantados no `ARCHITECTURAL_REVIEW.md` quando aplicável, mais qualquer achado de segurança adicional.
- Vulnerabilidades com severidade (Crítica / Alta / Média / Baixa), descrição, localização (arquivo/linha se identificável) e impacto potencial — sem valores reais de segredos
- Recomendação de correção por item
- Checklist de compliance LGPD/GDPR
- Status do supply chain: dependências desatualizadas encontradas de fato; CVEs apenas se confirmados (regra 3), caso contrário listar como "pendente de verificação com [ferramenta]"

### 📄 `docs/TECH_DEBT_REGISTER.md`
Catálogo de débito técnico (categoria: código / arquitetura / testes / docs / infra), referenciando IDs já existentes quando o item também aparece no `ARCHITECTURAL_REVIEW.md`.
- Tabela: ID, descrição, categoria, severidade, esforço de resolução, impacto se não resolvido
- Débitos críticos vs. aceitáveis (com justificativa explícita para os aceitos)
- Recomendação de priorização

### 📄 `docs/ACTION_PLAN.md`
Plano de ação priorizado, consolidando itens de `ARCHITECTURAL_REVIEW.md`, `SECURITY_REPORT.md` e `TECH_DEBT_REGISTER.md` por ID — não redefina esforço/impacto de um item aqui de forma diferente do arquivo de origem.
- **Críticos (imediato — sprint atual):** tarefa, ID de origem, responsável sugerido (backend/frontend/devops/segurança), critério de aceite
- **Curto prazo (≤4 semanas)**
- **Médio prazo (1–3 meses)**
- **Longo prazo (3–12 meses)**
- Para cada item: título, ID de origem, esforço (P/M/G), impacto (Alto/Médio/Baixo), eixo relacionado

### 📄 `docs/IMPROVEMENT_ROADMAP.md`
Roadmap por trimestre (Q1–Q4) ou por fase (se o projeto for novo), agrupando as iniciativas do `ACTION_PLAN.md` por ID — não crie iniciativas novas aqui que não estejam rastreadas nos arquivos anteriores.
- Por iniciativa: nome, ID(s) relacionado(s), objetivo, eixo arquitetural, dependências entre iniciativas, métrica de sucesso
- Seção destacada de "quick wins" (alto impacto, baixo esforço)

---

**Formato:** Markdown puro, headers, tabelas, checkboxes (`- [ ]`) onde aplicável, blocos de código com linguagem especificada. Objetivo, técnico, direto — evite generalidades e frases de efeito sem conteúdo.
