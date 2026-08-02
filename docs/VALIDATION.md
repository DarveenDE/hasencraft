# Validierungsstand

Stand: `0.1.0-alpha.4`, 2. August 2026.

## Bestanden

- LuckPerms `5.4.150` wurde auf dem NeoForge-1.21.1-Server mit der vom Upstream bereitgestellten SHA-512-Summe geprüft. Ein realer Spieler-Join erreichte danach den Spielzustand ohne die zuvor auftretende `UserCapabilityImpl`-Ausnahme.

- Packwiz-Index aktualisiert und 169 gepinnte Eintraege geprueft: 124 beide Seiten, 24 nur Client, 21 nur Server.
- Die neuen P1-Metadaten für FastSuite, Placebo, Structure Layout Optimizer, Resourceful Config und ServerCore sind gepinnt; Indexhash und Seitenzuordnung wurden durch `scripts/validate-pack.ps1` geprüft.
- Ein isolierter Dedicated-Serverstart mit FTB Chunks `2101.1.21`, FTB Library `2101.1.34`, FTB Teams `2101.1.10` und FTB XMod Compat `21.1.10` erreichte `Done (71.788s)`. Die KubeJS- und Waystones-Integrationen von FTB Chunks wurden aktiviert; die Claim-/Force-Load-Grenzen aus `config/ftbchunks-world.snbt` wurden vom Konfigurationssystem uebernommen.
- Die alpha.3-Prism-ZIP fuer Fluffy wurde erneut gebaut; die Pre-Launch-Aktualisierung ist enthalten.
- BlueMap, Create BlueMap und Discord Integration sind als gepinnte serverseitige Metadaten aufgenommen. Ein echter Lauf bleibt Teil des Beta-Stagings, damit weder eine Karte noch ein Discord-Bot vor der Zugriffskontrolle oeffentlich werden.
- Den offiziellen NeoForge-Installer `21.1.247` per Upstream-SHA-1 geprüft und mit Minecraft `1.21.1` sowie Java `21.0.12` lokal installiert.
- Den vollständigen Alpha-2-Serverstand bis `Done (3.217s)` gestartet und danach kontrolliert beendet; auch der vorausgehende Loader-Abgleich erreichte `Done (3.380s)`. Der Lauf ist die Baseline vor den neuen Performance-Mods.
- Das installierte Prism-Profil `Hasencraft Fluffy` im Online-Modus bis zum Titelbildschirm gestartet: NeoForge `21.1.247`, JEI `19.43.0.392`, Sodium `0.8.12` und Iris `1.8.14-beta.1` wurden gemeinsam geladen. Das ist die Shaderstack-Baseline vor dem neuen Eco-Profil.
- Complementary Reimagined wurde von Iris aktiviert; Distant Horizons meldete die erfolgreiche Iris-Event- und OpenGL-Anbindung.
- FTB Quests lud eine Gruppe, ein Kapitel und neun deutsche Quests.
- Simple Voice Chat startete auf UDP `24454`.
- Die endgültige Waystones-Konfiguration wurde ohne Laufzeitkorrektur bytegleich übernommen: keine Kosten, keine Cooldowns, kein Haltbarkeitsverlust sowie Transport von Haustieren und angeleinten Tieren.
- Nach den Hasencraft-Datenkorrekturen blieben keine Rezept-Parsefehler und kein fehlender Kartoffel-Tag zurück.
- Alle drei Prism-Profile (`fluffy`, `cozy`, `eco`) bestanden die automatisierte Archivprüfung zu Instanzname, Pre-Launch-URL, Speicherprofil, Distant Horizons, Shader- und Ressourcenpack-Auswahl.
- Der Alpha-2-Release-Snapshot enthält 182 durch `SHA256SUMS` geschützte Dateien. Ein zweiter Bau derselben Version wurde wie vorgesehen abgelehnt; die aktuelle Quellvalidierung umfasst 169 Einträge.
- Sämtliche Bash-Skripte bestanden eine Syntaxprüfung; die aktualisierten PowerShell-Skripte parsen unter Windows PowerShell 5.1 und die Archivprüfung lief dort erfolgreich.

## Erwartete, nicht fatale Upstream-Meldungen

- Loot-Tabellen für nicht installierte optionale Integrationen von drei Create-Erweiterungen.
- Zwei technische Advancements aus Dungeons & Taverns.
- Vier optionale Regions-Unexplored-Rewards aus Bumblezone.
- Einzelne optionale Mixin-Ziele und externe Versionsprüfungen.
- Fehlende optionale Shader-Uniforms von Complementary Reimagined sowie die fehlende Access-Transformer-Datei der aktuellen Iris/Flywheel-Bridge; beide Meldungen waren beim erfolgreichen Titelbildschirm-Start nicht fatal.

Diese Meldungen wurden bis zur jeweiligen bedingten Registrierung beziehungsweise Quelldatei zurückverfolgt. Sie weisen nicht auf eine Create-6.0.10-Inkompatibilität oder beschädigte Welt hin.

## Vor Stable noch manuell prüfen

- Die Weltgrenze beschliessen, auf Staging mit dem dokumentierten einmaligen Chunky-Ablauf vorabgenerieren und danach einen Distant-Horizons-Client testen.
- BlueMap nur ueber einen nicht-oeffentlichen Zugang rendern; erst danach Reverse Proxy, Karten- und Datenschutzregeln entscheiden.
- Discord Integration mit einem separaten Bot-Token und Testrollen aktivieren; Token, Guild- und Kanal-IDs niemals in Packdateien eintragen.

- Das Prism-Profil `cozy` importieren und mit dem zweiten Microsoft-Konto starten.
- Das Prism-Profil `eco` importieren, seine deaktivierten Shader und Fresh Animations prüfen und mit Cozy vergleichen.
- Iris, Complementary Reimagined, Fresh Animations und Distant Horizons im Spiel auf RX 7900 XT sowie vollständig auf GTX 1080 prüfen.
- Zwei bis vier Clients gleichzeitig neue Gebiete erkunden lassen und Spark-Profile vor und nach den Distant-Horizons-Limits vergleichen.
- More Culling und BadOptimizations ausschließlich auf einer frischen Testinstanz gegen den Shader-/Distant-Horizons-Stack testen; bei Fehlern nicht in den Stable-Feed übernehmen.
- Zwei Clients verbinden und Haustierbindung, Tod, Respawn, Waystone-Mitnahme und Dimensionswechsel spielen.
- Aether, Twilight Forest und Bumblezone betreten sowie einige Create-/AE2-/Mekanism-Rezepte in JEI anklicken.
- Installation, systemd-Lock, Backup und Rollback auf der vorgesehenen Ubuntu-VM testen.
- Beta-Staging mit LuckPerms und CoreProtectNeo starten, einen Claim mit zwei nicht-OP-Spielenden testen sowie einen bewusst kleinen CoreProtectNeo-Rollback ausführen.
- Erst danach die benötigten TCP-/UDP-Regeln öffnen und `stable` freigeben.
