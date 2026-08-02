# Hasencraft 🐰

> **Gemütlich bauen. Weit entdecken.**

Ein gemeinsames Minecraft-Modpack für Technik, Tierchen, Magie und große
Erkundungsziele. Über 150 Mods, aufeinander abgestimmt statt zusammengeworfen –
bau eine Basis, die sich nach Zuhause anfühlt, und entdecke, was dahinter liegt.

**→ [Installationsseite](https://darveende.github.io/hasencraft/)** – dort liegt
die Importadresse für Prism, immer auf dem freigegebenen Stand.

Minecraft `1.21.1` · NeoForge `21.1.247`

## Loslegen

1. Aktuellen [Prism Launcher](https://prismlauncher.org/) installieren und dein
   Microsoft-Konto anmelden.
2. Auf der [Installationsseite](https://darveende.github.io/hasencraft/) das
   passende Profil wählen und die Importadresse kopieren.
3. In Prism: **Instanz hinzufügen** → **Importieren** → Adresse einfügen.
4. Instanz einmal starten. Prism richtet Java 21 ein und lädt alles Nötige.
5. Die Serveradresse gibt es in der Community – im Multiplayer-Menü eintragen
   und losspielen.

## Welches Profil?

Alle drei enthalten **dieselben** Mods, Welten und Inhalte. Sie unterscheiden
sich nur bei lokalen Grafik-, Resourcepack- und Speicherwerten; ihr spielt
problemlos zusammen.

| Profil | Für wen | Grafik (Richtwert) | RAM | Das Profil setzt |
|---|---|---|---|---|
| **Fluffy** | Rechner mit Reserven | AMD RX 7800 XT · NVIDIA RTX 4070 | 32 GB | 10 GiB Heap · 14 Chunks · DH 256 · Shader auf High |
| **Cozy** | die meisten Rechner | AMD RX 6600 · NVIDIA GTX 1080 oder RTX 3060 | 16 GB | 8 GiB Heap · 10 Chunks · DH 96–128 · Shader auf Medium |
| **Eco** | schwächere Rechner | AMD RX 570 · NVIDIA GTX 1060 | 12 GB | 6 GiB Heap · 8 Chunks · DH 64 · ohne Shader |

Die Hardwareangaben sind Richtwerte, keine Anforderungen. Im Zweifel mit **Cozy**
anfangen und von dort nach oben oder unten wechseln – das Profil lässt sich
jederzeit neu importieren, ohne dass Welten oder Einstellungen verloren gehen.

## Was drin ist

- **Technik** – von der ersten Handkurbel bis zur vollautomatischen Fabrik:
  Create, Immersive Engineering, Applied Energistics 2, Mekanism.
- **Tiere** – Hamster, Hunde, Otter, Bienen und ein ganzer Zoo an Nachbarn, samt
  sicherem Zuhause: Naturalist, Doggy Talents Next, Animal Garden, Productive Bees.
- **Magie** – eigene Zauber bauen und mit Maschinen verzahnen: Ars Nouveau, Ars Creo.
- **Erkundung** – größere Berge, neue Biome, bewohnte Ruinen und drei zusätzliche
  Dimensionen: Tectonic, Regions Unexplored, Aether, Twilight Forest, Bumblezone.
- **Atmosphäre** – Fernsicht bis zum Horizont, Shader, lebendige Tiere:
  Distant Horizons, Complementary Reimagined, Fresh Animations, AmbientSounds.
- **Zusammen spielen** – Quests, Sprachchat, Wegpunkte und Claims für den eigenen
  Bauplatz: FTB Quests, FTB Chunks, Simple Voice Chat, Xaero's Map, Waystones.

Die vollständige Übersicht steht in der [Modliste](docs/MODLIST.md).

## Updates: automatisch beim Start

Du musst Mods **nicht** einzeln herunterladen oder aktualisieren. Bei jedem Start
prüft Hasencraft den freigegebenen Stand und installiert alle Änderungen, bevor
Minecraft öffnet. Nach einer Release-Ankündigung genügt also: Prism öffnen,
Hasencraft starten, kurz warten.

Bitte aktualisiere die Mods innerhalb der Instanz **nicht** eigenständig über
„Alle aktualisieren". Das Pack ist als getestete Kombination gebaut; einzelne
Mod-Updates können die Serververbindung oder den Shaderstack beschädigen.

Verteilt wird über zwei Kanäle: **stable** ist der freigegebene Spielstand – das,
was die Installationsseite ausliefert. **beta** dient dem Test vor einer Freigabe
und kann einer Version voraus sein.

## Gut zu wissen

- Für den Sprachchat muss Minecraft auf das Mikrofon zugreifen dürfen. Die
  Abfrage erscheint meist beim ersten Betreten des Servers.
- Eigene Tastenbelegung, Screenshots, Xaero-Karten samt Wegpunkten und die
  Distant-Horizons-Caches überstehen jedes Pack-Update.
- Wenn es ruckelt: erst die LoD-Distanz von Distant Horizons senken, dann die
  Shader-Details. Hilft das nicht, wechsle auf **Cozy** – und wenn es dann immer
  noch hakt, auf **Eco**.

## Hilfe

Bei Problemen schick dem Team einen Screenshot der Fehlermeldung und, wenn
möglich, die angezeigte Hasencraft-Version. Bitte keine Dateien im `mods`-Ordner
löschen – mit dem Originalzustand lässt sich der Fehler deutlich schneller
nachvollziehen.

Ausführlichere Hinweise zu Grafik und Distant Horizons stehen in der
[Installationshilfe](docs/INSTALL-CLIENT.md), bekannte Stolperfallen in den
[bekannten Problemen](docs/KNOWN-ISSUES.md).

## Dokumentation

| Für Spielende | |
|---|---|
| [Installationshilfe](docs/INSTALL-CLIENT.md) | Profile, Distant-Horizons-Werte, Shader |
| [Modliste](docs/MODLIST.md) | vollständige Übersicht aller Inhalte |
| [Bekannte Probleme](docs/KNOWN-ISSUES.md) | was gerade hakt und was hilft |
| [Community](server/COMMUNITY.md) | Regeln, Claims und Zusammenspiel |

| Fürs Team | |
|---|---|
| [Architektur](docs/ARCHITECTURE.md) | Kanäle, Dateibesitz, Sicherheitsgrenze |
| [Releases](docs/RELEASES.md) | Ablauf vom Build bis zur Freigabe |
| [Validierung](docs/VALIDATION.md) | Prüfungen vor einer Freigabe |
| [Branding](docs/BRANDING.md) | Wortmarke, Farben, Titelbildschirm |
| [Designkonzept](docs/DESIGN.md) | Gestaltung der Installationsseite |
| [Serverbetrieb](server/COMMUNITY-OPERATIONS.md) | Deployment, Backups, Rollback |

---

Mod-Dateien werden von ihren offiziellen Quellen geladen; alle Rechte liegen bei
den jeweiligen Autorinnen und Autoren. Siehe [THIRD_PARTY.md](THIRD_PARTY.md).
