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

Der Deploy-Befehl prüft die SHA-256-Summe des Updatewerkzeugs und lehnt Packs mit einer anderen NeoForge-Version ab. Vor jeder Änderung erstellt er ein vollständiges `.tar.zst` unter `/srv/hasencraft/backups/`. Vorher prüft er, ob mindestens die unkomprimierte Größe des Servers plus 2 GiB Reserve frei sind. Alte Backups werden absichtlich nicht automatisch gelöscht; bei der 120-GiB-SSD sollte ihre Belegung regelmäßig geprüft werden.

Serverlauf, Deployment, manuelle Backups und Rollback teilen sich denselben exklusiven Lifecycle-Lock. Ein konsistentes manuelles Backup wird deshalb nur bei gestopptem Dienst erstellt:

```bash
sudo systemctl stop hasencraft
sudo -u hasencraft /usr/local/libexec/hasencraft-backup
sudo systemctl start hasencraft
```

## Performance-Staging

FastSuite, Structure Layout Optimizer und ServerCore sind mit konservativen
Standardwerten Teil des Packs. FastSuite beschleunigt unter anderem die
Rezept- und Tagverarbeitung, während Structure Layout Optimizer die Suche nach
passenden Strukturen bei der Weltgenerierung verringert.

Die Distant-Horizons-Vorlage begrenzt LoD-Generierungs- und
Synchronisierungsanfragen pro Spieler sowie global. Sie deckt weiterhin die
256-LoD-Chunks des Fluffy-Profils ab, schützt aber die TPS bei mehreren
gleichzeitigen Anfragen. Die Hintergrund-Neugenerierung bleibt dabei bewusst
deaktiviert (`PRE_EXISTING_ONLY` und `enableDistantGeneration = false`): Der
Server darf LoDs aus bereits erzeugten Chunks liefern, soll aber nicht neben dem
Spielbetrieb neue, modded Terrain-Chunks erzeugen.

Der Installer kopiert diese Datei nur bei einer neuen Installation. Auf
bestehenden Servern nach dem Deployment sowohl den
`[common.worldGenerator]`- als auch den `[server]`-Block aus
`server/config/DistantHorizons.toml` in
`/srv/hasencraft/server/config/DistantHorizons.toml` übernehmen und den Dienst
neu starten. Eine Weltvorabgenerierung erfolgt getrennt, begrenzt und vor dem
Spielbetrieb; die Hintergrund-Neugenerierung nicht für einen laufenden Stream
einschalten.

Vor Stable mit zwei bis vier gleichzeitig spielenden Clients eine neue Gegend
erkunden und dabei TPS, Speicher sowie Chunk-Latenz beobachten. Bei einem
Spike im Chat oder in der Konsole `spark profiler start --timeout 300` ausführen,
die Situation nachstellen und den erzeugten Profil-Link dokumentieren. Keine
aggressiveren ServerCore- oder Distant-Horizons-Threadwerte ohne Vergleichsprofil
aktivieren.

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
