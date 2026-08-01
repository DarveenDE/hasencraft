# Validierungsstand

Stand: `0.1.0-alpha.1`, 1. August 2026.

## Bestanden

- Packwiz-Index aktualisiert und 158 gepinnte Einträge geprüft: 121 beide Seiten, 24 nur Client, 13 nur Server.
- Minecraft `1.21.1`, NeoForge `21.1.248` und Java `21.0.12` in einer frischen lokalen Serverinstallation verwendet.
- Drei Dedicated-Server-Starts bis `Done` und drei kontrollierte Shutdowns ausgeführt; der Wiederholungsstart erreichte die spielbereite Weltphase in 3,567 Sekunden.
- FTB Quests lud eine Gruppe, ein Kapitel und neun deutsche Quests.
- Simple Voice Chat startete auf UDP `24454`.
- Die endgültige Waystones-Konfiguration wurde ohne Laufzeitkorrektur bytegleich übernommen: keine Kosten, keine Cooldowns, kein Haltbarkeitsverlust sowie Transport von Haustieren und angeleinten Tieren.
- Nach den Hasencraft-Datenkorrekturen blieben keine Rezept-Parsefehler und kein fehlender Kartoffel-Tag zurück.
- Beide Prism-ZIPs (`fluffy`, `cozy`) bestanden 48 Prüfungen zu Archivstruktur, Loader-Versionen, Pre-Launch-Update, Icon, Speicherprofil, Distant Horizons, Shader und Resourcepack. Die lokalen Test-ZIPs mit Entwicklungs-URL wurden anschließend entfernt.
- Der Release-Snapshot enthält 182 durch `SHA256SUMS` geschützte Dateien. Ein zweiter Bau derselben Version wurde wie vorgesehen abgelehnt; die Quellvalidierung bleibt auch bei vorhandenem Snapshot bei exakt 158 Einträgen.
- Sämtliche Bash-Skripte bestanden eine Syntaxprüfung; die PowerShell-Skripte liefen unter Windows PowerShell 5.1.

## Erwartete, nicht fatale Upstream-Meldungen

- Loot-Tabellen für nicht installierte optionale Integrationen von drei Create-Erweiterungen.
- Zwei technische Advancements aus Dungeons & Taverns.
- Vier optionale Regions-Unexplored-Rewards aus Bumblezone.
- Einzelne optionale Mixin-Ziele und externe Versionsprüfungen.

Diese Meldungen wurden bis zur jeweiligen bedingten Registrierung beziehungsweise Quelldatei zurückverfolgt. Sie weisen nicht auf eine Create-6.0.10-Inkompatibilität oder beschädigte Welt hin.

## Vor Stable noch manuell prüfen

- Beide Prism-Profile wirklich importieren und mit Microsoft-Konto starten.
- Iris, Complementary Reimagined, Fresh Animations und Distant Horizons visuell auf RX 7900 XT und GTX 1080 prüfen.
- Zwei Clients verbinden und Haustierbindung, Tod, Respawn, Waystone-Mitnahme und Dimensionswechsel spielen.
- Aether, Twilight Forest und Bumblezone betreten sowie einige Create-/AE2-/Mekanism-Rezepte in JEI anklicken.
- Installation, systemd-Lock, Backup und Rollback auf der vorgesehenen Ubuntu-VM testen.
- Erst danach die benötigten TCP-/UDP-Regeln öffnen und `stable` freigeben.
