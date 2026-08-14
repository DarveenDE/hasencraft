# Validierungsstand

Stand: Release Candidate `0.1.0-alpha.7`, 14. August 2026.

## Bestanden

- Der Alpha-7-Quellstand besteht die Packwiz- und Prism-Profilpruefungen mit 173 gepinnten Eintraegen: 126 beide Seiten, 27 nur Client und 20 nur Server. Der unveraenderliche Release-Snapshot enthaelt 217 per SHA-256 geschuetzte Dateien.
- Eine frisch importierte Cozy-Dev-Instanz wartete vor dem Minecraft-Start auf den vollstaendigen Packwiz-Download. NeoForge `21.1.247` erkannte danach 180 Mods einschliesslich Inventory Essentials `21.1.17`, erreichte den Alpha-7-Titelbildschirm und lud eine neue Kreativ-Testwelt.
- In der frischen Testwelt sortierte ein Mittelklick sowohl absichtlich verstreute Kisteninhalte als auch das Spielerinventar kompakt nach der Creative-Reihenfolge. Die Shift-Drag-Funktion von Inventory Essentials bleibt deaktiviert, damit Mouse Tweaks allein fuer dieses Verhalten zustaendig ist.
- Der lokale Dev-Bootstrap verwendet fuer Packwiz das zu Prisms `javaw.exe` gehoerende `java.exe`. Dadurch wartet PowerShell auf den Bootstrap-Prozess und NeoForge kann nicht mehr parallel zu noch laufenden Mod-Downloads starten.

- Der Alpha-6-Quellstand besteht die Packwiz-, Prism-Profil- und Shell-Syntax-Prüfungen. Der unveränderliche Release-Snapshot enthält 215 per SHA-256 geschützte Dateien; der Beta-Feed wurde daraus erfolgreich veröffentlicht.
- Der Communityserver wurde nach einem 811-MB-Pre-Update-Snapshot aus dem Beta-Kanal auf Alpha 6 aktualisiert. Der Snapshot enthält keine Discord-Zugangsdaten; CreativeCore und Enchantment Descriptions wurden serverseitig entfernt, ServerCore geladen und die bisherige `simulation-distance=2` gezielt auf `5` migriert.
- Der bereinigte Alpha-6-Serverstart erreichte `Done (4.434s)`: Minecraft lauscht auf TCP `25565`, Simple Voice Chat auf UDP `24454`, der Dienst blieb ohne Restarts und die systemd-Sandbox erlaubt ResourcefulLib ausschließlich die benötigten Cache- und Datenverzeichnisse.

- Alpha5 ist als Tag und GitHub Release veröffentlicht; die drei stabilen Archive und ihre SHA-256-Prüfsummen wurden verifiziert.
- Der Server wurde nach einem Snapshot auf Alpha5 aktualisiert. Die neuen Mods wurden geladen, der Dienst läuft ohne Neustartschleife.
- Die produktiven LuckPerms-Gruppen `supporter`, `moderator` und `admin` sind eingerichtet. Der Server-Export bestätigt `Darveen` als Admin, `Amayia` als Moderator, die Gruppenvererbung sowie die expliziten Sperren kritischer Serverbefehle für Moderatoren. In `ops.json` ist ausschließlich `Darveen` mit Level 4 eingetragen.
- Für Alpha5 wurde bewusst gegen eine harte Worldborder und gegen Chunky-Vorabberechnung entschieden. Stattdessen gelten die bestehenden Sicht-/Simulationsdistanzen, Performance-Mods und das dokumentierte Monitoring.

- LuckPerms `5.4.150` wurde auf dem NeoForge-1.21.1-Server mit der vom Upstream bereitgestellten SHA-512-Summe geprüft. Ein realer Spieler-Join erreichte danach den Spielzustand ohne die zuvor auftretende `UserCapabilityImpl`-Ausnahme.

- Packwiz-Index aktualisiert und 172 gepinnte Eintraege geprueft: 126 beide Seiten, 26 nur Client, 20 nur Server.
- Die neuen P1-Metadaten für FastSuite, Placebo, Structure Layout Optimizer, Resourceful Config und ServerCore sind gepinnt; Indexhash und Seitenzuordnung wurden durch `scripts/validate-pack.ps1` geprüft.
- CreativeCore und Enchantment Descriptions werden ausschließlich an Clients ausgeliefert. Das Eco-Profil verarbeitet mit Distant Horizons nur bereits vorhandene Chunks; beide Vorgaben sind validatorgeschützt.
- Der Performance-Audit prüft die Minecraft-1.21.1-Servervorlage auf die gemeinsame Sicht- und Simulationsdistanz 5, LZ4-Regiondateien, asynchrone Chunk-Writes und das Fehlen der später eingeführten Idle-Pause-Option. Das Java-21-ZGC-Profil bleibt ohne String-Deduplication; die drei ausgewählten ServerCore-Optimierungen sind versioniert und validatorgeschützt.
- Ein isolierter Dedicated-Serverstart mit FTB Chunks `2101.1.21`, FTB Library `2101.1.34`, FTB Teams `2101.1.10` und FTB XMod Compat `21.1.10` erreichte `Done (71.788s)`. Die KubeJS- und Waystones-Integrationen von FTB Chunks wurden aktiviert; die Claim-/Force-Load-Grenzen aus `config/ftbchunks-world.snbt` wurden vom Konfigurationssystem uebernommen.
- Die alpha.3-Prism-ZIP fuer Fluffy wurde erneut gebaut; die Pre-Launch-Aktualisierung ist enthalten.
- BlueMap 5.7 und Create BlueMap 1.1.1 wurden auf der vorgesehenen VM initialisiert. HTTPS-Reverse-Proxy, sechs freigegebene Karten, AE2-Ausschluss, 8100-Bindung nur auf Tailscale und deaktivierte Live-Spielermarker sind als Serverpolicy dokumentiert.
- Den offiziellen NeoForge-Installer `21.1.247` per Upstream-SHA-1 geprüft und mit Minecraft `1.21.1` sowie Java `21.0.12` lokal installiert.
- Den vollständigen Alpha-2-Serverstand bis `Done (3.217s)` gestartet und danach kontrolliert beendet; auch der vorausgehende Loader-Abgleich erreichte `Done (3.380s)`. Der Lauf ist die Baseline vor den neuen Performance-Mods.
- Das installierte Prism-Profil `Hasencraft Fluffy` im Online-Modus bis zum Titelbildschirm gestartet: NeoForge `21.1.247`, JEI `19.43.0.392`, Sodium `0.8.12` und Iris `1.8.14-beta.1` wurden gemeinsam geladen. Das ist die Shaderstack-Baseline vor dem neuen Eco-Profil.
- Complementary Reimagined wurde von Iris aktiviert; Distant Horizons meldete die erfolgreiche Iris-Event- und OpenGL-Anbindung.
- FTB Quests lud eine Gruppe, ein Kapitel und neun deutsche Quests.
- Simple Voice Chat startete auf UDP `24454`.
- Die endgültige Waystones-Konfiguration wurde ohne Laufzeitkorrektur bytegleich übernommen: keine Kosten, keine Cooldowns, kein Haltbarkeitsverlust sowie Transport von Haustieren und angeleinten Tieren.
- Nach den Hasencraft-Datenkorrekturen blieben keine Rezept-Parsefehler und kein fehlender Kartoffel-Tag zurück.
- Alle drei Prism-Profile (`fluffy`, `cozy`, `eco`) bestanden die automatisierte Archivprüfung zu Instanzname, Pre-Launch-URL, Speicherprofil, Distant Horizons, Shader- und Ressourcenpack-Auswahl.
- Der Alpha-2-Release-Snapshot enthält 182 durch `SHA256SUMS` geschützte Dateien. Ein zweiter Bau derselben Version wurde wie vorgesehen abgelehnt; die aktuelle Alpha-6-Quellvalidierung umfasst 172 Einträge.
- Sämtliche Bash-Skripte bestanden eine Syntaxprüfung; die aktualisierten PowerShell-Skripte parsen unter Windows PowerShell 5.1 und die Archivprüfung lief dort erfolgreich.

## Erwartete, nicht fatale Upstream-Meldungen

- Loot-Tabellen für nicht installierte optionale Integrationen von drei Create-Erweiterungen.
- Zwei technische Advancements aus Dungeons & Taverns.
- Vier optionale Regions-Unexplored-Rewards aus Bumblezone.
- Einzelne optionale Mixin-Ziele und externe Versionsprüfungen.
- Fehlende optionale Shader-Uniforms von Complementary Reimagined sowie die fehlende Access-Transformer-Datei der aktuellen Iris/Flywheel-Bridge; beide Meldungen waren beim erfolgreichen Titelbildschirm-Start nicht fatal.

Diese Meldungen wurden bis zur jeweiligen bedingten Registrierung beziehungsweise Quelldatei zurückverfolgt. Sie weisen nicht auf eine Create-6.0.10-Inkompatibilität oder beschädigte Welt hin.
