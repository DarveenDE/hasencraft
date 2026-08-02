# Architektur

```text
Git / packwiz
├── unveränderliche Versionsstände
├── Kanal stable
└── Kanal beta
      │
      ├── Prism: Hasencraft Fluffy
      ├── Prism: Hasencraft Cozy
      ├── Prism: Hasencraft Eco
      └── Ubuntu-Server: explizites Deployment
```

## Zuständigkeiten

Prism verwaltet Minecraft, Java, Konten und die lokale Instanz. Der packwiz-Bootstrap läuft vor Minecraft und synchronisiert ausschließlich Dateien aus dem Pack-Index.

Git hält Quellstand, Versionsgeschichte und Tags. Das statische HTTPS-Hosting liefert vollständige, unveränderliche Release-Snapshots aus. `stable` und `beta` sind nur atomar umschaltbare Zeiger auf solche Snapshots.

Der Server aktualisiert sich nicht bei jedem normalen Neustart. Ein Release wird bewusst ausgelöst: Dienst stoppen, gemeinsamen Lifecycle-Lock übernehmen, vollständiges Backup erstellen, die im Pack deklarierte Loader-Version prüfen, Pack anwenden, Boot testen und erst danach den Dienst öffnen.

## Dateibesitz

Vom Pack verwaltet:

- Mods und Bibliotheken
- gemeinsame Konfigurationen und `defaultconfigs`
- KubeJS-Skripte und Datapack-Daten
- FTB-Quests
- der empfohlene Shader und das Resourcepack

Immer lokal beziehungsweise serverseitig erhalten:

- Welten und Backups
- `options.txt`, Keybinds und persönliche Shaderoptionen
- Xaero-Karten und Wegpunkte
- Distant-Horizons-LoD-Caches
- Screenshots, Logs und Crashreports
- `server.properties`, EULA, Whitelist, Ops und Bans

## Sicherheitsgrenze

Die Pack-URL ist funktional eine Codequelle, weil darüber Mod-JARs ausgewählt werden. Stable darf daher nie direkt auf eine Entwicklungsbranch zeigen. Release-Snapshots werden vollständig in einem Staging-Ordner gebaut, mit SHA-256 geprüft und erst anschließend atomar an ihren unveränderlichen Versionspfad verschoben. `stable` und `beta` werden nur nach erneuter Manifestprüfung umgeschaltet. Zugangsdaten werden nicht im Pack gespeichert.
