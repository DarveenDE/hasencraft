# Designkonzept – hasencraft.github.io

Gestaltungsgrundlage für die öffentliche Seite unter
<https://darveende.github.io/hasencraft/>. Umgesetzt in
[`hosting/pages/index.html`](../hosting/pages/index.html); die Versionswerte
setzt [`scripts/build-pages.ps1`](../scripts/build-pages.ps1) beim Bauen ein.

## 1. Aufgabe der Seite

Die Seite hat genau eine Hauptaufgabe: **jemanden ohne Vorwissen in wenigen
Minuten von „interessant“ zu „spielt mit“ bringen.** Alles andere – Feeds,
Prüfsummen, Modliste – ist Sekundärinhalt und darf den Weg dorthin nicht
verstellen.

Daraus folgen drei Leitsätze:

1. **Ein Ziel pro Bildschirm.** Der Hero verkauft, der Installationsblock
   handelt, der Rest beantwortet Rückfragen.
2. **Vertrauen durch Konkretheit.** Echte Versionsnummern, echte Hardwareklassen,
   echte Mod-Namen statt Werbefloskeln.
3. **Technik hinter einer Klappe.** Wer sie sucht, findet sie; wer sie nicht
   braucht, sieht sie nicht.

## 2. Markenfundament

Die Marke wird nicht neu erfunden, sondern aus dem bestehenden Pack-Icon
(`launcher/hasencraft.png`) abgeleitet: Pixelhase vor Nachtwald, Sonnenuntergang,
Biene, Zahnrad. Das Icon liegt als `hosting/pages/assets/hasencraft.png` und
dient gleichzeitig als Wortmarke-Begleiter, Favicon und Open-Graph-Bild.

**Tonalität:** warm, ruhig, kompetent. Gemütlich heißt nicht kindlich – die
Seite darf technisch klingen, aber nie einschüchternd. Durchgehend Duzen,
durchgehend Deutsch.

## 3. Farbsystem

Nachtwald als Grundton, Honig als einzige laute Farbe. Die Seite ist bewusst
**nur dunkel**: Das Pack spielt abends, das Icon ist eine Nachtszene, und ein
zweites Theme wäre doppelte Pflege ohne Nutzen.

| Token | Wert | Rolle |
|---|---|---|
| `--ink` | `#0d1310` | Seitenhintergrund |
| `--night` | `#111a15` | abgesetzte Bänder, Footer |
| `--surface` / `--surface-2` | `#18241e` / `#1f2d25` | Karten |
| `--line` / `--line-soft` | `#2c4034` / `#223126` | Rahmen, Trennlinien |
| `--cream` | `#f7efe6` | Fließtext, Überschriften |
| `--muted` | `#b6aa9f` | Sekundärtext |
| `--honey` | `#f6c453` | primäre Aktion, Akzent „Fluffy“ |
| `--teal` | `#5fb3a8` | Akzent „Cozy“ |
| `--moss` | `#8ec96f` | Links, Erfolgszustände, Schrittzähler |
| `--copper` | `#d1813f` | Sonnenuntergang, Akzent „Technik“ |
| `--blush` | `#f4b7c3` | Wortmarke, Akzent „Tiere“ |

**Regeln:**

- Honig ist reserviert. Pro Bildschirm höchstens eine honigfarbene Fläche, sonst
  verliert der Installations-Button seine Wirkung.
- Fluffy trägt Honig, Cozy trägt Teal – konsequent über Rahmen, Icon, Aufzählung
  und Button hinweg. Die Farbe erklärt die Wahl schneller als der Text.
- Text auf Farbfläche ist immer dunkel (`#14190f` / `#06201d`), nie weiß.
- Alle Text-/Hintergrundpaare liegen über WCAG AA (Fließtext ≥ 4,5:1,
  Sekundärtext auf Karte ≈ 7:1).

## 4. Typografie

Systemschriftstapel (`system-ui`), bewusst ohne Webfont: keine externen
Requests, kein Datenabfluss, kein Ladeflackern. Der Minecraft-Bezug kommt aus
Pixelgrafik und Farbe, nicht aus einer Pixelschrift – die wäre bei Fließtext
kaum lesbar.

- **Hero:** `clamp(2.9rem … 5.4rem)`, 800, Laufweite `-0.035em`. Zweigeteilt:
  „Bau mit.“ in Creme, „Hasencraft.“ in Blush mit 4-px-Versatzschatten in Kupfer
  – ein Blockschatten als Zitat der Pixeloptik.
- **Abschnittstitel:** `clamp(1.8rem … 2.7rem)`, 800, darüber ein „Kicker“ in
  Moos oder Honig (0,8 rem, Versalien, Sperrung `0.14em`).
- **Fließtext:** `clamp(1rem … 1.075rem)`, Zeilenhöhe 1,65, Zeilenlänge maximal
  ~60 Zeichen (`max-width: 46ch` im Hero, `60ch` in Einleitungen).
- `text-wrap: balance` für Überschriften, `pretty` für Absätze.

## 5. Layout

- Inhaltsbreite `min(100% - 2.5rem, 1080px)`, durchgehend zentriert.
- Vertikaler Rhythmus über `clamp(3.5rem … 6rem)` Bandabstand; abwechselnd
  `--ink` und ein leicht aufgehellter Verlauf (`.band--tint`), damit sich die
  Abschnitte ohne harte Trennlinien voneinander abheben.
- Raster: Mobile einspaltig, 700 px zweispaltig, 1000 px dreispaltig. Die
  Profilkarten wechseln bei 820 px auf zwei Spalten – vorher wird der
  Vergleich zu schmal.
- Sticky-Topbar (64 px) mit Blur; `scroll-margin-top: 84px` an allen
  Sprungzielen, damit Ankerlinks nicht unter der Leiste landen.

## 6. Bausteine

| Baustein | Zweck | Merkmale |
|---|---|---|
| **Topbar** | Orientierung + Statusanzeige | Marke links, Ankernavigation ab 860 px, Versions-Pille mit grünem Punkt als Live-Signal |
| **Hero** | Emotion + Einstieg | Pixelwald-Szene, zwei Aktionen (primär/sekundär) |
| **Faktenband** | Vertrauen in vier Zahlen | Vollbreites Raster, 1-px-Fugen, Werte aus `pack.toml` |
| **Schrittliste** | Angst vor Installation nehmen | Drei nummerierte Karten, CSS-Counter, jeweils ein Satz |
| **Profilkarte** | die eine echte Entscheidung | Akzentleiste oben, Hardware-Einordnung, drei Spezifikationen, ganzbreiter Kopierknopf, Alternativlink zum ZIP |
| **Hinweis-Note** | Missverständnisse abfangen | Honigrahmen links, genau eine Aussage |
| **Inhaltskarte** | Lust machen | Icon in Themenfarbe, zwei Sätze, Mod-Chips als Belege |
| **Galeriekachel** | zeigen statt behaupten | Bild 16:9 (breite Kachel 21:9), Vignette, Titel, Bildunterschrift, Meta-Chips |
| **Wissenskarte** | Support-Fälle vermeiden | Icon + Titel + Erklärung, vier Stück |
| **Technik-Akkordeon** | Tiefe ohne Ballast | `<details>`, zugeklappt als Standard |

**Kopierknopf** – das Kernstück der Seite:
Klick kopiert die Importadresse, der Knopf wechselt für 2,6 s auf „Kopiert!“ in
Moosgrün, darunter erscheint die Anweisung für den nächsten Schritt in Prism.
Scheitert der Zugriff auf die Zwischenablage (kein HTTPS, restriktiver Browser),
erscheint automatisch ein vorausgewähltes Textfeld mit der Adresse. Zusätzlich
steht dieselbe Adresse als normaler Download-Link daneben – der Weg bricht nie
ab.

## 7. Grafiksprache

Alle Grafiken sind **Inline-SVG oder CSS**, kein externes Bildmaterial außer dem
Pack-Icon:

- **Pixelwald:** ein `<symbol>` mit gestufter Nadelbaum-Silhouette, per `<use>`
  in zwei Ebenen gestreut (fern `--pine-far`, nah `--pine-near`). Das ergibt
  Tiefe bei ~2 KB Markup und skaliert per `preserveAspectRatio="slice"` von
  Handy bis Ultrawide.
- **Himmel:** drei überlagerte Verläufe – Kupferglühen unten rechts als
  Sonnenuntergang, kühler Teal-Schimmer oben links, dunkler Grundverlauf.
- **Glühwürmchen:** drei 4–5 px große Honigquadrate mit langsamer Drift.
- **Icons:** einheitlich 24×24 Strichzeichnungen, Strichstärke 2, runde
  Enden – neutral genug, um nicht mit der Pixeloptik zu konkurrieren.
- **Galeriebilder:** die einzigen Fotos der Seite. Sie stehen bewusst nur in der
  Galerie – im Hero und in den Karten bleibt es bei Vektorgrafik, damit die
  Screenshots ihre Wirkung nicht mit anderen Bildern teilen müssen.

## 7a. Bildrechte

Screenshots und Galeriebilder von Modrinth oder CurseForge gehören den jeweiligen
Mod-Autorinnen und -Autoren und dürfen hier nicht eingebunden werden – weder als
Datei noch per Hotlink. Auf die Seite kommen ausschließlich **eigene Aufnahmen
aus der eigenen Welt** oder selbst gezeichnete Grafiken. Deshalb sind die
Platzhalter gezeichnet und nicht geliehen.

Vor dem Veröffentlichen eines Bildes gehört die Frage beantwortet, wo es
herkommt. Ein Anhaltspunkt: Minecraft speichert Screenshots als PNG in
Fenstergröße. Eine kleine, web-optimierte JPEG- oder WebP-Datei stammt fast immer
von einer Website und nicht aus dem eigenen `screenshots`-Ordner.

## 8. Bewegung

Sparsam und funktional: 120–200 ms bei Hover und Zustandswechsel, 2 px Anheben
bei Karten und Knöpfen, sanftes Scrollen bei Ankersprüngen. Die einzige
Dauerbewegung sind die Glühwürmchen. `prefers-reduced-motion: reduce` schaltet
sämtliche Animationen, Transitions und das Smooth-Scrolling ab.

## 9. Barrierefreiheit

- Skip-Link direkt zur Installation als erstes fokussierbares Element.
- Sichtbarer Fokusring (3 px Honig, 3 px Abstand) auf allen interaktiven
  Elementen.
- Statusmeldung des Kopiervorgangs als `role="status"` mit `aria-live="polite"`.
- Dekorative Grafiken `aria-hidden`, Icons ohne eigene Bedeutung ohne Label.
- Semantik statt Optik: `<ol>` für Schritte, `<dl>` für Fakten, `<details>` für
  das Akkordeon, eine `<h1>` und danach saubere `<h2>`/`<h3>`-Folge.
- Klickflächen ≥ 44 px Höhe.

## 10. Technische Leitplanken

- **Eine Datei, null externe Requests.** CSS und JS inline, keine Webfonts,
  keine Analytics, keine CDN-Abhängigkeit. Das hält die Seite schnell, DSGVO-arm
  und unabhängig von fremder Verfügbarkeit.
- **Platzhalter bleiben der Vertrag** zwischen Seite und Build:
  `__STABLE_VERSION__`, `__FLUFFY_IMPORT_URL__`, `__COZY_IMPORT_URL__` sowie neu
  `__MINECRAFT_VERSION__` und `__NEOFORGE_VERSION__` (aus der `pack.toml` des
  Stable-Snapshots). `build-pages.ps1` bricht ab, wenn nach dem Ersetzen noch
  ein Platzhalter übrig ist – eine halbfertige Seite geht nicht live.
- **Relative Pfade**, weil die Seite unter dem Unterpfad `/hasencraft/` liegt.
  Absolut nur dort, wo es sein muss (Open-Graph-Bild).
- **Kein Framework, kein Build-Schritt für Assets.** Der Pages-Workflow kopiert
  `hosting/pages/*` unverändert; neue Assets einfach dort ablegen.
- Progressive Enhancement: ohne JavaScript funktionieren Navigation, Akkordeon
  und die ZIP-Links weiterhin, nur das Kopieren per Knopf entfällt.

## 11. Seitenaufbau

```text
Topbar        Marke · Ankernavigation · Stable-Version
Hero          Pixelwald · „Bau mit. Hasencraft.“ · zwei Aktionen
Faktenband    Mods · Minecraft · NeoForge · Updates
Installation  drei Schritte → Fluffy/Cozy → Hinweis „gleiche Inhalte“
Inhalte       sechs Themenkarten mit Mod-Belegen
Bilder        fünf Galeriekacheln mit eigenen Screenshots
Gut zu wissen vier Karten gegen die häufigsten Stolperfallen
Technik       Akkordeon: Feeds · Releases · Modquellen · Hilfe
Footer        Rechtehinweis · GitHub · Releases · Prism
```

## 12. Galerie: Belegung und Pflege

Die fünf Kacheln sind bewusst unterschiedlich – Weite, Nähe, hell, dunkel,
Technik, Leben. Eine Galerie aus fünf Landschaftsbildern langweilt, egal wie
schön die einzelnen sind.

| # | Motiv | Format | Datei |
|---|---|---|---|
| 1 | Aether-Landschaft mit schwebenden Felsen | 21:9 | `galerie-aether.webp` |
| 2 | Turm mit Portalen am Fluss | 16:9 | `galerie-magierturm.webp` |
| 3 | Wabenwand im Gegenlicht | 16:9 | `galerie-bienen.webp` |
| 4 | Morgennebel, Fernsicht bis zum Horizont | 16:9 | `galerie-fernsicht.webp` |
| 5 | Create-Pressenstraße im Betrieb | 16:9 | `galerie-create.webp` |

**Aufteilung:** Kachel 1 ist breit und spannt beide Spalten, die übrigen vier
füllen zwei Reihen zu je zwei. Fünf Bilder gehen in diesem Raster genau auf –
bei sechs bliebe eine Reihe halb leer. Wer eine Kachel ergänzt, ergänzt am
besten gleich zwei.

**Rhythmus:** hell neben dunkel. Kachel 2 (dunkler Turm) steht neben Kachel 3
(warme Wabenwand), Kachel 4 (heller Dunst) neben Kachel 5 (grüne Wiese). Wer
tauscht, sollte diesen Wechsel erhalten.

### Ein Bild austauschen oder ergänzen

**Aufnehmen:** HUD mit `F1` aus, Perspektive mit `F5`, Auslöser `F2`. Die Bilder
liegen im `screenshots`-Ordner der Instanz und überstehen Pack-Updates.

**Aufbereiten:** auf 1920 px Breite (breite Kachel) beziehungsweise 1280 px
(normale Kacheln) skalieren, als WebP unter 250 KB ablegen:

```bash
ffmpeg -i rohbild.png -vf scale=1280:-2 -c:v libwebp -quality 78 -preset picture hosting/pages/assets/galerie-basis.webp
```

**Einbauen:**

```html
<figure class="shot">
  <div class="shot__frame">
    <img src="assets/galerie-basis.webp" width="1280" height="720" loading="lazy" decoding="async"
         alt="Holzhütte mit erleuchteten Fenstern und Laternen am Waldrand in der Dämmerung">
  </div>
  <figcaption>
    <strong>Einladung, keine Bildunterschrift</strong>
    <p>Ein bis zwei Sätze darüber, was du erleben wirst – nicht darüber, was im Bild zu sehen ist.</p>
    <ul class="shot__meta"><li>Mod</li><li>Mod</li><li>Mod</li></ul>
  </figcaption>
</figure>
```

`shot--wide` nur für die breite Kachel. Der Zuschnitt passiert per CSS
(`aspect-ratio` am Rahmen, `object-fit: cover`), das Bild muss also nicht
vorgeschnitten werden – wichtig ist nur, dass das Motiv mittig sitzt.

### Textregel für die Galerie

Das Bild zeigt schon, was zu sehen ist. Der Text daneben hat eine andere
Aufgabe – er soll Lust machen, nicht beschreiben.

| Feld | Aufgabe | Beispiel |
|---|---|---|
| `<strong>` | Einladung, gern in zweiter Person | „Lauf einfach los“ statt „Morgennebel bis zum Horizont“ |
| `<p>` | was du damit erleben wirst | „Der Berg am Horizont ist wirklich da, und du kannst hin.“ |
| `shot__meta` | welche Mods dahinterstecken | `Distant Horizons` · `Complementary Reimagined` |
| `alt` | **hier** gehört die sachliche Beschreibung hin | „Sonnenaufgang über bewaldeten Hügeln, Nebel in den Tälern“ |

Die Beschreibung verschwindet also nicht, sie wandert nur dorthin, wo sie
gebraucht wird: in den `alt`-Text für alle, die das Bild nicht sehen.
Aufnahmedaten wie „Gegenlicht“ oder „16:9“ gehören in keinen der Felder – das
interessiert beim Bauen der Seite, nicht beim Lesen.

## 13. Bewusst nicht enthalten

- **Fremde Mod-Screenshots.** Siehe Abschnitt 7a – rechtlich nicht sauber und
  inhaltlich schwächer als eigene Bilder aus der eigenen Welt.
- **Serveradresse.** Bleibt bewusst in der Community, nicht auf einer
  öffentlichen Seite.
- **Helles Theme, Sprachumschalter, Newsbereich.** Pflegeaufwand ohne aktuellen
  Nutzen.
- **Lightbox / Vollbildgalerie.** Erst sinnvoll, wenn die Galerie deutlich
  wächst; bei fünf Bildern ist der Aufwand höher als der Gewinn.

## 14. Naheliegende nächste Schritte

1. **Zwei weitere Bilder** – die gemeinsame Basis zur blauen Stunde und ein
   Tiermotiv auf Augenhöhe. Damit wächst die Galerie auf sieben Kacheln und das
   Raster geht wieder auf.
2. **Changelog-Auszug** auf der Seite, gespeist aus `CHANGELOG.md`, damit
   Rückkehrende sehen, was das letzte Update gebracht hat.
3. **Statusanzeige des Servers**, falls es je einen erreichbaren Endpunkt gibt –
   die Versions-Pille ist dafür schon als Signalfläche angelegt.
