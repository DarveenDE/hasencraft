# Hasencraft

Hasencraft ist ein gemütliches, technisch tiefes Zwei-Personen-Modpack mit sehr vielen Tieren, großen Erkundungszielen und einer möglichst stressfreien Infrastruktur.

Aktueller Stand: **`0.1.0-alpha.2`**

- Minecraft `1.21.1`
- NeoForge `21.1.247`
- Java `21`
- 158 verwaltete Mods, Bibliotheken, Shader- und Resourcepack-Einträge
- Prism Launcher + packwiz
- dedizierter Ubuntu-Server mit kontrollierten Releases und vollständigen Pre-Update-Backups

Der Alpha-Stand wurde dreimal als echter NeoForge-Dedicated-Server bis `Done` gestartet und jeweils kontrolliert beendet. Das Questbuch, die gemeinsamen Waystone-Regeln, der Voicechat-Port und die korrigierten Rezepte wurden dabei geladen. Beide Prism-Profile bestanden zusätzlich 48 statische Build- und Extraktionsprüfungen. Das genaue Prüfprotokoll steht in [docs/VALIDATION.md](docs/VALIDATION.md).

## Inhaltliche Leitplanken

- gemütlicher Survival-Alltag, gelegentliche Herausforderungen
- Create → Immersive Engineering → Applied Energistics 2 → Mekanism
- Ars Nouveau und Ars Creo als kompakter Magiezweig
- Tectonic + Regions Unexplored und bewusst ausgewählte Strukturen
- Aether, Twilight Forest und Bumblezone
- Naturalist, Critters and Companions, Doggy Talents Next, Hamster, Ribbits, Snuffles, Productive Bees und ausgewählte Animal-Garden-Module
- Redomesticate als zentrales Haustier-Sicherheitsnetz
- Distant Horizons + Iris + Complementary Reimagined
- freie Waystone-Nutzung und `keepInventory`

Die vollständige, maschinenlesbare Quelle liegt in `pack.toml`, `index.toml` und den `*.pw.toml`-Dateien. Die kuratierte Übersicht steht in [docs/MODLIST.md](docs/MODLIST.md).

## Einmaliger Client-Import

Die öffentlichen Clients verwenden den Stable-Kanal auf GitHub Pages:

`https://darveende.github.io/hasencraft/channels/stable/pack.toml`

Die beiden Prism-ZIPs werden damit gebaut:

```powershell
.\scripts\build-prism.ps1 `
  -PackUrl "https://darveende.github.io/hasencraft/channels/stable/pack.toml" `
  -Channel stable `
  -Profile fluffy

.\scripts\build-prism.ps1 `
  -PackUrl "https://darveende.github.io/hasencraft/channels/stable/pack.toml" `
  -Channel stable `
  -Profile cozy
```

Danach wird die jeweilige ZIP einmal in Prism importiert. Bei jedem Start lädt packwiz ausschließlich den freigegebenen Kanalstand. Persönliche Einstellungen, Welten, Karten, Wegpunkte und DH-Caches sind ausdrücklich nicht Bestandteil des Packs.

## Wartung

Modversionen werden im Stable-Kanal nicht blind aktualisiert. Ein Release läuft immer über Beta, einen Server-Boot-Test, ein Versions-Tag und ein Pre-Update-Backup. Details: [docs/RELEASES.md](docs/RELEASES.md).

## Aktueller Deploymentstand

Das lokale Prism-Profil `Hasencraft Fluffy` ist installiert und Alpha 2 wurde bis zum Titelbildschirm mit aktivem Shader sowie Distant-Horizons-/Iris-Anbindung getestet. Der dedizierte Ubuntu-Server läuft mit demselben Alpha-2-Stand. GitHub Pages veröffentlicht die unveränderlichen Releases und die Kanäle `stable` und `beta`; GitHub Releases enthält die schlanken Prism-Importpakete. Whitelist, Welten und Spielerdaten bleiben bewusst außerhalb dieses Repositorys.
