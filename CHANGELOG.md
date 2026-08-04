# Changelog

Alle relevanten Änderungen an Mods, Konfiguration, Quests und Serveranforderungen werden hier dokumentiert.

## 0.1.0-alpha.6 — 2026-08-04

- Die drei Prism-Profile verwenden Java 21 mit generational ZGC; die problematische String-Deduplication bleibt deaktiviert.
- Das Hauptmenü zeigt die Hasencraft-Version, `/hasencraft` erinnert an Karten-Tasten und Questbuch, und Waystones sind direkt aus dem Inventar erreichbar.
- CreativeCore und Enchantment Descriptions werden nur noch an Clients ausgeliefert; Eco verarbeitet mit Distant Horizons ausschließlich bereits vorhandene Chunks.
- ServerCore entlastet gezielt synchrone Chunk-Ladevorgänge, tickende Chunk-Listen und Command-Block-Parsing. Aggressivere Gameplay-Eingriffe bleiben deaktiviert.
- Der Server verwendet LZ4-Regiondateien, asynchrone Chunk-Writes und eine Sicht- sowie Simulationsdistanz von 5. Das Deployment migriert ausschließlich den bisherigen Standardwert 2 und erhält individuelle Serverwerte.
- Distant Horizons, BlueMap, Discord-Integration sowie Backup-, Deployment- und Rollback-Abläufe wurden für den Communityserver weiter abgesichert.
- Pack-, Release- und Prism-Validatoren prüfen Seitenzuordnungen, Profile, kritische Pins, Servervorlagen, Shell-Syntax und den Ausschluss lokaler beziehungsweise geheimer Laufzeitdateien.

## 0.1.0-alpha.4 — 2026-08-02

- LuckPerms wurde auf dem NeoForge-Server von `5.4.140` auf `5.4.150` aktualisiert. Das behebt den Join-Abbruch durch eine nicht initialisierte Spieler-Capability; Clients benötigen dafür keine zusätzliche Änderung.

## 0.1.0-alpha.3 — 2026-08-02

- Installationsseite neu gestaltet: Hero mit Wortmarke und Panorama, Profilvergleich Fluffy/Cozy/Eco, Inhaltsübersicht, Bildergalerie und aufklappbarer Technikbereich.
- Minecraft- und NeoForge-Version werden beim Bauen der Seite aus der `pack.toml` des Stable-Snapshots eingesetzt; unaufgelöste Platzhalter lassen den Build fehlschlagen.
- Designkonzept in `docs/DESIGN.md` dokumentiert.

- FastSuite mit Placebo, Structure Layout Optimizer mit Resourceful Config sowie ServerCore als gepinnte Performance-Grundlage ergänzt.
- Distant Horizons auf dem Server mit 256-Chunks-Grenzen sowie fairen Anfrage- und Bandbreitenlimits abgesichert.
- Das Prism-Profil `eco` für schwächere Rechner ergänzt und den Release-/Pages-Ablauf auf drei Profile erweitert.
- Automatische Archivprüfung für Fluffy, Cozy und Eco ergänzt; Testkandidaten mit potenziellen Shader-Konflikten bleiben außerhalb des Stable-Packs.

- Community-Grundlage ergänzt: FTB Chunks, LuckPerms und CoreProtectNeo.
- Claims sind über die vorhandenen FTB Teams geschützt und mit konservativen Community-Limits vorkonfiguriert.
- Carry On verlangsamt beim Tragen von Entitäten nur noch auf 25 Prozent.
- Neue Installationen verwenden `U` für die FTB-Karte; Xaero's Weltkarte bleibt auf `M`.

- BlueMap, Create BlueMap und Discord Integration sind ausschliesslich auf dem Server ergaenzt; Karte und Discord-Bot bleiben bis zum Staging-Test deaktiviert beziehungsweise nicht oeffentlich.

## 0.1.0-alpha.2 — 2026-08-02

- NeoForge von `21.1.248` auf `21.1.247` gepinnt, da Prism für den neueren Maven-Build noch keine Komponenten-Metadaten ausliefert.
- Prism- und Servervorlagen auf denselben Loader-Stand gebracht.
- Sodium `0.8.12` und das dazu passende Iris `1.8.14-beta.1` aktualisiert, damit Supplementaries korrekt lädt.
- JEI auf `19.43.0.392` aktualisiert, wie von Sophisticated Core vorausgesetzt.

## 0.1.0-alpha.1 — 2026-08-01

- Packwiz-Projekt für Minecraft 1.21.1 und NeoForge 21.1.248 erstellt.
- Ersten kuratierten Inhaltssatz mit 158 verwalteten Einträgen aufgebaut.
- Distant-Horizons-/Iris-/Sodium-Versionen als kompatiblen Stack gepinnt.
- Cozy-, Tier-, Tech-, Magie-, Weltgenerierungs- und Dimensionskern hinzugefügt.
- Redomesticate-Kompatibilität für Doggy Talents vorbereitet.
- Prism-Profile `fluffy` und `cozy` vorbereitet.
- Stable-/Beta-Releaseablauf sowie Ubuntu-Backup und Rollback angelegt.
- Neun kurze deutsche Einstiegsquests und freie, tierfreundliche Waystones vorkonfiguriert.
- Fehlerhafte 1.21.1-Rezept- und Tag-Daten von Snuffles, Create Deco und Adorable Hamster Pets korrigiert.
- Drei vollständige Dedicated-Server-Starts mit sauberem Shutdown bestanden.
- Beide Prism-Profile mit insgesamt 48 Struktur-, Versions- und Inhaltsprüfungen verifiziert.
- Release-Snapshots atomar, unveränderlich und mit vollständigem SHA-256-Manifest umgesetzt.
- Server-Deployment, Backups und Rollback über einen gemeinsamen Offline-Lock abgesichert.
