# Guia: gerar os enfeites da placa com IA

A IA de imagem não gera transparência. Por isso cada enfeite é gerado **sozinho, sobre um fundo de cor chapada**, e a página remove o fundo automaticamente (chroma key). Você não precisa editar nada: só salvar o arquivo na pasta `img/` com o nome certo.

## Opção rápida: UMA folha com tudo (recomendada)

Gere **uma única imagem** com todos os enfeites num fundo **azul `#0000FF`** e salve como `img/sheet.png` (ou `.jpg`/`.webp`). A página recorta cada elemento sozinha.

Por que azul e não verde: nenhum enfeite tem azul, e assim as folhas verdes das flores sobrevivem.

A posição importa: a página identifica cada elemento pelo **quadrante** onde ele está.

```
┌───────────────┬───────────────┐
│  GANSO        │  LAÇO ROSA    │
│  (esquerda)   │               │
├───────────────┼───────────────┤
│  FLORES       │  3 BORBOLETAS │
│               │  (lado a lado)│
└───────────────┴───────────────┘
```

### Prompt (cole inteiro)

```
A sprite sheet of four decorative elements for a baby shower, arranged in a strict
2x2 grid with clear empty space between all of them. Soft vintage watercolor
children's book illustration, delicate hand-painted look, gentle pastel colors,
thin soft outline in a slightly darker tone of each color, cute and charming.

TOP-LEFT quadrant: a single plump white goose standing, strict side view facing LEFT,
full body from head to webbed feet, cream-white feathers, rounded chubby body, short
upturned tail, folded wing with a few drawn feathers, small black eye with a tiny
highlight, pink cheek blush, orange beak and orange feet, a pink and white
gingham-checkered ribbon bow tied around the neck.

TOP-RIGHT quadrant: a single large satin ribbon bow in pale baby pink, symmetrical,
front view, two big loops, a center knot and two ribbon tails hanging down.

BOTTOM-LEFT quadrant: a compact bouquet of three or four pastel pink flowers with
yellow centers, sage-green leaves and tiny buds, leaves fanning out from the bottom.

BOTTOM-RIGHT quadrant: three golden-yellow butterflies with wings fully open, top-down
view, delicate darker veins, thin brown body and antennae, side by side, each one in a
different size and a slightly different rotation.

Each element stays fully inside its own quadrant and never touches another element or
the image edge. Every element is a separate isolated object, nothing overlaps.

BACKGROUND: perfectly flat, uniform, solid pure blue (#0000FF), like a blue screen,
across the entire image. No gradient, no shadows on the ground, no reflections, no
vignette, no paper texture, no grid lines, no labels, no text, no frame, no border.
None of the elements contains any blue.
```

Formato: landscape (3:2 ou 4:3) ou quadrado, o maior que a IA oferecer.

### Se a IA não obedecer à grade
1. Peça de novo com "strictly arranged in a 2x2 grid, one element per quadrant".
2. Se ainda vier torto, gere em **duas folhas**: uma só com ganso + laço (fundo azul) e outra com flores + borboletas, e me mande as duas. Eu ajusto o recorte.
3. Se um elemento sair no quadrante errado, a página o ignora ou o troca de lugar. A linha "Imagens: …" sob "Enfeites" mostra o que foi detectado (ex.: `borboleta(s) ×3`).

### Sobre as 3 borboletas
Cada borboleta é um sprite separado, e a página usa uma diferente em cada posição da placa. Isso evita aquela cara de "copiar e colar".

---

## Alternativa: um arquivo por elemento

Use se a folha única não ficar boa. Arquivos individuais **têm prioridade** sobre a folha (dá para consertar só um elemento).

## Resumo dos 4 arquivos

| Arquivo (em `img/`) | O que é | Fundo | Obs. |
|---|---|---|---|
| `goose.png` | Ganso com laço xadrez rosa | **Verde `#00FF00`** | virado para a **esquerda** (a página espelha sozinha) |
| `butterfly.png` | Borboleta amarela, asas abertas, vista de cima | **Verde `#00FF00`** | |
| `bow.png` | Laço rosa grande com fitas | **Verde `#00FF00`** | |
| `flowers.png` | Buquê de flores rosa com folhas verdes | **Azul `#0000FF`** | folhas são verdes, então o fundo NÃO pode ser verde |

Extensões aceitas: `.png`, `.webp`, `.jpg`. Pode ser JPG mesmo (a remoção tolera a compressão).

## Regra de ouro
- O fundo é uma cor **100% chapada e pura**. Sem degradê, sem sombra no chão, sem vinheta, sem textura de papel.
- O **objeto não pode conter a cor do fundo**. Por isso as flores (que têm folhas verdes) usam fundo azul.
- Um enfeite por imagem. Imagem quadrada, 1024×1024 ou maior, com margem generosa em volta (o objeto ocupa ~70% do quadro).
- Sem texto, sem moldura, sem borda, sem sombra projetada.

## Bloco de estilo (cole no início de TODOS os prompts)

```
Soft vintage watercolor children's book illustration, delicate hand-painted look,
gentle pastel colors, subtle paper-grain texture inside the subject only, thin soft
outline in a slightly darker tone of each color, cute and charming, baby shower style.
```

## Bloco de fundo (cole no FIM de cada prompt)

Para os arquivos com fundo **verde**:
```
The subject is isolated on a perfectly flat, uniform, solid pure green background
(#00FF00), like a green screen. No gradient, no shadow on the ground, no reflections,
no vignette, no texture on the background. The subject contains absolutely no green.
Centered, full subject visible, generous empty margin around it, square image.
No text, no frame, no border.
```

Para as **flores** (fundo azul):
```
The subject is isolated on a perfectly flat, uniform, solid pure blue background
(#0000FF), like a blue screen. No gradient, no shadow on the ground, no reflections,
no vignette, no texture on the background. The subject contains no blue.
Centered, full subject visible, generous empty margin around it, square image.
No text, no frame, no border.
```

---

## 1) `goose.png` — ganso

```
[BLOCO DE ESTILO]
A single plump white goose standing, side view, body and head facing LEFT, full body
visible from head to webbed feet. Cream-white feathers with soft shading, rounded chubby
body, short upturned tail, folded wing with a few drawn feathers, small black eye with a
tiny highlight, pink rosy cheek blush, orange beak, orange webbed feet. A pink and white
gingham-checkered ribbon bow tied around the neck. Calm sweet expression.
[BLOCO DE FUNDO VERDE]
```
Dicas: se vier de 3/4 ou virado para a direita, peça "strictly side profile, facing left" ou espelhe a imagem antes de salvar. Se o ganso sair com cinza/verde nas penas, peça "warm cream white feathers, no green or gray tint".

## 2) `butterfly.png` — borboleta

```
[BLOCO DE ESTILO]
A single butterfly with wings fully open, top-down view, perfectly symmetrical.
Golden yellow and soft ochre wings with delicate darker veins and subtle cream spots on
the edges, thin brown body, two thin curved antennae. Elegant and delicate.
[BLOCO DE FUNDO VERDE]
```
Dica: peça 2 ou 3 versões e salve só a melhor como `butterfly.png`. Hoje a página usa um único arquivo, espelhado/rotacionado para variar.

## 3) `bow.png` — laço rosa

```
[BLOCO DE ESTILO]
A single large satin ribbon bow in pale baby pink, symmetrical, front view, two big
loops, a center knot and two ribbon tails hanging down with gently curved ends.
Soft fabric folds and subtle highlights, delicate and elegant.
[BLOCO DE FUNDO VERDE]
```

## 4) `flowers.png` — flores

```
[BLOCO DE ESTILO]
A small cluster of three or four pastel pink flowers with yellow centers and a few
sage-green leaves and tiny buds, arranged as a compact corner bouquet, slightly
asymmetrical, leaves fanning out from the bottom.
[BLOCO DE FUNDO AZUL]
```

---

## Conferindo antes de salvar
- [ ] Fundo é uma cor única, sem degradê nem sombra no chão?
- [ ] O objeto não toca as bordas da imagem?
- [ ] Nenhuma parte do objeto tem a cor do fundo (verde no ganso/borboleta/laço, azul nas flores)?
- [ ] Ganso virado para a esquerda?
- [ ] Nome do arquivo exato: `goose`, `butterfly`, `bow`, `flowers`?

## Problemas comuns
| Sintoma | Causa | Solução |
|---|---|---|
| Contorno esverdeado ao redor do ganso | IA deixou o fundo com tom irregular ou o objeto reflete verde | Peça "flat uniform pure #00FF00, no color spill, no rim light" |
| Buraco no objeto | O objeto tem partes verdes (azuis nas flores) | Troque a cor do fundo ou do objeto |
| Sombra cinza sob o ganso virou mancha | IA pôs sombra no chão | Repita com "no ground shadow, floating subject" |
| Imagem veio com xadrez de "transparência" falso | IA desenhou o padrão de PNG transparente | Não serve; insista no fundo verde chapado |
| Tamanho estranho | O recorte usa a área ocupada pelo objeto | Pode ser ajustado em `SPRITES` no `index.html` |

## Como testar
1. Salve os arquivos (`sheet` e/ou individuais) em `sketches/gerador-placa/img/`.
2. `python3 -m http.server -d . 8000` na raiz e abra `/sketches/gerador-placa/`.
   (Abrir o `index.html` direto por `file://` não funciona: o navegador bloqueia a leitura dos pixels.)
3. Sob "Enfeites", a linha "Imagens carregadas: …" mostra o que foi detectado. O que não existir continua vetorial.
