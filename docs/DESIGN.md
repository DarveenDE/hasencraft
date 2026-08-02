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

Maßgeblich ist [`docs/BRANDING.md`](BRANDING.md) – dieses Dokument setzt die
Marke um, es definiert sie nicht. Von dort kommen Leitsatz, Wortmarke und
Farbwerte; die Seite ergänzt nur, was zum Bauen einer Website fehlt
(Flächenhierarchie, abgeleitete Grautöne, Kontrastvarianten).

Übernommen werden:

- **Leitsatz** „Gemütlich bauen. Weit entdecken." als Hero-Eyebrow.
- **Wortmarke** `assets/hasencraft-wordmark.png` als `<h1>`-Bild, mit
  `visually-hidden`-Textalternative „Hasencraft".
- **Emblem** `assets/hasencraft.png` in der Topbar, als Favicon und
  Apple-Touch-Icon.
- **Panorama** `assets/hasencraft-panorama.webp` als Hero-Hintergrund –
  dasselbe Bild, das im Spiel den Titelbildschirm trägt. Wer die Seite
  besucht und danach das Spiel startet, sieht dieselbe Szene wieder.

**Tonalität:** warm, ruhig, kompetent. Gemütlich heißt nicht kindlich – die
Seite darf technisch klingen, aber nie einschüchternd. Durchgehend Duzen,
durchgehend Deutsch.

## 3. Farbsystem

Petrol als Grundton, Honig als einzige laute Farbe. Die Seite ist bewusst
**nur dunkel**: Das Pack spielt abends, Panorama und Emblem sind Nachtszenen,
und ein zweites Theme wäre doppelte Pflege ohne Nutzen.

Die ersten sechs Werte stammen unverändert aus `BRANDING.md`, der Rest ist
daraus abgeleitet:

| Token | Wert | Herkunft | Rolle |
|---|---|---|---|
| `--ink` | `#071e1c` | Nachtpetrol | Seitenhintergrund |
| `--surface` | `#0d2b28` | Panel-Petrol | Karten |
| `--teal` | `#2f8378` | Teal | Rahmen, Deko |
| `--honey` | `#ffd166` | Honig | primäre Aktion, Akzent „Fluffy“ |
| `--copper` | `#d97941` | Kupfer | Akzent „Technik“ |
| `--cream` | `#fff6e5` | Fellcreme | Fließtext, Überschriften |
| `--night` / `--surface-2` | `#0a2523` / `#123531` | abgeleitet | Bänder, erhöhte Karten |
| `--line` / `--line-soft` | `#1d4a44` / `#163a35` | abgeleitet | Rahmen, Trennlinien |
| `--muted` | `#a8bdb8` | abgeleitet | Sekundärtext |
| `--teal-bright` | `#57b3a6` | aufgehellt | Flächen mit dunklem Text, Akzent „Cozy“ |
| `--moss` | `#8ec96f` | ergänzt | Links, Schrittzähler, Akzent „Eco“ |
| `--blush` | `#f4b7c3` | ergänzt | Akzent „Tiere“ |

**Regeln:**

- Honig ist reserviert. Pro Bildschirm höchstens eine honigfarbene Fläche, sonst
  verliert der Installations-Button seine Wirkung.
- Fluffy trägt Honig, Cozy trägt helles Teal, Eco trägt Moos – konsequent über
  Rahmen, Icon, Beschriftung und Button hinweg. Die Farbe erklärt die Wahl
  schneller als der Text.
- Text auf Farbfläche ist immer dunkel, nie weiß. Jede Akzentfarbe bringt ihren
  eigenen Textton mit (`--accent-ink`).
- **Das Marken-Teal `#2f8378` trägt keinen Text.** Gegen dunklen Text kommt es
  nur auf 3,8:1 und reißt damit AA. Für Flächen mit Beschriftung gibt es
  `--teal-bright`; das Marken-Teal bleibt Rahmen, Icon und Dekoration.
- Gemessene Werte: Fließtext 16,2:1, Knopfbeschriftungen 12,9:1 (Fluffy),
  6,8:1 (Cozy) und 8,7:1 (Eco).

## 4. Typografie

Systemschriftstapel (`system-ui`), bewusst ohne Webfont: keine externen
Requests, kein Datenabfluss, kein Ladeflackern. Der Minecraft-Bezug kommt aus
Pixelgrafik und Farbe, nicht aus einer Pixelschrift – die wäre bei Fließtext
kaum lesbar.

- **Hero:** die Wortmarke als Bild (`width: min(100%, 30rem)`), darüber der
  Leitsatz als Eyebrow. Kein gesetzter Titel – die Wortmarke *ist* die
  Überschrift; der Textinhalt der `<h1>` steckt in einem `visually-hidden`-Span.
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
- Raster: Mobile einspaltig, 700 px zweispaltig, 1000 px dreispaltig. Die drei
  Profilkarten springen erst bei 940 px auf drei Spalten und bleiben davor
  untereinander – zwei nebeneinander plus ein Waisenkind wäre schlechter
  vergleichbar als eine saubere Reihe.
- Sticky-Topbar (64 px) mit Blur; `scroll-margin-top: 84px` an allen
  Sprungzielen, damit Ankerlinks nicht unter der Leiste landen.

## 6. Bausteine

| Baustein | Zweck | Merkmale |
|---|---|---|
| **Topbar** | Orientierung + Statusanzeige | Marke links, Ankernavigation ab 860 px, Versions-Pille mit grünem Punkt als Live-Signal |
| **Hero** | Emotion + Einstieg | Panorama aus dem Titelbildschirm, Wortmarke, zwei Aktionen |
| **Faktenband** | Vertrauen in vier Zahlen | Vollbreites Raster, 1-px-Fugen, Werte aus `pack.toml` |
| **Schrittliste** | Angst vor Installation nehmen | Drei nummerierte Karten, CSS-Counter, jeweils ein Satz |
| **Profilkarte** | die eine echte Entscheidung | Akzentleiste oben, Block „Mindestens empfohlen“ (Grafik als AMD/NVIDIA-Paar, RAM, was das Profil setzt), ganzbreiter Kopierknopf, Alternativlink zum ZIP |
| **Hinweis-Note** | Missverständnisse abfangen | Honigrahmen links, genau eine Aussage |
| **Inhaltskarte** | Lust machen | Icon in Themenfarbe, zwei Sätze, Mod-Chips als Belege |
| **Galeriekachel** | zeigen statt behaupten | Bild 16:9 (breite Kachel 21:9), Vignette, Titel, Bildunterschrift, Meta-Chips |
| **Wissenskarte** | Support-Fälle vermeiden | Icon + Titel + Erklärung, vier Stück |
| **Technik-Akkordeon** | Tiefe ohne Ballast | `<details>`, zugeklappt als Standard |

**Kopierknopf** – das Kernstück der Seite:
Klick kopiert die Importadresse; der Knopf bekommt für 2,6 s einen cremefarbenen
Innenring und die Beschriftung „Kopiert!“, darunter erscheint die Anweisung für
den nächsten Schritt in Prism. Der Erfolgszustand hat bewusst **keine** eigene
Farbe – Eco ist bereits moosgrün, eine grüne Bestätigung wäre dort unsichtbar.
Jeder Knopf hat seinen eigenen Timer, und ein Klick setzt zuerst alle anderen
zurück: In der Zwischenablage liegt nur eine Adresse, also darf auch nur ein
Knopf bestätigt aussehen.
Scheitert der Zugriff auf die Zwischenablage (kein HTTPS, restriktiver Browser),
erscheint automatisch ein vorausgewähltes Textfeld mit der Adresse. Zusätzlich
steht dieselbe Adresse als normaler Download-Link daneben – der Weg bricht nie
ab.

## 7. Grafiksprache

Bilder tragen die Stimmung, Vektorgrafik die Struktur. Ein einziges Foto-Asset
trägt Hero und Profilkarten:

- **Panorama:** dasselbe Bild, das im Spiel den Titelbildschirm trägt, als
  Hero-Hintergrund mit radialem Scrim links. Ein früher hier gezeichneter
  Pixelwald ist entfallen; das echte Panorama sagt dasselbe besser und
  verbindet Seite und Spielstart.
- **Kopfband der Profilkarten:** jede Karte trägt ihr eigenes Bild, ausgewählt
  nach Bedeutung – Weitsicht für Fluffy, die gemütliche Hütte für Cozy, eine
  ruhige Wiese für Eco. Alle drei sind bereits für Hero oder Galerie geladen,
  es kommt also kein Download dazu.
  **Die Verlaufsstopps stehen in Pixeln, nicht in Prozent** (84 / 148 / 172 px).
  Nur so ist das Band in allen drei Karten gleich hoch; mit Prozentwerten würde
  es mit der Textlänge wandern und die Reihe sähe schief aus. Aus demselben
  Grund hat `.profile__desc` eine `min-height`, damit „Mindestens empfohlen“
  überall auf derselben Linie beginnt.
- **Galeriebilder:** die Screenshots der Galerie. Zwei davon tauchen verkleinert
  als Kartenband wieder auf – dort sind sie Stimmung, in der Galerie Inhalt.
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
  `__STABLE_VERSION__`, `__FLUFFY_IMPORT_URL__`, `__COZY_IMPORT_URL__`,
  `__ECO_IMPORT_URL__` sowie
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
Hero          Panorama · Wortmarke · Leitsatz · zwei Aktionen
Faktenband    Mods · Minecraft · NeoForge · Updates
Installation  drei Schritte → Fluffy/Cozy/Eco → Hinweis „gleiche Inhalte“
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
