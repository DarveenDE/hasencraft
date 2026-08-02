# Hasencraft Branding

Hasencraft verbindet gemütliches Zuhause, Tierchen, Technik und große
Erkundungsziele. Die visuelle Leitlinie lautet:

> **Gemütlich bauen. Weit entdecken.**

## Markenbausteine

- **Emblem:** Hase, Biene und Zahnrad aus
  [`launcher/hasencraft-master.png`](../launcher/hasencraft-master.png).
- **Wortmarke:** warmes Creme/Honiggold mit Petrol-Schatten; als eigener,
  bewusst nicht an das Minecraft-Logo angelehnter Schriftzug.
- **Farben:** Nachtpetrol `#071E1C`, Panel-Petrol `#0D2B28`, Teal `#2F8378`,
  Honig `#FFD166`, Kupfer `#D97941`, Fellcreme `#FFF6E5`.

Fluffy und Cozy sind Leistungsprofile derselben Marke. Sie erhalten eigene
Badges und Beschreibungen, aber keine abweichende Farbwelt oder Wortmarke.

## Auslieferung

- `kubejs/assets/` wird als immer aktives Resource Pack geladen. Es liefert
  Wortmarke, alternativen Feiertags-Schriftzug, Unterzeile, Panorama und
  Splash-Texte aus.
- `kubejs/config/client.json` setzt den Fenstertitel; `packicon.png` liefert
  ein 32-Bit-Fenster-/Taskleisten-Icon.
- `hosting/pages/assets/` enthält die für die Installationsseite optimierten
  Bilddateien.
- Das quellbild für das Panorama liegt bewusst unter `docs/branding/`, damit
  es dokumentiert bleibt, aber nicht Bestandteil des Runtime-Packs wird.

Bei Änderungen am Titelbildschirm beide Profile bis zum Hauptmenü starten und
Wortmarke, Panorama, Splash-Texte sowie Fenster-Icon prüfen.
