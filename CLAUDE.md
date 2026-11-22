# Pages — repositório agregador (GitHub Pages)

Repositório único que hospeda várias páginas estáticas: ideias iniciais, esboços e páginas semi-privadas. Objetivo: **publicar em segundos, sem build, sem dependências**.

## Princípios
1. **Zero build por padrão.** HTML/CSS/JS puro. Só use bundler se a página realmente exigir; nesse caso, commite a saída pronta dentro da pasta da página.
2. **Uma página = uma pasta autocontida.** Nada compartilhado entre páginas (sem CSS/JS global), para que apagar/mover uma pasta nunca quebre outra.
3. **Esboço primeiro.** Não polir, não criar abstrações, não adicionar frameworks sem pedido explícito.
4. **Privacidade é explícita, nunca implícita** (ver seção abaixo).

## Estrutura

```
/
├── index.html            # hub: lista SOMENTE páginas públicas
├── robots.txt            # Disallow: /u/  e /sketches/ (ver nota: não é segurança)
├── .nojekyll             # desativa Jekyll (evita ignorar pastas com "_")
├── ideas/<slug>/         # ideias iniciais, listadas no hub
├── sketches/<slug>/      # protótipos/rascunhos, listados no hub
├── u/<slug>-<token>/     # "unlisted": fora do hub, noindex, URL não adivinhável
├── p/<slug>/             # protegidas por senha (conteúdo criptografado)
└── assets/               # só se um asset for realmente reutilizado
```

- `slug`: minúsculo, `kebab-case`, sem acentos (`ideia-agenda`, não `Ideia Agenda`).
- `token`: 8+ caracteres aleatórios (`openssl rand -hex 4`). Gerar, nunca inventar.
- Cada pasta tem `index.html` e, opcionalmente, `meta.json`:
  ```json
  { "title": "Nome", "desc": "Uma linha", "status": "idea|sketch|wip|done", "date": "2026-11-22" }
  ```

## Fluxo: criar uma nova página
1. Escolher a categoria (`ideas`, `sketches`, `u`, `p`). **Se não estiver claro, perguntar.**
2. Criar `<categoria>/<slug>/index.html` (+ `meta.json` se for listada).
3. Adicionar o `<head>` mínimo abaixo.
4. Se for `ideas/` ou `sketches/`: adicionar entrada no `index.html` do hub.
5. Se for `u/`: **não** listar no hub, **não** citar a URL em nenhum arquivo do repo; entregar a URL completa só na resposta ao usuário.
6. Testar localmente: `python3 -m http.server -d . 8000` e abrir a página.
7. Commit na branch de trabalho; publicar apenas via merge na branch configurada no Pages.

### `<head>` mínimo
```html
<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Título</title>
  <!-- só em u/ e p/: -->
  <meta name="robots" content="noindex, nofollow, noarchive">
</head>
```

## Privacidade — leia antes de colocar algo sensível
**GitHub Pages é público.** Se o repositório é público, o código-fonte também é. Níveis reais:

| Nível | Mecanismo | Protege contra | NÃO protege contra |
|---|---|---|---|
| Público | `ideas/`, `sketches/` + hub | — | — |
| Unlisted | `u/slug-token/` + `noindex` + `robots.txt` | Buscadores, navegação casual | Quem tem o link; repositório público expõe o caminho no código; `robots.txt` é público e revela pastas |
| Protegido | `p/` com conteúdo cifrado no cliente (StatiCrypt, AES-256) | Leitura sem senha | Senha fraca; metadados (título, tamanho) |
| Privado real | Repo privado + Pages privado (planos pagos) ou Cloudflare Access | Acesso não autorizado | — |

Regras:
- **Nunca** colocar em páginas públicas/unlisted: credenciais, tokens, dados pessoais, dados de clientes, informação sob NDA. "Semi-privado" = *não divulgado*, não *seguro*.
- Para o nível Protegido: cifrar com `npx staticrypt <arquivo>.html -p "<senha>" -d p/<slug>/` e commitar **apenas o HTML cifrado**. O original em texto claro fica fora do repo (ou em pasta ignorada via `.gitignore`).
- Se o conteúdo for realmente confidencial, recomendar repo privado ou Cloudflare Access em vez de contornar com ofuscação.
- Não colocar analytics/trackers/CDNs de terceiros em páginas `u/` e `p/` sem pedido.

## Convenções de código
- Mobile-first, um arquivo `index.html` com `<style>`/`<script>` inline quando < ~300 linhas; separar só se crescer.
- Caminhos relativos (`./app.js`), nunca absolutos (`/app.js`) — o site pode viver em subpath `/<repo>/`.
- Bibliotecas externas: via CDN com versão fixa (`lib@1.2.3`), nunca `latest`.
- Sem segredos no código. Chaves de API no front-end são públicas por definição.

## Hub (`index.html`)
- Lista simples e estática: título, descrição, status, data, link.
- Ordenar por data decrescente. Sem JS obrigatório.
- Quando passar de ~15 páginas, propor gerar o índice a partir dos `meta.json` (script ou GitHub Action) em vez de editar à mão.

## Ao receber um pedido do usuário
- Ambiguidade de categoria/privacidade/escopo → **perguntar antes de criar**.
- Sempre responder com: **o que** foi criado (caminho), **por que** nessa categoria, e a **URL final** (`https://<usuario>.github.io/<repo>/<caminho>/`).
- Apontar riscos de privacidade relevantes à página criada, em uma linha.
- Não renomear/mover/apagar páginas existentes sem confirmação (links externos podem depender delas).
