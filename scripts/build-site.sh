#!/usr/bin/env bash
# Monta _site/ a partir da allowlist (publish.txt) e valida regras de privacidade.
# Uso: scripts/build-site.sh [pasta-saida]   (falha com exit 1 se alguma regra for violada)
set -euo pipefail
OUT="${1:-_site}"
fail=0
err(){ echo "::error::$*"; fail=1; }

rm -rf "$OUT"; mkdir -p "$OUT"

# 1) copia somente o que está na allowlist
while IFS= read -r line; do
  line="${line%%#*}"; line="$(echo "$line" | xargs || true)"
  [ -z "$line" ] && continue
  case "$line" in /*|*..*) err "caminho inválido em publish.txt: $line"; continue;; esac
  if [ -e "$line" ]; then cp -R --parents "$line" "$OUT"/; else echo "ignorado (não existe): $line"; fi
done < publish.txt
touch "$OUT/.nojekyll"

# 2) remove lixo/documentação interna mesmo dentro de pastas permitidas
find "$OUT" \( -name '*.md' -o -name '.gitkeep' -o -name '.DS_Store' -o -name '*.map' \) -type f -delete

# 3) arquivos que nunca devem ir ao site
bad=$(find "$OUT" -type f \( -name '.env*' -o -name '*.pem' -o -name '*.key' -o -name 'id_rsa*' -o -name '*.p12' -o -name '*.sqlite' -o -name '*.local.html' \) || true)
[ -n "$bad" ] && err "arquivo sensível na saída: $bad"

# 4) padrões de segredo no conteúdo
hits=$(grep -rIlE 'AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{40,}|-----BEGIN [A-Z ]*PRIVATE KEY-----|sk-[A-Za-z0-9]{32,}|xox[baprs]-[A-Za-z0-9-]{10,}' "$OUT" || true)
[ -n "$hits" ] && err "possível segredo em: $hits"

# 5) u/ (unlisted): nome com token, noindex, e nunca referenciado no hub/robots
if [ -d "$OUT/u" ]; then
  for d in "$OUT"/u/*/; do
    [ -d "$d" ] || continue
    n=$(basename "$d")
    echo "$n" | grep -Eq '^[a-z0-9-]+-[0-9a-f]{8,}$' || err "u/$n: nome deve ser <slug>-<token hex de 8+>"
    grep -rIqi 'name="robots"[^>]*noindex' "$d" --include='*.html' || err "u/$n: falta <meta name=\"robots\" content=\"noindex...\">"
    for f in "$OUT/index.html" "$OUT/robots.txt"; do
      [ -f "$f" ] && grep -q "$n" "$f" && err "u/$n: URL vazada em $(basename "$f")"
    done
  done
  for f in "$OUT/index.html" "$OUT/robots.txt"; do
    [ -f "$f" ] && grep -Eq '(^|[^a-z])/?u/' "$f" && err "$(basename "$f") não pode citar /u/ (revela a pasta)"
  done
fi

# 6) p/ (protegido): conteúdo precisa estar cifrado (StatiCrypt) e com noindex
if [ -d "$OUT/p" ]; then
  while IFS= read -r f; do
    grep -qi 'staticrypt' "$f" || err "$f: página em p/ não está cifrada (StatiCrypt)"
    grep -qi 'noindex' "$f" || err "$f: página em p/ sem noindex"
  done < <(find "$OUT/p" -name '*.html' -type f)
fi

# 7) limite de tamanho (Pages: 1 GB; aqui 100 MB p/ evitar acidentes)
kb=$(du -sk "$OUT" | cut -f1)
[ "$kb" -gt 102400 ] && err "site com ${kb} KB (> 100 MB)"

echo "--- publicado em $OUT ($kb KB) ---"; (cd "$OUT" && find . -type f | sort | head -100)
[ "$fail" -eq 0 ] || { echo "BUILD BLOQUEADO: regras de privacidade violadas."; exit 1; }
