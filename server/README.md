# Ubuntu-Server

Zielplattform: Ubuntu Server 24.04 LTS, Java 21, 6 vCPU, 16 GiB VM-RAM und 120 GiB SSD. Das mitgelieferte Java-Profil verwendet `-Xms8G -Xmx12G`; damit bleiben ungefähr 4 GiB für Betriebssystem, Dateicache, Zabbix und weitere Dienste frei.

## Installation

Repository auf die VM kopieren und aus dessen Wurzel ausführen:

```bash
sudo ./server/install-server.sh
```

Das Skript installiert Java 21 und zstd, legt den nicht-interaktiven Benutzer `hasencraft` an, installiert NeoForge `21.1.247`, kopiert den packwiz-Bootstrap und richtet den systemd-Dienst ein. Es startet den Server nicht und akzeptiert die Minecraft-EULA nicht stellvertretend.

Danach:

```bash
sudoedit /etc/hasencraft/hasencraft.env
sudo -u hasencraft cp /srv/hasencraft/server/server.properties.example \
  /srv/hasencraft/server/server.properties
sudoedit /srv/hasencraft/server/server.properties
sudoedit /srv/hasencraft/server/eula.txt

sudo systemctl stop hasencraft
sudo -u hasencraft /usr/local/libexec/hasencraft-deploy stable
sudo systemctl start hasencraft
```

## Updates

```bash
sudo systemctl stop hasencraft
sudo -u hasencraft /usr/local/libexec/hasencraft-deploy stable
sudo systemctl start hasencraft
```

Der Deploy-Befehl prüft die SHA-256-Summe des Updatewerkzeugs und lehnt Packs mit einer anderen NeoForge-Version ab. Vor jeder Änderung erstellt er ein `.tar.zst` unter `/srv/hasencraft/backups/`; die einzige bewusste Ausnahme ist `world/serverconfig/discordintegration-server.toml`, weil diese Datei den Bot-Token enthält. Vorher prüft er, ob mindestens die unkomprimierte Größe des Servers plus 2 GiB Reserve frei sind. Alte Backups werden absichtlich nicht automatisch gelöscht; bei der 120-GiB-SSD sollte ihre Belegung regelmäßig geprüft werden.

Serverlauf, Deployment, manuelle Backups und Rollback teilen sich denselben exklusiven Lifecycle-Lock. Ein konsistentes manuelles Backup wird deshalb nur bei gestopptem Dienst erstellt:

```bash
sudo systemctl stop hasencraft
sudo -u hasencraft /usr/local/libexec/hasencraft-backup
sudo systemctl start hasencraft
```

Ein Rollback übernimmt die aktuelle lokale DI-Konfiguration direkt in den
wiederhergestellten Serverbaum. Der Token wird dadurch weder archiviert noch in
das Quarantäneverzeichnis verschoben. Die `ExecStartPre`-Prüfung startet einen
Server mit aktivem DI außerdem nur, wenn der letzte Deploy aus dem `beta`-Kanal
kam.

Backups aus der Zeit vor diesem Schutz werden nicht automatisch verändert. Falls
ein solches Archiv jemals eine aktive DI-Konfiguration enthielt, darf es nicht
weitergegeben werden; den betroffenen Discord-Bot-Token im Developer Portal
sofort regenerieren.

## Performance-Staging

FastSuite, Structure Layout Optimizer und ServerCore sind Teil des Packs.
FastSuite beschleunigt unter anderem die Rezept- und Tagverarbeitung, während
Structure Layout Optimizer die Suche nach passenden Strukturen bei der
Weltgenerierung verringert. Die versionierte
`config/servercore/optimizations.yml` aktiviert drei gezielte Entlastungen:
synchrone Chunk-Ladevorgänge werden reduziert, die Liste tickender Chunks wird
einmal pro Sekunde gecacht und Command-Block-Befehle werden wiederverwendet.
`reduce-sync-loads` kann bewirken, dass Karten nur noch geladene Chunks sehen;
die Einstellung bleibt deshalb bewusst auf diese drei Optionen begrenzt und
aktiviert keine Mob-, Fluid- oder Aktivierungsbereichsänderungen.

Die Servervorlage nutzt auf der Linux-SSD `region-file-compression=lz4` und
`sync-chunk-writes=false`, damit Kompression und Flushes nicht unnötig im
Tick-Pfad blockieren. Die Lifecycle-Skripte stoppen den Dienst vor Backups und
Updates. `pause-when-empty-seconds` ist absichtlich nicht enthalten: diese
Option gehört nicht zum Minecraft-1.21.1-Server. Das Java-21-Profil verwendet
generational ZGC ohne `UseStringDeduplication`, weil diese Kombination bei
kurzlebigen Strings zusätzlichen Retention- und Verarbeitungsaufwand erzeugen
kann.

Die Distant-Horizons-Vorlage begrenzt LoD-Generierungs- und
Synchronisierungsanfragen pro Spieler sowie global. Sie deckt weiterhin die
256-LoD-Chunks des Fluffy-Profils ab, schützt aber die TPS bei mehreren
gleichzeitigen Anfragen. Im Hintergrund darf genau ein Worker mit maximal 25
Prozent Laufzeit LoDs aus bereits vorhandenen Chunks erstellen
(`PRE_EXISTING_ONLY`). Der Server erzeugt dabei keine neuen, modded
Terrain-Chunks. Vorbereitete LoDs können über normale Clientanfragen
ausgeliefert werden; automatische Synchronisierung beim Login und
Echtzeit-Updates bleiben deaktiviert. Dadurch wachsen die Fernansichten bereits
besuchter Gebiete langsam nach, während der Dedicated Server TPS priorisiert.

Der Installer kopiert diese Datei nur bei einer neuen Installation. Auf
bestehenden Servern nach dem Deployment sowohl den
`[common.worldGenerator]`- als auch den `[server]`-Block aus
`server/config/DistantHorizons.toml` in
`/srv/hasencraft/server/config/DistantHorizons.toml` übernehmen und den Dienst
neu starten. Eine Weltvorabgenerierung erfolgt getrennt, begrenzt und vor dem
Spielbetrieb. Die Hintergrundverarbeitung bleibt auf bereits erzeugte Chunks,
einen Worker und 25 Prozent Laufzeit beschraenkt.

Die Servervorlage verwendet außerdem `view-distance=5` und
`simulation-distance=5`. Damit tickt der gesamte an Clients ausgelieferte
Bereich, sodass Felder und einfache Maschinen am Rand der Sichtweite nicht
unerwartet stehen bleiben. Ein zusätzlicher, unsichtbarer Simulationsring wird
auf dem 16-GiB-Streamserver vermieden. Die Spawn-Chunks werden pro Welt mit
`/gamerule spawnChunkRadius 0` deaktiviert, nicht über `server.properties`.
Höhere Werte erst nach einem Spark-Vergleichsprofil setzen.

Beim Alpha-6-Deployment migriert `hasencraft-deploy` ausschließlich den
bisherigen Hasencraft-Standard `simulation-distance=2` auf `5`. Ein bewusst
abweichender serverlokaler Wert bleibt erhalten. Die Änderung erfolgt nach dem
automatischen Pre-Update-Backup und vor dem nächsten Serverstart.

Für eine spätere Laufzeitdiagnose kann bei einem reproduzierbaren Spike
`spark profiler start --timeout 300` verwendet werden. Die Profilerstellung ist
eine Diagnosehilfe und kein Bestandteil der automatischen Packvalidierung.

Zeigt ein Vergleichsprofil synchrone Chunk-Ladevorgänge auf dem Server-Thread,
kann ServerCore vorübergehend mit
`features.prevent-moving-into-unloaded-chunks: true` geschützt und per
`/servercore reload` ohne Neustart geladen werden. An noch nicht geladenen
Chunkgrenzen wird die Bewegung dann kurz korrigiert, statt den gesamten Server
durch einen synchronen Ladevorgang anzuhalten.

### Zeitlich begrenzter Streammodus

Alle folgenden Massnahmen sind ausschliesslich serverseitig; ein neues
Client-Pack oder eine neue Alpha-Version ist dafuer nicht erforderlich:

- `features.lobotomize-villagers.enabled: true` und
  `activation-range.enabled: true` in ServerCore begrenzen unproduktive
  Villager- und Mob-Ticks. Farmen ausserhalb der Aktivierungsreichweite
  reagieren dadurch bewusst langsamer.
- `features.prevent-moving-into-unloaded-chunks: true` schuetzt gegen
  synchrone Struktur-/Chunk-Ladevorgange. An neuen Chunkgrenzen ist ein kurzer
  Bewegungs-Reset besser als ein globaler Tick-Stall.
- Die Werte `view-distance=5`, `simulation-distance=5` und
  `/gamerule spawnChunkRadius 0` sind das ausgewogene Stream-Profil: Der
  sichtbare Bereich tickt vollständig, zusätzliche unsichtbare Ringe bleiben
  aus. Höhere Werte erst nach einem neuen Spark-Vergleich aktivieren.

CoreProtectNeo ist bewusst nicht Teil des Serverprofils. Claims und
Zugriffsregeln kommen von FTB Chunks; der Wiederherstellungspfad besteht aus
den regulaeren, pruefbaren Server-Backups.

## Rollback

Zuerst den gehosteten Stable-Kanal auf das alte Release zurückstellen. Dann:

```bash
sudo systemctl stop hasencraft
sudo /usr/local/libexec/hasencraft-rollback \
  /srv/hasencraft/backups/pre-update-YYYYMMDDTHHMMSSZ.tar.zst
sudo systemctl start hasencraft
```

## Netzwerk

- Minecraft TCP `25565`
- Simple Voice Chat UDP `24454`

RCON bleibt deaktiviert. Die Ports sollten erst nach dem erfolgreichen Staging-Test und nur für die tatsächlich benötigten Netze geöffnet werden. Für einen privaten Betrieb sind LAN und Tailscale sinnvoller als eine pauschale öffentliche Freigabe, zum Beispiel:

```bash
sudo ufw allow from <LAN-CIDR> to any port 25565 proto tcp comment 'Hasencraft LAN'
sudo ufw allow in on tailscale0 to any port 25565 proto tcp comment 'Hasencraft Tailscale'
sudo ufw allow from <LAN-CIDR> to any port 24454 proto udp comment 'Hasencraft Voice LAN'
sudo ufw allow in on tailscale0 to any port 24454 proto udp comment 'Hasencraft Voice Tailscale'
```

Die Platzhalter sind vor der Ausführung bewusst durch die gewünschte lokale Netzfreigabe zu ersetzen. IP-Adressen, Hostnamen und SSH-Ziele gehören nicht in das veröffentlichte Modpack-Repository.
