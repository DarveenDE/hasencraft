# Releases und Kanäle

## Kanäle

- `beta`: neuer Stand für Client- und Staging-Tests
- `stable`: gemeinsam gespielte, freigegebene Version
- Versionsordner wie `0.1.0-alpha.1`: unveränderliche Snapshots

## Release-Ablauf

1. Neue oder aktualisierte Mods einzeln auf 1.21.1/NeoForge prüfen.
2. Packwiz-Metadaten auf die ausdrücklich gewählte Version setzen und `scripts/update-title-edition.ps1` ausführen. Das erzeugt die im Hauptmenü sichtbare Hasencraft-Version aus der `pack.toml`.
3. `packwiz refresh` und `scripts/validate-pack.ps1` ausführen.
4. Die [lokale Entwicklerinstanz](DEVELOPMENT.md) bis zum Titelbildschirm und mit einer neuen Singleplayer-Welt testen.
5. Release-Snapshot mit `scripts/make-release.ps1` bauen. Eine vorhandene Versionsnummer wird niemals überschrieben; jede Änderung benötigt eine neue Version.
6. Beta-Prism-Instanz und Staging-Server starten.
7. Verbindung, Weltladen, Dimensionen, Haustier-Respawn, JEI-Rezepte und Shader testen.
8. Vollständiges Server-Backup erstellen.
9. Server auf den neuen Versionsstand bringen und booten.
10. Erst danach den Stable-Kanal mit `hosting/promote.sh <version> stable` atomar auf das geprüfte Release umstellen. Das Skript verifiziert vorher `SHA256SUMS`.
11. Changelog und Git-Tag veröffentlichen.
12. Der Tag-Workflow baut die drei schlanken Prism-Profile und veröffentlicht sie mit SHA-256-Prüfsummen als GitHub Release.

## Öffentliche Verteilung

`hosting/channels.json` legt fest, welcher unveränderliche Snapshot als `stable` beziehungsweise `beta` veröffentlicht wird. Der GitHub-Pages-Workflow prüft sämtliche SHA-256-Einträge, materialisiert die Kanäle ohne Symlinks und veröffentlicht sie unter:

- `https://darveende.github.io/hasencraft/channels/stable/pack.toml`
- `https://darveende.github.io/hasencraft/channels/beta/pack.toml`

Mod-JARs werden nicht im Repository oder im Prism-ZIP gebündelt. packwiz lädt sie anhand der geprüften Metadaten von den jeweiligen offiziellen Quellen.

## Rollback

Ein bloßes Downgrade der Moddateien reicht nicht. Neue Blöcke, Entitäten oder Registries können bereits in der Welt gespeichert sein. Daher werden Packstand und vollständiger Pre-Update-Server-Snapshot gemeinsam zurückgesetzt.

Vor dem Restore muss außerdem der Stable-Kanal wieder auf das alte immutable Release zeigen, sonst würde der nächste Deploy den Fehlerstand sofort erneut installieren.

## Kritische Pins

- NeoForge `21.1.247`
- Distant Horizons `3.2.0-b`
- Iris `1.8.14-beta.1`
- Sodium `0.8.12`
- Create `6.0.10`
- JEI `19.43.0.392`

Diese Pins werden nur als getestete Gruppe verändert.
